//
//  ZLGithubHttpClient_GraphQL.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/20.
//  Copyright © 2020 ZM. All rights reserved.
//

import Foundation
import Apollo

public typealias GithubResponseSwift = (Bool,Any?,String) -> Void

let GithubGraphQLAPI = "https://api.github.com/graphql"



private class ZLTokenIntercetor : ApolloInterceptor {
    
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void){
        request.addHeader(name:"Authorization", value: "Bearer \(ZLGithubHttpClient.default().token)")
        chain.proceedAsync(request: request, response: response, completion: completion)
    }
}

private class ZLTokenInvalidDealIntercetor : ApolloInterceptor {
    
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void){
       
        if let httpResponse = response?.httpResponse{
            if httpResponse.statusCode == 401 {
                ZLMainThreadDispatch({
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ZLGithubTokenInvalid_Notification"), object: nil)
                })
            }
        }
        chain.proceedAsync(request: request, response: response, completion: completion)
    }
}

private struct ZLNetworkInterceptorProvider: InterceptorProvider {
    
    // These properties will remain the same throughout the life of the `InterceptorProvider`, even though they
    // will be handed to different interceptors.
    private let store: ApolloStore
    private let client: URLSessionClient
    
    init(store: ApolloStore,
         client: URLSessionClient) {
        self.store = store
        self.client = client
    }
    
    func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        return [
            ZLTokenIntercetor(),
            MaxRetryInterceptor(),
            LegacyCacheReadInterceptor(store: self.store),
            NetworkFetchInterceptor(client: self.client),
            ZLTokenInvalidDealIntercetor(),
            ResponseCodeInterceptor(),
            LegacyParsingInterceptor(cacheKeyForObject: self.store.cacheKeyForObject),
            AutomaticPersistedQueryInterceptor(),
            LegacyCacheWriteInterceptor(store: self.store)
        ]
    }
}




public extension ZLGithubHttpClient{
    
    fileprivate static var realApolloCilent : ApolloClient = {
        
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        
        let client = URLSessionClient()
        let provider = ZLNetworkInterceptorProvider(store: store, client: client)
            
        let networkTransport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: URL.init(string: GithubGraphQLAPI)!)
        
