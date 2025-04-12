//
//  ZLEventServiceHeader.h
//  ZLGitHubClient
//
//  Created by LongMac on 2019/9/1.
//  Copyright © 2019年 ZM. All rights reserved.
//

#ifndef ZLEventServiceHeader_h
#define ZLEventServiceHeader_h

#import "ZLBaseServiceModel.h"
@class ZLOperationResultModel;

#pragma mark - NotificationName

static NSNotificationName const _Nonnull ZLGetUserReceivedEventResult_Notification = @"ZLGetUserReceivedEventResult_Notification";
static NSNotificationName const _Nonnull ZLGetMyEventResult_Notification = @"ZLGetMyEventResult_Notification";

@protocol ZLEventServiceModuleProtocol <ZLBaseServiceModuleProtocol>

#pragma mark - event

/**
 *  @brief 请求当前用户的event
 *
 **/
- (void) getMyEventsWithpage:(NSUInteger)page
                    per_page:(NSUInteger)per_page
                serialNumber:(NSString * _Nonnull)serialNumber
              completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle ;

/**
 *  @brief 请求用户的event
 *
 **/
- (void) getEventsForUser:(NSString * _Nonnull) userName
                     page:(NSUInteger)page
                 per_page:(NSUInteger)per_page
             serialNumber:(NSString * _Nonnull)serialNumber
           completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;



/**
 * @brief 请求某个用户的receive_events
 *
 **/
- (void)getReceivedEventsForUser:(NSString * _Nonnull)userName
                            page:(NSUInteger)page
                        per_page:(NSUInteger)per_page
                    serialNumber:(NSString * _Nonnull)serialNumber
                  completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;



#pragma mark - notification

- (void) getNotificationsWithShowAll:(bool) showAll
                                page:(int) page
                            per_page:(int) page
                        serialNumber:(NSString * _Nonnull)serialNumber
                      completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle;


- (void) markNotificationReadedWithNotificationId:(NSString * _Nonnull) notificationId
                                     serialNumber:(NSString * _Nonnull)serialNumber
                                   completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle;


#pragma mark - PR

- (void) getPRInfoWithLogin:(NSString * _Nonnull) login
                   repoName:(NSString * _Nonnull) repoName
                     number:(int) number
                      after:(NSString * _Nullable) after
               serialNumber:(NSString *_Nonnull) serialNumber
             completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle;

#pragma mark - discussion


/**
 * @brief 获取discussion info
 * @param loginName 登录名
 * @param repoName 仓库名
 * @param number discussion number
 * @param serialNumber 流水号
 **/
- (void) getDiscussionInfoWithLogin:(NSString * _Nonnull) login
                           repoName:(NSString * _Nonnull) repoName
                             number:(int) number
                       serialNumber:(NSString *_Nonnull) serialNumber
                     completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle;

/**
 * @brief 获取discussion 的评论
 * @param loginName 登录名
 * @param repoName 仓库名
 * @param number discussion number
 * @param per_page 每页数量
 * @param after after
 * @param serialNumber 流水号
 **/
- (void) getDiscussionCommentWithLogin:(NSString * _Nonnull) login
                              repoName:(NSString * _Nonnull) repoName
                                number:(int) number
                              per_page:(int) per_page
                                 after:(NSString * _Nullable) after
                          serialNumber:(NSString *_Nonnull) serialNumber
                        completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle;

/**
 * @brief 获取仓库的discussion列表
 * @param loginName 登录名
 * @param repoName 仓库名
 * @param per_page 每页数量
 * @param after after 
 * @param serialNumber 流水号
 **/
- (void) getDiscussionInfoListWithLogin:(NSString * _Nonnull) login
                               repoName:(NSString * _Nonnull) repoName
                               per_page:(int) number
                                  after:(NSString * _Nullable) after
                           serialNumber:(NSString *_Nonnull) serialNumber
                         completeHandle:(void(^_Nonnull)(ZLOperationResultModel * _Nonnull)) handle;

#pragma mark - issues

/**
 * @brief 获取issue info
 * @param loginName 登录名
 * @param repoName 仓库名
 * @param number issue number
 * @param serialNumber 流水号
 **/
