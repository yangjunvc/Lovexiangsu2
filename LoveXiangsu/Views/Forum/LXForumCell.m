//
//  LXForumCell.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/22.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXForumCell.h"
#import "LXUICommon.h"
#import "LXCommon.h"
#import "UILabel+VerticalAlign.h"

@implementation LXForumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *superCell = self.contentView;
        self.topImg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.topImg];
        [self.topImg makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(MARGIN);
            make.width.equalTo(TopImgWidth);
            make.height.equalTo(TopImgHeight);
        }];

        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textColor = LX_MAIN_TEXT_COLOR;
        self.titleLabel.font = LX_TEXTSIZE_16;
        self.titleLabel.clipsToBounds = NO;
        self.titleLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.titleLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN + TopImgWidth);
            make.top.equalTo(MARGIN);
            make.right.equalTo(superCell.right).offset(-MARGIN);
            // 高度等于MARGIN即可
            make.height.equalTo(MARGIN);
        }];

        self.topicImg = [[UIImageView alloc]init];
        self.topicImg.contentMode = UIViewContentModeScaleAspectFill;
        self.topicImg.clipsToBounds = YES;
        self.topicImg.layer.borderColor = LX_DEBUG_COLOR;
        self.topicImg.layer.borderWidth = 1;
        [self.contentView addSubview:self.topicImg];
        [self.topicImg makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superCell.right).offset(-MARGIN);
            make.top.equalTo(self.titleLabel.bottom).offset(MARGIN);
            make.width.equalTo(TopicImgWidth);
            make.height.equalTo(TopicImgHeight);
        }];

        self.contentLabel = [[TTTAttributedLabel alloc]init];
        self.contentLabel.numberOfLines = 4;
        self.contentLabel.font = LX_TEXTSIZE_14;
        self.contentLabel.textColor = LX_MAIN_TEXT_COLOR;
        self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.contentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        self.contentLabel.clipsToBounds = YES;
        self.contentLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.contentLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.titleLabel.bottom).offset(MARGIN);
            make.right.equalTo(superCell.right).offset(-(MARGIN * 2 + TopicImgWidth));
            make.height.lessThanOrEqualTo(TopicImgHeight);
        }];

//        self.topicImgView = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.topicImgView.layer.borderColor = LX_DEBUG_COLOR;
//        self.topicImgView.layer.borderWidth = 1;
//        [self.contentView addSubview:self.topicImgView];
//        [self.topicImgView makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.topicImg);
//        }];

        self.replyImg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.replyImg];
        [self.replyImg makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.contentLabel.bottom).offset(MARGIN);
            make.bottom.equalTo(superCell.bottom).offset(-MARGIN);
            make.width.equalTo(ReplyImgWidth);
            make.height.equalTo(ReplyImgHeight);
        }];

        self.replyCountLabel = [[UILabel alloc]init];
        self.replyCountLabel.font = LX_TEXTSIZE_12;
        self.replyCountLabel.textColor = LX_SECOND_TEXT_COLOR;
        self.replyCountLabel.textAlignment = NSTextAlignmentLeft;
        self.replyCountLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.replyCountLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.replyCountLabel];
        [self.replyCountLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.replyImg.right).offset(PADDING);
            make.centerY.equalTo(self.replyImg.centerY);
            make.width.equalTo(TopicImgWidth);
            make.height.equalTo(MARGIN);
        }];

        self.forumNameLabel = [[UILabel alloc]init];
        self.forumNameLabel.font = LX_TEXTSIZE_12;
        self.forumNameLabel.textColor = LX_SECOND_TEXT_COLOR;
        self.forumNameLabel.textAlignment = NSTextAlignmentLeft;
        self.forumNameLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.forumNameLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.forumNameLabel];
        [self.forumNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.replyCountLabel.right).offset(MARGIN);
            make.centerY.equalTo(self.replyImg.centerY);
            make.width.equalTo(TopicImgWidth * 2);
            make.height.equalTo(MARGIN);
        }];

        self.updateTimeLabel = [[UILabel alloc]init];
        self.updateTimeLabel.font = LX_TEXTSIZE_12;
        self.updateTimeLabel.textColor = LX_SECOND_TEXT_COLOR;
        self.updateTimeLabel.textAlignment = NSTextAlignmentRight;
        self.updateTimeLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.updateTimeLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.updateTimeLabel];
        [self.updateTimeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superCell.right).offset(-MARGIN);
            make.centerY.equalTo(self.replyImg.centerY);
            make.width.equalTo(TopicImgWidth * 2);
            make.height.equalTo(MARGIN);
        }];
    }

    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    UIView *superCell = self.contentView;
    NSLog(@"帖子标题：%@", self.titleLabel.text);

    if (self.topImg.hidden) {
        [self.titleLabel updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
        }];
    } else {
        [self.titleLabel updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN + TopImgWidth);
        }];
    }

    if (self.topicImg.hidden) {
        [self.contentLabel updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superCell.right).offset(-MARGIN);
        }];
    } else {
        [self.contentLabel updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superCell.right).offset(-(MARGIN * 2 + TopicImgWidth));
        }];
    }
}

@end
