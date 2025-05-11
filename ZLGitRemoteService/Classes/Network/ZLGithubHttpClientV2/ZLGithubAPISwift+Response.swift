//
//  ZLGithubAPISwift+Response.swift
//  ZLGitRemoteService
//
//  Created by 朱猛 on 2023/4/13.
//

import Foundation
import MJExtension
import Alamofire
import Kanna
import ZLUtilities
import ObjectMapper


// MARK: - ZLGithubAPIResultParseProtocol 处理协议
protocol ZLGithubAPIResultParseProtocol {
    func parseData(api:ZLGithubAPISwift,response: HTTPURLResponse, data: Data) -> Any?
}

// MARK: - ZLGithubAPIObjectTypeWrapper 转Object
struct ZLGithubAPIObjectTypeWrapper<T : NSObject>: ZLGithubAPIResultParseProtocol {
   
    var isArray: Bool = false
    
    func parseData(api:ZLGithubAPISwift,response: HTTPURLResponse, data: Data) -> Any? {
        if isArray {
            return T.mj_objectArray(withKeyValuesArray: data)
        } else {
            return T.mj_object(withKeyValues: data)
        }
    }
}

// MARK: - ZLGithubAPIResultCustomParseWrapper 自定义返回处理
struct ZLGithubAPIResultCustomParseWrapper: ZLGithubAPIResultParseProtocol {
   
    var block: ((ZLGithubAPISwift,HTTPURLResponse, Data) -> Any?)?
    
    func parseData(api:ZLGithubAPISwift, response: HTTPURLResponse, data: Data) -> Any? {
        return block?(api,response,data)
    }
}


// MARK: - ZLGithubAPIResultType
enum ZLGithubAPIResultType {
    case data           // 返回 Data
    case jsonObject     // 返回 Dictionary
    case string         // 返回 String
    case object(parseWrapper: ZLGithubAPIResultParseProtocol) // 返回 Object
    case custom(parseWrapper: ZLGithubAPIResultParseProtocol) // 自定义返回
}

// MARK: - ZLGithubAPISwift+SuccessStatusCodes
extension ZLGithubAPISwift {
    
    static let commonStatusCodes = Set(200...299)
    var successStatusCodes: Set<Int> {
        switch self {
        case .getFollowUserStatus,
                .getBlockUserStatus,
                .getStarRepoStatus,
                .getWatchRepoStatus:
            var codes = ZLGithubAPISwift.commonStatusCodes
            codes.insert(404)
            return codes
        default:
            return ZLGithubAPISwift.commonStatusCodes
        }
    }
}

// MARK: - ZLGithubAPISwift+ResultType
extension ZLGithubAPISwift {
    
