//
//  LXStoreReplyCommentView.h
//  LoveXiangsu
//
//  Created by yangjun on 16/3/4.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"
#import "TTTAttributedLabel.h"

@interface LXStoreReplyCommentView : UIView

@property (nonatomic, strong) UILabel               * nicknameLabel;
@property (nonatomic, strong) TTTAttributedLabel    * commentLabel;
@property (nonatomic, strong) UILabel               * createdatLabel;

@property (nonatomic, strong) SZTextView            * replyContent;

@end
