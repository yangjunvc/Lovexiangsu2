//
//  LXStoreAddServiceViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 16/3/2.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

@interface LXStoreAddServiceViewController : LXBaseViewController<LXRequestDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSString     * store_id;

@end
