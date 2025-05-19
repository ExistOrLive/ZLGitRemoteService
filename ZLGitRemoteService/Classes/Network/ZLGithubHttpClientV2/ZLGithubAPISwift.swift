//
//  ZLGithubAPISwift.swift
//  ZLGitRemoteService
//
//  Created by 朱猛 on 2023/4/10.
//

import Foundation
import MJExtension
import Alamofire

enum ZLGithubAPISwift {
    
    // MARK: User
    
    /// 当前用户的Repo 包括private
    ///  - Parameters
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    case currentUserRepoUrl(page: Int,
                            per_Page: Int)
    /// 当前用户的Star列表
    ///  - Parameters
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    case currentUserStarreds(page: Int,
                             per_page: Int)
    ///  当前用户的Gist列表
    ///  - Parameters
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    case currentUserGists(page: Int,
                          per_page: Int)
    /// 用户信息
    ///  - Parameters
    ///    - login: 用户标识
    case userInfo(login: String)
    
    /// 更新用户信息
    ///  - Parameters
    ///    - name: user name
    ///    - email:
    ///    - blog: 博客地址
    ///    - company:
    ///    - location:
    ///    - hireable: 是否可雇佣
    case updateCurrentUserInfo(name: String?,
                               email: String?,
                               blog: String?,
                               company: String?,
                               location: String?,
                               hireable: NSNumber?,
                               bio: String?)
    ///  获取follow用户状态
    ///  - Parameters
    ///    - login: 用户标识
    case getFollowUserStatus(login: String)
    ///  follow 用户
    ///  - Parameters
    ///    - login: 用户标识
    case followUser(login: String)
    ///  取消follow用户
    ///  - Parameters
    ///    - login: 用户标识
    case unfollowUser(login: String)
    ///  获取block的用户列表
    case getBlockedUsers
    ///  获取block 用户状态
    ///  - Parameters
    ///    - login: 用户标识
    case getBlockUserStatus(login: String)
    ///  block用户
    ///  - Parameters
    ///    - login: 用户标识
    case blockUser(login: String)
    ///  取消block用户
    ///  - Parameters
    ///    - login: 用户标识
    case unblockUser(login: String)
    ///  获取某个用户的公共仓库列表
    ///  - Parameters
    ///    - login: 用户标识
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    case getRepositoriesForUser(login: String,
                                page: Int,
                                per_page: Int)
    ///  获取某个用户的粉丝列表
    ///  - Parameters
    ///    - login: 用户标识
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    case getFollowersForUser(login: String,
                             page: Int,
                             per_page: Int)
    ///  获取某个用户的关注列表
    ///  - Parameters
    ///    - login: 用户标识
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    case getFollowingsForUser(login: String,
                              page: Int,
                              per_page: Int)
    ///  获取某个用户的star仓库列表
    ///  - Parameters
    ///    - login: 用户标识
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    case getStarredForUser(login: String,
                           page: Int,
                           per_page: Int)
    ///  获取某个用户的Gist列表
    ///  - Parameters
    ///    - login: 用户标识
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    case getGistsForUser(login: String,
                         page: Int,
                         per_page: Int)
    
    ///  某个用户的事件(如果为当前登陆用户则会包含私密事件)
    ///  - Parameters
    ///    - login: 用户标识
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    case getEventsForUser(login: String,
                          page: Int,
                          per_page: Int)
    
    /// 某个用户接受的事件(关注的仓库或用户的事件)
    ///  - Parameters
    ///    - login: 用户标识
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    case getReceivedEventsForUser(login: String,
                                  page: Int,
                                  per_page: Int)
    
    // MARK: Repo
    ///  获取readme
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - ref: 分支
    ///    - mediaType:  返回的数据类型
    case getRepoReadMeInfo(fullName: String,
                           ref: String?,
                           mediaType: ZLGithubMediaType)
    ///  获取仓库的PR列表
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - state: 状态  open/closed
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    case getPRsForRepo(fullName: String,
                       state: String,
                       page: Int,
                       per_page: Int)
    ///  获取仓库的commit列表
    ///  - Parameters
    ///    - fullName : 仓库名 existorlive/githubclient
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    ///    - sha:  SHA or branch 默认： 默认分支
    ///    - path: 文件路径 过滤包含该文件的commit
    ///    - author: 作者
    ///    - committer: 提交者
    ///    - since: 过滤时间之后 YYYY-MM-DDTHH:MM:SSZ
    ///    - until: 过滤时间之前 
    case getCommitsForRepo(fullName: String,
                           page: Int = 1,
                           per_page: Int = 30,
                           sha: String? = nil,
                           path: String? = nil,
                           author: String? = nil,
                           committer: String? = nil,
                           since: Date? = nil,
                           until: Date? = nil)
    ///  获取仓库的commit 信息
    ///  - Parameters
    ///    - login : existorlive
    ///    - repoName: 仓库名 githubclient
    ///    - ref:  commit sha
    case getCommitInfoForRepo(login: String,
                              repoName: String,
                              ref: String)
    
    ///  获取仓库的commit diff 信息
    ///  - Parameters
    ///    - login : existorlive
    ///    - repoName: 仓库名 githubclient
    ///    - ref:  commit sha
    case getCommitDiffForRepo(login: String,
                              repoName: String,
                              ref: String)
    
    
    ///  比较两次commit
    ///  - Parameters
    ///    - login : existorlive
    ///    - repoName: 仓库名 githubclient
    ///    - ref:  commit sha
    case getCommitCompareForRepo(login: String,
                                 repoName: String,
                                 baseRef: String,
                                 headRef: String,
                                 page: Int = 1,
                                 per_page: Int = 30)

