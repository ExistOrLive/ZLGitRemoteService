
//
//  ZLSharedDataManager.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/2/7.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLSharedDataManager.h"
#import "ZLKeyChainManager.h"
#import <MJExtension/MJExtension.h>
#import "ZLGitRemoteService-Swift.h"

#define APP_GROUP_ID @"group.com.zm.ZLGithubClient"

#define ZLSharedDataManager_Version 1

#define ZLKeyChainService @"com.zm.fbd34c5a34be72f66c35.ZLGitHubClient"
#define ZLKeyChainServiceFixRepos @"com.zm.fbd34c5a34be72f66c35.ZLGitHubClient.fixrepo"
#define ZLKeyChainServiceDeviceId @"com.zm.fbd34c5a34be72f66c35.ZLGitHubClient.deviceId"

#define ZLAccessTokenKey @"ZLAccessTokenKey"
#define ZLGithubConfigKey @"ZLGithubConfigKey"
#define ZLGithubLanguageKey @"ZLGithubLanguagueKey"

#define ZLGithubTrendRepositoriesKey @"ZLGithubTrendRepositoriesKey"
#define ZLGithubTrendUsersKey @"ZLGithubTrendUsersKey"

@interface ZLSharedDataManager()

@property(nonatomic,strong,nullable) ZLGithubUserModel * userInfoModel;

@end 

 
@implementation ZLSharedDataManager

@synthesize userInfoModel = _userInfoModel;
@synthesize githubAccessToken = _githubAccessToken;
@synthesize configModel = _configModel;
@dynamic deviceId;
@dynamic githubLanguageList;

+ (instancetype) sharedInstance{
    static ZLSharedDataManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZLSharedDataManager alloc] init];
        [manager dataMigration];
    });
    
    return manager;
}

- (void) dataMigration {
    
    /// 在 App Group 中保存 token
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:ZLAccessTokenKey];
    if(token) {
        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:APP_GROUP_ID];
        [sharedDefaults setObject:token forKey:ZLAccessTokenKey];
        [sharedDefaults synchronize];   /// 迁移到APP Group 中
    }
}


#pragma mark -

- (void) setCurrentLoginName:(NSString *)currentLoginName{
    [[NSUserDefaults standardUserDefaults] setObject:currentLoginName forKey:@"currentLoginName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (NSString *) currentLoginName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLoginName"];
}


// deprecated
- (void) setUserInfoModel:(ZLGithubUserModel * _Nullable)userInfoModel{
    if(userInfoModel){
        _userInfoModel = userInfoModel;
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:userInfoModel];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userInfoModel"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        _userInfoModel = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfoModel"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (ZLGithubUserModel *) userInfoModel{
    if(!_userInfoModel){
        _userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoModel"]];
    }
    return _userInfoModel;
}




#pragma mark accesstoken

- (void) setGithubAccessToken:(NSString * _Nullable)githubAccessToken{
    _githubAccessToken = githubAccessToken;
    [[NSUserDefaults standardUserDefaults] setObject:githubAccessToken forKey:ZLAccessTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /// app group 中同步数据
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:APP_GROUP_ID];
    [sharedDefaults setObject:githubAccessToken forKey:ZLAccessTokenKey];
    [sharedDefaults synchronize];
}

- (NSString *) githubAccessToken{
    if(!_githubAccessToken){
        _githubAccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:ZLAccessTokenKey];
    }
    return _githubAccessToken;
}


#pragma mark

- (void) clearGithubTokenAndUserInfo{
    [self setCurrentLoginName:nil];
    [self setUserInfoModel:nil];
    [self setGithubAccessToken:nil];
}


#pragma mark - 与用户无关的配置

#pragma mark  langugaue

- (NSArray<NSString *> *) githubLanguageList {
    id array = [[NSUserDefaults standardUserDefaults] objectForKey:ZLGithubLanguageKey];
    return array;
}

- (void)setGithubLanguageList:(NSArray<NSString *> *)githubLanguageList{
    [[NSUserDefaults standardUserDefaults] setObject:githubLanguageList forKey:ZLGithubLanguageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark deviceId

- (NSString *) deviceId {
    
    static NSString* deviceId = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceId = [ZLKeyChainManager load:ZLKeyChainServiceDeviceId];
        if(deviceId == nil || deviceId.length == 0) {
            
            NSString* idfv =  [UIDevice currentDevice].identifierForVendor.UUIDString;
            idfv = [idfv stringByReplacingOccurrencesOfString:@"-" withString:@""];
            idfv = [idfv lowercaseString];
            deviceId = [[NSString alloc] initWithFormat:@"%@-%lf",idfv,[NSDate new].timeIntervalSince1970];
            [ZLKeyChainManager save:ZLKeyChainServiceDeviceId data:deviceId];
        }
    });

    return deviceId;
}


#pragma mark  config

- (void) setConfigModel:(ZLGithubConfigModel *)configModel{
    _configModel = configModel;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:configModel];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:ZLGithubConfigKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (ZLGithubConfigModel *)configModel{
    if(!_configModel){
        NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:ZLGithubConfigKey];
        _configModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return _configModel;
}

#pragma mark  fix repo

