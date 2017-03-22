//
//  LXForumMenuViewController.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/11.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

@interface LXForumMenuViewController : LXBaseViewController<UITableViewDataSource,UITableViewDelegate,LXRequestDelegate>

extern NSString * defaultForumName;                   // 缺省论坛名称
extern NSInteger  defaultForumId;                     // 缺省论坛ID

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * tableArray;

- (void)setNeedsTableViewRefresh;
- (void)setDonotNeedScrollToTop;

@end