    var resultType: ZLGithubAPIResultType {
        switch self {
        case .currentUserRepoUrl,
                .getRepositoriesForUser,
                .currentUserStarreds,
                .getStarredForUser,
                .getForksForRepo:
            return .object(parseWrapper: ZLGithubAPIObjectTypeWrapper<ZLGithubRepositoryModel>(isArray: true))
        case .getBlockedUsers,
                .getFollowersForUser,
                .getFollowingsForUser,
                .getWatchersForRepo,
                .getStargazersForRepo,
                .getContributorsForRepo:
            return .object(parseWrapper: ZLGithubAPIObjectTypeWrapper<ZLGithubUserModel>(isArray: true))
        case .currentUserGists,
                .getGistsForUser:
            return .object(parseWrapper: ZLGithubAPIObjectTypeWrapper<ZLGithubGistModel>(isArray: true))
        case .getRepoReadMeInfo(_, _, let mediaType):
            switch mediaType {
            case .json,.json_text,.json_full:
                return .object(parseWrapper: ZLGithubAPIObjectTypeWrapper<ZLGithubContentModel>())
            case .json_raw,.json_html:
                return .string
            }
        case .getPRsForRepo:
             return .object(parseWrapper: ZLGithubAPIObjectTypeWrapper<ZLGithubPullRequestModel>(isArray: true))
        case .getCommitsForRepo:
            return .object(parseWrapper: ZLGithubAPIObjectTypeWrapper<ZLGithubCommitModel>(isArray: true))
        case .getBranchsForRepo:
            return .object(parseWrapper: ZLGithubAPIObjectTypeWrapper<ZLGithubRepositoryBranchModel>(isArray: true))
        case .getIssuesForRepo:
            return .object(parseWrapper: ZLGithubAPIObjectTypeWrapper<ZLGithubIssueModel>(isArray: true))
        case .forkRepo:
            return .object(parseWrapper: ZLGithubAPIObjectTypeWrapper<ZLGithubRepositoryModel>())
        case .getDirContentForRepo:
            return .object(parseWrapper: ZLGithubAPIObjectTypeWrapper<ZLGithubContentModel>(isArray: true))
        case .getEventsForUser,
                .getReceivedEventsForUser:
            return .object(parseWrapper: ZLGithubAPIObjectTypeWrapper<ZLGithubEventModel>(isArray: true))
        case .notification:
            return .object(parseWrapper: ZLGithubAPIObjectTypeWrapper<ZLGithubNotificationModel>(isArray: true))
        case .updateCurrentUserInfo:
            return .object(parseWrapper: ZLGithubAPIObjectTypeWrapper<ZLGithubUserModel>())
        case .getFileContentForRepo(_, _, _ , let mediaType):
            switch mediaType {
            case .json,.json_text,.json_full:
                return .object(parseWrapper: ZLGithubAPIObjectTypeWrapper<ZLGithubContentModel>())
            case .json_raw,.json_html:
                return .string
            }
        case .getWorkflowsForRepo:
            return .custom(parseWrapper: ZLGithubAPIResultCustomParseWrapper(block: { api, _, data in
                if let jsonObject = (data as NSObject).mj_JSONObject() as? [String: Any?],
                   let workflows = jsonObject["workflows"] {
                    return ZLGithubRepoWorkflowModel.mj_objectArray(withKeyValuesArray: workflows)
                }
                return nil
            }))
        case .getWorkflowRunsForRepo:
            return .custom(parseWrapper: ZLGithubAPIResultCustomParseWrapper(block: { api, _, data in
                if let jsonObject = (data as NSObject).mj_JSONObject() as? [String: Any?],
                   let workflows = jsonObject["workflow_runs"] {
                    return ZLGithubRepoWorkflowRunModel.mj_objectArray(withKeyValuesArray: workflows)
                }
                return nil
            }))
        case .userInfo(let login):
            return .custom(parseWrapper: ZLGithubAPIResultCustomParseWrapper(block: { api, _, data in
                if let jsonObject = (data as NSObject).mj_JSONObject() as? [String: Any?],
                   let type = jsonObject["type"] as? String {
                    if type == "Organization" {
                        return ZLGithubOrgModel.mj_object(withKeyValues: data)
                    } else {
                        return ZLGithubUserModel.mj_object(withKeyValues: data)
                    }
                }
                return nil
            }))
        case .getAPPCommonConfig:
            return .custom(parseWrapper: ZLGithubAPIResultCustomParseWrapper(block: { api, _, data in
                let appVersion = ZLDeviceInfo.getAppVersion()
                if let jsonObject = (data as NSObject).mj_JSONObject() as? [String: Any?],
                   let config = jsonObject[appVersion] as? [String: Any?] {
                    return ZLGithubConfigModel.mj_object(withKeyValues: config)
                }
                return nil
            }))
        case .getDevelopLanguageList:
            return .custom(parseWrapper: ZLGithubAPIResultCustomParseWrapper(block: { api, _, data in
                if let jsonObject = (data as NSObject).mj_JSONObject() as? [[String: Any?]] {
                    return jsonObject.compactMap { item in
                        item["name"] as? String
                    }
                }
                return nil
            }))
        case .getFollowUserStatus:
            return .custom(parseWrapper: ZLGithubAPIResultCustomParseWrapper(block: { api, response, _ in
                if response.statusCode == 404 {
                    return ["isFollow":false]
                } else {
                    return ["isFollow":true]
                }
            }))
        case .getBlockUserStatus:
            return .custom(parseWrapper: ZLGithubAPIResultCustomParseWrapper(block: { api, response, _ in
                if response.statusCode == 404 {
                    return ["isBlock":false]
                } else {
                    return ["isBlock":true]
                }
            }))
        case .getWatchRepoStatus:
            return .custom(parseWrapper: ZLGithubAPIResultCustomParseWrapper(block: { api, response, _ in
                if response.statusCode == 404 {
                    return ["isWatch":false]
                } else {
                    return ["isWatch":true]
                }
            }))
        case .getStarRepoStatus:
            return .custom(parseWrapper: ZLGithubAPIResultCustomParseWrapper(block: { api, response, _ in
                if response.statusCode == 404 {
                    return ["isStar":false]
                } else {
                    return ["isStar":true]
                }
            }))
        case .getTrendingDevelopers:
            return .custom(parseWrapper: ZLGithubAPIResultCustomParseWrapper(block: { api, response, data in
                return ZLGithubAPISwift.parseDataForTrendingDevelopers(api: api,
                                                                       response: response,
                                                                       data: data)
            }))
        case .getTrendingRepos:
            return .custom(parseWrapper: ZLGithubAPIResultCustomParseWrapper(block: { api, response, data in
                return ZLGithubAPISwift.parseDataForTrendingRepo(api: api,
                                                                 response: response,
                                                                 data: data)
            }))
        case .searchUser:
            return .custom(parseWrapper: ZLGithubAPIResultCustomParseWrapper(block: { api, response, data in
                return ZLGithubAPISwift.parseDataForSearchUsers(api: api,
                                                                response: response,
                                                                data: data)
            }))
        case .searchRepo:
            return .custom(parseWrapper: ZLGithubAPIResultCustomParseWrapper(block: { api, response, data in
                return ZLGithubAPISwift.parseDataForSearchRepos(api: api,
                                                                response: response,
                                                                data: data)
            }))
        case .getLanguagesInfoForRepo,.getHtmlURL:
            return .jsonObject
        case .renderCodeToMarkdown:
            return .string
        default:
            return .data

        }
    }
}

