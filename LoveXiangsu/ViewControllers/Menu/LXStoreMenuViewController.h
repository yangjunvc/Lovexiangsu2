//
//  LXStoreMenuViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 15/11/10.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

@interface LXStoreMenuViewController : LXBaseViewController<UITableViewDataSource,UITableViewDelegate,LXRequestDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * tableArray;

- (void)setNeedsTableViewRefresh;
- (void)setDonotNeedScrollToTop;

@end
