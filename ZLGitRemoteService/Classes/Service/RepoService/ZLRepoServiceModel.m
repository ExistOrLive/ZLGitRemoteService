//
//  ZLRepoServiceModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/24.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "ZLRepoServiceModel.h"
#import "ZLRepoServiceHeader.h"

#import "ZLGithubRequestErrorModel.h"
#import "ZLOperationResultModel.h"
#import "ZLGitRemoteService-Swift.h"


@implementation ZLRepoServiceModel

+ (instancetype) sharedServiceModel
{
    static ZLRepoServiceModel * serviceModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceModel = [[ZLRepoServiceModel alloc] init];
    });
    return serviceModel;
}

/**
 * @brief 根据repo full name 获取仓库信息
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/

- (ZLGithubRepositoryModel *) getRepoInfoWithFullName:(NSString * _Nonnull) fullName
                                         serialNumber:(NSString * _Nonnull) serialNumber
                                       completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle{
    
    if(fullName.length <= 1 || ![fullName containsString:@"/"]){
        ZLGithubRequestErrorModel *errorModel = [ZLGithubRequestErrorModel errorModelWithStatusCode:0 message:@"fullName is invalid" documentation_url:nil];
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = false;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = errorModel;
        handle(repoResultModel);
        return nil;
    }
    
    NSString *ownerName = [fullName componentsSeparatedByString:@"/"].firstObject;
    NSString *name = [fullName componentsSeparatedByString:@"/"].lastObject;
    
    return [self getRepoInfoWithOwnerName:ownerName
                                 repoName:name
                             serialNumber:serialNumber
                           completeHandle:handle];
}

/**
 * @brief 根据repo full name 获取仓库信息
 * @param ownerName octocat
 * @param repoName Hello-World
 * @param serialNumber 流水号
 **/
- (ZLGithubRepositoryModel *) getRepoInfoWithOwnerName:(NSString * _Nonnull) ownerName
                                              repoName:(NSString * _Nonnull) repoName
                                          serialNumber:(NSString * _Nonnull) serialNumber
                                        completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle{
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(result == true){
            [[ZLServiceManager sharedInstance].dbModule insertOrUpdateRepoInfo:(ZLGithubRepositoryModel *)responseObject];
        }
        
        ZLMainThreadDispatch(if(handle){
            handle(repoResultModel);
        })
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getRepoInfoWithLogin:ownerName
                                                        name:repoName
                                                serialNumber:serialNumber
                                                       block:response];
    
    return [[ZLServiceManager sharedInstance].dbModule getRepoInfoWithFullName:[NSString stringWithFormat:@"%@/%@",ownerName,repoName]];
    
}


#pragma mark - commits branch language pullrequest issue


- (void) getRepoReadMeInfoWithFullName:(NSString *) fullName
                                branch:(NSString * __nullable) branch
                                isHTML:(BOOL) isHTML
                          serialNumber:(NSString *) serialNumber
                        completeHandle:(void(^)(ZLOperationResultModel *)) handle
{
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle){
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getRepoReadMeInfoWithFullName:fullName
                                                                    ref:branch
                                                          isHTMLContent:isHTML
                                                           serialNumber:serialNumber
                                                               response:response];
}


- (void) getRepoPullRequestWithFullName:(NSString *) fullName
                                  state:(NSString *) state
                               per_page:(NSInteger)per_page
                                   page:(NSInteger)page
                           serialNumber:(NSString *) serialNumber
                         completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getPRsForRepoWithFullName:fullName
                                                              state:state
                                                               page:page
                                                           per_page:per_page
                                                       serialNumber:serialNumber
                                                           response:response];
}



- (void) getRepoCommitWithFullName:(NSString *) fullName
                              page:(NSUInteger) page
                          per_page:(NSUInteger) per_page
                            branch:(NSString * __nullable) branch
                             until:(NSDate *) untilDate
                             since:(NSDate *) sinceDate
                      serialNumber:(NSString *) serialNumber
                    completeHandle:(void(^)(ZLOperationResultModel *)) handle
{
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getCommitsForRepoWithFullName:fullName
                                                                   page:page
                                                               per_page:per_page
                                                                    sha:branch
                                                                   path:nil
                                                                 author:nil
                                                              committer:nil
                                                                  since:sinceDate
                                                                  until:untilDate
                                                           serialNumber:serialNumber
                                                               response:response];
}


