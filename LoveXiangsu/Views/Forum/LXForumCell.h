//
//  LXForumCell.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/22.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface LXForumCell : UITableViewCell

@property (nonatomic, strong) NSString    * topicId;
@property (nonatomic, strong) NSString    * forumId;

@property (nonatomic, strong) UIImageView * topImg;
@property (nonatomic, strong) UILabel     * titleLabel;

@property (nonatomic, strong) TTTAttributedLabel * contentLabel;
@property (nonatomic, strong) UIImageView * topicImg;

@property (nonatomic, strong) UIImageView * replyImg;
@property (nonatomic, strong) UILabel     * replyCountLabel;

@property (nonatomic, strong) UILabel     * forumNameLabel;

@property (nonatomic, strong) UILabel     * updateTimeLabel;

//@property (nonatomic, strong) UIButton    * topicImgView;

@property (nonatomic, strong) NSString    * topicImgPath;

@end
