//
//  ZLSharedDataManager.h
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/2/7.
//  Copyright © 2020 ZM. All rights reserved.
//

/**
 *   维护保存在keychain，userdefaults 或者沙盒中的数据
 *
 */

#import <Foundation/Foundation.h>
#import "ZLSearchServiceHeader.h"


@class ZLGithubUserModel;
@class ZLGithubConfigModel;
@class ZLGithubCollectedRepoModel;
@class ZLGithubRepositoryModel;
 
NS_ASSUME_NONNULL_BEGIN


@interface ZLSharedDataManager : NSObject

+ (instancetype) sharedInstance;


#pragma mark - 登录用户有关的设置

@property(nonatomic,strong,nullable) NSString * currentLoginName;

@property(nonatomic,strong,nullable) NSString * githubAccessToken;


- (void) clearGithubTokenAndUserInfo;



#pragma mark - 与登录用户无关的设置

// github 支持的开发语言列表
@property(nonatomic,strong,nullable) NSArray<NSString *>* githubLanguageList;

// 设备id
@property(nonatomic,strong,readonly) NSString * deviceId;

// 应用动态配置
@property(nonatomic,strong,nullable) ZLGithubConfigModel *configModel;

// fix repo

- (void) setFixRepos:(NSArray *)repos forLoginUser:(NSString *)login;

- (NSArray* __nullable) fixReposForLoginUser:(NSString *)login;


#pragma mark - Trending Cache

- (NSArray<ZLGithubRepositoryModel *> *) trendRepositoriesWithLanguage:(NSString *) languague
                                                        spokenLanguage:(NSString *) spokenLanguage
                                                             dateRange:(ZLDateRange) range;

- (NSArray<ZLGithubUserModel *> *) trendUsersWithLanguage:(NSString *) languague
                                                dateRange:(ZLDateRange) range;


- (void) setTrendRepositories:(NSArray<ZLGithubRepositoryModel *> *) array
                     language:(NSString *) languague
               spokenLanguage:(NSString *) spokenLanguage
                    dateRange:(ZLDateRange) range;

- (void) setTrendUsers:(NSArray<ZLGithubUserModel *> *) array
              language:(NSString *) languague
             dateRange:(ZLDateRange) range;
@end

NS_ASSUME_NONNULL_END
