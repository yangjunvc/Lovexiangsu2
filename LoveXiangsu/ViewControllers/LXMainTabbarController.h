//
//  LXMainTabbarController.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/10/22.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXMainTabbarController : UITabBarController<EMCallManagerDelegate, IChatManagerDelegate>
{
    EMConnectionState _connectionState;
}

@property (nonatomic , assign) int currentSelectedIndex;

-(void)selectAnotherViewController:(NSUInteger)selectedIndex;
-(void)networkChanged:(EMConnectionState)connectionState;

-(void)jumpToChatList;
-(void)didReceiveLocalNotification:(UILocalNotification *)notification;

@end
