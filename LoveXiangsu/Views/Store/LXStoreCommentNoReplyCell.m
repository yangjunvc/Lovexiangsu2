//
//  LXStoreCommentNoReplyCell.m
//  LoveXiangsu
//
//  Created by yangjun on 16/3/2.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreCommentNoReplyCell.h"
#import "LXUICommon.h"
#import "LXCommon.h"
#import "UILabel+VerticalAlign.h"
#import "Utils.h"

@implementation LXStoreCommentNoReplyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *superCell = self.contentView;

        self.nicknameLabel = [[UILabel alloc]init];
        self.nicknameLabel.font = LX_TEXTSIZE_14;
        self.nicknameLabel.textColor = LX_SECOND_TEXT_COLOR;
        self.nicknameLabel.textAlignment = NSTextAlignmentLeft;
        self.nicknameLabel.adjustsFontSizeToFitWidth = YES;
        self.nicknameLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.nicknameLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.nicknameLabel];
        [self.nicknameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(MARGIN);
            make.width.greaterThanOrEqualTo(0);
            make.height.equalTo(MARGIN);
        }];

        self.commentLabel = [[TTTAttributedLabel alloc]init];
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.font = LX_TEXTSIZE_14;
        self.commentLabel.textColor = LX_MAIN_TEXT_COLOR;
        self.commentLabel.adjustsFontSizeToFitWidth = YES;
        self.commentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        self.commentLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.commentLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.commentLabel];
        [self.commentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nicknameLabel.right).offset(0);
            make.top.equalTo(MARGIN);
            make.right.equalTo(superCell.right).offset(-MARGIN);
//            make.width.greaterThanOrEqualTo(0);
            make.height.greaterThanOrEqualTo(MARGIN);
        }];

        self.tipLabel = [[UILabel alloc]init];
        self.tipLabel.font = LX_TEXTSIZE_12;
        self.tipLabel.textColor = LX_ACCENT_COLOR;
        self.tipLabel.textAlignment = NSTextAlignmentLeft;
        self.tipLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.tipLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.tipLabel];
        [self.tipLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.commentLabel.bottom).offset(MARGIN);
            make.bottom.equalTo(superCell.bottom).offset(-MARGIN);
            make.width.equalTo(150);
            make.height.equalTo(MARGIN);
        }];

        self.createdatLabel = [[UILabel alloc]init];
        self.createdatLabel.font = LX_TEXTSIZE_12;
        self.createdatLabel.textColor = LX_SECOND_TEXT_COLOR;
        self.createdatLabel.textAlignment = NSTextAlignmentRight;
        self.createdatLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.createdatLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.createdatLabel];
        [self.createdatLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superCell.right).offset(-MARGIN);
            make.top.equalTo(self.commentLabel.bottom).offset(MARGIN);
            make.bottom.equalTo(superCell.bottom).offset(-MARGIN);
            make.width.equalTo(150);
            make.height.equalTo(MARGIN);
        }];
        
        self.cellSeparator = [[UIView alloc]init];
        // [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0]
        self.cellSeparator.layer.borderColor = [LX_THIRD_TEXT_COLOR CGColor];
        self.cellSeparator.layer.borderWidth = BorderWidth05;
        [self.contentView addSubview:self.cellSeparator];
        [self.cellSeparator makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superCell.left);
            make.right.equalTo(superCell.right);
            make.bottom.equalTo(superCell.bottom);
            make.height.equalTo(BorderWidth05);
            make.width.equalTo(ScreenWidth);
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

    CGFloat nicknameWidth = [self.nicknameLabel getFittingWidth];
    [self.nicknameLabel updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(nicknameWidth);
    }];
}

@end
