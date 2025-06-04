//
//  ZLGithubUserModel.swift
//  ZLServiceFramework
//
//  Created by 朱猛 on 2021/4/8.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import MJExtension



// MARK: ----- ZLGithubUserBriefModel -----
@objcMembers open class ZLGithubUserBriefModel: ZLBaseObject {
    open var node_id: String?               // node_id 用于与graphql api 交互
    open var user_id: String?               // databaseid
    open var loginName: String?
    open var html_url: String?
    open var avatar_url: String?
    open var type: ZLGithubUserType = .user
    
    open override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["user_id":"id","loginName":"login"]
    }
    
    open override func mj_newValue(fromOldValue oldValue: Any!, property: MJProperty!) -> Any! {
        if "type" == property.name {
            if let str: String = oldValue as? String{
                if "Organization" == str {
                    return ZLGithubUserType.organization.rawValue
                } else {
                    return ZLGithubUserType.user.rawValue
                }
            }
            return ZLGithubUserType.user.rawValue
        }
        return oldValue
    }
    
    class func supportsSecureCoding() -> Bool {
        return true
    }
}

// MARK: ----- ZLGithubUserModel -----
@objcMembers open class ZLGithubUserModel: ZLGithubUserBriefModel{
    
    open var name: String?
    
    open var company: String?
    open var blog: String?
    open var location: String?
    open var email: String?
    open var bio: String?
    open var twitter_username: String?
    
    open var followers: Int = 0
    open var following: Int = 0
    open var gists: Int{
        get{
            if _gists == nil{
                return private_gists + public_gists
            }
            return _gists ?? 0
        }
        set{
            _gists = newValue
        }
        
    }
    open var repositories: Int{
        get{
            if _repositories == nil {
                return public_repos + total_private_repos
            }
            return _repositories ?? 0
        }
        set{
            _repositories = newValue
        }
    }
    
    open var created_at: Date?
    open var updated_at: Date?
    
    open var statusMessage: String?
    
    open var isViewer: Bool = false
    open var viewerIsFollowing: Bool = false
    open var isDeveloperProgramMember: Bool = false
    
    // MARK: private property
    open var public_repos: Int = 0
    open var total_private_repos: Int = 0
    private var _repositories: Int?
    open var private_gists: Int = 0
    open var public_gists: Int = 0
    private var _gists: Int?
    
    
    open override func mj_newValue(fromOldValue oldValue: Any!, property: MJProperty!) -> Any! {
        if "created_at" == property.name ||
            "updated_at" == property.name {
            if let str: String = oldValue as? String{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                return dateFormatter.date(from: str)
            }
            return nil
        }
        return super.mj_newValue(fromOldValue: oldValue, property: property)
    }
    
    override class func supportsSecureCoding() -> Bool {
        return true
    }
    
}


// MARK: ----- ZLGithubOrgModel -----
//  ZLGithubOrgModel
@objcMembers open class ZLGithubOrgModel: ZLGithubUserBriefModel{
    
    open var name: String?
    
    open var blog: String?
    open var location: String?
    open var email: String?
    open var bio: String? {
        get {
            if _bio == nil {
                _bio = desc_org
            }
            return _bio
        }
        set {
            _bio = newValue
        }
    }
    
    open var desc_org: String?

    open var members: Int = 0
    open var teams: Int = 0
    open var repositories: Int{
        get{
            if _repositories == nil {
                return public_repos + total_private_repos
            }
            return _repositories ?? 0
        }
        set{
            _repositories = newValue
        }
    }
    
    open var created_at: Date?
    open var updated_at: Date?
    
    open var viewerIsAMember: Bool = false
    
    // MARK: private property
    open var public_repos: Int = 0
    open var total_private_repos: Int = 0
    
    private var _repositories: Int?
    private var _bio: String?
    
    open override func mj_newValue(fromOldValue oldValue: Any!, property: MJProperty!) -> Any! {
        if "created_at" == property.name ||
            "updated_at" == property.name {
            if let str: String = oldValue as? String{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                return dateFormatter.date(from: str)
            }
            return nil
        }
        return super.mj_newValue(fromOldValue: oldValue, property: property)
    }
    
    public override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        var result = super.mj_replacedKeyFromPropertyName()
        result?["desc_org"] = "description"
        return result
    }
 

    override class func supportsSecureCoding() -> Bool {
        return true
    }
}