- (void) getRepositoryIssueInfoWithLoginName:(NSString * _Nonnull) loginName
                                    repoName:(NSString * _Nonnull) repoName
                                      number:(int) number
                                serialNumber:(NSString * _Nonnull) serialNumber
                              completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

/**
 * @brief 获取issue timeline info
 * @param loginName 登录名
 * @param repoName 仓库名
 * @param number issue number
 * @param after
 * @param serialNumber 流水号
 **/
- (void) getRepositoryIssueTimelineWithLoginName:(NSString * _Nonnull) loginName
                                        repoName:(NSString * _Nonnull) repoName
                                          number:(int) number
                                           after:(NSString * _Nullable) after
                                    serialNumber:(NSString * _Nonnull) serialNumber
                                  completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;
/**
 * @brief 获取issue 的可编辑信息 如 受理者 label 里程碑 项目
 * @param loginName 登录名
 * @param repoName 仓库名
 * @param number issue编号
 * @param serialNumber 流水号
 **/
- (void) getIssueEditInfoWithLoginName:(NSString * _Nonnull) loginName
                              repoName:(NSString * _Nonnull) repoName
                                number:(int) number
                          serialNumber:(NSString * _Nonnull) serialNumber
                        completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

/**
 * @brief 添加issue 评论
 * @param issueId  graogql node id
 * @param comment 评论
 * @param serialNumber 流水号
 **/
- (void) addIssueCommentWithIssueId:(NSString * _Nonnull) issueId
                            comment:(NSString * _Nonnull) comment
                       serialNumber:(NSString * _Nonnull) serialNumber
                     completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;


/**
 * @brief 编辑issue 受理者
 * @param issueId  graogql node id
 * @param addedList 添加的受理者id
 * @param removedList 移除的受理者id
 * @param serialNumber 流水号
 **/
- (void) editIssueAssigneesWithIssueId:(NSString * _Nonnull) issueId
                             addedList:(NSArray<NSString *> * _Nonnull) addedList
                           removedList:(NSArray<NSString *> * _Nonnull) removedList
                          serialNumber:(NSString * _Nonnull) serialNumber
                        completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;


/**
 * @brief 根据repo fullname 创建 issues
 * @param fullName octocat/Hello-World
 * @param serialNumber 流水号
 **/
- (void) createIssueWithFullName:(NSString * _Nonnull) fullName
                           title:(NSString * _Nonnull) title
                            body:(NSString * __nullable) body
                          labels:(NSArray * __nullable) labels
                       assignees:(NSArray * __nullable) assignees
                    serialNumber:(NSString * _Nonnull) serialNumber
                  completeHandle:(void(^ _Nonnull)(ZLOperationResultModel *  _Nonnull)) handle;

/**
 * @brief 打开/关闭issue
 * @param issueId  graogql node id
 * @param open 打开/关闭
 * @param serialNumber 流水号
 **/
- (void) openOrCloseIssue:(NSString * _Nonnull) issueId
                     open:(BOOL) open
             serialNumber:(NSString * _Nonnull) serialNumber
           completeHandle:(void(^ _Nonnull)(ZLOperationResultModel * _Nonnull)) handle;

/**
 * @brief 锁定/解锁 issue/pr
 * @param lockableId  graogql node id
 * @param lock 锁定/解锁
 * @param serialNumber 流水号
 **/
- (void) lockOrUnlockLockable:(NSString * _Nonnull) lockableId
                         lock:(BOOL) lock
                 serialNumber:(NSString * _Nonnull) serialNumber
               completeHandle:(void(^ _Nonnull)(ZLOperationResultModel * _Nonnull)) handle;

/**
 * @brief 订阅/取消订阅 issue/pr
 * @param subscriptionId  graogql node id
 * @param subscribe 订阅/取消订阅
 * @param serialNumber 流水号
 **/
- (void) subscribeOrUnsubscribeSubscription:(NSString * _Nonnull) subscriptionId
                                  subscribe:(BOOL) subscribe
                               serialNumber:(NSString * _Nonnull) serialNumber
                             completeHandle:(void(^ _Nonnull)(ZLOperationResultModel * _Nonnull)) handle;
@end

#endif /* ZLEventServiceHeader_h */
