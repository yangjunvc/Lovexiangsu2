//
//  LXSettingViewController.h
//  LoveXiangsu
//
//  Created by ting.zhang on 15/10/31.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"
#import "LXShareManager.h"

@interface LXSettingViewController : LXBaseViewController<UITableViewDataSource, UITableViewDelegate, LXRequestDelegate, LXShareActionDelegate>

@property (nonatomic, strong) UITableView * tableView;

@end
