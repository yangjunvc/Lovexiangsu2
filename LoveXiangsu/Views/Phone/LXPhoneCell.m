//
//  LXPhoneCell.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/14.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXPhoneCell.h"
#import "LXUICommon.h"
#import "UILabel+VerticalAlign.h"

@implementation LXPhoneCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        LXPhoneCell *superCell = self;
        //        self.layer.borderColor = [[UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0] CGColor];
        //        self.layer.borderWidth = 1;

        self.callingImg = [[UIImageView alloc]init];
        self.callingImg.layer.borderColor = LX_DEBUG_COLOR;
        self.callingImg.layer.borderWidth = 1;
        [self addSubview:self.callingImg];
        [self.callingImg makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superCell.right).offset(-MARGIN);
            make.centerY.equalTo(superCell.centerY);
            make.width.height.equalTo(CallingImgSize);
        }];

        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.numberOfLines = 2;
        self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.nameLabel.font = LX_TEXTSIZE_16;
        self.nameLabel.textColor = LX_MAIN_TEXT_COLOR;
        self.nameLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.nameLabel.layer.borderWidth = 1;
        [self addSubview:self.nameLabel];
        [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(MARGIN);
            make.right.equalTo(self.callingImg.left).offset(-MARGIN);
            make.bottom.equalTo(superCell.bottom).offset(-MARGIN);
            //            make.height.greaterThanOrEqualTo(MARGIN);
            make.height.equalTo(MARGIN * 2.5);
        }];

        self.callingView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.callingView.layer.borderColor = LX_DEBUG_COLOR;
        self.callingView.layer.borderWidth = 1;
        [self addSubview:self.callingView];
        [self.callingView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superCell.top);
            make.right.equalTo(superCell.right);
            make.bottom.equalTo(superCell.bottom);
            make.left.equalTo(self.callingImg.left);
        }];

        self.cellSeparator = [[UIView alloc]init];
        // [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0]
        self.cellSeparator.layer.borderColor = [LX_THIRD_TEXT_COLOR CGColor];
        self.cellSeparator.layer.borderWidth = BorderWidth05;
        [self addSubview:self.cellSeparator];
        [self.cellSeparator makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superCell.left).offset(0);
            make.right.equalTo(superCell.right).offset(0);
            make.bottom.equalTo(superCell.bottom).offset(0);
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

    if ([self.nameLabel.text hasSuffix:@"\n "]) {
        NSLog(@"电话名称：%@，无需再次处理~~~~~", self.nameLabel.text);
        return;
    }
    NSLog(@"(Before)nameLabel = %@!!!!!", self.nameLabel.text);
    double finalWidth = ScreenWidth - MARGIN * 2 - CallingImgSize - MARGIN;
    double realHeight = [self.nameLabel alignTop:finalWidth];
    NSLog(@"(After )nameLabel = %@!!!!!", self.nameLabel.text);
    NSLog(@"realHeight = %f!!!!!", realHeight);
//    [self.nameLabel updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(realHeight + 0.5);
//    }];
}

@end
