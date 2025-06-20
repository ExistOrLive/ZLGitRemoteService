//
//  ZLRepoServiceHeader.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/24.
//  Copyright © 2019 ZM. All rights reserved.
//

#ifndef ZLRepoServiceHeader_h
#define ZLRepoServiceHeader_h

#import "ZLBaseServiceModel.h"
@class ZLOperationResultModel;
@class ZLGithubRepositoryModelV2;

#pragma mark - NotificationName

@protocol ZLRepoServiceModuleProtocol <ZLBaseServiceModuleProtocol>


#pragma mark - Repo Info

/**
 * @brief 根据repo full name 获取仓库信息
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/

- (ZLGithubRepositoryModelV2 *_Nullable) getRepoInfoWithFullName:(NSString * _Nonnull) fullName
                                         serialNumber:(NSString * _Nonnull) serialNumber
                                       completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

/**
 * @brief 根据repo full name 获取仓库信息
 * @param ownerName octocat
 * @param repoName Hello-World
 * @param serialNumber 流水号
 **/
- (ZLGithubRepositoryModelV2 *_Nullable) getRepoInfoWithOwnerName:(NSString * _Nonnull) ownerName
                                              repoName:(NSString * _Nonnull) repoName
                                          serialNumber:(NSString * _Nonnull) serialNumber
                                        completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;



#pragma mark - Repo ReadMe PullRequest Commit Branch

/**
 * @brief 根据repo readMe 地址
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) getRepoReadMeInfoWithFullName:(NSString * _Nonnull) fullName
                                branch:(NSString * __nullable) branch
                                isHTML:(BOOL) isHTML
                          serialNumber:(NSString * _Nonnull) serialNumber
                        completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

/**
 * @brief 根据repo 获取pullrequest
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/

- (void) getRepoPullRequestWithFullName:(NSString * _Nonnull) fullName
                                  state:(NSString * _Nonnull) state
                               per_page:(NSInteger)per_page
                                   page:(NSInteger)page
                           serialNumber:(NSString * _Nonnull) serialNumber
                         completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;


/**
 * @brief 根据repo 获取commit
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/

- (void) getRepoCommitWithFullName:(NSString * _Nonnull) fullName
                              page:(NSUInteger) page
                          per_page:(NSUInteger) per_page
                            branch:(NSString * __nullable) branch
                             until:(NSDate * __nullable) untilDate
                             since:(NSDate * __nullable) sinceDate
                      serialNumber:(NSString * _Nonnull) serialNumber
                    completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

/**
 * @brief 获取commit 的信息
 * @param login octocat/Hello-World
 * @param repoName octocat/Hello-World
 * @param ref sha
 * @param serialNumber 流水号
 **/


- (void) getRepoCommitInfoWithLogin:(NSString * _Nonnull) login
                           repoName:(NSString * _Nonnull) repoName
                                ref:(NSString * _Nonnull) ref
                       serialNumber:(NSString *) serialNumber
                     completeHandle:(void(^ _Nonnull)(ZLOperationResultModel * _Nonnull)) handle;

/**
 * @brief 获取commit 的diff信息
 * @param login octocat/Hello-World
 * @param repoName octocat/Hello-World
 * @param ref sha
 * @param serialNumber 流水号
 **/

- (void) getRepoCommitDiffWithLogin:(NSString * _Nonnull) login
                           repoName:(NSString * _Nonnull) repoName
                                ref:(NSString * _Nonnull) ref
                       serialNumber:(NSString *) serialNumber
                     completeHandle:(void(^ _Nonnull)(ZLOperationResultModel * _Nonnull)) handle;

/**
 * @brief 获取两次commit 的比较信息
 * @param login octocat/Hello-World
 * @param repoName octocat/Hello-World
 * @param ref sha
 * @param serialNumber 流水号
 **/
- (void) getRepoCommitCompareWithLogin:(NSString * _Nonnull) login
                              repoName:(NSString * _Nonnull) repoName
                               baseRef:(NSString * _Nonnull) baseRef
                               headRef:(NSString * _Nonnull) headRef
                              per_page:(NSInteger)per_page
                                  page:(NSInteger)page
                          serialNumber:(NSString *) serialNumber
                        completeHandle:(void(^ _Nonnull)(ZLOperationResultModel * _Nonnull)) handle;

