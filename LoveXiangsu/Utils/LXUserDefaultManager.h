//
//  LXUserDefaultManager.h
//  LoveXiangsu
//
//  Created by yangjun on 15/11/1.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXLoginResponseModel.h"

@interface LXUserDefaultManager : NSObject

/**
 * 用户Nonce
 */
// 保存用户Nonce
+ (void)saveUserNonce:(NSString *)nonce;
// 获取用户Nonce
+ (NSString *)getUserNonce;
// 清除用户Nonce
+ (void)clearUserNonce;

/**
 * 用户信息
 */
// 保存用户信息
+ (void)saveUserInfo:(LXLoginResponseModel *)userModel;
// 获取用户信息
+ (LXLoginResponseModel *)getUserInfo;
// 获取用户手机号
+ (NSString *)getUserPhone;
// 获取用户ID
+ (NSString *)getUserID;
// 清除用户信息
+ (void)clearUserInfo;

/**
 * 定位信息
 */
// 保存定位信息
+ (void)saveLocationInfo:(CLLocationCoordinate2D)coordinate;
// 判断是否存在定位信息
+ (BOOL)haveLocationInfo;
// 获取定位信息
+ (CLLocationCoordinate2D)getLocationInfo;
// 清除定位信息
+ (void)clearLocationInfo;

@end
