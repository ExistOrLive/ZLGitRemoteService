//
//  ZLGithubUserModel-Extension.swift
//  ZLGitRemoteService
//
//  Created by 朱猛 on 2021/12/5.
//

import Foundation

extension ZLGithubUserModel{
    convenience init(queryData: UserInfoQuery.Data){
        self.init()
        user_id = queryData.user?.userId == nil ? nil : String(queryData.user!.userId!)
        node_id = queryData.user?.nodeId
        loginName = queryData.user?.loginName
        html_url = queryData.user?.htmlUrl
        avatar_url = queryData.user?.avatarUrl
        type = .user
        
        name = queryData.user?.name
        company = queryData.user?.company
        blog = queryData.user?.blog
        location = queryData.user?.location
        email = queryData.user?.email
        bio = queryData.user?.bio
        
        followers = queryData.user?.followers.totalCount ?? 0
        following = queryData.user?.following.totalCount ?? 0
        gists = queryData.user?.gists.totalCount ?? 0
        repositories = queryData.user?.repositories.totalCount ?? 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        created_at = dateFormatter.date(from: queryData.user?.createdAt ?? "")
        updated_at = dateFormatter.date(from: queryData.user?.updatedAt ?? "")
        
        statusMessage = queryData.user?.status?.message
        isViewer = queryData.user?.isViewer ?? false
        viewerIsFollowing = queryData.user?.viewerIsFollowing ?? false
        isDeveloperProgramMember = queryData.user?.isDeveloperProgramMember ?? false
    }
    
    convenience init(viewerQueryData: ViewerInfoQuery.Data){
        self.init()
        user_id = String(viewerQueryData.viewer.userId ?? 0)
        node_id = viewerQueryData.viewer.nodeId
        loginName = viewerQueryData.viewer.loginName
        html_url = viewerQueryData.viewer.htmlUrl
        avatar_url = viewerQueryData.viewer.avatarUrl
        type = .user
        
        name = viewerQueryData.viewer.name
        company = viewerQueryData.viewer.company
        blog = viewerQueryData.viewer.blog
        location = viewerQueryData.viewer.location
        email = viewerQueryData.viewer.email
        bio = viewerQueryData.viewer.bio
        
        followers = viewerQueryData.viewer.followers.totalCount
        following = viewerQueryData.viewer.following.totalCount
        gists = viewerQueryData.viewer.gists.totalCount
        repositories = viewerQueryData.viewer.repositories.totalCount
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        created_at = dateFormatter.date(from: viewerQueryData.viewer.createdAt )
        updated_at = dateFormatter.date(from: viewerQueryData.viewer.updatedAt )
        
        statusMessage = viewerQueryData.viewer.status?.message
        isViewer = viewerQueryData.viewer.isViewer
        viewerIsFollowing = viewerQueryData.viewer.viewerIsFollowing
        isDeveloperProgramMember = viewerQueryData.viewer.isDeveloperProgramMember
    }
    
    convenience init(UserOrOrgQueryData queryData: UserOrOrgInfoQuery.Data){
        self.init()
        user_id = queryData.user?.userId == nil ? nil : String(queryData.user!.userId!)
        node_id = queryData.user?.nodeId
        loginName = queryData.user?.loginName
        html_url = queryData.user?.htmlUrl
        avatar_url = queryData.user?.avatarUrl
        type = .user
        
        name = queryData.user?.name
        company = queryData.user?.company
        blog = queryData.user?.blog
        location = queryData.user?.location
        email = queryData.user?.email
        bio = queryData.user?.bio
        
        followers = queryData.user?.followers.totalCount ?? 0
        following = queryData.user?.following.totalCount ?? 0
        gists = queryData.user?.gists.totalCount ?? 0
        repositories = queryData.user?.repositories.totalCount ?? 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        created_at = dateFormatter.date(from: queryData.user?.createdAt ?? "")
        updated_at = dateFormatter.date(from: queryData.user?.updatedAt ?? "")
        
        statusMessage = queryData.user?.status?.message
        isViewer = queryData.user?.isViewer ?? false
        viewerIsFollowing = queryData.user?.viewerIsFollowing ?? false
        isDeveloperProgramMember = queryData.user?.isDeveloperProgramMember ?? false
    }
}


extension ZLGithubOrgModel{
    
    convenience init(queryData: OrgInfoQuery.Data){
        self.init()
        
        user_id = String(queryData.organization?.userId ?? 0)
        node_id = queryData.organization?.nodeId
        loginName = queryData.organization?.loginName
        html_url = queryData.organization?.htmlUrl
        avatar_url = queryData.organization?.avatarUrl
        type = .organization
        
        name = queryData.organization?.name
        blog = queryData.organization?.blog
        location = queryData.organization?.location
        email = queryData.organization?.email
        bio = queryData.organization?.bio
        
        members = queryData.organization?.membersWithRole.totalCount ?? 0
        teams = queryData.organization?.teams.totalCount ?? 0
        repositories = queryData.organization?.repositories.totalCount ?? 0
        viewerIsAMember = queryData.organization?.viewerIsAMember ?? false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        created_at = dateFormatter.date(from: queryData.organization?.createdAt ?? "")
        updated_at = dateFormatter.date(from: queryData.organization?.updatedAt ?? "")
    }
    
