//
//  LXUserDefaultManager.m
//  LoveXiangsu
//
//  Created by yangjun on 15/11/1.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXUserDefaultManager.h"
#import "LXCommon.h"

@implementation LXUserDefaultManager

/**
 * 用户Nonce
 */
// 保存用户Nonce
+ (void)saveUserNonce:(NSString *)nonce
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nonce forKey:USERINFO_USERNONCE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 获取用户Nonce
+ (NSString *)getUserNonce
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:USERINFO_USERNONCE];
}

// 清除用户Nonce
+ (void)clearUserNonce
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERINFO_USERNONCE]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USERINFO_USERNONCE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/**
 * 用户信息
 */
// 保存用户信息
+ (void)saveUserInfo:(LXLoginResponseModel *)userModel
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userModel.id            forKey:USERINFO_USER_UID];
    [userDefaults setObject:userModel.nickname      forKey:USERINFO_USER_NICKNAME];
    [userDefaults setObject:userModel.email         forKey:USERINFO_USER_EMAIL];
    [userDefaults setObject:userModel.sex           forKey:USERINFO_USER_SEX];
    [userDefaults setObject:userModel.city          forKey:USERINFO_USER_CITY];
    [userDefaults setObject:userModel.profession    forKey:USERINFO_USER_PROFESSION];
    [userDefaults setObject:userModel.ip            forKey:USERINFO_USER_IP];
    [userDefaults setObject:userModel.name          forKey:USERINFO_USER_NAME];
    [userDefaults setObject:userModel.phone         forKey:USERINFO_USER_PHONE];
    [userDefaults setObject:userModel.birthday      forKey:USERINFO_USER_BIRTHDAY];
    [userDefaults setObject:userModel.online        forKey:USERINFO_USER_ONLINE];
    [userDefaults setObject:userModel.icon_url      forKey:USERINFO_USER_ICONURL];
    [userDefaults setObject:userModel.icon_full_url forKey:USERINFO_USER_ICONFULLURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 获取用户信息
+ (LXLoginResponseModel *)getUserInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    LXLoginResponseModel *userModel = [[LXLoginResponseModel alloc]init];
    userModel.id            = [userDefaults objectForKey:USERINFO_USER_UID];
    userModel.nickname      = [userDefaults objectForKey:USERINFO_USER_NICKNAME];
    userModel.email         = [userDefaults objectForKey:USERINFO_USER_EMAIL];
    userModel.sex           = [userDefaults objectForKey:USERINFO_USER_SEX];
    userModel.city          = [userDefaults objectForKey:USERINFO_USER_CITY];
    userModel.profession    = [userDefaults objectForKey:USERINFO_USER_PROFESSION];
    userModel.ip            = [userDefaults objectForKey:USERINFO_USER_IP];
    userModel.name          = [userDefaults objectForKey:USERINFO_USER_NAME];
    userModel.phone         = [userDefaults objectForKey:USERINFO_USER_PHONE];
    userModel.birthday      = [userDefaults objectForKey:USERINFO_USER_BIRTHDAY];
    userModel.online        = [userDefaults objectForKey:USERINFO_USER_ONLINE];
    userModel.icon_url      = [userDefaults objectForKey:USERINFO_USER_ICONURL];
    userModel.icon_full_url = [userDefaults objectForKey:USERINFO_USER_ICONFULLURL];
    return userModel;
}

// 获取用户手机号
+ (NSString *)getUserPhone
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *phone         = [userDefaults objectForKey:USERINFO_USER_PHONE];
    return phone;
}

// 获取用户ID
+ (NSString *)getUserID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *uid         = [userDefaults objectForKey:USERINFO_USER_UID];
    return uid;
}

// 清除用户信息
+ (void)clearUserInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:USERINFO_USER_UID]) {
        [userDefaults setObject:@"" forKey:USERINFO_USER_UID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([userDefaults objectForKey:USERINFO_USER_NICKNAME]) {
        [userDefaults setObject:@"" forKey:USERINFO_USER_NICKNAME];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([userDefaults objectForKey:USERINFO_USER_EMAIL]) {
        [userDefaults setObject:@"" forKey:USERINFO_USER_EMAIL];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([userDefaults objectForKey:USERINFO_USER_SEX]) {
        [userDefaults setObject:@"" forKey:USERINFO_USER_SEX];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([userDefaults objectForKey:USERINFO_USER_CITY]) {
        [userDefaults setObject:@"" forKey:USERINFO_USER_CITY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([userDefaults objectForKey:USERINFO_USER_PROFESSION]) {
        [userDefaults setObject:@"" forKey:USERINFO_USER_PROFESSION];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([userDefaults objectForKey:USERINFO_USER_IP]) {
        [userDefaults setObject:@"" forKey:USERINFO_USER_IP];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([userDefaults objectForKey:USERINFO_USER_NAME]) {
        [userDefaults setObject:@"" forKey:USERINFO_USER_NAME];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([userDefaults objectForKey:USERINFO_USER_PHONE]) {
        [userDefaults setObject:@"" forKey:USERINFO_USER_PHONE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([userDefaults objectForKey:USERINFO_USER_BIRTHDAY]) {
        [userDefaults setObject:@"" forKey:USERINFO_USER_BIRTHDAY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([userDefaults objectForKey:USERINFO_USER_ONLINE]) {
        [userDefaults setObject:@"" forKey:USERINFO_USER_ONLINE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([userDefaults objectForKey:USERINFO_USER_ICONURL]) {
        [userDefaults setObject:@"" forKey:USERINFO_USER_ICONURL];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([userDefaults objectForKey:USERINFO_USER_ICONFULLURL]) {
        [userDefaults setObject:@"" forKey:USERINFO_USER_ICONFULLURL];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/**
 * 定位信息
 */
// 保存定位信息
+ (void)saveLocationInfo:(CLLocationCoordinate2D)coordinate
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(coordinate.latitude)       forKey:LOCATIONINFO_LATITUDE];
    [userDefaults setObject:@(coordinate.longitude)      forKey:LOCATIONINFO_LONGITUDE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 判断是否存在定位信息
+ (BOOL)haveLocationInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:LOCATIONINFO_LATITUDE] ||
        ![userDefaults objectForKey:LOCATIONINFO_LONGITUDE]) {
        return NO;
    } else {
        return YES;
    }
}

// 获取定位信息
+ (CLLocationCoordinate2D)getLocationInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude       = [((NSNumber *)[userDefaults objectForKey:LOCATIONINFO_LATITUDE]) doubleValue];
    coordinate.longitude      = [((NSNumber *)[userDefaults objectForKey:LOCATIONINFO_LONGITUDE]) doubleValue];
    return coordinate;
}

// 清除定位信息
+ (void)clearLocationInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:LOCATIONINFO_LATITUDE]) {
        [userDefaults setObject:nil forKey:LOCATIONINFO_LATITUDE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([userDefaults objectForKey:LOCATIONINFO_LONGITUDE]) {
        [userDefaults setObject:nil forKey:LOCATIONINFO_LONGITUDE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
