//
//  LXNotificationCenterString.h
//  LoveXiangsu
//
//  Created by yangjun on 15/10/18.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXNotificationCenterString : NSObject

extern NSString * const k_Noti_changeTabBarButton;                  // 切换TabBar的按钮通知
extern NSString * const k_Noti_changeTabBarToHomepage;              // 切换TabBar到主页的通知
extern NSString * const k_Noti_changeTabBarToStoreList;             // 切换TabBar到店铺列表页的通知
extern NSString * const k_Noti_changeTabBarToChatList;              // 切换TabBar到聊天列表页的通知
extern NSString * const k_Noti_changeTabBarToForumList;             // 切换TabBar到论坛列表页的通知
extern NSString * const k_Noti_comebackToForumList;                 // 从话题详情页回到论坛列表页的通知
extern NSString * const k_Noti_comebackToStoreList;                 // 从店铺详情页回到店铺列表页的通知
extern NSString * const k_Noti_refreshForumList;                    // 刷新论坛列表页的通知
extern NSString * const k_Noti_refreshTopicDetail;                  // 刷新帖子详情页的通知
extern NSString * const k_Noti_refreshStoreDetail;                  // 刷新店铺详情页的通知
extern NSString * const k_Noti_refreshActivityList;                 // 刷新店铺活动列表页的通知
extern NSString * const k_Noti_refreshArticleList;                  // 刷新店铺商品列表页的通知
extern NSString * const k_Noti_refreshServiceList;                  // 刷新店铺服务列表页的通知
extern NSString * const k_Noti_refreshCommentList;                  // 刷新店铺评论列表页的通知

extern NSString * const k_Noti_userLoginSuccess;                    // 用户登录成功通知
extern NSString * const k_Noti_userLogoutSuccess;                   // 用户登出成功通知

extern NSString * const k_Noti_StoreMenuSelected;                   // 店铺菜单选择通知
extern NSString * const k_Noti_PhoneMenuSelected;                   // 电话菜单选择通知
extern NSString * const k_Noti_ForumMenuSelected;                   // 论坛菜单选择通知

extern NSString * const k_Noti_removeAppStartView;                  // 移除APP自定义启动页通知

@end
