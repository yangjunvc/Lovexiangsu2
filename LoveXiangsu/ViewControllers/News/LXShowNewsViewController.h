//
//  LXShowNewsViewController.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/8.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

@interface LXShowNewsViewController : LXBaseViewController<UIWebViewDelegate, LXRequestDelegate>

@property (strong, nonatomic) NSString * htmlContent;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * id;

@end