    ///  获取仓库的分支列表
    ///  - Parameters
    ///    - fullName : 仓库名 existorlive/githubclient
    case getBranchsForRepo(fullName: String)
    ///  获取仓库的贡献者列表
    ///  - Parameters
    ///    - fullName : 仓库名 existorlive/githubclient
    case getContributorsForRepo(fullName: String)
    ///  获取仓库的issue列表
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - state: 状态  open/closed
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    case getIssuesForRepo(fullName: String,
                          state: String,
                          page: Int,
                          per_page: Int)
    ///  在指定repo创建issue
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - title: 标题
    ///    - body: issue 内容
    ///    - labels: label
    ///    - assignees: 指定负责人
    case createIssueForRepo(fullName: String,
                            title: String,
                            body: String,
                            labels: [String],
                            assignees: [String])
    ///  获取watch仓库的状态
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    case getWatchRepoStatus(fullName: String)
    ///  watch仓库
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    case watchRepo(fullName: String)
    ///  取消watch仓库
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    case unwatchRepo(fullName: String)
    ///  获取仓库的watchers列表
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    case getWatchersForRepo(fullName: String,
                            page: Int,
                            per_page: Int)
    ///  获取star仓库的状态
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    case getStarRepoStatus(fullName: String)
    ///  star仓库
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    case starRepo(fullName: String)
    ///  取消star仓库
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    case unstarRepo(fullName: String)
    ///  获取仓库的stargazers列表
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    case getStargazersForRepo(fullName: String,
                              page: Int,
                              per_page: Int)
    ///  fork 仓库
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - organization: 组织名：  fork 仓库到组织下
    ///    - name: fork 后的仓库名
    ///    - default_branch_only: 是否只fork 默认分支
    case forkRepo(fullName: String,
                  organization: String?,
                  name: String?,
                  default_branch_only: Bool = false)
    ///  获取仓库的fork列表
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    case getForksForRepo(fullName: String,
                         page: Int,
                         per_page: Int)
    ///  获取仓库的开发语言信息
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    case getLanguagesInfoForRepo(fullName: String)
    ///  获取仓库的workflow
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    case getWorkflowsForRepo(fullName: String,
                             page: Int,
                             per_page: Int)
    ///  获取仓库的workflow的执行记录
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - workflowId:  workflowId
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    case getWorkflowRunsForRepo(fullName: String,
                                workflowId: String,
                                page: Int,
                                per_page: Int)
    /// 从新执行仓库的workflow的某次执行
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - workflowRunId:  workflowRunId
    case rerunWorkflowRunForRepo(fullName: String,
                                 workflowRunId: String)
    /// 取消仓库的workflow的某次执行
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - workflowRunId:  workflowRunId
    case cancelWorkflowRunForRepo(fullName: String,
                                  workflowRunId: String)
    ///  获取仓库的workflow的某次执行的日志
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - workflowRunId:  workflowRunId
    case getWorkflowRunLogForRepo(fullName: String,
                                  workflowRunId: String)
    ///  获取仓库的指定目录内容
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - path:  目录的路径
    ///    - ref: 分支，传空使用默认分支
    case getDirContentForRepo(fullName: String,
                              path: String,
                              ref: String?)
    ///  获取仓库的指定文件内容
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - path:  仓库的路径
    ///    - ref: 分支，传空使用默认分支
    ///    - mediaType: 文件内容返回的类型 （text，html 或 raw）
    case getFileContentForRepo(fullName: String,
                               path: String,
                               ref: String?,
                               mediaType: ZLGithubMediaType)
    
    // MARK: Notification
    ///  获取当前用户的通知
    ///  - Parameters
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    ///    - all: 是否全部；否则只返回未读通知
    case notification(page: Int,
                      per_page: Int,
                      all: Bool)
    
    ///  设置通知已读
    ///  - Parameters
    ///    - thread_id: 通知的id
    case markNotificationReaded(thread_id: String)
    
    // MARK: Trending
    ///  获取趋势仓库
    ///  - Parameters
    ///    - language: 开发语言
    ///    - spokenLanguageCode: 交流语言
    ///    - dateRange: 时间范围
    case getTrendingRepos(language: String?,
                          spokenLanguageCode: String?,
                          dateRange: ZLDateRange)
    ///  获取趋势开发者
    ///  - Parameters
    ///    - language: 开发语言
    ///    - dateRange: 时间范围
    case getTrendingDevelopers(language: String?,
                               dateRange: ZLDateRange)
    
    // MARK: Search
    ///  搜索用户
    ///  - Parameters
    ///    - q: 关键字
    ///    - sort: 排序方式 followers/joined/repositories
    ///    - asc: 是否递增
    case searchUser(q: String,
                    sort: String?,
                    asc: Bool,
                    page: Int,
                    per_page: Int)
    
    ///  搜索仓库
    ///  - Parameters
    ///    - q: 关键字
    ///    - sort: 排序方式 stars/forks/updated
    ///    - asc: 是否递增
    case searchRepo(q: String,
                    sort: String?,
                    asc: Bool,
                    page: Int,
                    per_page: Int)
    
    // MARK: other
    ///  获取Github支持的开发语言列表
    case getDevelopLanguageList
    ///  将代码渲染为markdown
    case renderCodeToMarkdown(code: String)
    
    /// 获取html API
    case getHtmlURL(api: String)
    
    
    
    
    // MARK: 非Github API
    case getAPPCommonConfig
}











