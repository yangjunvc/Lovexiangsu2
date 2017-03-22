//
//  LXPhoneMenuViewController.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/14.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

@interface LXPhoneMenuViewController : LXBaseViewController<UITableViewDataSource,UITableViewDelegate,LXRequestDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic , strong) NSMutableArray * tableArray;

- (void)setNeedsTableViewRefresh;

@end
