//
//  LXSubmitReportViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 16/2/2.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

#import "SZTextView.h"

@interface LXSubmitReportViewController : LXBaseViewController<LXRequestDelegate>

@property (nonatomic, strong) SZTextView  * reportContent;

@property (nonatomic, strong) NSString    * topicId;
@property (nonatomic, strong) NSString    * replyId;
@property (nonatomic, strong) NSString    * userId;

@end
