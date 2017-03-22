//
//  LXStoreServiceListViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 16/3/1.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

@interface LXStoreServiceListViewController : LXBaseViewController<LXRequestDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString * storeId;

@end
