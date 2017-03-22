//
//  LXMenuManager.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/11.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXMenuManager.h"
#import "LXMainMenuViewController.h"
#import "LXStoreMenuViewController.h"
#import "LXForumMenuViewController.h"
#import "LXPhoneMenuViewController.h"
#import "LXNavigationController.h"

@implementation LXMenuManager

@synthesize mainMenuNavVC = _mainMenuNavVC;
@synthesize storeMenuVC = _storeMenuVC;
@synthesize forumMenuVC = _forumMenuVC;
@synthesize phoneMenuVC = _phoneMenuVC;

+ (LXMenuManager *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (UIViewController *) mainMenuNavVC
{
    if (_mainMenuNavVC) {
        return _mainMenuNavVC;
    }

    // 主菜单
    UIViewController * mainMenuDrawerViewController = [[LXMainMenuViewController alloc] init];
    _mainMenuNavVC = [[LXNavigationController alloc] initWithRootViewController:mainMenuDrawerViewController];
    [_mainMenuNavVC setRestorationIdentifier:@"LXMainMenuNavigationControllerRestorationKey"];
    // 隐藏掉导航条
    _mainMenuNavVC.navigationBarHidden = YES;
    return _mainMenuNavVC;
}

- (UIViewController *) storeMenuVC
{
    if (_storeMenuVC) {
        return _storeMenuVC;
    }
    _storeMenuVC = [[LXStoreMenuViewController alloc]init];
    return _storeMenuVC;
}

- (UIViewController *) forumMenuVC
{
    if (_forumMenuVC) {
        return _forumMenuVC;
    }
    _forumMenuVC = [[LXForumMenuViewController alloc]init];
    return _forumMenuVC;
}

- (UIViewController *) phoneMenuVC
{
    if (_phoneMenuVC) {
        return _phoneMenuVC;
    }
    _phoneMenuVC = [[LXPhoneMenuViewController alloc]init];
    return _phoneMenuVC;
}

@end
