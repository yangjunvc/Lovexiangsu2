//
//  LXShowTopicDetailViewController.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/28.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

#import "LXMessageToolBar.h"

@interface LXShowTopicDetailViewController : LXBaseViewController<LXRequestDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString * topicId;
@property (strong, nonatomic) LXMessageToolBar *chatToolBar;

@end
