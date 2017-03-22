//
//  LXStoreActivityCell.m
//  LoveXiangsu
//
//  Created by yangjun on 16/2/20.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreActivityCell.h"
#import "LXUICommon.h"
#import "LXCommon.h"
#import "UILabel+VerticalAlign.h"

@implementation LXStoreActivityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *superCell = self.contentView;

        self.activityImg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.activityImg];
        [self.activityImg makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(MARGIN);
            make.width.equalTo(ActivityImgWidth);
            make.height.equalTo(ActivityImgHeight);
        }];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textColor = LX_MAIN_TEXT_COLOR;
        self.titleLabel.font = LX_TEXTSIZE_16;
        self.titleLabel.clipsToBounds = NO;
        self.titleLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.titleLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.activityImg.right).offset(PADDING);
            make.top.equalTo(MARGIN);
            make.right.equalTo(superCell.right).offset(-MARGIN);
            // 高度等于MARGIN即可
            make.height.equalTo(MARGIN);
        }];

        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.numberOfLines = 3;
        self.contentLabel.font = LX_TEXTSIZE_12;
        self.contentLabel.textColor = LX_SECOND_TEXT_COLOR;
        self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.contentLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.contentLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.activityImg.right).offset(PADDING);
            make.top.equalTo(self.titleLabel.bottom).offset(PADDING);
            make.right.equalTo(superCell.right).offset(-MARGIN);
            make.height.greaterThanOrEqualTo(MARGIN * 2);
        }];

        self.startTimeLabel = [[UILabel alloc]init];
        self.startTimeLabel.font = LX_TEXTSIZE_12;
        self.startTimeLabel.textColor = LX_SECOND_TEXT_COLOR;
        self.startTimeLabel.textAlignment = NSTextAlignmentLeft;
        self.startTimeLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.startTimeLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.startTimeLabel];
        [self.startTimeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.contentLabel.bottom).offset(MARGIN);
            make.bottom.equalTo(superCell.bottom).offset(-MARGIN);
            make.width.equalTo(150);
            make.height.equalTo(MARGIN);
        }];

        self.endTimeLabel = [[UILabel alloc]init];
        self.endTimeLabel.font = LX_TEXTSIZE_12;
        self.endTimeLabel.textColor = LX_SECOND_TEXT_COLOR;
        self.endTimeLabel.textAlignment = NSTextAlignmentRight;
        self.endTimeLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.endTimeLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.endTimeLabel];
        [self.endTimeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superCell.right).offset(-MARGIN);
            make.top.equalTo(self.contentLabel.bottom).offset(MARGIN);
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
}

@end
