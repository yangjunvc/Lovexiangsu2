//
//  LXForumNewTopicViewController.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/12/22.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

#import "LXTextField.h"

#import "SZTextView.h"

@interface LXForumNewTopicViewController : LXBaseViewController<LXRequestDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) LXTextField * boardTypeName;
@property (nonatomic, strong) UITextField * topicTitle;
@property (nonatomic, strong) SZTextView  * topicContent;

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * tag;

@end
