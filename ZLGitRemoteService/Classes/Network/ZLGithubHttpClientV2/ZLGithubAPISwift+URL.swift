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
        case .updateCurrentUserInfo:
            return ZLGithubAPISwift.GitHubAPIURL + "/user"
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
        case .getCommitInfoForRepo(let login, let repoName, let ref),
                .getCommitDiffForRepo(let login,let repoName,let ref):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + login.urlPathEncoding + "/" + repoName.urlPathEncoding + "/commits/" + ref.urlPathEncoding
        case .getBranchsForRepo(let fullName):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "/branches"
        case .getContributorsForRepo(let fullName):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "/contributors"
        case .getIssuesForRepo(let fullName, _, _, _):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "/issues"
        case .createIssueForRepo(let fullName, _, _, _, _):
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
        case .getDirContentForRepo(let fullName, let path, _),
                .getFileContentForRepo(let fullName, let path, _, _):
            return ZLGithubAPISwift.GitHubAPIURL + "/repos/" + fullName.urlPathEncoding + "/contents/" + path.urlPathEncoding
        case .getDevelopLanguageList:
            return ZLGithubAPISwift.GitHubAPIURL + "/languages"
        case .renderCodeToMarkdown(let code):
            return ZLGithubAPISwift.GitHubAPIURL + "/markdown"
        case .getAPPCommonConfig:
            return "https://www.existorlive.cn/ZLGithubConfig/ZLGithubConfig.json"
        case .getEventsForUser(let login, _, _):
            return ZLGithubAPISwift.GitHubAPIURL + "/users/" + login.urlPathEncoding + "/events"
        case .getReceivedEventsForUser(let login, _, _):
            return ZLGithubAPISwift.GitHubAPIURL + "/users/" + login.urlPathEncoding + "/received_events"
        case .notification:
            return ZLGithubAPISwift.GitHubAPIURL + "/notifications"
        case .markNotificationReaded(let thread_id):
            return ZLGithubAPISwift.GitHubAPIURL + "/notifications/threads/" + thread_id.urlPathEncoding
        case .getTrendingDevelopers(let language, _):
            return "https://github.com/trending/developers/" + (language?.urlPathEncoding ?? "")
        case .getTrendingRepos(let language, _, _):
            return "https://github.com/trending/" + (language?.urlPathEncoding ?? "")
        case .searchUser:
            return ZLGithubAPISwift.GitHubAPIURL + "/seach/users"
        case .searchRepo:
            return ZLGithubAPISwift.GitHubAPIURL + "/search/repositories"
        case .getHtmlURL(api: let api):
            return api
        }
    }
}
