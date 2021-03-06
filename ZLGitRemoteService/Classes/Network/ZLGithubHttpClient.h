//
//  ZLGithubHttpClient.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/12.
//  Copyright © 2019 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLSearchServiceHeader.h"

typedef void(^GithubResponse)(BOOL,id _Nullable ,NSString * _Nonnull);

NS_ASSUME_NONNULL_BEGIN

@interface ZLGithubHttpClient : NSObject

+ (instancetype) defaultClient;

// github token
@property (nonatomic, strong, readonly) NSString * token;

// request callback queue
@property (nonatomic, strong, readonly) dispatch_queue_t completeQueue;


/**
 * 设置token，检查token是否有效
*
 */
- (void) checkTokenIsValid:(GithubResponse) block
                     token:(NSString *) token
              serialNumber:(NSString *) serialNumber;

/**
 *
 * 注销
 *  清除token，
 *  清除cookie
 **/
- (void) logout:(GithubResponse __nullable) block
   serialNumber:(NSString * __nullable) serialNumber;


#pragma mark - users

/**
 *
 * 获取当前登陆的用户信息
 **/
- (void) getCurrentLoginUserInfo:(GithubResponse) block
                    serialNumber:(NSString *) serialNumber;


/**
 * @brief 根据loginName获取指定的用户信息
 * @param loginName 登陆名
 **/
- (void) getUserInfo:(GithubResponse) block
           loginName:(NSString *) loginName
        serialNumber:(NSString *) serialNumber;


/**
 * @brief 根据loginName和userType获取指定的组织信息
 * @param loginName 登陆名
 **/
- (void) getOrgInfo:(GithubResponse) block
          loginName:(NSString *) loginName
       serialNumber:(NSString *) serialNumber;

/**
 * @brief 根据关键字搜索users
 * @param block 请求回调
 * @param keyword 关键字
 * @param page  第n页
 * @param per_page 一页多少记录
 * @param serialNumber 流水号 通过block回调原样返回
 **/
- (void) searchUser:(GithubResponse) block
            keyword:(NSString *) keyword
               sort:(NSString *) sort
              order:(BOOL) isAsc
               page:(NSUInteger) page
           per_page:(NSUInteger) per_page
       serialNumber:(NSString *) serialNumber;


/**
 * @brief 更新用户的public Profile info
 * @param block 请求回调
 * @param name 名字 nil时不更新
 * @param blog 博客 nil时不更新
 * @param company 公司 nil时不更新
 * @param location 地址 nil时不更新
 * @param hireable 是否可以被雇佣 nil时不更新
 * @param bio 自我描述 nil时不更新
 * @param serialNumber 流水号 通过block回调原样返回
 **/
- (void) updateUserPublicProfile:(GithubResponse) block
                            name:(NSString * _Nullable) name
                           email:(NSString * _Nullable) email
                            blog:(NSString * _Nullable) blog
                         company:(NSString * _Nullable) company
                        location:(NSString * _Nullable) location
                        hireable:(NSNumber * _Nullable) hireable
                             bio:(NSString * _Nullable) bio
                    serialNumber:(NSString *) serialNumber;


/**
 * @brief 查询用户的contributions
 * @param loginName 用户的登录名
 **/
- (void) getUserContributionsData:(GithubResponse) block
                        loginName: (NSString * _Nonnull) loginName
                     serialNumber: (NSString * _Nonnull) serialNumber;


#pragma mark - repositories
/**
 * @brief 获取当前登陆的用户 repositories信息
 * @param block 请求回调
 * @param page  第n页
 * @param per_page 一页多少记录
 * @param serialNumber 流水号 通过block回调原样返回
 **/
- (void) getRepositoriesForCurrentLoginUser:(GithubResponse) block
                                       page:(NSUInteger) page
                                   per_page:(NSUInteger) per_page
                               serialNumber:(NSString *) serialNumber;




/**
 * @brief 获取某用户 repositories信息
 * @param block 请求回调
 * @param loginName 用户的登陆名
 * @param page  第n页
 * @param per_page 一页多少记录
 * @param serialNumber 流水号 通过block回调原样返回
 **/
