//
//  ZLEventServiceModel.m
//  ZLGitHubClient
//
//  Created by LongMac on 2019/9/1.
//  Copyright © 2019年 ZM. All rights reserved.
//

#import "ZLEventServiceModel.h"
#import "ZLEventServiceHeader.h"
#import "ZLUserServiceModel.h"
#import "ZLOperationResultModel.h"
#import "ZLGitRemoteService-Swift.h"


@implementation ZLEventServiceModel

+ (instancetype) sharedServiceModel{
    
    static ZLEventServiceModel *eventServiceModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        eventServiceModel = [[ZLEventServiceModel alloc] init];
    });
    
    return eventServiceModel;
}


#pragma mark - event

/**
 *  @brief 请求当前用户的event
 *
 **/
- (void) getMyEventsWithpage:(NSUInteger)page
                    per_page:(NSUInteger)per_page
                serialNumber:(NSString *)serialNumber
              completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle {
    
    __weak typeof(self) weakSelf = self;
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        ZLMainThreadDispatch(if(handle)handle(repoResultModel);)
    };
    
    NSString * loginName = ZLServiceManager.sharedInstance.viewerServiceModel.currentUserLoginName;
    
    
    [[ZLGithubHttpClientV2 defaultClient] getEventsForUserWithLogin:loginName
                                                               page:page
                                                           per_page:per_page
                                                       serialNumber:serialNumber response:responseBlock];
}


/**
 *  @brief 请求用户的event
 *
 **/
- (void) getEventsForUser:(NSString *) userName
                     page:(NSUInteger)page
                 per_page:(NSUInteger)per_page
             serialNumber:(NSString *)serialNumber
           completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle {
    
    __weak typeof(self) weakSelf = self;
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        ZLMainThreadDispatch(if(handle)handle(repoResultModel);)
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getEventsForUserWithLogin:userName
                                                               page:page
                                                           per_page:per_page
                                                       serialNumber:serialNumber response:responseBlock];
}


/**
 * @brief 请求某个用户的receive_events
 *
 **/
- (void)getReceivedEventsForUser:(NSString *)userName
                            page:(NSUInteger)page
                        per_page:(NSUInteger)per_page
                    serialNumber:(NSString *)serialNumber 
                  completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;
{
    
    __weak typeof(self) weakSelf = self;
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        ZLMainThreadDispatch(if(handle)handle(repoResultModel);)
    };
    
    
    [[ZLGithubHttpClientV2 defaultClient] getReceivedEventsForUserWithLogin:userName
                                                                       page:page
                                                                   per_page:per_page
                                                               serialNumber:serialNumber response:responseBlock];
}


#pragma mark - notification

- (void) getNotificationsWithShowAll:(bool) showAll
                                page:(int) page
                            per_page:(int) per_page
                        serialNumber:(NSString * _Nonnull)serialNumber
                      completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle {
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * resultModel = [[ZLOperationResultModel alloc] init];
        resultModel.result = result;
        resultModel.serialNumber = serialNumber;
        resultModel.data = responseObject;
        
        ZLMainThreadDispatch(if(handle)handle(resultModel);)
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getNotificationsWithPage:page
                                                          per_page:per_page
                                                               all:showAll
                                                      serialNumber:serialNumber
                                                          response:responseBlock];
    
}


- (void) markNotificationReadedWithNotificationId:(NSString * _Nonnull) notificationId
                                     serialNumber:(NSString * _Nonnull)serialNumber
                                   completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle {
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * resultModel = [[ZLOperationResultModel alloc] init];
        resultModel.result = result;
        resultModel.serialNumber = serialNumber;
        resultModel.data = responseObject;
        
        ZLMainThreadDispatch(if(handle)handle(resultModel);)
    };
    
    [[ZLGithubHttpClientV2 defaultClient] markNotificationReadedWithThread_id:notificationId
                                                                 serialNumber:serialNumber
                                                                     response:responseBlock];
    
}



