//
//  LXNewsCell.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/14.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXNewsCell.h"
#import "LXUICommon.h"

@implementation LXNewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *superCell = self.contentView;
//        self.layer.borderColor = [[UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0] CGColor];
//        self.layer.borderWidth = 1;

        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = LX_TEXTSIZE_16;
        self.nameLabel.textColor = LX_MAIN_TEXT_COLOR;
        self.nameLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.nameLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(MARGIN);
            make.right.equalTo(superCell.right).offset(-MARGIN);
//            make.height.greaterThanOrEqualTo(MARGIN);
            make.height.lessThanOrEqualTo(MARGIN * 2.5);
        }];

        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.font = LX_TEXTSIZE_12;
        self.contentLabel.textColor = LX_SECOND_TEXT_COLOR;
        self.contentLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.contentLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.bottom).offset(PADDING);
            make.left.equalTo(MARGIN);
            make.right.equalTo(superCell.right).offset(-MARGIN);
//            make.height.greaterThanOrEqualTo(PADDING * 1.5);
            make.height.lessThanOrEqualTo(PADDING * 4.5);
        }];

        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.font = LX_TEXTSIZE_12;
        self.timeLabel.textColor = LX_SECOND_TEXT_COLOR;
        self.timeLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.timeLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.bottom).offset(PADDING);
            make.right.equalTo(superCell.right).offset(-MARGIN);
            make.bottom.equalTo(-MARGIN);
            make.height.equalTo(PADDING * 2);
            make.width.equalTo(150);
        }];

//        self.cellSeparator = [[UIView alloc]init];
//        // [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0]
//        self.cellSeparator.layer.borderColor = [LX_THIRD_TEXT_COLOR CGColor];
//        self.cellSeparator.layer.borderWidth = BorderWidth05;
//        [self.contentView addSubview:self.cellSeparator];
//        [self.cellSeparator makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(0);
//            make.right.equalTo(0);
//            make.bottom.equalTo(0);
//            make.height.equalTo(BorderWidth05);
//            make.width.equalTo(ScreenWidth);
//        }];
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

@end
