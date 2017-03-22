//
//  LXStoreModifyActivityViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 16/2/21.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

@interface LXStoreModifyActivityViewController : LXBaseViewController<LXRequestDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSString     * activity_id;

@end