#pragma mark - pr

- (void) getPRInfoWithLogin:(NSString * _Nonnull) login
                   repoName:(NSString * _Nonnull) repoName
                     number:(int) number
                      after:(NSString * _Nullable) after
               serialNumber:(NSString *_Nonnull) serialNumber
             completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle {
    
    GithubResponse reposoneBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * resultModel = [[ZLOperationResultModel alloc] init];
        resultModel.result = result;
        resultModel.serialNumber = serialNumber;
        resultModel.data = responseObject;
        
        if(handle){
            ZLMainThreadDispatch(handle(resultModel);)
        }
        
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getPRInfoWithLogin:login
                                                  repoName:repoName
                                                    number:number
                                                     after:after
                                              serialNumber:serialNumber
                                                     block:reposoneBlock];
}

#pragma mark - discussion

- (void) getDiscussionInfoWithLogin:(NSString * _Nonnull) login
                           repoName:(NSString * _Nonnull) repoName
                             number:(int) number
                       serialNumber:(NSString *_Nonnull) serialNumber
                     completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle {
    
    GithubResponse reposoneBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * resultModel = [[ZLOperationResultModel alloc] init];
        resultModel.result = result;
        resultModel.serialNumber = serialNumber;
        resultModel.data = responseObject;
        
        if(handle){
            ZLMainThreadDispatch(handle(resultModel);)
        }
        
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getDiscussionInfoWithLogin:login
                                                            repoName:repoName
                                                              number:(NSInteger)number
                                                        serialNumber:serialNumber
                                                               block:reposoneBlock];
}


- (void) getDiscussionCommentWithLogin:(NSString * _Nonnull) login
                              repoName:(NSString * _Nonnull) repoName
                                number:(int) number
                              per_page:(int) per_page
                                 after:(NSString * _Nullable) after
                          serialNumber:(NSString *_Nonnull) serialNumber
                        completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle {
    
    GithubResponse reposoneBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * resultModel = [[ZLOperationResultModel alloc] init];
        resultModel.result = result;
        resultModel.serialNumber = serialNumber;
        resultModel.data = responseObject;
        
        if(handle){
            ZLMainThreadDispatch(handle(resultModel);)
        }
        
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getDiscussionCommentWithLogin:login
                                                               repoName:repoName
                                                                 number:number
                                                               per_page:per_page
                                                                  after:after
                                                           serialNumber:serialNumber
                                                                  block:reposoneBlock];
}


- (void) getDiscussionInfoListWithLogin:(NSString * _Nonnull) login
                               repoName:(NSString * _Nonnull) repoName
                               per_page:(int) per_page
                                  after:(NSString * _Nullable) after
                           serialNumber:(NSString *_Nonnull) serialNumber
                         completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle {
    
    GithubResponse reposoneBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * resultModel = [[ZLOperationResultModel alloc] init];
        resultModel.result = result;
        resultModel.serialNumber = serialNumber;
        resultModel.data = responseObject;
        
        if(handle){
            ZLMainThreadDispatch(handle(resultModel);)
        }
        
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getDiscussionInfoListWithLogin:login
                                                                repoName:repoName
                                                                per_page:per_page
                                                                   after:after
                                                            serialNumber:serialNumber
                                                                   block:reposoneBlock];
                                                        
}


#pragma mark - issue

- (void) getRepositoryIssueInfoWithLoginName:(NSString * _Nonnull) loginName
                                    repoName:(NSString * _Nonnull) repoName
                                      number:(int) number
                                serialNumber:(NSString * _Nonnull) serialNumber
                              completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle {
    
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
    
    [[ZLGithubHttpClientV2 defaultClient] getIssueInfoWithLogin:loginName
                                                     repoName:repoName
                                                       number:number
                                                 serialNumber:serialNumber
                                                        block:response];
    
}


