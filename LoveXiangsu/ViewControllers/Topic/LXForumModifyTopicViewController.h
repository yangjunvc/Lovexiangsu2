//
//  LXForumModifyTopicViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 15/12/28.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

#import "SZTextView.h"

@interface LXForumModifyTopicViewController : LXBaseViewController<LXRequestDelegate>

@property (nonatomic, strong) UITextField * topicTitle;
@property (nonatomic, strong) SZTextView  * topicContent;

@property (strong, nonatomic) NSString * topicId;
@property (strong, nonatomic) NSString * topicTitleStr;
@property (strong, nonatomic) NSString * topicContentStr;
@property (strong, nonatomic) NSArray  * imageArray;

@end
