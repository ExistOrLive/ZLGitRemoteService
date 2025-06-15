//
//  ZLUserServiceModel.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/18.
//  Copyright © 2019 ZM. All rights reserved.
//

// service
#import "ZLUserServiceModel.h"
#import "ZLLoginServiceModel.h"
#import "ZLOperationResultModel.h"

// tool
#import "ZLSharedDataManager.h"

#import <MJExtension/MJExtension.h>

#import "ZLGitRemoteService-Swift.h"


@implementation ZLUserServiceModel

+ (instancetype) sharedServiceModel
{
    static ZLUserServiceModel * model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[ZLUserServiceModel alloc] init];
    });
    return model;
}

- (instancetype) init
{
    if(self = [super init])
    {
    }
    return self;
}


# pragma mark - user info

/// 通过 rest api 获取用户数据
- (void) getUserInfoWithLoginName:(NSString * _Nonnull) loginName
                                         serialNumber:(NSString * _Nonnull) serailNumber
                                       completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle{
    
    GithubResponse response = ^(BOOL result,id responseObject,NSString * serialNumber){
        ZLOperationResultModel * userResultModel = [[ZLOperationResultModel alloc] init];
        userResultModel.result = result;
        userResultModel.serialNumber = serialNumber;
        userResultModel.data = responseObject;
    
        ZLMainThreadDispatch(if(handle){handle(userResultModel);})
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getUserInfoWithLogin:loginName
                                                  serialNumber:serailNumber
                                                      response:response];
}

/// 通过 rest api 获取组织数据
- (void) getOrgInfoWithLoginName:(NSString * _Nonnull) loginName
                                        serialNumber:(NSString * _Nonnull) serailNumber
                                      completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle{
    
    GithubResponse response = ^(BOOL result,id responseObject,NSString * serialNumber){
        ZLOperationResultModel * userResultModel = [[ZLOperationResultModel alloc] init];
        userResultModel.result = result;
        userResultModel.serialNumber = serialNumber;
        userResultModel.data = responseObject;
        
        if(result == true && [responseObject isKindOfClass:[ZLGithubUserBriefModel class]]) {
            [[ZLServiceManager sharedInstance].dbModule insertOrUpdateUserInfo:(ZLGithubUserBriefModel *)responseObject];
        }
        
        ZLMainThreadDispatch(if(handle){handle(userResultModel);})
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getOrgInfoWithLogin:loginName
                                                 serialNumber:serailNumber
                                                     response:response];
}


/// 通过 graphql  api 获取用户/组织数据
/** https://docs.github.com/en/organizations/managing-programmatic-access-to-your-organization/limiting-oauth-app-and-github-app-access-requests
    如果组织的所有者没有授权，oauth app 不能通过 graphql api 访问组织的repo数据，且会导致整个请求报错，因此该方法 不直接获取 组织的仓库数据； 通过 getOrgInfoWithLoginName 方法获取仓库数据
 **/

- (ZLGithubUserBriefModel *) getUserOrOrgInfoWithLoginName:(NSString * _Nonnull) loginName
                                              serialNumber:(NSString * _Nonnull) serailNumber
                                            completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle{
    
    GithubResponse response = ^(BOOL result,id responseObject,NSString * serialNumber){
        ZLOperationResultModel * userResultModel = [[ZLOperationResultModel alloc] init];
        userResultModel.result = result;
        userResultModel.serialNumber = serialNumber;
        userResultModel.data = responseObject;
        
        if(result == true && [responseObject isKindOfClass:[ZLGithubUserBriefModel class]]) {
            [[ZLServiceManager sharedInstance].dbModule insertOrUpdateUserInfo:(ZLGithubUserBriefModel *)responseObject];
        }
        
        ZLMainThreadDispatch(if(handle){handle(userResultModel);})
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getUserOrOrgInfoWithLogin:loginName
                                                       serialNumber:serailNumber
                                                              block:response];
        
    return [[ZLServiceManager sharedInstance].dbModule getUserOrOrgInfoWithLoginName:loginName];
    
}

