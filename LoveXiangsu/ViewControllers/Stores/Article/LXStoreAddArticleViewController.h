//
//  LXStoreAddArticleViewController.h
//  LoveXiangsu
//
//  Created by 张婷 on 16/2/29.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

@interface LXStoreAddArticleViewController : LXBaseViewController<LXRequestDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSString     * store_id;

@end