- (void) getRepositoryIssueTimelineWithLoginName:(NSString * _Nonnull) loginName
                                        repoName:(NSString * _Nonnull) repoName
                                          number:(int) number
                                           after:(NSString * _Nullable) after
                                    serialNumber:(NSString * _Nonnull) serialNumber
                                  completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle {
    
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
    
    [[ZLGithubHttpClientV2 defaultClient] getIssueTimelinesInfoWithLogin:loginName
                                                              repoName:repoName
                                                                number:number
                                                                 after:after
                                                          serialNumber:serialNumber
                                                                 block:response];
    
}


- (void) getIssueEditInfoWithLoginName:(NSString * _Nonnull) loginName
                              repoName:(NSString * _Nonnull) repoName
                                number:(int) number
                          serialNumber:(NSString * _Nonnull) serialNumber
                        completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle {
    
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
    
    [[ZLGithubHttpClientV2 defaultClient] getEditIssueInfoWithLogin:loginName
                                                         repoName:repoName
                                                           number:number
                                                     serialNumber:serialNumber
                                                            block:response];
    
}


- (void) addIssueCommentWithIssueId:(NSString * _Nonnull) issueId
                            comment:(NSString * _Nonnull) comment
                       serialNumber:(NSString * _Nonnull) serialNumber
                     completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle {
    
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
    
    [[ZLGithubHttpClientV2 defaultClient] addIssueCommentWithIssueId:issueId
                                                       commentBody:comment
                                                      serialNumber:serialNumber
                                                             block:response];
}

- (void) editIssueAssigneesWithIssueId:(NSString *) issueId
                             addedList:(NSArray<NSString *> *) addedList
                           removedList:(NSArray<NSString *> *) removedList
                          serialNumber:(NSString * _Nonnull) serialNumber
                        completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle {
    
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
    
    [[ZLGithubHttpClientV2 defaultClient] editIssueAssigneesWithIssueId:issueId
                                                       addedAssignees:addedList
                                                     removedAssignees:removedList
                                                         serialNumber:serialNumber
                                                                block:response];
}



- (void) createIssueWithFullName:(NSString *) fullName
                           title:(NSString *) title
                            body:(NSString *) body
                          labels:(NSArray *) labels
                       assignees:(NSArray *) assignees
                    serialNumber:(NSString *) serialNumber
                  completeHandle:(void(^)(ZLOperationResultModel *)) handle {
    
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
    
    [[ZLGithubHttpClientV2 defaultClient] createIssuesForRepoWithFullName:fullName
                                                                    title:title
                                                                     body:body
                                                                   labels:labels
                                                                assignees:assignees
                                                             serialNumber:serialNumber response:response];
}


- (void) openOrCloseIssue:(NSString *) issueId
                     open:(BOOL) open
             serialNumber:(NSString *) serialNumber
           completeHandle:(void(^)(ZLOperationResultModel *)) handle {
    
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
    
    
    [[ZLGithubHttpClientV2 defaultClient] openIssueWithId:issueId
                                                   open:open
                                           serialNumber:serialNumber
                                                  block:response];
}


- (void) lockOrUnlockLockable:(NSString *) lockableId
                         lock:(BOOL) lock
                 serialNumber:(NSString *) serialNumber
               completeHandle:(void(^)(ZLOperationResultModel *)) handle {
    
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
    
    
    [[ZLGithubHttpClientV2 defaultClient] lockLockableWithId:lockableId
                                                      lock:lock
                                              serialNumber:serialNumber
                                                     block:response];
}


- (void) subscribeOrUnsubscribeSubscription:(NSString *) subscriptionId
                                  subscribe:(BOOL) subscribe
                               serialNumber:(NSString *) serialNumber
                             completeHandle:(void(^)(ZLOperationResultModel *)) handle {
    
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
    
    
    [[ZLGithubHttpClientV2 defaultClient] subscribeSubscriptionWithId:subscriptionId
                                                          subscribe:subscribe
                                                       serialNumber:serialNumber
                                                              block:response];
}


@end