        return ApolloClient.init(networkTransport:networkTransport, store: store)
    }()
    
    
    fileprivate var apolloClient: ApolloClient!{
        ZLGithubHttpClient.realApolloCilent
    }
    
    func baseQuery<Query: GraphQLQuery>(query: Query,
                                        serialNumber: String,
                                        block: @escaping GithubResponseSwift){
        
        analytics.log(.URLUse(url: query.operationName))
        
        self.apolloClient.fetch(query: query,
                                cachePolicy: .fetchIgnoringCacheData,
                                queue: self.completeQueue)
        { result in
            var resultData : Any? = nil
            var success = false
            switch result{
            case .success(_):do{
                if let data = try? result.get().data{
                    success = true
                    let json = data.jsonObject
                    let serialized = try! JSONSerialization.data(withJSONObject: json, options: [])
                    let deserialized = try! JSONSerialization.jsonObject(with: serialized, options: []) as! JSONObject
                    let result = try! type(of: query).Data(jsonObject: deserialized)
                    resultData = result
                } else {
                    success = false
                    let errorModel = ZLGithubRequestErrorModel()
                    if let error = try? result.get().errors?.first{
                        errorModel.message = error.localizedDescription
                    }
                    resultData = errorModel
                    analytics.log(.URLFailed(url: query.operationName, error: errorModel.message))
                }
            }
                break
            case .failure(let error):do{
                success = false
                let errorModel = ZLGithubRequestErrorModel()
                errorModel.message = error.localizedDescription
                resultData = errorModel
                analytics.log(.URLFailed(url: query.operationName, error: errorModel.message))
            }
                break
            }
            block(success,resultData,serialNumber)
        }
        
    }
    
    
    func baseMutation<Mutation: GraphQLMutation>(mutation: Mutation,
                                                 serialNumber: String,
                                                 block: @escaping GithubResponseSwift) {
        analytics.log(.URLUse(url: mutation.operationName))
        
        self.apolloClient.perform(mutation: mutation,
                                  publishResultToStore: true,
                                  queue: completeQueue) { result in
            
            var resultData : Any? = nil
            var success = false
            switch result{
            case .success(_):do{
                if let data = try? result.get().data{
                    success = true
                    let json = data.jsonObject
                    let serialized = try! JSONSerialization.data(withJSONObject: json, options: [])
                    let deserialized = try! JSONSerialization.jsonObject(with: serialized, options: []) as! JSONObject
                    let result = try! type(of: mutation).Data(jsonObject: deserialized)
                    resultData = result
                } else {
                    success = false
                    let errorModel = ZLGithubRequestErrorModel()
                    if let error = try? result.get().errors?.first{
                        errorModel.message = error.localizedDescription
                    }
                    resultData = errorModel
                    analytics.log(.URLFailed(url: mutation.operationName, error: errorModel.message))
                }
            }
                break
            case .failure(let error):do{
                success = false
                let errorModel = ZLGithubRequestErrorModel()
                errorModel.message = error.localizedDescription
                resultData = errorModel
                analytics.log(.URLFailed(url: mutation.operationName, error: errorModel.message))
            }
                break
            }
            block(success,resultData,serialNumber)
        }
    }
    
    // MARK: WorkBoard
    /**
     * @param serialNumber
     * @param block
     *  查询我的工作台信息
     */
    @objc func getWorkBoardInfo(serialNumber: String,block: @escaping GithubResponseSwift){
        let query = WorkboardInfoQuery()
        self.baseQuery(query: query, serialNumber: serialNumber, block: block)
    }
    
    /**
     * @param serialNumber
     * @param block
     *  查询我的组织信息
     */
    @objc func getOrgs(serialNumber: String,block: @escaping GithubResponseSwift){
        let query = ViewerOrgsQuery()
        self.baseQuery(query: query, serialNumber: serialNumber, block: block)
    }
    
    /**
     * @param serialNumber
     * @param block
     *  查询我的issue
     */
    @objc func getMyIssues(assignee: String?,
                           createdBy: String?,
                           mentioned: String?,
                           after: String?,
                           serialNumber: String,
                           block: @escaping GithubResponseSwift){
       
        let query = ViewerIssuesQuery(assignee: assignee, creator: createdBy, mentioned: mentioned, after: after)
        self.baseQuery(query: query, serialNumber: serialNumber, block: block)
    }
    
    

    
    /**
     * @param query  查询条件 archived:false sort:created-desc is:open is:issue mentions:@me
     * @param block
     *  搜索issue
     */
    @objc enum SearchTypeForOC : NSInteger{
        case User
        case Repo
        case Issue
    }

    
    @objc func searchItem(after: String?,
                          query: String,
                          type : SearchTypeForOC,
                          serialNumber: String,
                          block: @escaping GithubResponseSwift){
        var realType = SearchType.user
        switch type {
        case .User:
            realType = .user
        case .Repo:
            realType = .repository
        case .Issue:
            realType = .issue
        default:
            realType = .user
        }
        
        let query = SearchItemQuery(after: after, query: query, type: realType)
        self.baseQuery(query: query, serialNumber: serialNumber, block: block)
    }
    
    
    /**
     * @param serialNumber
     * @param block
     *  查询我的repo
     */
    @objc func getMyTopRepo(after: String?,
                            serialNumber: String,
                            block: @escaping GithubResponseSwift){
        let query = ViewerTopRepositoriesQuery(after: after)
        self.baseQuery(query: query, serialNumber: serialNumber, block: block)
    }
    
    /**
     * @param serialNumber
     * @param block
     *  查询我的pr
     */
    @objc func getMyPRs(state: ZLGithubPullRequestState,
                        after: String?,
                        serialNumber: String,
                        block: @escaping GithubResponseSwift){
        var pullRequestState : PullRequestState
        switch state {
        case .open:
            pullRequestState = .open
        case .closed:
            pullRequestState = .closed
        case .merged:
            pullRequestState = .merged
        @unknown default:
            pullRequestState = .open
        }
        let query = ViewerPullRequestQuery(state: [pullRequestState], after: after)
        self.baseQuery(query: query, serialNumber: serialNumber, block: block)
    }
    
    // MARK: issue info
    
    /**
     * @param login
     * @param repoName
     *  @param number
     *  查询某个issue
     */
    
    @objc func getIssueInfo(login: String,
                            repoName: String,
                            number: Int,
                            after: String?,
                            serialNumber: String,
                            block: @escaping GithubResponseSwift){
        let query = IssueInfoQuery(owner: login, name: repoName, number: number, after:after)
        self.baseQuery(query: query, serialNumber: serialNumber, block: block)
    }
    
    /**
     *  获取issue的可编辑信息
     *
     */
    @objc func getEditIssueInfo(login : String,
                                repoName : String,
                                number : Int,
                                serialNumber: String,
                                block: @escaping GithubResponseSwift) {
        let query = IssueEditInfoQuery(owner: login, name: repoName, number: number)
        baseQuery(query: query, serialNumber: serialNumber, block: block)
    }
    
    /**
     * @param issueId
     * @param commentBody
     * @param serialNumber
     *  添加issue 评论
     *
     */
    @objc func addIssueComment(issueId: String,
                               commentBody: String,
                               serialNumber: String,
                               block: @escaping GithubResponseSwift) {
        
        let input = AddCommentInput(subjectId: issueId, body: commentBody, clientMutationId: serialNumber)
        let mutation = AddIssueCommentMutation(addInput: input)
        baseMutation(mutation: mutation, serialNumber: serialNumber, block: block)
    }
    
    /**
     * @param issueId
     * @param commentBody
     * @param serialNumber
     *   编辑issue的受理者
     *
     */
    @objc func editIssueAssignees(issueId: String,
                                  addedAssignees: [String],
                                  removedAssignees: [String],
                                  serialNumber: String,
                                  block: @escaping GithubResponseSwift) {
        
        let addInput = AddAssigneesToAssignableInput(assignableId: issueId, assigneeIds: addedAssignees, clientMutationId: serialNumber)
        let removeInput = RemoveAssigneesFromAssignableInput(assignableId: issueId, assigneeIds: removedAssignees, clientMutationId: serialNumber)
        let mutation = EditIssueAssigneesMutation(addInput: addInput, removeInput: removeInput)
        baseMutation(mutation: mutation, serialNumber: serialNumber, block: block)
    }
    
    
    
    
    // MARK: pull request info
    
    /**
     * @param login
     * @param repoName
     *  @param number
     *  查询某个pr
     */
    @objc func getPRInfo(login : String,
                         repoName : String,
                         number : Int,
                         after : String?,
                         serialNumber: String,
                         block: @escaping GithubResponseSwift) {
        let query = PrInfoQuery(owner: login, name: repoName, number: number, after: after)
        self.baseQuery(query: query, serialNumber: serialNumber, block: block)
    }

    
    //MARK: userinfo
    
    @objc func getCurrentUserInfo(serialNumber: String,
                                  block: @escaping GithubResponseSwift){
        let query = ViewerInfoQuery()
        self.baseQuery(query: query, serialNumber: serialNumber) { (result, data, serialNumber) in
            if let queryData = data as? ViewerInfoQuery.Data {
                block(result,ZLGithubUserModel(viewerQueryData:queryData),serialNumber)
            } else {
                block(result,data,serialNumber)
            }
        }
    }
    
    @objc func getUserInfo(login: String,
                           serialNumber: String,
                           block: @escaping GithubResponseSwift){
        let query = UserInfoQuery(login: login)
        self.baseQuery(query: query, serialNumber: serialNumber) { (result, data, serialNumber) in
            if let queryData = data as? UserInfoQuery.Data {
                block(result,ZLGithubUserModel(queryData: queryData),serialNumber)
            } else {
                block(result,data,serialNumber)
            }
        }
        
    }
    
    @objc func getOrgInfo(login: String,
                          serialNumber: String,
                          block: @escaping GithubResponseSwift){
        
        let query = OrgInfoQuery(login: login)
        self.baseQuery(query: query, serialNumber: serialNumber) { (result, data, serialNumber) in
            if let queryData = data as? OrgInfoQuery.Data {
                block(result,ZLGithubOrgModel(queryData: queryData),serialNumber)
            } else {
                block(result,data,serialNumber)
            }
        }
   }
    
    @objc func getUserOrOrgInfo(login: String,
                                serialNumber: String,
                                block: @escaping GithubResponseSwift){
        let query = UserOrOrgInfoQuery(login: login)
        self.baseQuery(query: query, serialNumber: serialNumber) { (result, data, serialNumber) in
            if let queryData = data as? UserOrOrgInfoQuery.Data{
                if queryData.user != nil {
                    block(result,ZLGithubUserInfoModelForView(UserOrOrgQueryData: queryData),serialNumber)
                } else if queryData.organization != nil{
                    block(result,ZLGithubOrgInfoModelForView(UserOrOrgQueryData: queryData),serialNumber)
                } else {
                    block(result,data,serialNumber)
                }
            } else {
                block(result,data,serialNumber)
            }
           
        }
    }
    
    @objc func getUserContributionsDataSwift(login: String,
                                             serialNumber: String,
                                             block: @escaping GithubResponseSwift) {
        
        let query = UserContributionDetailQuery(loginName: login)
        self.baseQuery(query: query, serialNumber: serialNumber) { (result, data, serialNumber) in
            if let queryData = data as? UserContributionDetailQuery.Data{
                block(result,ZLGithubUserContributionData.getContributionDataArray(UserContributionDetailQuery:queryData),serialNumber)
            } else {
                block(result,data,serialNumber)
            }
        }
    }
    
    
    @objc func getUserAvatar(login: String,
                             serialNumber: String,
                             block: @escaping GithubResponseSwift){
        let query = AvatarQuery(login: login)
        self.baseQuery(query: query, serialNumber: serialNumber) { (result, data, serialNumber) in
            if let queryData = data as? UserOrOrgInfoQuery.Data{
                block(result,queryData.user?.avatarUrl,serialNumber)
            } else {
                block(result,data,serialNumber)
            }
        }
    }
    
    @objc func getUserPinnedRepositories(login: String,
                                         serialNumber: String,
                                         block: @escaping GithubResponseSwift){
        let query = UserPinnedItemQuery(login: login)
        self.baseQuery(query: query, serialNumber: serialNumber) { (result, data, serialNumber) in
            if let queryData = data as? UserPinnedItemQuery.Data{
                block(result,
                      ZLGithubRepositoryBriefModel.getRepositoryBriefModelArray(UserPinnedItemQuery:queryData),
                      serialNumber)
            } else {
                block(result,data,serialNumber)
            }
        }
    }
    
    @objc func getOrgPinnedRepositories(login: String,
                                        serialNumber: String,
                                        block: @escaping GithubResponseSwift){
        let query = OrgPinnedItemQuery(login: login)
        self.baseQuery(query: query, serialNumber: serialNumber) { (result, data, serialNumber) in
            if let queryData = data as? OrgPinnedItemQuery.Data{
                block(result,
                      ZLGithubRepositoryBriefModel.getRepositoryBriefModelArray(OrgPinnedItemQuery:queryData),
                      serialNumber)
            } else {
                block(result,data,serialNumber)
            }
        }
    }
    
   // MARK: 仓库信息
    @objc func getRepoInfo(login: String,
                           name: String,
                           serialNumber: String,
                           block: @escaping GithubResponseSwift){
        let query = RepoInfoQuery(login: login, name: name)
        self.baseQuery(query: query, serialNumber: serialNumber) { (result, data, serialNumber) in
            if let queryData = data as? RepoInfoQuery.Data {
                if queryData.repository == nil {
                    block(result,nil,serialNumber)
                } else {
                    block(result,ZLGithubRepositoryModel(queryData: queryData),serialNumber)
                }
            } else {
                block(result,data,serialNumber)
            }
        }
    }
    
}



