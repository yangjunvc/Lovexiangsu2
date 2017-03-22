//
//  LXShowStoreDetailViewController.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/8.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"
#import "LXShareManager.h"

@interface LXShowStoreDetailViewController : LXBaseViewController<UIWebViewDelegate,LXRequestDelegate,LXShareActionDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSString * storeId;
@property (strong, nonatomic) NSString * storeName;
@property (strong, nonatomic) NSString * storeDesc;

@end
