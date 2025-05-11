//
//  ZLGIthubHttpClientV2+Repository.swift
//  ZLGitRemoteService
//
//  Created by 朱猛 on 2023/4/10.
//

import Foundation
import Alamofire
import MJExtension

typealias ZLGithubHttpClientSuccessBlock = (ZLGithubAPISwift, HTTPURLResponse, Data) -> Void

public extension ZLGithubHttpClientV2 {
    
    // MARK: - User
    /// 获取当前用户的仓库
    @objc func getRepositoriesForCurrentUser(page: Int,
                                             perPage: Int,
                                             serialNumber: String,
                                             response: @escaping GithubResponseSwift) {
        
        let api = ZLGithubAPISwift.currentUserRepoUrl(page: page, per_Page: perPage)
        
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    
    /// 获取用户信息
    @objc func getUserInfo(login: String,
                           serialNumber: String,
                           response: @escaping GithubResponseSwift) {
        
        let api = ZLGithubAPISwift.userInfo(login: login)
        
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    /// 更新用户信息
    ///  - Parameters
    ///    - name: user name
    ///    - email:
    ///    - blog: 博客地址
    ///    - company:
    ///    - location:
    ///    - bio: 自我介绍
    ///    - hireable: 是否可雇佣
    @objc func updateCurrentUserInfo(name: String?,
                                     email: String?,
                                     blog: String?,
                                     company: String?,
                                     location: String?,
                                     hireable: NSNumber?,
                                     bio: String?,
                                     serialNumber: String,
                                     response: @escaping GithubResponseSwift) {
        
        let api = ZLGithubAPISwift.updateCurrentUserInfo(name:  name,
                                                         email: email,
                                                         blog: blog,
                                                         company: company,
                                                         location: location,
                                                         hireable: hireable,
                                                         bio: bio)
        
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    
    
    /// 获取用户的follow状态
    @objc func getFollowStatusFor(login: String,
                                  serialNumber: String,
                                  response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getFollowUserStatus(login: login)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    /// follow用户
    @objc func followUser(login: String,
                          serialNumber: String,
                          response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.followUser(login: login)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    
    /// 取消follow用户
    @objc func unfollowUser(login: String,
                            serialNumber: String,
                            response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.unfollowUser(login: login)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    
    /// 获取用户的Block状态
    @objc func getBlockUsers(serialNumber: String,
                             response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getBlockedUsers
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    /// 获取用户的Block状态
    @objc func getBlockStatusFor(login: String,
                                 serialNumber: String,
                                 response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getBlockUserStatus(login: login)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    /// block用户
    @objc func blockUser(login: String,
                         serialNumber: String,
                         response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.blockUser(login: login)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    
    /// 取消block用户
    @objc func unblockUser(login: String,
                           serialNumber: String,
                           response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.unblockUser(login: login)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    
    /// 获取指定用户的仓库
    @objc func getRepositoriesForUser(login: String,
                                      page: Int,
                                      perPage: Int,
                                      serialNumber: String,
                                      response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getRepositoriesForUser(login: login,
                                                          page: page,
                                                          per_page: perPage)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    /// 获取指定用户的followers
    @objc func getFollowersForUser(login: String,
                                   page: Int,
                                   perPage: Int,
                                   serialNumber: String,
                                   response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getFollowersForUser(login: login,
                                                       page: page,
                                                       per_page: perPage)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    /// 获取指定用户的followings
    @objc func getFollowingsForUser(login: String,
                                    page: Int,
                                    perPage: Int,
                                    serialNumber: String,
                                    response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getFollowingsForUser(login: login,
                                                        page: page,
                                                        per_page: perPage)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    
    /// 获取指定用户的star的仓库
    @objc func getStarredsForUser(login: String,
                                  page: Int,
                                  perPage: Int,
                                  serialNumber: String,
                                  response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getStarredForUser(login: login, page: page, per_page: perPage)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    /// 获取当前的star的仓库
    @objc func getStarredsForCurrentUser(page: Int,
                                         perPage: Int,
                                         serialNumber: String,
                                         response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.currentUserStarreds(page: page, per_page: perPage)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    /// 获取当前的star的仓库
    @objc func getGistsForCurrentUser(page: Int,
                                      perPage: Int,
                                      serialNumber: String,
                                      response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.currentUserGists(page: page, per_page: perPage)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    /// 获取当前的star的仓库
    @objc func getGistsForUser(login: String,
                               page: Int,
                               perPage: Int,
                               serialNumber: String,
                               response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getGistsForUser(login: login, page: page, per_page: perPage)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    /// 获取当前仓库的readme
    @objc func getRepoReadMeInfo(fullName: String,
                                 ref: String?,
                                 isHTMLContent: Bool,
                                 serialNumber: String,
                                 response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getRepoReadMeInfo(fullName: fullName,
                                                     ref: ref,
                                                     mediaType: isHTMLContent ? .json_html : .json)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    /// 获取当前仓库的pr列表
    @objc func getPRsForRepo(fullName: String,
                             state: String,
                             page: Int,
                             per_page: Int,
                             serialNumber: String,
                             response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getPRsForRepo(fullName: fullName, state: state, page: page, per_page: per_page)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
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
    @objc func getCommitsForRepo(fullName: String,
                                 page: Int = 1,
                                 per_page: Int = 30,
                                 sha: String? = nil,
                                 path: String? = nil,
                                 author: String? = nil,
                                 committer: String? = nil,
                                 since: Date? = nil,
                                 until: Date? = nil,
                                 serialNumber: String,
                                 response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getCommitsForRepo(fullName: fullName,
                                                     page: page,
                                                     per_page: per_page,
                                                     sha:sha,
                                                     path: path,
                                                     author: author,
                                                     committer: committer,
                                                     since:since,
                                                     until: until)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  获取仓库某个commit的信息
    ///  - Parameters
    ///    - login : existorlive
    ///    - repoName: 仓库名 githubclient
    ///    - ref:  commit sha
    @objc func getCommitInfoForRepo(login: String,
                                 repoName: String,
                                 ref: String,
                                 serialNumber: String,
                                 response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getCommitInfoForRepo(login: login, repoName: repoName, ref: ref)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  获取仓库的分支列表
    ///  - Parameters
    ///    - fullName : 仓库名 existorlive/githubclient
    @objc dynamic func getBranchsForRepo(fullName: String,
                                         serialNumber: String,
                                         response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getBranchsForRepo(fullName: fullName)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  获取仓库的分支列表
    ///  - Parameters
    ///    - fullName : 仓库名 existorlive/githubclient
    @objc dynamic func getContributorsForRepo(fullName: String,
                                              serialNumber: String,
                                              response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getContributorsForRepo(fullName: fullName)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    
    ///  获取仓库的issue列表
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - state: 状态  open/closed
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    @objc dynamic func getIssuesForRepo(fullName: String,
                                        state: String,
                                        page: Int,
                                        per_page: Int,
                                        serialNumber: String,
                                        response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getIssuesForRepo(fullName: fullName,
                                                    state: state,
                                                    page: page,
                                                    per_page: per_page)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  在指定repo创建issue
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - title: 标题
    ///    - body: issue 内容
    ///    - labels: label
    ///    - assignees: 指定负责人
    @objc dynamic func createIssuesForRepo(fullName: String,
                                           title: String,
                                           body: String,
                                           labels: [String],
                                           assignees: [String],
                                           serialNumber: String,
                                           response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.createIssueForRepo(fullName: fullName,
                                                      title: title,
                                                      body: body,
                                                      labels: labels,
                                                      assignees: assignees)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    
    ///  获取watch仓库的状态
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    @objc func getWatchRepoStatus(fullName: String,
                                  serialNumber: String,
                                  response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getWatchRepoStatus(fullName: fullName)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  watch仓库
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    @objc func watchRepo(fullName: String,
                         serialNumber: String,
                         response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.watchRepo(fullName: fullName)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    
    ///  取消watch仓库
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    @objc func unwatchRepo(fullName: String,
                           serialNumber: String,
                           response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.unwatchRepo(fullName: fullName)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  获取仓库的watchers列表
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    @objc func getWatchersForRepo(fullName: String,
                                  page: Int,
                                  per_page: Int,
                                  serialNumber: String,
                                  response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getWatchersForRepo(fullName:fullName , page: page, per_page: per_page)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  获取star仓库的状态
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    @objc func getStarRepoStatus(fullName: String,
                                 serialNumber: String,
                                 response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getStarRepoStatus(fullName:fullName)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  star仓库
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    @objc func starRepo(fullName: String,
                        serialNumber: String,
                        response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.starRepo(fullName:fullName)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  取消star仓库
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    @objc func unstarRepo(fullName: String,
                          serialNumber: String,
                          response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.unstarRepo(fullName:fullName)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    
    ///  获取仓库的stargazers列表
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    @objc func getStargazersForRepo(fullName: String,
                                    page: Int,
                                    per_page: Int,
                                    serialNumber: String,
                                    response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getStargazersForRepo(fullName:fullName, page: page, per_page: per_page)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  fork 仓库
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - organization: 组织名：  fork 仓库到组织下
    ///    - name: fork 后的仓库名
    ///    - default_branch_only: 是否只fork 默认分支
    @objc func forkRepo(fullName: String,
                        organization: String?,
                        name: String?,
                        default_branch_only: Bool,
                        serialNumber: String,
                        response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.forkRepo(fullName: fullName,
                                            organization: organization,
                                            name: name,
                                            default_branch_only: default_branch_only)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  获取仓库的fork列表
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    @objc func getForksForRepo(fullName: String,
                               page: Int,
                               per_page: Int,
                               serialNumber: String,
                               response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getForksForRepo(fullName: fullName,
                                                   page: page,
                                                   per_page: per_page)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }

    ///  获取仓库的开发语言信息
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    @objc func getLanguagesInfoForRepo(fullName: String,
                                       serialNumber: String,
                                       response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getLanguagesInfoForRepo(fullName: fullName)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  获取仓库的workflow
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    @objc func getWorkflowsForRepo(fullName: String,
                                   page: Int,
                                   per_page: Int,
                                       serialNumber: String,
                                       response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getWorkflowsForRepo(fullName: fullName,
                                                       page: page,
                                                       per_page: per_page)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  获取仓库的workflow的执行记录
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - workflowId:  workflowId
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    @objc func getWorkflowRunsForRepo(fullName: String,
                                      workflowId: String,
                                      page: Int,
                                      per_page: Int,
                                      serialNumber: String,
                                      response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getWorkflowRunsForRepo(fullName: fullName,
                                                          workflowId: workflowId,
                                                          page: page,
                                                          per_page: per_page)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    /// 从新执行仓库的workflow的某次执行
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - workflowRunId:  workflowRunId
    @objc func rerunWorkflowRunForRepo(fullName: String,
                                       workflowRunId: String,
                                       serialNumber: String,
                                       response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.rerunWorkflowRunForRepo(fullName: fullName,
                                                           workflowRunId: workflowRunId)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    /// 取消仓库的workflow的某次执行
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - workflowRunId:  workflowRunId
    @objc func cancelWorkflowRunForRepo(fullName: String,
                                        workflowRunId: String,
                                        serialNumber: String,
                                        response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.cancelWorkflowRunForRepo(fullName: fullName,
                                                            workflowRunId: workflowRunId)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  获取仓库的workflow的某次执行的日志
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - workflowRunId:  workflowRunId
    @objc func getWorkflowRunLogForRepo(fullName: String,
                                        workflowRunId: String,
                                        serialNumber: String,
                                        response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getWorkflowRunLogForRepo(fullName: fullName,
                                                            workflowRunId: workflowRunId)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  获取仓库的指定目录内容
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - path:  目录的路径
    ///    - ref: 分支，传空使用默认分支
    @objc func getDirContentForRepo(fullName: String,
                                    path: String,
                                    ref: String?,
                                    serialNumber: String,
                                    response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getDirContentForRepo(fullName: fullName,
                                                        path: path,
                                                        ref: ref)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  获取仓库的指定文件内容
    ///  - Parameters
    ///    - fullName: 仓库名 existorlive/githubclient
    ///    - path:  仓库的路径
    ///    - ref: 分支，传空使用默认分支
    ///    - mediaType: 文件内容返回的类型 （text，html 或 raw）
    @objc func getFileContentForRepo(fullName: String,
                                    path: String,
                                    ref: String?,
                                     mediaType: ZLGithubMediaType,
                                    serialNumber: String,
                                    response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getFileContentForRepo(fullName: fullName,
                                                         path: path,
                                                         ref: ref,
                                                         mediaType: mediaType)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  获取Github支持的开发语言列表
    @objc func getDevelopLanguageList(serialNumber: String,
                                      response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getDevelopLanguageList
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  将代码渲染为markdown
    @objc func renderCodeToMarkdown(code: String,
                                    serialNumber: String,
                                    response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.renderCodeToMarkdown(code: code)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  获取APP 配置文件
    @objc func getAPPCommonConfig(serialNumber: String,
                                  response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getAPPCommonConfig
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    // MARK: - Notifications
    ///  获取当前用户的通知
    ///  - Parameters
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    ///    - all: 是否全部；否则只返回未读通知
    @objc func getNotifications(page: Int,
                                per_page: Int,
                                all: Bool,
                                serialNumber: String,
                                response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.notification(page: page, per_page: per_page, all: all)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  设置通知已读
    ///  - Parameters
    ///    - thread_id: 通知的id
    @objc func markNotificationReaded(thread_id: String,
                                      serialNumber: String,
                                      response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.markNotificationReaded(thread_id: thread_id)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    // MARK: - Event
    ///  某个用户的事件(如果为当前登陆用户则会包含私密事件)
    ///  - Parameters
    ///    - login: 用户标识
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    @objc func getEventsForUser(login: String,
                                page: Int,
                                per_page: Int,
                                serialNumber: String,
                                response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getEventsForUser(login: login,
                                                    page: page,
                                                    per_page: per_page)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    /// 某个用户接受的事件(关注的仓库或用户的事件)
    ///  - Parameters
    ///    - login: 用户标识
    ///    - page: 页号 从 1 开始
    ///    - per_page: pageSize
    @objc func getReceivedEventsForUser(login: String,
                                        page: Int,
                                        per_page: Int,
                                        serialNumber: String,
                                        response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getReceivedEventsForUser(login: login,
                                                            page: page,
                                                            per_page: per_page)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    // MARK: Trending
    ///  获取趋势仓库
    ///  - Parameters
    ///    - language: 开发语言
    ///    - spokenLanguageCode: 交流语言
    ///    - dateRange: 时间范围
    @objc func getTrendingRepos(language: String?,
                                spokenLanguageCode: String?,
                                dateRange: ZLDateRange,
                                serialNumber: String,
                                response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getTrendingRepos(language: language,
                                                    spokenLanguageCode: spokenLanguageCode,
                                                    dateRange: dateRange)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  获取趋势开发者
    ///  - Parameters
    ///    - language: 开发语言
    ///    - dateRange: 时间范围
    @objc func getTrendingDevelopers(language: String?,
                                     dateRange: ZLDateRange,
                                     serialNumber: String,
                                     response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.getTrendingDevelopers(language: language,
                                                         dateRange: dateRange)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }

    // MARK: - Search
    ///  搜索用户
    ///  - Parameters
    ///    - q: 关键字
    ///    - sort: 排序方式 followers/joined/repositories
    ///    - asc: 是否递增
    @objc func searchUser(q: String,
                          sort: String?,
                          asc: Bool,
                          page: Int,
                          per_page: Int,
                          serialNumber: String,
                          response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.searchUser(q: q,
                                              sort: sort,
                                              asc: asc,
                                              page: page,
                                              per_page: per_page)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    ///  搜索仓库
    ///  - Parameters
    ///    - q: 关键字
    ///    - sort: 排序方式 stars/forks/updated
    ///    - asc: 是否递增
    @objc func searchRepo(q: String,
                          sort: String?,
                          asc: Bool,
                          page: Int,
                          per_page: Int,
                          serialNumber: String,
                          response: @escaping GithubResponseSwift) {
        let api = ZLGithubAPISwift.searchRepo(q: q,
                                              sort: sort,
                                              asc: asc,
                                              page: page,
                                              per_page: per_page)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
    }
    
    
    /// 获取指定API的html url 
    @objc func getHtmlURL(api: String,
                          serialNumber: String,
                          response: @escaping GithubResponseSwift){
        
        let api = ZLGithubAPISwift.getHtmlURL(api: api)
        self.requestGithubAPI(api: api, serialNumber: serialNumber, responseBlock: response)
        
    }
}