- (void) getRepositoriesForUser:(GithubResponse) block
                      loginName:(NSString*) loginName
                           page:(NSUInteger) page
                       per_page:(NSUInteger) per_page
                   serialNumber:(NSString *) serialNumber;


/**
 * @brief 获取当前登陆的用户 标星的repositories信息
 * @param block 请求回调
 * @param page  第n页
 * @param per_page 一页多少记录
 * @param serialNumber 流水号 通过block回调原样返回
 **/
- (void) getStarredRepositoriesForCurrentLoginUser:(GithubResponse) block
                                              page:(NSUInteger) page
                                          per_page:(NSUInteger) per_page
                                      serialNumber:(NSString *) serialNumber;




/**
 * @brief 获取某用户标星 repositories信息
 * @param block 请求回调
 * @param loginName 用户的登陆名
 * @param page  第n页
 * @param per_page 一页多少记录
 * @param serialNumber 流水号 通过block回调原样返回
 **/
- (void) getStarredRepositoriesForUser:(GithubResponse) block
                             loginName:(NSString*) loginName
                                  page:(NSUInteger) page
                              per_page:(NSUInteger) per_page
                          serialNumber:(NSString *) serialNumber;


/**
 * @brief 根据关键字搜索repos
 * @param block 请求回调
 * @param keyword 关键字
 * @param page  第n页
 * @param per_page 一页多少记录
 * @param serialNumber 流水号 通过block回调原样返回
 **/
- (void) searchRepos:(GithubResponse) block
             keyword:(NSString *) keyword
                sort:(NSString *) sort
               order:(BOOL) isAsc
                page:(NSUInteger) page
            per_page:(NSUInteger) per_page
        serialNumber:(NSString *) serialNumber;


/**
 * @brief 根据fullName直接获取Repo的详细信息
 * @param block 请求回调
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号 通过block回调原样返回
 **/
- (void) getRepositoryInfo:(GithubResponse) block
                  fullName:(NSString *) fullName
              serialNumber:(NSString *) serialNumber;


/**
* @brief 根据fullName直接获取Repo readme 信息
* @param block 请求回调
* @param fullName octocat/Hello-World
* @param serialNumber 流水号 通过block回调原样返回
**/
- (void) getRepositoryReadMeInfo:(GithubResponse) block
                        fullName:(NSString *) fullName
                          branch:(NSString * __nullable)branch
                          isHTML:(BOOL) isHTML
                    serialNumber:(NSString *) serialNumber;


/**
 * @brief 根据fullName直接获取Repo readme 信息
 * @param block 请求回调
 * @param fullName octocat/Hello-World
 * @param state closed / open / all
 * @param serialNumber 流水号 通过block回调原样返回
 **/
- (void) getRepositoryPullRequestInfo:(GithubResponse) block
                             fullName:(NSString *) fullName
                                state:(NSString *) state
                             per_page:(NSInteger) per_page
                                 page:(NSInteger) page
                         serialNumber:(NSString *) serialNumber;

/**
 * @brief 根据fullName直接获取Repo readme 信息
 * @param block 请求回调
 * @param fullName octocat/Hello-World
 * @param untilDate  限制commit的最晚时间
 * @param sinceDate 限制commir的最早时间
 * @param serialNumber 流水号 通过block回调原样返回
 **/
- (void) getRepositoryCommitsInfo:(GithubResponse) block
                         fullName:(NSString *) fullName
                           branch:(NSString *) branch
                            until:(NSDate *) untilDate
                            since:(NSDate *) sinceDate
                     serialNumber:(NSString *) serialNumber;

/**
 * @brief 根据fullName直接获取branches 信息
 * @param block 请求回调
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号 通过block回调原样返回
 **/
- (void) getRepositoryBranchesInfo:(GithubResponse) block
                          fullName:(NSString *) fullName
                      serialNumber:(NSString *) serialNumber;


/**
 * @brief 根据fullName直接获取contents 信息
 * @param block 请求回调
 * @param fullName octocat/Hello-World
 * @param path 路径
 * @param serialNumber 流水号 通过block回调原样返回
 **/