/**
 * @brief 根据登陆名获取用户或者组织avatar
 * @param loginName 登陆名
 **/

- (void) getUserAvatarWithLoginName:(NSString * _Nonnull) loginName
                       serialNumber:(NSString * _Nonnull) serailNumber
                     completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle{
    
    GithubResponse response = ^(BOOL result,id responseObject,NSString * serialNumber){
        ZLOperationResultModel * userResultModel = [[ZLOperationResultModel alloc] init];
        userResultModel.result = result;
        userResultModel.serialNumber = serialNumber;
        userResultModel.data = responseObject;
        
        ZLMainThreadDispatch(if(handle){handle(userResultModel);})
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getUserAvatarWithLogin:loginName
                                                  serialNumber:serailNumber
                                                         block:response];
        
}


#pragma mark - follow

/**
 * @brief 获取user follow状态
 * @param loginName 用户的登录名
 **/
- (void) getUserFollowStatusWithLoginName:(NSString *) loginName
                             serialNumber:(NSString *) serialNumber
                           completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    if(loginName.length <= 0){
        ZLLog_Info(@"loginName is invalid");
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
    
    
    [[ZLGithubHttpClientV2 defaultClient] getFollowStatusForLogin:loginName
                                                     serialNumber:serialNumber
                                                         response:response];
}

/**
 * @brief follow user
 * @param loginName 用户的登录名
 **/
- (void) followUserWithLoginName:(NSString *)loginName
                    serialNumber:(NSString *) serialNumber
                  completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    if(loginName.length <= 0){
        ZLLog_Info(@"loginName is invalid");
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
    
    [[ZLGithubHttpClientV2 defaultClient] followUserWithLogin:loginName
                                                 serialNumber:serialNumber
                                                     response:response];
}
/**
 * @brief unfollow user
 * @param loginName 用户的登录名
 **/
- (void) unfollowUserWithLoginName:(NSString *)loginName
                      serialNumber:(NSString *) serialNumber
                    completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    if(loginName.length <= 0){
        ZLLog_Info(@"loginName is invalid");
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
    
    [[ZLGithubHttpClientV2 defaultClient] unfollowUserWithLogin:loginName
                                                 serialNumber:serialNumber
                                                     response:response];
}

#pragma mark - block

/**
 * @brief 获取当前屏蔽的用户
 **/

- (void) getBlockedUsersWithSerialNumber:(NSString *) serialNumber
                          completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * blockedUsersResultModel = [[ZLOperationResultModel alloc] init];
        blockedUsersResultModel.result = result;
        blockedUsersResultModel.serialNumber = serialNumber;
        blockedUsersResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(blockedUsersResultModel);)
        }
    };
    
    
    
    [[ZLGithubHttpClientV2 defaultClient] getBlockUsersWithSerialNumber:serialNumber
                                                               response:response];
}



- (void) getUserBlockStatusWithLoginName: (NSString *) loginName
                            serialNumber:(NSString *) serialNumber
                          completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * blockedUsersResultModel = [[ZLOperationResultModel alloc] init];
        blockedUsersResultModel.result = result;
        blockedUsersResultModel.serialNumber = serialNumber;
        blockedUsersResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(blockedUsersResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getBlockStatusForLogin:loginName
                                                    serialNumber:serialNumber
                                                        response:response];
}

- (void) blockUserWithLoginName: (NSString *) loginName
                   serialNumber: (NSString *) serialNumber
                 completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * blockedUsersResultModel = [[ZLOperationResultModel alloc] init];
        blockedUsersResultModel.result = result;
        blockedUsersResultModel.serialNumber = serialNumber;
        blockedUsersResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(blockedUsersResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] blockUserWithLogin:loginName
                                                serialNumber:serialNumber
                                                    response:response];
    
}

