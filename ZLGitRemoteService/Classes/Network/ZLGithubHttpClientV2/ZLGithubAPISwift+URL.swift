//
//  ZLGithubAPISwift+URL.swift
//  ZLGitRemoteService
//
//  Created by 朱猛 on 2023/4/13.
//

import Foundation

extension String {
    var urlPathEncoding: String {
        return addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
    }
}

extension ZLGithubAPISwift {
    
    static let GitHubAPIURL =  "https://api.github.com"
    
    var url: String {
        switch self {
        case .currentUserRepoUrl:
            return ZLGithubAPISwift.GitHubAPIURL + "/user/repos"
        case .userInfo(let login):
            return ZLGithubAPISwift.GitHubAPIURL + "/users/" + login.urlPathEncoding
        case .getFollowUserStatus(login: let login),
                .followUser(login: let login),
                .unfollowUser(login: let login):
            return ZLGithubAPISwift.GitHubAPIURL + "/user/following/" + login.urlPathEncoding
        case .getBlockedUsers:
            return ZLGithubAPISwift.GitHubAPIURL + "/user/blocks"
        case .getBlockUserStatus(login: let login),
                .blockUser(login: let login),
                .unblockUser(login: let login):
            return ZLGithubAPISwift.GitHubAPIURL + "/user/blocks/" + login.urlPathEncoding
        case .getRepositoriesForUser(let login, _, _):
            return ZLGithubAPISwift.GitHubAPIURL + "/users/" + login.urlPathEncoding + "/repos"
        case .getFollowersForUser(let login, _ , _):
            return ZLGithubAPISwift.GitHubAPIURL + "/users/" + login.urlPathEncoding + "/followers"
        case .getFollowingsForUser(let login, _, _):
            return ZLGithubAPISwift.GitHubAPIURL + "/users/" + login.urlPathEncoding + "/following"
        case .currentUserStarreds:
            return ZLGithubAPISwift.GitHubAPIURL + "/user/starred"
        case .currentUserGists:
            return ZLGithubAPISwift.GitHubAPIURL + "/gists"
        case .getStarredForUser(let login, _, _ ):
            return ZLGithubAPISwift.GitHubAPIURL + "/users/" + login.urlPathEncoding + "/starred"
        case .getGistsForUser(let login, _, _):
            return ZLGithubAPISwift.GitHubAPIURL + "/users/" + login.urlPathEncoding + "/gists"
        case .getRepoReadMeInfo(let fullName,_,_):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "/readme"
        case .getPRsForRepo(let fullName, _, _, _):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "/pulls"
        case .getCommitsForRepo(let fullName, _, _, _, _, _, _, _, _):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "/commits"
        case .getBranchsForRepo(let fullName):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "/branches"
        case .getContributorsForRepo(let fullName):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "/contributors"
        case .getIssuesForRepo(let fullName, _, _, _):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "/issues"
        case .getWatchRepoStatus(let fullName),
                .watchRepo(let fullName),
                .unwatchRepo(let fullName):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "/subscription"
        case .getWatchersForRepo(let fullName, _, _):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "/subscribers"
        case .getStarRepoStatus(let fullName),
                .starRepo(let fullName),
                .unstarRepo(let fullName):
            return ZLGithubAPISwift.GitHubAPIURL + "/user/starred/" + fullName.urlPathEncoding
        case .getStargazersForRepo(let fullName, _, _):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "/stargazers"
        case .forkRepo(let fullName, _, _, _),
                .getForksForRepo(let fullName, _, _):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "/forks"
        case .getLanguagesInfoForRepo(let fullName):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "/languages"
        case .getWorkflowsForRepo(let fullName, _, _):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "/actions/workflows"
        case .getWorkflowRunsForRepo(let fullName, let workflowId, _, _):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "/actions/workflows/" + workflowId.urlPathEncoding + "/runs"
        case .rerunWorkflowRunForRepo(let fullName, let workflowRunId):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "actions/runs/" + workflowRunId.urlPathEncoding + "/rerun"
        case .cancelWorkflowRunForRepo(let fullName, let workflowRunId):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "actions/runs/" + workflowRunId.urlPathEncoding + "/cancel"
        case .getWorkflowRunLogForRepo(let fullName, let workflowRunId):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "actions/runs/" + workflowRunId.urlPathEncoding + "/logs"
        }
    }
}