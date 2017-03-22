//
//  LXStoreCommentListViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 16/3/2.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

@interface LXStoreCommentListViewController : LXBaseViewController<LXRequestDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString * storeId;

@end
