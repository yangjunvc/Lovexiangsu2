//
//  LXStoreFixInfosViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 16/1/7.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

#import "LXTextView.h"

#define kInputTextViewMinHeight 28
#define kInputTextViewMaxHeight 56

@interface LXStoreFixInfosViewController : LXBaseViewController<LXRequestDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSString     * store_id;

@end
