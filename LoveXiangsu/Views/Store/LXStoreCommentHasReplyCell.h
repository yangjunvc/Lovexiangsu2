//
//  LXStoreCommentHasReplyCell.h
//  LoveXiangsu
//
//  Created by yangjun on 16/3/2.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTTAttributedLabel.h"

@interface LXStoreCommentHasReplyCell : UITableViewCell

@property (nonatomic, strong) NSString    * comment_id;

@property (nonatomic, strong) UILabel     * nicknameLabel;
@property (nonatomic, strong) TTTAttributedLabel * commentLabel;
@property (nonatomic, strong) UILabel     * createdatLabel;

@property (nonatomic, strong) UILabel     * ownerLabel;
@property (nonatomic, strong) TTTAttributedLabel * replyLabel;
@property (nonatomic, strong) UILabel     * replyTimeLabel;

@property (nonatomic, strong) UIView      * cellSeparator;

@end
