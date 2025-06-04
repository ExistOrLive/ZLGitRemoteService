//
//  ZLGithubAPISwift+Parameter.swift
//  ZLGitRemoteService
//
//  Created by 朱猛 on 2023/4/13.
//

import Foundation
import Alamofire

@objc public enum ZLGithubMediaType: Int {
    case json
    case json_html
    case json_raw
    case json_text
    case json_full
    
    var acceptType: String {
        switch self {
        case .json:
            return "application/vnd.github.v3+json"
        case .json_html:
            return "application/vnd.github.v3.html+json"
        case .json_raw:
            return "application/vnd.github.v3.raw+json"
        case .json_text:
            return "application/vnd.github.v3.text+json"
        case .json_full:
            return "application/vnd.github.v3.full+json"
        }
    }
}

extension ZLDateRange {
    var since: String {
        switch self {
        case ZLDateRangeDaily:
            return "daily"
        case ZLDateRangeWeakly:
            return "weekly"
        case ZLDateRangeMonthly:
            return "monthly"
        default:
            return "daily"
        }
    }
}

extension ZLGithubAPISwift {
 
    var method: HTTPMethod {
        switch self {
        case .unfollowUser,
                .unblockUser,
                .unwatchRepo,
                .unstarRepo:
            return .delete
        case .followUser,
                .blockUser,
                .watchRepo,
                .starRepo:
            return .put
        case .forkRepo,
                .cancelWorkflowRunForRepo,
                .rerunWorkflowRunForRepo,
                .renderCodeToMarkdown,
                .createIssueForRepo,
                .updateCurrentUserInfo:
            return .post
        case .markNotificationReaded:
            return .patch
        
        default:
            return .get
        }
    }
}


extension ZLGithubAPISwift {
    
    var headers: [String: String] {
        switch self {
        case .blockUser,
                .unblockUser,
                .getBlockedUsers,
                .getBlockUserStatus:
            return ["Accept":"application/vnd.github.giant-sentry-fist-preview+json"]
        case .getRepoReadMeInfo(_, _, let mediaType):
            return ["Accept": mediaType.acceptType]
        case .getFileContentForRepo(_, _ , _, let mediaType):
            return ["Accept": mediaType.acceptType]
        case .getAPPCommonConfig:
            return ["Accept": "application/json"]
        case .renderCodeToMarkdown:
            return ["Accept": ZLGithubMediaType.json_html.acceptType]
        case .getTrendingDevelopers,
                .getTrendingRepos:
            return ["Accept": "application/html, text/html"]
        case .getCommitDiffForRepo:
            return ["Accept": "application/vnd.github.diff"]
        default:
            return [:]
        }
    }
}


extension ZLGithubAPISwift {
    var paramsEncoding: ParameterEncoding {
        switch self {
        case .forkRepo,
                .cancelWorkflowRunForRepo,
                .rerunWorkflowRunForRepo,
                .renderCodeToMarkdown,
                .createIssueForRepo,
                .markNotificationReaded,
                .updateCurrentUserInfo:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
}

extension Dictionary where Key == String, Value == Any? {
    func toParameters() -> [String: Any] {
        self.compactMapValues { value in
            return value
        }
    }
}

extension ZLGithubAPISwift {
    
    var params: [String: Any] {
        var params: [String: Any?] = [:]
        switch self {
        case .currentUserRepoUrl(let page, let per_page),
                .getRepositoriesForUser(_, let page, let  per_page),
                .getFollowersForUser(_, let page, let  per_page),
                .getFollowingsForUser(_, let page, let  per_page),
                .currentUserStarreds(let page, let per_page),
                .currentUserGists(let page, let per_page),
                .getStarredForUser(_, let page, let  per_page),
                .getGistsForUser(_, let page, let  per_page),
                .getWatchersForRepo(_ , let page, let per_page),
                .getStargazersForRepo(_, let page, let per_page),
                .getForksForRepo(_, let page, let per_page),
                .getWorkflowsForRepo(_ , let page, let per_page),
                .getWorkflowRunsForRepo(_, _, let page, let per_page),
                .getEventsForUser(_, let page, let per_page),
                .getReceivedEventsForUser(_, let page, let per_page),
                .getCommitCompareForRepo(_, _, _, _, let page,let per_page):
            params = ["page": page,
                      "per_page": per_page]
        case .getRepoReadMeInfo(_,let ref,_):
            params = ["ref": ref].toParameters()
        case .getPRsForRepo(_, let state, let page, let perPage):
            params = ["state": state,
                      "page": page,
                      "per_page": perPage]
        case .getCommitsForRepo(_,
                                let page,
                                let per_page,
                                let sha,
                                let path,
                                let author,
                                let committer,
                                let since,
                                let until):
            params = ["page":page,
                      "per_page":per_page,
                      "sha":sha,
                      "path":path,
                      "author":author,
                      "committer":committer,
                      "since":(since as NSDate?)?.dateStrForYYYYMMDDTHHMMSSZForTimeZone0,
                      "until":(until as NSDate?)?.dateStrForYYYYMMDDTHHMMSSZForTimeZone0]
        case .getIssuesForRepo(_, let state, let page, let per_page):
            params = ["state": state,
                      "page": page,
                      "per_page": per_page]
        case .forkRepo(_, let organization, let name, let default_branch_only):
            params = ["organization": organization,
                      "name": name,
                      "default_branch_only": default_branch_only]
        case .getFileContentForRepo(_ , _, let ref, _),
                .getDirContentForRepo(_, _, let ref): 
            params = ["ref":ref]
        case .renderCodeToMarkdown(let code):
            params = ["text": code]
        case .notification(let page, let per_page, let all):
            params = ["page": page,
                      "per_page": per_page,
                      "all": all]
        case .createIssueForRepo(_, let title, let body, let labels, let assignees):
            params = ["title": title,
                      "body": body,
                      "labels": labels,
                      "assignees": assignees]
        case .getTrendingDevelopers(_, let dateRange):
            params = ["since": dateRange.since]
        case .getTrendingRepos(_ , let spokenLanguageCode, let dateRange):
            params = ["since": dateRange.since,
                      "spoken_language_code": spokenLanguageCode]
        case .searchRepo(let q, let sort, let asc, let page, let per_page),
                .searchUser(let q, let sort, let asc, let page, let per_page):
            params = ["q": q,
                      "page": page,
                      "per_page": per_page]
            if let sort = sort {
                params["sort"] = sort
                params["order"] = asc ? "asc" : "desc"
            }
        case .updateCurrentUserInfo(let name,
                                    let email,
                                    let blog,
                                    let company,
                                    let location,
                                    let hireable,
                                    let bio):
            params = ["name": name,
                      "email": email,
                      "blog": blog,
                      "company": company,
                      "location": location,
                      "hireable": hireable?.boolValue,
                      "bio": bio]
        case .getRepositoriesForOrg(let _,let page,let per_page):
            params = ["page": page,
                      "per_page": per_page]
        default:
            params = [:]
        }
        return params.toParameters()
    }
}
