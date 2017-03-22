//
//  LXMainMenuViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 15/10/18.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXMainMenuHeaderView.h"
#import "LXBaseViewController.h"
#import "UIViewController+MMDrawerController.h"

typedef NS_ENUM(NSInteger, LXMainMenuItem) {
    LXMainMenuMyStore                      = 0,
    LXMainMenuMyFavorStore                 ,
    LXMainMenuMyCalledStore                ,
    LXMainMenuMyTopic                      ,
    LXMainMenuMyComment                    ,
    LXMainMenuSetting                      ,
};

@interface LXMainMenuViewController : LXBaseViewController

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) LXMainMenuHeaderView * headerView;

@end
