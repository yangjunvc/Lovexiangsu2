//
//  LXStoreModifyArticleViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 16/3/1.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

@interface LXStoreModifyArticleViewController : LXBaseViewController<LXRequestDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSString     * goods_id;

@end
