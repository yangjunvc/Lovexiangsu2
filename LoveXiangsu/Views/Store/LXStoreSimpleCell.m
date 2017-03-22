//
//  LXStoreSimpleCell.m
//  LoveXiangsu
//
//  Created by yangjun on 16/2/29.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreSimpleCell.h"
#import "LXUICommon.h"
#import "LXCommon.h"

@implementation LXStoreSimpleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *superCell = self.contentView;

        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = LX_MAIN_TEXT_COLOR;
        self.nameLabel.font = FONT_SYSTEM(17);
        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.nameLabel.clipsToBounds = NO;
        self.nameLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.nameLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(MARGIN);
            make.bottom.equalTo(superCell.bottom).offset(-MARGIN);
            make.width.equalTo((ScreenWidth - 2 * MARGIN) / 2);
        }];
        
        self.priceLabel = [[UILabel alloc]init];
        self.priceLabel.textColor = LX_MAIN_TEXT_COLOR;
        self.priceLabel.font = FONT_SYSTEM(17);
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        self.priceLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.priceLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(MARGIN);
            make.right.equalTo(superCell.right).offset(-MARGIN);
            make.bottom.equalTo(superCell.bottom).offset(-MARGIN);
            make.width.equalTo((ScreenWidth - 2 * MARGIN) / 2);
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
