//
//  LXBasePageViewController.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/15.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

@interface LXBasePageViewController : LXBaseViewController<LXRequestDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * tableArray;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger amountPerPage;

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * tag;
@property (nonatomic, strong) NSString * order;

- (void)initProperties;
- (void)putElements;

@end