- (void) getRepositoryContentsInfo:(GithubResponse) block
                          fullName:(NSString *) fullName
                              path:(NSString *) path
                            branch:(NSString *) branch
                      serialNumber:(NSString *) serialNumber;


- (void) getRepositoryFileInfo:(GithubResponse) block
                      fullName:(NSString *) fullName
                          path:(NSString *) path
                        branch:(NSString *) branch
                    acceptType:(NSString * __nullable) acceptType
                  serialNumber:(NSString *) serialNumber;


- (void) getRepositoryContributors:(GithubResponse) block
                          fullName:(NSString *) fullName
                      serialNumber:(NSString *) serialNumber;


#pragma mark - star repo

- (void) getStarRepositoryStatus:(GithubResponse) block
                        fullName:(NSString *) fullName
                    serialNumber:(NSString *) serialNumber;

- (void) starRepository:(GithubResponse) block
               fullName:(NSString *) fullName
           serialNumber:(NSString *) serialNumber;

- (void) unstarRepository:(GithubResponse) block
                 fullName:(NSString *) fullName
             serialNumber:(NSString *) serialNumber;

- (void) getRepoStargazers:(GithubResponse) block
                  fullName:(NSString *) fullName
                  per_page:(NSInteger) per_page
                      page:(NSInteger) page
              serialNumber:(NSString *) serialNumber;


#pragma mark - watch repo

- (void) getWatchRepositoryStatus:(GithubResponse) block
                         fullName:(NSString *) fullName
                     serialNumber:(NSString *) serialNumber;

- (void) watchRepository:(GithubResponse) block
                fullName:(NSString *) fullName
            serialNumber:(NSString *) serialNumber;

- (void) unwatchRepository:(GithubResponse) block
                  fullName:(NSString *) fullName
              serialNumber:(NSString *) serialNumber;

- (void) getRepoWatchers:(GithubResponse) block
                fullName:(NSString *) fullName
                per_page:(NSInteger) per_page
                    page:(NSInteger) page
            serialNumber:(NSString *) serialNumber;


#pragma mark - fork repo


/**
 * @brief fork repo
 * @param block 请求回调
 * @param fullName octocat/Hello-World
 * @param org 组织名  nil 默认fork至当前用户   非nil fork至org
 **/

- (void) forkRepository:(GithubResponse) block
               fullName:(NSString *) fullName
                    org:(NSString * __nullable) org
           serialNumber:(NSString *) serialNumber;


- (void) getRepoForks:(GithubResponse) block
             fullName:(NSString *) fullName
             per_page:(NSInteger) per_page
                 page:(NSInteger) page
         serialNumber:(NSString *) serialNumber;



#pragma mark - gists

- (void) getGistsForCurrentUser:(GithubResponse) block
                           page:(NSUInteger) page
                       per_page:(NSUInteger) per_page
                   serialNumber:(NSString *) serialNumber;

- (void) getGistsForUser:(GithubResponse) block
               loginName:(NSString *) loginName
                    page:(NSUInteger) page
                per_page:(NSUInteger) per_page
            serialNumber:(NSString *) serialNumber;

#pragma mark - followers

- (void) getFollowersForUser:(GithubResponse) block
                   loginName:(NSString*) loginName
                        page:(NSUInteger) page
                    per_page:(NSUInteger) per_page
                serialNumber:(NSString *) serialNumber;

- (void) getUserFollowStatus: (GithubResponse) block
                   loginName: (NSString *) loginName
                serialNumber:(NSString *) serialNumber;

- (void) followUser: (GithubResponse) block
          loginName: (NSString *) loginName
       serialNumber: (NSString *) serialNumber;

- (void) unfollowUser: (GithubResponse) block
            loginName: (NSString *) loginName
         serialNumber: (NSString *) serialNumber;


#pragma mark - following

- (void) getFollowingForUser:(GithubResponse) block
                   loginName:(NSString*) loginName
                        page:(NSUInteger) page
                    per_page:(NSUInteger) per_page
                serialNumber:(NSString *) serialNumber;

#pragma mark - events
- (void)getReceivedEventsForUser:(NSString *)userName
                            page:(NSUInteger)page
                        per_page:(NSUInteger)per_page
                    serialNumber:(NSString *)serialNumber
                   responseBlock:(GithubResponse)block;


