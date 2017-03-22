//
//  LXMenuManager.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/11.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXMenuManager : NSObject

// 主菜单（带导航视图）
@property(nonatomic, strong) UINavigationController * mainMenuNavVC;
// 店铺菜单
@property(nonatomic, strong) UIViewController * storeMenuVC;
// 论坛菜单
@property(nonatomic, strong) UIViewController * forumMenuVC;
// 电话菜单
@property(nonatomic, strong) UIViewController * phoneMenuVC;

+ (LXMenuManager *)sharedInstance;

@end
