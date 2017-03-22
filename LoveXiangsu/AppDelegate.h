//
//  AppDelegate.h
//  LoveXiangsu
//
//  Created by yangjun on 15/10/17.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXMainTabbarController.h"

static NSString *appKey = @"6e807bb273ad481e555ba95b";
static NSString *channel = @"App Store";
static BOOL isProduction = TRUE;

@interface AppDelegate : UIResponder <UIApplicationDelegate, IChatManagerDelegate>
{
    EMConnectionState _connectionState;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LXMainTabbarController * tabbarDrawerViewController;

+ (instancetype)sharedInstance;

@end

