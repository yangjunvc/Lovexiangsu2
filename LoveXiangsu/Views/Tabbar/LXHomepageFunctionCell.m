//
//  LXHomepageFunctionCell.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/8.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXHomepageFunctionCell.h"
#import "LXUICommon.h"

@implementation LXHomepageFunctionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        LXHomepageFunctionCell *superCell = self;

        self.noticeImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.noticeImgBtn];
        [self.noticeImgBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(MARGIN);
            make.bottom.equalTo(-MARGIN);
            make.width.height.equalTo(NoticeImgSize);
        }];

        self.noticeTxtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.noticeTxtBtn.titleLabel.font = LX_TEXTSIZE_16;
        self.noticeTxtBtn.tintColor = LX_SECOND_TEXT_COLOR;
        [self addSubview:self.noticeTxtBtn];
        [self.noticeTxtBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.noticeImgBtn.right);
            make.centerY.equalTo(self.noticeImgBtn.centerY);
            make.width.equalTo(NoticeTxtWidth);
            make.height.equalTo(35);
        }];

        self.phoneImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.phoneImgBtn];
        [self.phoneImgBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superCell.centerX);
            make.top.equalTo(MARGIN);
            make.bottom.equalTo(-MARGIN);
            make.width.height.equalTo(PhoneImgSize);
        }];

        self.phoneTxtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.phoneTxtBtn.titleLabel.font = LX_TEXTSIZE_16;
        self.phoneTxtBtn.tintColor = LX_SECOND_TEXT_COLOR;
        [self addSubview:self.phoneTxtBtn];
        [self.phoneTxtBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.phoneImgBtn.right);
            make.centerY.equalTo(self.phoneImgBtn.centerY);
            make.width.equalTo(PhoneTxtWidth);
            make.height.equalTo(35);
        }];

        UIView *cellSeparator = [[UIView alloc]init];
        // [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0]
        cellSeparator.layer.borderColor = [LX_THIRD_TEXT_COLOR CGColor];
        cellSeparator.layer.borderWidth = BorderWidth05;
        [self addSubview:cellSeparator];
        [cellSeparator makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superCell.left);
            make.right.equalTo(superCell.right);
            make.bottom.equalTo(superCell.bottom);
            make.height.equalTo(BorderWidth05);
            make.width.equalTo(ScreenWidth);
        }];
    }

    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