/**
 * @brief 根据repo 获取branch
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) getRepositoryBranchesInfoWithFullName:(NSString * _Nonnull) fullName
                                  serialNumber:(NSString * _Nonnull) serialNumber
                                completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;





/**
 * @brief 根据repo fullname获取 贡献者
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) getRepositoryContributorsWithFullName:(NSString * _Nonnull) fullName
                                  serialNumber:(NSString * _Nonnull) serialNumber
                                completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;


/**
 * @brief 根据repo fullname获取 issues
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) getRepositoryIssuesWithFullName:(NSString * _Nonnull) fullName
                                   state:(NSString * _Nonnull) state
                                per_page:(NSInteger) per_page
                                    page:(NSInteger) page
                            serialNumber:(NSString * _Nonnull) serialNumber
                          completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;


#pragma mark - subscription

- (void) watchRepoWithFullName:(NSString * _Nonnull) fullName
                  serialNumber:(NSString * _Nonnull) serialNumber
                completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

- (void) unwatchRepoWithFullName:(NSString * _Nonnull) fullName
                    serialNumber:(NSString * _Nonnull) serialNumber
                  completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

- (void) getRepoWatchStatusWithFullName:(NSString * _Nonnull) fullName
                           serialNumber:(NSString * _Nonnull) serialNumber
                         completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

- (void) getRepoWatchersWithFullName:(NSString * _Nonnull) fullName
                        serialNumber:(NSString * _Nonnull) serialNumber
                            per_page:(NSInteger) per_page
                                page:(NSInteger) page
                      completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;





#pragma mark - star repo

- (void) starRepoWithFullName:(NSString * _Nonnull) fullName
                  serialNumber:(NSString * _Nonnull) serialNumber
                completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

- (void) unstarRepoWithFullName:(NSString * _Nonnull) fullName
                    serialNumber:(NSString * _Nonnull) serialNumber
                  completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

- (void) getRepoStarStatusWithFullName:(NSString * _Nonnull) fullName
                           serialNumber:(NSString * _Nonnull) serialNumber
                         completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

- (void) getRepoStargazersWithFullName:(NSString * _Nonnull) fullName
                          serialNumber:(NSString * _Nonnull) serialNumber
                              per_page:(NSInteger) per_page
                                  page:(NSInteger) page
                        completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;



#pragma mark - fork

- (void) forkRepositoryWithFullName:(NSString * _Nonnull) fullName
                                org:(NSString * __nullable) org
                       serialNumber:(NSString * _Nonnull) serialNumber
                     completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

- (void) getRepoForksWithFullName:(NSString * _Nonnull) fullName
                     serialNumber:(NSString * _Nonnull) serialNumber
                         per_page:(NSInteger) per_page
                             page:(NSInteger) page
                   completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;


#pragma mark - languages

- (void) getRepoLanguagesWithFullName:(NSString * _Nonnull) fullName
                     serialNumber:(NSString * _Nonnull) serialNumber
                       completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;


#pragma mark - actions

- (void) getRepoWorkflowsWithFullName:(NSString * _Nonnull) fullName
                             per_page:(NSInteger) per_page
                                 page:(NSInteger) page
                         serialNumber:(NSString * _Nonnull) serialNumber
                       completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;



- (void) getRepoWorkflowRunsWithFullName:(NSString * _Nonnull) fullName
                              workflowId:(NSString * _Nonnull) workflowId
                                per_page:(NSInteger) per_page
                                    page:(NSInteger) page
                            serialNumber:(NSString * _Nonnull) serialNumber
                          completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

- (void) rerunRepoWorkflowRunWithFullName:(NSString * _Nonnull) fullName
                            workflowRunId:(NSString * _Nonnull) workflowRunId
                             serialNumber:(NSString * _Nonnull) serialNumber
                           completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

- (void) cancelRepoWorkflowRunWithFullName:(NSString * _Nonnull) fullName
                             workflowRunId:(NSString * _Nonnull) workflowRunId
                              serialNumber:(NSString * _Nonnull) serialNumber
                            completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

- (void) getRepoWorkflowRunLogWithFullName:(NSString * _Nonnull) fullName
                             workflowRunId:(NSString * _Nonnull) workflowRunId
                              serialNumber:(NSString * _Nonnull) serialNumber
                            completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;


#pragma mark - Repo Content


/**
 * @brief 根据repo fullname获取 内容
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) getRepositoryContentsInfoWithFullName:(NSString * _Nonnull) fullName
                                          path:(NSString * _Nonnull) path
                                        branch:(NSString * _Nonnull) branch
                                  serialNumber:(NSString * _Nonnull) serialNumber
                                completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;


- (void) getRepositoryFileInfoWithFullName:(NSString * _Nonnull) fullName
                                      path:(NSString * _Nonnull) path
                                    branch:(NSString * _Nonnull) branch
                              serialNumber:(NSString * _Nonnull) serialNumber
                            completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;


- (void) getRepositoryFileHTMLInfoWithFullName:(NSString * _Nonnull) fullName
                                          path:(NSString * _Nonnull) path
                                        branch:(NSString * _Nonnull) branch
                                  serialNumber:(NSString * _Nonnull) serialNumber
                                completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;


- (void) getRepositoryFileRawInfoWithFullName:(NSString * _Nonnull) fullName
                                         path:(NSString * _Nonnull) path
                                       branch:(NSString * _Nonnull) branch
                                 serialNumber:(NSString * _Nonnull) serialNumber
                               completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

#pragma mark - Releases

- (void) getRepoReleaseLitsWithLogin:(NSString * _Nonnull) login
                            repoName:(NSString * _Nonnull) repoName
                             per_page:(NSInteger) per_page
                               after:(NSString *) after
                         serialNumber:(NSString * _Nonnull) serialNumber
                      completeHandle:(void(^ _Nonnull)(ZLOperationResultModel * _Nonnull)) handle;


- (void) getRepoReleaseInfoWithLogin:(NSString * _Nonnull) login
                            repoName:(NSString * _Nonnull) repoName
                             tagName:(NSString * _Nonnull) tagName
                         serialNumber:(NSString *) serialNumber
                      completeHandle:(void(^ _Nonnull)(ZLOperationResultModel * _Nonnull)) handle;




@end


#endif /* ZLRepoServiceHeader_h */
