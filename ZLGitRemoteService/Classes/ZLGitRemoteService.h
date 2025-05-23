//
//  ZLServiceFramework.h
//  ZLServiceFramework
//
//  Created by 朱猛 on 2020/12/30.
//  Copyright © 2020 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for ZLServiceFramework.
FOUNDATION_EXPORT double ZLServiceFrameworkVersionNumber;

//! Project version string for ZLServiceFramework.
FOUNDATION_EXPORT const unsigned char ZLServiceFrameworkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ZLGitRemoteService/PublicHeader.h>

// GeneralDefine
#include "ZLGitRemoteSerivce_GeneralDefine.h"

// model
#import "ZLBaseObject.h"
#import "ZLGithubRepositoryBranchModel.h"
#import "ZLGithubRepositoryReadMeModel.h"
#import "ZLGithubCommitModel.h"
#import "ZLGithubPullRequestModel.h"
#import "ZLGithubContentModel.h"
#import "ZLGithubGistModel.h"
#import "ZLGithubIssueModel.h"
#import "ZLGitHubEventModel.h"
#import "ZLGithubEventType.h"
#import "ZLGithubRequestErrorModel.h"
#import "ZLOperationResultModel.h"
#import "ZLSearchFilterInfoModel.h"
#import "ZLTrendingFilterInfoModel.h"
#import "ZLSearchResultModel.h"

// Tool
#import "ZLLogModuleProtocol.h"
#import "ZLDBModuleProtocol.h"
#import "ZLSharedDataManager.h"

#import "ZLBaseServiceModel.h"
#import "ZLEventServiceHeader.h"
#import "ZLAdditionServiceHeader.h"
#import "ZLSearchServiceHeader.h"
#import "ZLRepoServiceHeader.h"
#import "ZLUserServiceHeader.h"
#import "ZLLoginServiceHeader.h"

//extension
#import "NSString+ZLExtension.h"
#import "NSDate+Format.h"