// MARK: - ZLGithubAPISwift + deal with response
extension ZLGithubAPISwift {
    
    class TrendingConfig: Mappable {
        required init() {}
        required init?(map: Map) { }
        
        var path: String = ""
        var property: String = ""
  
        func mapping(map: Map) {
            path    <- map["path"]
            property  <- map["property"]
        }
        
        func getTargetElementStr(element: XMLElement) -> String? {
            guard let targetElement = element.at_xpath(path) else {
                return nil
            }
            var content: String?
            let set = NSCharacterSet(charactersIn: " \n") as CharacterSet
            if property == "content" {
                content = targetElement.content
            } else {
                content = targetElement[property]
            }
            return content?.trimmingCharacters(in: set)
        }
    }
    class TrendingRepoConfig: Mappable {
        var repoArrayPath: String = ""
        var fullName: TrendingConfig = TrendingConfig()
        var desc: TrendingConfig = TrendingConfig()
        var language: TrendingConfig = TrendingConfig()
        var star: TrendingConfig = TrendingConfig()
        var fork: TrendingConfig = TrendingConfig()
        
        required init?(map: ObjectMapper.Map) {}
        
        func mapping(map: ObjectMapper.Map) {
            repoArrayPath <- map["repoArrayPath"]
            fullName <- map["fullName"]
            desc <- map["desc"]
            language <- map["language"]
            star <- map["star"]
            fork <- map["fork"]
        }
    }
    static let trendingRepoConfig: [String:Any] = [
        "repoArrayPath": "//article[@class=\"Box-row\"]",
        "fullName": [
          "path": "/h2[@class=\"h3 lh-condensed\"]/a[@class=\"Link\"]",
          "property": "href"
        ],
        "desc": [
          "path": "/p[@class=\"col-9 color-fg-muted my-1 pr-4\"]",
          "property": "content"
        ],
        "language": [
          "path": "/div[@class=\"f6 color-fg-muted mt-2\"]/span[@class=\"d-inline-block ml-0 mr-3\"]/span[@itemprop=\"programmingLanguage\"]",
          "property": "content"
        ],
        "star": [
          "path": "/div[@class=\"f6 color-fg-muted mt-2\"]/a[@class=\"Link Link--muted d-inline-block mr-3\"]/svg[@aria-label=\"star\"]/..",
          "property": "content"
        ],
        "fork": [
          "path": "/div[@class=\"f6 color-fg-muted mt-2\"]/a[@class=\"Link Link--muted d-inline-block mr-3\"]/svg[@aria-label=\"fork\"]/..",
          "property": "content"
        ]
    ]
    
