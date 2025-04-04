//
//  ZLServiceManager.swift
//  ZLServiceFramework
//
//  Created by 朱猛 on 2020/12/31.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import SYDCentralPivot

public func ZLLoginServiceShared() ->  ZLLoginServiceModuleProtocol? {
    ZLServiceManager.sharedInstance.loginServiceModel
}

public func ZLViewerServiceShared() ->  ZLViewerServiceModuleProtocol? {
    ZLServiceManager.sharedInstance.viewerServiceModel
}

public func ZLUserServiceShared() ->  ZLUserServiceModuleProtocol? {
    ZLServiceManager.sharedInstance.userServiceModel
}

public func ZLRepoServiceShared() ->  ZLRepoServiceModuleProtocol? {
    ZLServiceManager.sharedInstance.repoServiceModel
}

public func ZLSearchServiceShared() ->  ZLSearchServiceModuleProtocol? {
    ZLServiceManager.sharedInstance.searchServiceModel
}

public func ZLEventServiceShared() ->  ZLEventServiceModuleProtocol? {
    ZLServiceManager.sharedInstance.eventServiceModel
}


@objcMembers public class ZLServiceManager: NSObject {

    static public var sharedInstance = getSharedInstance()
    
    private static func getSharedInstance() -> ZLServiceManager {
        let bundle = Bundle(for: ZLServiceManager.self)
        let moduleName = "ZLGitRemoteService"
        
        let configArray = [
            SYDCentralRouterModel(modelKey: "ZLLogModule", modelType: .other, claStr: "ZLLogManager", moduleName: moduleName, single: true, singletonMethodStr: "sharedInstance"),
            SYDCentralRouterModel(modelKey: "ZLDBModule", modelType: .other, claStr: "ZLDataBaseManager", moduleName: moduleName, single: true, singletonMethodStr: "sharedInstance"),
            SYDCentralRouterModel(modelKey: "ZLViewerServiceModel", modelType: .service, claStr: "ZLViewerServiceModel", moduleName: moduleName, single: true, singletonMethodStr: "sharedServiceModel"),
            SYDCentralRouterModel(modelKey: "ZLViewerServiceModel", modelType: .service, claStr: "ZLViewerServiceModel", moduleName: moduleName, single: true, singletonMethodStr: "sharedServiceModel"),
            SYDCentralRouterModel(modelKey: "ZLUserServiceModel", modelType: .service, claStr: "ZLUserServiceModel", moduleName: moduleName, single: true, singletonMethodStr: "sharedServiceModel"),
            SYDCentralRouterModel(modelKey: "ZLLoginServiceModel", modelType: .service, claStr: "ZLLoginServiceModel", moduleName: moduleName, single: true, singletonMethodStr: "sharedServiceModel"),
            SYDCentralRouterModel(modelKey: "ZLRepoServiceModel", modelType: .service, claStr: "ZLRepoServiceModel", moduleName: moduleName, single: true, singletonMethodStr: "sharedServiceModel"),
            SYDCentralRouterModel(modelKey: "ZLSearchServiceModel", modelType: .service, claStr: "ZLSearchServiceModel", moduleName: moduleName, single: true, singletonMethodStr: "sharedServiceModel"),
            SYDCentralRouterModel(modelKey: "ZLAdditionServiceModel", modelType: .service, claStr: "ZLAdditionServiceModel", moduleName: moduleName, single: true, singletonMethodStr: "sharedServiceModel"),
            SYDCentralRouterModel(modelKey: "ZLEventServiceModel", modelType: .service, claStr: "ZLEventServiceModel", moduleName: moduleName, single: true, singletonMethodStr: "sharedServiceModel"),
        ]
        SYDCentralRouter.sharedInstance().addConfig(configArray)
        
        return ZLServiceManager()
    }
    
    public func initManager() {
      
        SYDCentralFactory.sharedInstance().getCommonBean("ZLLoginServiceModel")
        SYDCentralFactory.sharedInstance().getCommonBean("ZLViewerServiceModel")
        
        self.additionServiceModel?.getGithubClientConfig(NSString.generateSerialNumber())
    }
    
    
    public var loginServiceModel : ZLLoginServiceModuleProtocol? {
        return SYDCentralFactory.sharedInstance().getCommonBean("ZLLoginServiceModel") as? ZLLoginServiceModuleProtocol
    }
    
    public var userServiceModel : ZLUserServiceModuleProtocol? {
        return SYDCentralFactory.sharedInstance().getCommonBean("ZLUserServiceModel") as? ZLUserServiceModuleProtocol
    }
    
    public var viewerServiceModel : ZLViewerServiceModuleProtocol? {
        return SYDCentralFactory.sharedInstance().getCommonBean("ZLViewerServiceModel") as? ZLViewerServiceModuleProtocol
    }
    
    public var repoServiceModel : ZLRepoServiceModuleProtocol? {
        return SYDCentralFactory.sharedInstance().getCommonBean("ZLRepoServiceModel") as? ZLRepoServiceModuleProtocol
    }
    
    public var searchServiceModel : ZLSearchServiceModuleProtocol? {
        return SYDCentralFactory.sharedInstance().getCommonBean("ZLSearchServiceModel") as? ZLSearchServiceModuleProtocol
    }
    
    
    public  var additionServiceModel : ZLAdditionServiceModuleProtocol? {
        return SYDCentralFactory.sharedInstance().getCommonBean("ZLAdditionServiceModel") as? ZLAdditionServiceModuleProtocol
    }
    
    public var eventServiceModel : ZLEventServiceModuleProtocol? {
        return SYDCentralFactory.sharedInstance().getCommonBean("ZLEventServiceModel") as? ZLEventServiceModuleProtocol
    }
        
    public var logModule : ZLLogModuleProtocol?{
        return SYDCentralFactory.sharedInstance().getCommonBean("ZLLogModule") as? ZLLogModuleProtocol
    }
    
    public var dbModule : ZLDBModuleProtocol?{
        return SYDCentralFactory.sharedInstance().getCommonBean("ZLDBModule") as? ZLDBModuleProtocol
    }    
}
