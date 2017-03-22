/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "AppDelegate.h"

#import "LXBaseRequest.h"

typedef NS_ENUM(NSInteger, LXEaseMobRegistStatus) {
    LXEaseMobRegistSuccess                      = 0,
    LXEaseMobErrorServerNotReachable            = -1,
    LXEaseMobErrorServerDuplicatedAccount       = -2,
    LXEaseMobErrorNetworkNotConnected           = -3,
    LXEaseMobErrorServerTimeout                 = -4,
    LXEaseMobErrorServerRegistFailed            = -5,
};

typedef NS_ENUM(NSInteger, LXEaseMobLoginStatus) {
    LXEaseMobLoginSuccess                      = 0,
    LXEaseMobErrorLoginNetworkFail             = -1,
    LXEaseMobErrorLoginServerFail              = -2,
    LXEaseMobErrorLoginAuthenticationFail      = -3,
    LXEaseMobErrorLoginServerTimeout           = -4,
    LXEaseMobErrorLoginLoginFailure            = -5,
    LXEaseMobErrorLoginNotExists               = -6,
};

@interface AppDelegate (EaseMob)<LXRequestDelegate>

+ (NSMutableDictionary *)occupantsInfoDict;
+ (void)setOccupantsInfoDict:(NSMutableDictionary *)infoDict;

- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)loginWithUsername:(NSString *)username password:(NSString *)password;
- (void)registerWithUsername:(NSString *)username password:(NSString *)password;

@end