    convenience init(UserOrOrgQueryData queryData: UserOrOrgInfoQuery.Data){
        self.init()
        
        user_id = String(queryData.organization?.userId ?? 0)
        node_id = queryData.organization?.nodeId
        loginName = queryData.organization?.loginName
        html_url = queryData.organization?.htmlUrl
        avatar_url = queryData.organization?.avatarUrl
        type = .organization
        
        name = queryData.organization?.name
        blog = queryData.organization?.blog
        location = queryData.organization?.location
        email = queryData.organization?.email
        bio = queryData.organization?.bio
        
        members = queryData.orgInfoMemberCount?.membersWithRole.totalCount ?? 0
        teams = queryData.orgInfoTeamCount?.teams.totalCount ?? 0
        repositories = queryData.orgInfoRepoCount?.repositories.totalCount ?? 0
        viewerIsAMember = queryData.organization?.viewerIsAMember ?? false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        created_at = dateFormatter.date(from: queryData.organization?.createdAt ?? "")
        updated_at = dateFormatter.date(from: queryData.organization?.updatedAt ?? "")
    }
}


extension ZLGithubUserInfoModelForView {
    convenience init(UserOrOrgQueryData queryData: UserOrOrgInfoQuery.Data){
        self.init()
        userInfo = ZLGithubUserModel(UserOrOrgQueryData: queryData)
        isViewer = queryData.user?.isViewer ?? false
      
        contributionData = ZLGithubUserContributionData.getContributionDataArray(UserOrOrgInfoQuery:queryData)
        totalContributions = queryData.user?.contributionsCollection.contributionCalendar.totalContributions ?? 0
        
        var pinnedRepoArray = [ZLGithubRepositoryBriefModel]()
        if let nodes = queryData.user?.pinnedItems.nodes {
            for node in nodes{
                if let repoQueryData = node as? UserOrOrgInfoQuery.Data.User.PinnedItem.Node.AsRepository {
                    pinnedRepoArray.append(ZLGithubRepositoryBriefModel(UserInfoQuery: repoQueryData))
                }
            }
        }
        pinnedRepos = pinnedRepoArray
    }
}

extension ZLGithubOrgInfoModelForView{
    
    convenience init(UserOrOrgQueryData queryData: UserOrOrgInfoQuery.Data){
        self.init()
        organizationInfo = ZLGithubOrgModel(UserOrOrgQueryData: queryData)
        viewerIsAMember = queryData.organization?.viewerIsAMember ?? false
              
        var pinnedRepoArray = [ZLGithubRepositoryBriefModel]()
        if let nodes = queryData.organization?.pinnedItems.nodes {
            for node in nodes{
                if let repoQueryData = node as? UserOrOrgInfoQuery.Data.Organization.PinnedItem.Node.AsRepository {
                    pinnedRepoArray.append(ZLGithubRepositoryBriefModel(OrgInfoQuery: repoQueryData))
                }
            }
        }
        pinnedRepos = pinnedRepoArray
    }
}


extension ZLGithubUserContributionData{
    convenience init(queryData: UserOrOrgInfoQuery.Data.User.ContributionsCollection.ContributionCalendar.Week.ContributionDay){
        self.init()
        
        contributionsDate = queryData.date
        contributionsNumber = queryData.contributionCount
        contributionsWeekday = queryData.weekday
        switch queryData.contributionLevel{
        case .none:
            contributionsLevel = 0
        case .firstQuartile:
            contributionsLevel = 1
        case .secondQuartile:
            contributionsLevel = 2
        case .thirdQuartile:
            contributionsLevel = 3
        case .fourthQuartile:
            contributionsLevel = 4
        case .__unknown(_):
            contributionsLevel = 0
        }
    }
    
    convenience init(UserContributionDetailQueryQueryData queryData: UserContributionDetailQuery.Data.User.ContributionsCollection.ContributionCalendar.Week.ContributionDay){
        self.init()
        
        contributionsDate = queryData.date
        contributionsNumber = queryData.contributionCount
        contributionsWeekday = queryData.weekday
        switch queryData.contributionLevel{
        case .none:
            contributionsLevel = 0
        case .firstQuartile:
            contributionsLevel = 1
        case .secondQuartile:
            contributionsLevel = 2
        case .thirdQuartile:
            contributionsLevel = 3
        case .fourthQuartile:
            contributionsLevel = 4
        case .__unknown(_):
            contributionsLevel = 0
        }
    }
    
    static func getContributionDataArray(UserContributionDetailQuery queryData:UserContributionDetailQuery.Data) -> [ZLGithubUserContributionData]{
        var contributionDataArray = [ZLGithubUserContributionData]()
        if let weeks = queryData.user?.contributionsCollection.contributionCalendar.weeks {
            for week in weeks{
                for day in week.contributionDays{
                    contributionDataArray.append(ZLGithubUserContributionData(UserContributionDetailQueryQueryData:day))
                }
            }
        }
        return contributionDataArray
    }
    
    static func getContributionDataArray(UserOrOrgInfoQuery queryData: UserOrOrgInfoQuery.Data) -> [ZLGithubUserContributionData]{
        var contributionDataArray = [ZLGithubUserContributionData]()
        if let weeks = queryData.user?.contributionsCollection.contributionCalendar.weeks {
            for week in weeks{
                for day in week.contributionDays{
                    contributionDataArray.append(ZLGithubUserContributionData(queryData:day))
                }
            }
        }
        return contributionDataArray
    }
}