- (void) unBlockUserWithLoginName: (NSString *) loginName
                     serialNumber: (NSString *) serialNumber
                   completeHandle:(void(^)(ZLOperationResultModel *)) handle{
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * blockedUsersResultModel = [[ZLOperationResultModel alloc] init];
        blockedUsersResultModel.result = result;
        blockedUsersResultModel.serialNumber = serialNumber;
        blockedUsersResultModel.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(blockedUsersResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] unblockUserWithLogin:loginName
                                                  serialNumber:serialNumber
                                                      response:response];
}



#pragma mark - contributions

/**
 * @brief 查询用户的contributions
 * @param loginName 用户的登录名
 **/
- (NSArray<ZLGithubUserContributionData *> *) getUserContributionsDataWithLoginName: (NSString * _Nonnull) loginName
                                                                       serialNumber: (NSString * _Nonnull) serialNumber
                                                                     completeHandle: (void(^ _Nonnull)(ZLOperationResultModel * _Nonnull)) handle{
    
    NSString *contributionsStr = [[ZLServiceManager sharedInstance].dbModule getUserContributionsWithLoginName:loginName];
    NSMutableArray *contributionsArray = [ZLGithubUserContributionData mj_objectArrayWithKeyValuesArray:contributionsStr];
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * blockedUsersResultModel = [[ZLOperationResultModel alloc] init];
        blockedUsersResultModel.result = result;
        blockedUsersResultModel.serialNumber = serialNumber;
        blockedUsersResultModel.data = responseObject;
        
        if(result == true){
            id keyValueArray = [ZLGithubUserContributionData mj_keyValuesArrayWithObjectArray:responseObject];
            NSString *tmpcontributionStr = [keyValueArray mj_JSONString];
            if(tmpcontributionStr != nil){
                [[ZLServiceManager sharedInstance].dbModule insertOrUpdateUserContributions:tmpcontributionStr loginName:loginName];
            }
        }
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(blockedUsersResultModel);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getUserContributionsDataSwiftWithLogin:loginName
                                                                  serialNumber:serialNumber
                                                                         block:response];
    
    return contributionsArray;
}


#pragma mark - user or org pinned repo

- (void) getUserPinnedRepositories:(NSString * _Nonnull) loginName
                      serialNumber: (NSString * _Nonnull) serialNumber
                    completeHandle: (void(^ _Nonnull)(ZLOperationResultModel * _Nonnull)) handle{
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * model = [[ZLOperationResultModel alloc] init];
        model.result = result;
        model.serialNumber = serialNumber;
        model.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(model);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getUserPinnedRepositoriesWithLogin:loginName
                                                              serialNumber:serialNumber
                                                                     block:response];
}


- (void) getOrgPinnedRepositories:(NSString * _Nonnull) loginName
                      serialNumber: (NSString * _Nonnull) serialNumber
                    completeHandle: (void(^ _Nonnull)(ZLOperationResultModel * _Nonnull)) handle{
    
    GithubResponse response = ^(BOOL  result, id responseObject, NSString * serialNumber)
    {
        ZLOperationResultModel * model = [[ZLOperationResultModel alloc] init];
        model.result = result;
        model.serialNumber = serialNumber;
        model.data = responseObject;
        
        if(handle)
        {
            ZLMainThreadDispatch(handle(model);)
        }
    };
    
    [[ZLGithubHttpClientV2 defaultClient] getOrgPinnedRepositoriesWithLogin:loginName
                                                             serialNumber:serialNumber
                                                                    block:response];
}


#pragma mark - user additions info (repos followers followings gists)

