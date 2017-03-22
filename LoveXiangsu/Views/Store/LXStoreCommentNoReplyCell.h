//
//  LXStoreCommentNoReplyCell.h
//  LoveXiangsu
//
//  Created by yangjun on 16/3/2.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTTAttributedLabel.h"

@interface LXStoreCommentNoReplyCell : UITableViewCell

@property (nonatomic, strong) NSString    * comment_id;

@property (nonatomic, strong) UILabel     * nicknameLabel;
@property (nonatomic, strong) TTTAttributedLabel * commentLabel;

@property (nonatomic, strong) UILabel     * tipLabel;
@property (nonatomic, strong) UILabel     * createdatLabel;

@property (nonatomic, strong) UIView      * cellSeparator;

@end
