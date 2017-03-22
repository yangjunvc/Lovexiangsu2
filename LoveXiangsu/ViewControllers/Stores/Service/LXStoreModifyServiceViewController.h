//
//  LXStoreModifyServiceViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 16/3/2.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

@interface LXStoreModifyServiceViewController : LXBaseViewController<LXRequestDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSString     * service_id;
@property (nonatomic, strong) NSString     * order_id;

@end