- (void)getEventsForUser:(NSString *)userName
                    page:(NSUInteger)page
                per_page:(NSUInteger)per_page
            serialNumber:(NSString *)serialNumber
           responseBlock:(GithubResponse)block;



#pragma mark - Issues


- (void) getRepositoryIssues:(GithubResponse) block
                    fullName:(NSString *) fullName
                       state:(NSString *) state
                    per_page:(NSInteger) per_page
                        page:(NSInteger) page
                serialNumber:(NSString *) serialNumber;


- (void) createIssue:(GithubResponse) block
            fullName:(NSString *) fullName
               title:(NSString *) title
             content:(NSString * __nullable) content
              labels:(NSArray * __nullable) labels
           assignees:(NSArray * __nullable) assignees
        serialNumber:(NSString *) serialNumber;


#pragma mark - notification

- (void) getNotification:(GithubResponse) block
                 showAll:(BOOL) showAll
                    page:(NSUInteger)page
                per_page:(NSUInteger)per_page
            serialNumber:(NSString *) serialNumer;

- (void) markNotificationRead:(GithubResponse) block
               notificationId:(NSString *) notificationId
                 serialNumber:(NSString *) serialNumer;


#pragma mark - languages

- (void) getLanguagesList:(GithubResponse) block
             serialNumber:(NSString *) serialNumber;


- (void) getRepoLanguages:(GithubResponse) block
                 fullName:(NSString *) fullName
             serialNumber:(NSString *) serialNumber;


#pragma mark - action

- (void) getRepoWorkflows:(GithubResponse) block
                 fullName:(NSString *) fullName
                 per_page:(NSInteger) per_page
                     page:(NSInteger) page
             serialNumber:(NSString *) serialNumer;



- (void) getRepoWorkflowRuns:(GithubResponse) block
                    fullName:(NSString *) fullName
                  workflowId:(NSString *) workflowId
                    per_page:(NSInteger) per_page
                        page:(NSInteger) page
                serialNumber:(NSString *) serialNumer;


- (void) rerunRepoWorkflowRun:(GithubResponse) block
                     fullName:(NSString *) fullName
                workflowRunId:(NSString *) workflowRunId
                 serialNumber:(NSString *) serialNumer;

- (void) cancelRepoWorkflowRun:(GithubResponse) block
                      fullName:(NSString *) fullName
                 workflowRunId:(NSString *) workflowRunId
                  serialNumber:(NSString *) serialNumer;

- (void) getRepoWorkflowRunLog:(GithubResponse) block
                      fullName:(NSString *) fullName
                 workflowRunId:(NSString *) workflowRunId
                  serialNumber:(NSString *) serialNumer;


#pragma mark - markdown

- (void) renderCodeToMarkdown:(GithubResponse) block
                          code:(NSString *) code
                 serialNumber:(NSString *) serialNumber;



#pragma mark - Blocks

- (void) getBlocks:(GithubResponse) block
      serialNumber:(NSString *) serialNumber;

- (void) getUserBlockStatus: (GithubResponse) block
                  loginName: (NSString *) loginName
               serialNumber:(NSString *) serialNumber;

- (void) blockUser: (GithubResponse) block
         loginName: (NSString *) loginName
      serialNumber: (NSString *) serialNumber;

- (void) unBlockUser: (GithubResponse) block
           loginName: (NSString *) loginName
        serialNumber: (NSString *) serialNumber;


#pragma mark - config

- (void) getGithubClientConfig:(GithubResponse)block
                  serialNumber:(NSString *) serialNumber;


#pragma mark - trending

- (void) trendingUser: (GithubResponse)block
             language:(NSString * __nullable) language
            dateRange:(ZLDateRange) dateRange
         serialNumber:(NSString *) serialNumber;

- (void) trendingRepo:(GithubResponse)block
             language:(NSString * __nullable) language
   spokenLanguageCode:(NSString * __nullable) spokenLanguageCode
            dateRange:(ZLDateRange) dateRange
         serialNumber:(NSString *) serialNumber;
@end








NS_ASSUME_NONNULL_END