- (void) getAdditionInfoForUser:(NSString * _Nonnull) userLoginName
                          isOrg: (Boolean) isOrg
                       infoType:(ZLUserAdditionInfoType) type
                           page:(NSUInteger) page
                       per_page:(NSUInteger) per_page
                   serialNumber:(NSString * _Nonnull) serialNumber
                 completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle{
    // 检查登录名
    if(userLoginName.length == 0){
        ZLLog_Warning(@"userLoginName is nil,so return");
        ZLOperationResultModel* resultModel = [ZLOperationResultModel new];
        resultModel.result = false;
        resultModel.data = [ZLGithubRequestErrorModel errorModelWithStatusCode:0 message:@"login is nil" documentation_url:nil];
        resultModel.serialNumber = serialNumber;
        handle(resultModel);
        return;
    }
    
    switch(type)
    {
        case ZLUserAdditionInfoTypeRepositories:
        {
            if(isOrg) {
                
                [self getRepositoriesInfoForOrg:userLoginName
                                            page:page
                                        per_page:per_page
                                    serialNumber:serialNumber
                                  completeHandle:handle];
            } else {
                [self getRepositoriesInfoForUser:userLoginName
                                            page:page
                                        per_page:per_page
                                    serialNumber:serialNumber
                                  completeHandle:handle];
            }
        }
            break;
        case ZLUserAdditionInfoTypeGists:
        {
            [self getGistsForUser:userLoginName
                             page:page
                         per_page:per_page
                     serialNumber:serialNumber
                   completeHandle:handle];
        }
            break;
        case ZLUserAdditionInfoTypeFollowers:
        {
            [self getFollowersInfoForUser:userLoginName
                                     page:page
                                 per_page:per_page
                             serialNumber:serialNumber
                           completeHandle:handle];
        }
            break;
        case ZLUserAdditionInfoTypeFollowing:
        {
            [self getFollowingInfoForUser:userLoginName
                                     page:page
                                 per_page:per_page
                             serialNumber:serialNumber
                           completeHandle:handle];
        }
            break;
        case ZLUserAdditionInfoTypeStarredRepos:
        {
            [self getStarredReposInfoForUser:userLoginName
                                        page:page
                                    per_page:per_page
                                serialNumber:serialNumber
                              completeHandle:handle];
        }
            break;
    }
    
    
    return;
}




/**
 * @brief 请求repos
 *
 **/
- (void) getRepositoriesInfoForUser:(NSString *) userLoginName
                               page:(NSUInteger) page
                           per_page:(NSUInteger) per_page
                       serialNumber:(NSString *) serialNumber
                     completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle{
    
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
 
        
        if(handle){
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    NSString * currentLoginName = ZLServiceManager.sharedInstance.viewerServiceModel.currentUserLoginName;
    
    if([currentLoginName isEqualToString:userLoginName])
    {
        [[ZLGithubHttpClientV2 defaultClient] getRepositoriesForCurrentUserWithPage:page
                                                                            perPage:per_page
                                                                       serialNumber:serialNumber
                                                                           response:responseBlock];
    }
    else
    {
        // 不是当前登陆的用户
        [[ZLGithubHttpClientV2 defaultClient] getRepositoriesForUserWithLogin:userLoginName
                                                                         page:page
                                                                      perPage:per_page serialNumber:serialNumber response:responseBlock];
    }
    
}

/**
 * @brief 请求repos
 *
 **/
- (void) getRepositoriesInfoForOrg:(NSString *) userLoginName
                               page:(NSUInteger) page
                           per_page:(NSUInteger) per_page
                       serialNumber:(NSString *) serialNumber
                     completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle{
    
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
 
        
        if(handle){
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    

        [[ZLGithubHttpClientV2 defaultClient] getRepositoriesForOrgWithLogin:userLoginName
                                                                         page:page
                                                                      perPage:per_page serialNumber:serialNumber response:responseBlock];

}

/**
 * @brief 请求followers
 *
 **/
- (void) getFollowersInfoForUser:(NSString *) userLoginName
                                    page:(NSUInteger) page
                                per_page:(NSUInteger) per_page
                            serialNumber:(NSString *) serialNumber
                  completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle{
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * followerResultModel = [[ZLOperationResultModel alloc] init];
        followerResultModel.result = result;
        followerResultModel.serialNumber = serialNumber;
        followerResultModel.data = responseObject;
     
        if(handle){
            ZLMainThreadDispatch(handle(followerResultModel);)
        }
    };
    

    [[ZLGithubHttpClientV2 defaultClient] getFollowersForUserWithLogin:userLoginName
                                                                  page:page
                                                               perPage:per_page
                                                          serialNumber:serialNumber
                                                              response:responseBlock];
}


/**
 * @brief 请求followers
 *
 **/
- (void) getFollowingInfoForUser:(NSString *) userLoginName
                                 page:(NSUInteger) page
                             per_page:(NSUInteger) per_page
                         serialNumber:(NSString *) serialNumber
                  completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle{
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * followingResultModel = [[ZLOperationResultModel alloc] init];
        followingResultModel.result = result;
        followingResultModel.serialNumber = serialNumber;
        followingResultModel.data = responseObject;
        
        if(handle){
            ZLMainThreadDispatch(handle(followingResultModel);)
        }
        
    };
    
    
    [[ZLGithubHttpClientV2 defaultClient] getFollowingsForUserWithLogin:userLoginName
                                                                   page:page
                                                                perPage:per_page
                                                           serialNumber:serialNumber response:responseBlock];
}