- (void) setFixRepos:(NSArray *)repos forLoginUser:(NSString *)login{
    if(!repos || !login){
        return;
    }
    
    NSMutableDictionary *reposDic =  [ZLKeyChainManager load:ZLKeyChainServiceFixRepos];
    if(!reposDic) {
        reposDic = [NSMutableDictionary new];
    }
    [reposDic setObject:repos forKey:login];
    [ZLKeyChainManager save:ZLKeyChainServiceFixRepos data:reposDic];
}

- (NSArray * __nullable) fixReposForLoginUser:(NSString *)login{
    NSMutableDictionary *reposDic =  [ZLKeyChainManager load:ZLKeyChainServiceFixRepos];
    return [reposDic objectForKey:login];
}


#pragma mark - Trending Cache

- (NSArray<ZLGithubRepositoryModel *> *) trendRepositoriesWithLanguage:(NSString *) languague
                                                        spokenLanguage:(NSString *) spokenLanguage
                                                             dateRange:(ZLDateRange) range{
    NSString *rangeStr = @"";
    switch (range) {
        case ZLDateRangeDaily:
            rangeStr = @"daily";
            break;
        case ZLDateRangeWeakly:
            rangeStr = @"weekly";
            break;
        case ZLDateRangeMonthly:
            rangeStr = @"monthly";
            break;
        default:
            break;
    }
    
    NSMutableString *key = [NSMutableString stringWithFormat:@"%@-%@-%@",ZLGithubTrendRepositoriesKey,languague == nil ? @"" : languague,rangeStr];
    if(spokenLanguage != nil && [spokenLanguage length] > 0) {
        [key appendFormat:@"-%@",spokenLanguage];
    }
        
    id result = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if([result isKindOfClass:[NSString class]]) {
        NSString *jsonStr = result;
        NSData* data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        id dicArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:&error];
        if(error == nil) {
            return [ZLGithubRepositoryModel mj_objectArrayWithKeyValuesArray:dicArray];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return nil;
    }
}

- (NSArray<ZLGithubUserModel *> *) trendUsersWithLanguage:(NSString *) languague
                                                dateRange:(ZLDateRange) range{
    NSString *rangeStr = @"";
    switch (range) {
        case ZLDateRangeDaily:
            rangeStr = @"daily";
            break;
        case ZLDateRangeWeakly:
            rangeStr = @"weekly";
            break;
        case ZLDateRangeMonthly:
            rangeStr = @"monthly";
            break;
        default:
            break;
    }
    
    NSString *key = [NSString stringWithFormat:@"%@-%@-%@",ZLGithubTrendUsersKey,languague == nil ? @"" : languague,rangeStr];
    
    id result = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if([result isKindOfClass:[NSString class]]) {
        NSString *jsonStr = result;
        NSData* data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        id dicArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:&error];
        if(error == nil) {
            return [ZLGithubUserModel mj_objectArrayWithKeyValuesArray:dicArray];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return nil;
    }
}


- (void) setTrendRepositories:(NSArray<ZLGithubRepositoryModel *> *) array
                     language:(NSString *) languague
               spokenLanguage:(NSString *) spokenLanguage
                    dateRange:(ZLDateRange) range{
    
    NSString *rangeStr = @"";
    switch (range) {
        case ZLDateRangeDaily:
            rangeStr = @"daily";
            break;
        case ZLDateRangeWeakly:
            rangeStr = @"weekly";
            break;
        case ZLDateRangeMonthly:
            rangeStr = @"monthly";
            break;
        default:
            break;
    }
    
    NSMutableString *key = [NSMutableString stringWithFormat:@"%@-%@-%@",ZLGithubTrendRepositoriesKey,languague == nil ? @"" : languague,rangeStr];
    if(spokenLanguage != nil && [spokenLanguage length] > 0) {
        [key appendFormat:@"-%@",spokenLanguage];
    }
    
    if(array == nil){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    NSMutableArray<NSDictionary *>* dicArray =  [ZLGithubRepositoryModel mj_keyValuesArrayWithObjectArray:array];
    if([NSJSONSerialization isValidJSONObject:dicArray]) {
        NSError *error = nil;
        NSData* data = [NSJSONSerialization dataWithJSONObject:dicArray
                                                       options:NSJSONWritingSortedKeys
                                                         error:&error];
        if( nil == error) {
            NSString* jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [[NSUserDefaults standardUserDefaults] setObject:jsonStr forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void) setTrendUsers:(NSArray<ZLGithubUserModel *> *) array
                                        language:(NSString *) languague
                                       dateRange:(ZLDateRange) range{
    
    NSString *rangeStr = @"";
    switch (range) {
        case ZLDateRangeDaily:
            rangeStr = @"daily";
            break;
        case ZLDateRangeWeakly:
            rangeStr = @"weekly";
            break;
        case ZLDateRangeMonthly:
            rangeStr = @"monthly";
            break;
        default:
            break;
    }
    
    NSString *key = [NSString stringWithFormat:@"%@-%@-%@",ZLGithubTrendUsersKey,languague == nil ? @"" : languague,rangeStr];
    
    if(array == nil){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    NSMutableArray<NSDictionary *>* dicArray =  [ZLGithubUserModel mj_keyValuesArrayWithObjectArray:array];
    if([NSJSONSerialization isValidJSONObject:dicArray]) {
        NSError *error = nil;
        NSData* data = [NSJSONSerialization dataWithJSONObject:dicArray
                                                       options:NSJSONWritingSortedKeys
                                                         error:&error];
        if( nil == error) {
            NSString* jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [[NSUserDefaults standardUserDefaults] setObject:jsonStr forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}



@end
