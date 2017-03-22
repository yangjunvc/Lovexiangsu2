//
//  LXStoreMenuCell.m
//  LoveXiangsu
//
//  Created by yangjun on 15/11/10.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreMenuCell.h"
#import "LXUICommon.h"

@interface LXStoreMenuCell()

@end

@implementation LXStoreMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        LXStoreMenuCell *superCell = self;

        UIView *frameView = [[UIView alloc]init];
        frameView.clipsToBounds = YES;
        [self addSubview:frameView];
        [frameView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(superCell.centerX);
            make.top.equalTo(superCell.top);
            make.width.height.equalTo(IconSize);
        }];

        self.contentImg = [[UIImageView alloc]init];
        [frameView addSubview:self.contentImg];
        [self.contentImg makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(frameView.centerX);
            make.centerY.equalTo(frameView.centerY);
            make.width.height.equalTo(IconSize);
        }];

        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.font = LX_TEXTSIZE_12;
        self.contentLabel.textColor = LX_SECOND_TEXT_COLOR;
        [self addSubview:self.contentLabel];
        [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentImg.bottom);
            make.centerX.equalTo(self.contentImg.centerX);
            make.left.equalTo(superCell.left);
            make.right.equalTo(superCell.right);
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
    if (selected) {
        if (self.isByHot) {
            self.isByHot = NO;
            self.contentImg.image = [UIImage imageNamed:@"main_store_tag_location_blue"];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromLeft;
            [self.contentImg.layer addAnimation:transition forKey:nil];
        } else {
            self.isByHot = YES;
            self.contentImg.image = [UIImage imageNamed:@"main_store_tag_hot_blue"];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromLeft;
            [self.contentImg.layer addAnimation:transition forKey:nil];
        }
        self.contentLabel.textColor = LX_PRIMARY_COLOR_DARK;
    } else {
        self.isByHot = NO;
        self.contentImg.image = self.origImg;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.contentImg.layer addAnimation:transition forKey:nil];
        self.contentLabel.textColor = LX_SECOND_TEXT_COLOR;
    }
}

@end
