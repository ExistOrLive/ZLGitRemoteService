//
//  ZLGithubRepositoryModel_Graphql.swift
//  ZLGitRemoteService
//
//  Created by 朱猛 on 2021/12/5.
//

import Foundation

extension ZLGithubRepositoryBriefModel{
    
    convenience init(UserInfoQuery queryData: UserOrOrgInfoQuery.Data.User.PinnedItem.Node.AsRepository){
        self.init()
        name = queryData.name
        full_name = queryData.nameWithOwner
        desc_Repo = queryData.description
        language = queryData.primaryLanguage?.name
        languageColor = queryData.primaryLanguage?.color
        stargazers_count = queryData.stargazerCount
        html_url = queryData.url
        isPriva = queryData.isPrivate
        
        let userModel = ZLGithubUserBriefModel()
        owner = userModel
        userModel.loginName = queryData.owner.login
        userModel.avatar_url = queryData.owner.avatarUrl
        userModel.html_url = queryData.owner.url
    }
    
    convenience init(OrgInfoQuery queryData: UserOrOrgInfoQuery.Data.Organization.PinnedItem.Node.AsRepository){
        self.init()
        name = queryData.name
        full_name = queryData.nameWithOwner
        desc_Repo = queryData.description
        language = queryData.primaryLanguage?.name
        languageColor = queryData.primaryLanguage?.color
        stargazers_count = queryData.stargazerCount
        html_url = queryData.url
        isPriva = queryData.isPrivate
        
        let userModel = ZLGithubUserBriefModel()
        owner = userModel
        userModel.loginName = queryData.owner.login
        userModel.avatar_url = queryData.owner.avatarUrl
        userModel.html_url = queryData.owner.url
    }
    
    convenience init(UserPinnedItemQuery queryData: UserPinnedItemQuery.Data.User.PinnedItem.Node.AsRepository){
        self.init()
        name = queryData.name
        full_name = queryData.nameWithOwner
        desc_Repo = queryData.description
        language = queryData.primaryLanguage?.name
        languageColor = queryData.primaryLanguage?.color
        stargazers_count = queryData.stargazerCount
        forks_count = queryData.forkCount
        html_url = queryData.url
        isPriva = queryData.isPrivate
        
        let userModel = ZLGithubUserBriefModel()
        owner = userModel
        userModel.loginName = queryData.owner.login
        userModel.avatar_url = queryData.owner.avatarUrl
        userModel.html_url = queryData.owner.url
    }
    
    convenience init(OrgPinnedItemQuery queryData: OrgPinnedItemQuery.Data.Organization.PinnedItem.Node.AsRepository){
        self.init()
        name = queryData.name
        full_name = queryData.nameWithOwner
        desc_Repo = queryData.description
        language = queryData.primaryLanguage?.name
        languageColor = queryData.primaryLanguage?.color
        stargazers_count = queryData.stargazerCount
        forks_count = queryData.forkCount
        html_url = queryData.url
        isPriva = queryData.isPrivate
        
        let userModel = ZLGithubUserBriefModel()
        owner = userModel
        userModel.loginName = queryData.owner.login
        userModel.avatar_url = queryData.owner.avatarUrl
        userModel.html_url = queryData.owner.url
    }
    
    
    static func getRepositoryBriefModelArray(UserPinnedItemQuery queryData: UserPinnedItemQuery.Data) -> [ZLGithubRepositoryBriefModel] {
        var array = [ZLGithubRepositoryBriefModel]()
        if let nodes = queryData.user?.pinnedItems.nodes {
            for node in nodes{
                if let node = node as? UserPinnedItemQuery.Data.User.PinnedItem.Node,
                   let repoQueryData = node.asRepository {
                    array.append(ZLGithubRepositoryBriefModel(UserPinnedItemQuery: repoQueryData))
                }
            }
        }
        return array
    }
    
    static func getRepositoryBriefModelArray(OrgPinnedItemQuery queryData: OrgPinnedItemQuery.Data) -> [ZLGithubRepositoryBriefModel] {
        var array = [ZLGithubRepositoryBriefModel]()
        if let nodes = queryData.organization?.pinnedItems.nodes {
            for node in nodes{
                if let node = node as? OrgPinnedItemQuery.Data.Organization.PinnedItem.Node,
                   let repoQueryData = node.asRepository{
                    array.append(ZLGithubRepositoryBriefModel(OrgPinnedItemQuery: repoQueryData))
                }
            }
        }
        return array
    }
}