    static func parseDataForTrendingRepo(api: ZLGithubAPISwift,
                                         response: HTTPURLResponse,
                                         data: Data) -> Any? {
       
        var repos = [ZLGithubRepositoryModel]()
        do {
            let htmlDoc = try HTML(html:data, encoding: .utf8 )
    
            let trendConfigDic = ZLRCM().configAsJsonObject(for: "TrendRepoConfig",defaultValue: ZLGithubAPISwift.trendingRepoConfig)
            guard let trendConfig = TrendingRepoConfig(JSON: trendConfigDic) else {
                return repos
            }
            
            for article in htmlDoc.xpath(trendConfig.repoArrayPath) {
                
                guard var fullName = trendConfig.fullName.getTargetElementStr(element: article) else {
                    continue
                }
                fullName = String(fullName.suffix(from: fullName.index(after: fullName.startIndex)))
       
                let repoModel = ZLGithubRepositoryModel()
                repoModel.full_name = fullName
                repoModel.name = String(fullName.split(separator: "/").last ?? "")
                
                let owner = ZLGithubUserBriefModel()
                let loginName = String(fullName.split(separator: "/").first ?? "")
                owner.loginName = loginName
                owner.avatar_url = "https://avatars.githubusercontent.com/\(loginName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
                repoModel.owner = owner
            
                if let desc = trendConfig.desc.getTargetElementStr(element: article) {
                    repoModel.desc_Repo = desc
                }
                
                if let language = trendConfig.language.getTargetElementStr(element: article){
                    repoModel.language = language
                }
            
                if var starStr = trendConfig.star.getTargetElementStr(element: article) {
                    starStr = (starStr as NSString).replacingOccurrences(of: ",", with: "")
                    if let num = Int(starStr) {
                        repoModel.stargazers_count = num
                    }
                }
                
                if var forkStr = trendConfig.fork.getTargetElementStr(element: article) {
                    forkStr = (forkStr as NSString).replacingOccurrences(of: ",", with: "")
                    if let num = Int(forkStr) {
                        repoModel.forks_count = num
                    }
                }
               
                repos.append(repoModel)
            }
        } catch {
            
        }
        
        return repos
    }
    
    class TrendingUserConfig: Mappable {
        var userArrayPath: String = ""
        var loginName: TrendingConfig = TrendingConfig()
        var displayName: TrendingConfig = TrendingConfig()
        
        required init?(map: ObjectMapper.Map) {}
        
        func mapping(map: ObjectMapper.Map) {
            userArrayPath <- map["userArrayPath"]
            loginName <- map["loginName"]
            displayName <- map["displayName"]
        }
    }
    static let trendingUserConfig: [String:Any] = [
        "userArrayPath": "//article[@class=\"Box-row d-flex\"]/div[@class=\"d-sm-flex flex-auto\"]/div[@class=\"col-sm-8 d-md-flex\"]/div[@class=\"col-md-6\"]",
        "loginName": [
          "path": "/h1[@class=\"h3 lh-condensed\"]/a",
          "property": "href"
        ],
        "displayName": [
          "path": "/h1[@class=\"h3 lh-condensed\"]/a" ,
          "property": "content"
        ]
    ]
    
    
    static func parseDataForTrendingDevelopers(api: ZLGithubAPISwift,
                                               response: HTTPURLResponse,
                                               data: Data) -> Any? {
        var users = [ZLGithubUserModel]()
        do {
            let htmlDoc = try HTML(html:data, encoding: .utf8 )
            
            let trendConfigDic = ZLRCM().configAsJsonObject(for: "TrendUserConfig",defaultValue: ZLGithubAPISwift.trendingUserConfig)
            guard let trendConfig = TrendingUserConfig(JSON: trendConfigDic) else {
                return users
            }
            
            for article in htmlDoc.xpath(trendConfig.userArrayPath) {
                
                guard let loginName = trendConfig.loginName.getTargetElementStr(element: article) else {
                    continue
                }
                let user = ZLGithubUserModel()
                user.loginName = String(loginName.suffix(from: loginName.index(after: loginName.startIndex)))
                user.avatar_url = "https://avatars.githubusercontent.com/\(loginName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
                
                if let displayName = trendConfig.displayName.getTargetElementStr(element: article) {
                    user.name = displayName
                }
                users.append(user)
            }
        
        } catch {
           
        }
        return users
    }
    
    
    static func parseDataForSearchUsers(api: ZLGithubAPISwift,
                                        response: HTTPURLResponse,
                                        data: Data) -> Any? {
        var searchModel = ZLSearchResultModel()
        if let jsonObject = (data as NSObject).mj_JSONObject() as? [String: Any?] {
            searchModel.incomplete_results = jsonObject["incomplete_results"] as? Bool ?? false
            searchModel.totalNumber = jsonObject["totalNumber"] as? UInt ?? 0
            searchModel.data = ZLGithubUserModel.mj_objectArray(withKeyValuesArray: jsonObject["items"]) as? [Any] ?? []
        }
        return searchModel
    }
    
    static func parseDataForSearchRepos(api: ZLGithubAPISwift,
                                        response: HTTPURLResponse,
                                        data: Data) -> Any? {
        var searchModel = ZLSearchResultModel()
        if let jsonObject = (data as NSObject).mj_JSONObject() as? [String: Any?] {
            searchModel.incomplete_results = jsonObject["incomplete_results"] as? Bool ?? false
            searchModel.totalNumber = jsonObject["totalNumber"] as? UInt ?? 0
            searchModel.data = ZLGithubRepositoryModel.mj_objectArray(withKeyValuesArray: jsonObject["items"]) as? [Any] ?? []
        }
        return searchModel
    }
}