/**
 * @brief 请求标星的repos
 *
 **/
- (void) getStarredReposInfoForUser:(NSString *) userLoginName
                                    page:(NSUInteger) page
                                per_page:(NSUInteger) per_page
                            serialNumber:(NSString *) serialNumber
                          completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle
{
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle){
            ZLMainThreadDispatch(handle(repoResultModel);)
        }
    };
    
    NSString * currentLoginName = ZLServiceManager.sharedInstance.viewerServiceModel.currentUserLoginName;
    
    if([currentLoginName isEqualToString:userLoginName])
    {
        // 为当前登陆的用户
        [[ZLGithubHttpClientV2 defaultClient] getStarredsForCurrentUserWithPage:page
                                                                        perPage:per_page
                                                                   serialNumber:serialNumber
                                                                       response:responseBlock];
    }
    else
    {
        // 不是当前登陆的用户
        [[ZLGithubHttpClientV2 defaultClient] getStarredsForUserWithLogin:userLoginName
                                                                     page:page
                                                                  perPage:per_page
                                                             serialNumber:serialNumber
                                                                 response:responseBlock];
    }
}

/**
 * @brief 请求gists
 *
 **/
- (void) getGistsForUser:(NSString *) userLoginName
                    page:(NSUInteger) page
                per_page:(NSUInteger) per_page
            serialNumber:(NSString *) serialNumber
          completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle
{
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle){
            ZLMainThreadDispatch( handle(repoResultModel);)
        }
    };
    
    NSString * currentLoginName = ZLServiceManager.sharedInstance.viewerServiceModel.currentUserLoginName;
    
    if([currentLoginName isEqualToString:userLoginName])
    {
        // 为当前登陆的用户
        [[ZLGithubHttpClientV2 defaultClient] getGistsForCurrentUserWithPage:page
                                                                     perPage:per_page
                                                                serialNumber:serialNumber
                                                                    response:responseBlock];
    }
    else
    {
        // 不是当前登陆的用户
        [[ZLGithubHttpClientV2 defaultClient] getGistsForUserWithLogin:userLoginName
                                                                  page:page
                                                               perPage:per_page
                                                          serialNumber:serialNumber
                                                              response:responseBlock];
    }
    
}


/**
 * @brief 请求gist 信息
 *
 **/
- (void) getGistInfoFor:(NSString *) gistId
           serialNumber:(NSString *) serialNumber
         completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle {
    
    GithubResponse responseBlock = ^(BOOL result, id _Nullable responseObject, NSString * serialNumber) {
        
        ZLOperationResultModel * repoResultModel = [[ZLOperationResultModel alloc] init];
        repoResultModel.result = result;
        repoResultModel.serialNumber = serialNumber;
        repoResultModel.data = responseObject;
        
        if(handle){
            ZLMainThreadDispatch( handle(repoResultModel);)
        }
    };
    
    // 获取gist信息
    [[ZLGithubHttpClientV2 defaultClient] getGistWithGistId: gistId
                                               serialNumber:serialNumber
                                                   response:responseBlock];
    
}



@end

