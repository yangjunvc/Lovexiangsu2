//
//  LXStoreAddActivityViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 16/2/20.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

@interface LXStoreAddActivityViewController : LXBaseViewController<LXRequestDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSString     * store_id;

@end
