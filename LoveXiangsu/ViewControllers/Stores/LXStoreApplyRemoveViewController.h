//
//  LXStoreApplyRemoveViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 16/1/9.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

#import "SZTextView.h"

@interface LXStoreApplyRemoveViewController : LXBaseViewController<LXRequestDelegate>

@property (nonatomic, strong) SZTextView  * applyReason;

@property (nonatomic, strong) NSString * store_id;

@end