/**
 * @brief 根据repo 获取branch
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) getRepositoryBranchesInfoWithFullName:(NSString *) fullName
                                  serialNumber:(NSString *) serialNumber
                                completeHandle:(void(^)(ZLOperationResultModel *)) handle
{
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getBranchsForRepoWithFullName:fullName
                                                           serialNumber:serialNumber
                                                               response:response];
}






/**
 * @brief 根据repo fullname获取 贡献者
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) getRepositoryContributorsWithFullName:(NSString *) fullName
                                  serialNumber:(NSString *) serialNumber
                                completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getContributorsForRepoWithFullName:fullName
                                                                serialNumber:serialNumber
                                                                    response:response];
}






/**
 * @brief 根据repo fullname获取 issues
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) getRepositoryIssuesWithFullName:(NSString *) fullName
                                   state:(NSString *) state
                                per_page:(NSInteger) per_page
                                    page:(NSInteger) page
                            serialNumber:(NSString *) serialNumber
                          completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getIssuesForRepoWithFullName:fullName
                                                                 state:state
                                                                  page:page
                                                              per_page:per_page
                                                          serialNumber:serialNumber response:response];
}






#pragma mark - subscription

- (void) watchRepoWithFullName:(NSString *) fullName
                  serialNumber:(NSString *) serialNumber
                completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    if(fullName.length == 0 || ![fullName containsString:@"/"]){
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber){
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle){
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] watchRepoWithFullName:fullName
                                                   serialNumber:serialNumber
                                                       response:response];
}

- (void) unwatchRepoWithFullName:(NSString *) fullName
                    serialNumber:(NSString *) serialNumber
                  completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] unwatchRepoWithFullName:fullName
                                                     serialNumber:serialNumber
                                                         response:response];
}

- (void) getRepoWatchStatusWithFullName:(NSString *) fullName
                           serialNumber:(NSString *) serialNumber
                         completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getWatchRepoStatusWithFullName:fullName
                                                            serialNumber:serialNumber
                                                                response:response];
    
}



- (void) getRepoWatchersWithFullName:(NSString *) fullName
                        serialNumber:(NSString *) serialNumber
                            per_page:(NSInteger) per_page
                                page:(NSInteger) page
                      completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getWatchersForRepoWithFullName:fullName
                                                                    page:page
                                                                per_page:per_page
                                                            serialNumber:serialNumber
                                                                response:response];
}


#pragma mark - star repo

- (void) starRepoWithFullName:(NSString *) fullName
                 serialNumber:(NSString *) serialNumber
               completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] starRepoWithFullName:fullName
                                                  serialNumber:serialNumber
                                                      response:response];
}

- (void) unstarRepoWithFullName:(NSString *) fullName
                   serialNumber:(NSString *) serialNumber
                 completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] unstarRepoWithFullName:fullName
                                                    serialNumber:serialNumber
                                                        response:response];
}

- (void) getRepoStarStatusWithFullName:(NSString *) fullName
                          serialNumber:(NSString *) serialNumber
                        completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getStarRepoStatusWithFullName:fullName
                                                           serialNumber:serialNumber
                                                               response:response];
}

- (void) getRepoStargazersWithFullName:(NSString *) fullName
                          serialNumber:(NSString *) serialNumber
                              per_page:(NSInteger) per_page
                                  page:(NSInteger) page
                        completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getStargazersForRepoWithFullName:fullName
                                                                      page:page
                                                                  per_page:per_page
                                                              serialNumber:serialNumber
                                                                  response:response];
}


#pragma mark - fork

- (void) forkRepositoryWithFullName:(NSString *) fullName
                                org:(NSString * __nullable) org
                       serialNumber:(NSString *) serialNumber
                     completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    
    [[ZLGithubHttpClientV2 defaultClient] forkRepoWithFullName:fullName
                                                  organization:org
                                                          name:nil
                                           default_branch_only:false
                                                  serialNumber:serialNumber
                                                      response:response];
}


- (void) getRepoForksWithFullName:(NSString *) fullName
                     serialNumber:(NSString *) serialNumber
                         per_page:(NSInteger) per_page
                             page:(NSInteger) page
                   completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getForksForRepoWithFullName:fullName
                                                                 page:page
                                                             per_page:per_page
                                                         serialNumber:serialNumber
                                                             response:response];
}

#pragma mark - languages

- (void) getRepoLanguagesWithFullName:(NSString *) fullName
                         serialNumber:(NSString *) serialNumber
                       completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getLanguagesInfoForRepoWithFullName:fullName
                                                                 serialNumber:serialNumber
                                                                     response:response];
}



#pragma mark - actions

- (void) getRepoWorkflowsWithFullName:(NSString *) fullName
                             per_page:(NSInteger) per_page
                                 page:(NSInteger) page
                         serialNumber:(NSString *) serialNumber
                       completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getWorkflowsForRepoWithFullName:fullName
                                                                     page:page
                                                                 per_page:per_page
                                                             serialNumber:serialNumber
                                                                 response:response];
}


- (void) getRepoWorkflowRunsWithFullName:(NSString *) fullName
                              workflowId:(NSString *) workflowId
                                per_page:(NSInteger) per_page
                                    page:(NSInteger) page
                            serialNumber:(NSString *) serialNumber
                          completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getWorkflowRunsForRepoWithFullName:fullName
                                                                  workflowId:workflowId
                                                                        page:page
                                                                    per_page:per_page
                                                                serialNumber:serialNumber
                                                                    response:response];
}


- (void) rerunRepoWorkflowRunWithFullName:(NSString *) fullName
                            workflowRunId:(NSString *) workflowRunId
                             serialNumber:(NSString *) serialNumber
                           completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] rerunWorkflowRunForRepoWithFullName:fullName
                                                                workflowRunId:workflowRunId
                                                                 serialNumber:serialNumber
                                                                     response:response];
}

- (void) cancelRepoWorkflowRunWithFullName:(NSString *) fullName
                             workflowRunId:(NSString *) workflowRunId
                              serialNumber:(NSString *) serialNumber
                            completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] cancelWorkflowRunForRepoWithFullName:fullName
                                                                 workflowRunId:workflowRunId
                                                                  serialNumber:serialNumber
                                                                      response:response];
}

- (void) getRepoWorkflowRunLogWithFullName:(NSString *) fullName
                             workflowRunId:(NSString *) workflowRunId
                              serialNumber:(NSString *) serialNumber
                            completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getWorkflowRunLogForRepoWithFullName:fullName
                                                                 workflowRunId:workflowRunId
                                                                  serialNumber:serialNumber
                                                                      response:response];
    
}

#pragma mark - File Content


/**
 * @brief 根据repo fullname获取 内容
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) getRepositoryContentsInfoWithFullName:(NSString *) fullName
                                          path:(NSString *) path
                                        branch:(NSString *) branch
                                  serialNumber:(NSString *) serialNumber
                                completeHandle:(void(^)(ZLOperationResultModel *)) handle
{
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getDirContentForRepoWithFullName:fullName
                                                                      path:path
                                                                       ref:branch
                                                              serialNumber:serialNumber response:response];
}


- (void) getRepositoryFileInfoWithFullName:(NSString *) fullName
                                      path:(NSString *) path
                                    branch:(NSString *) branch
                              serialNumber:(NSString *) serialNumber
                            completeHandle:(void(^)(ZLOperationResultModel *)) handle
{
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getFileContentForRepoWithFullName:fullName
                                                                       path:path
                                                                        ref:branch
                                                                  mediaType:ZLGithubMediaTypeJson
                                                               serialNumber:serialNumber response:response];
}



- (void) getRepositoryFileHTMLInfoWithFullName:(NSString *) fullName
                                          path:(NSString *) path
                                        branch:(NSString *) branch
                                  serialNumber:(NSString *) serialNumber
                                completeHandle:(void(^)(ZLOperationResultModel *)) handle
{
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    
    [[ZLGithubHttpClientV2 defaultClient] getFileContentForRepoWithFullName:fullName
                                                                       path:path
                                                                        ref:branch
                                                                  mediaType:ZLGithubMediaTypeJson_html
                                                               serialNumber:serialNumber response:response];
}


- (void) getRepositoryFileRawInfoWithFullName:(NSString *) fullName
                                          path:(NSString *) path
                                        branch:(NSString *) branch
                                  serialNumber:(NSString *) serialNumber
                                completeHandle:(void(^)(ZLOperationResultModel *)) handle
{
    if(fullName.length == 0 || ![fullName containsString:@"/"])
    {
        ZLLog_Info(@"fullName is not valid");
        return;
    }
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getFileContentForRepoWithFullName:fullName
                                                                       path:path
                                                                        ref:branch
                                                                  mediaType:ZLGithubMediaTypeJson_raw
                                                               serialNumber:serialNumber response:response];
}

@end
