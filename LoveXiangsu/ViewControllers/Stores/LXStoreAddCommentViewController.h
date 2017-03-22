//
//  LXStoreAddCommentViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 16/1/6.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

#import "SZTextView.h"

@interface LXStoreAddCommentViewController : LXBaseViewController<LXRequestDelegate>

@property (nonatomic, strong) UIImageView * star1;
@property (nonatomic, strong) UIImageView * star2;
@property (nonatomic, strong) UIImageView * star3;
@property (nonatomic, strong) UIImageView * star4;
@property (nonatomic, strong) UIImageView * star5;
@property (nonatomic, strong) SZTextView  * storeComment;

@property (nonatomic, strong) NSString * store_id;

@end
