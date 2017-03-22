//
//  LXStoreReplyCommentViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 16/3/4.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

@interface LXStoreReplyCommentViewController : LXBaseViewController<LXRequestDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSString     * comment_id;

@property (nonatomic, strong) NSString     * nickname;
@property (nonatomic, strong) NSString     * comment;
@property (nonatomic, strong) NSString     * createdat;

@end
