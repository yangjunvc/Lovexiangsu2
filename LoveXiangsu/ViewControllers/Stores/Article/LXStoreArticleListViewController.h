//
//  LXStoreArticleListViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 16/2/29.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

@interface LXStoreArticleListViewController : LXBaseViewController<LXRequestDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString * storeId;

@end
