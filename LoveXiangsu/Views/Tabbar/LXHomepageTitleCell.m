//
//  LXHomepageTitleCell.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/8.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXHomepageTitleCell.h"
#import "LXUICommon.h"

@implementation LXHomepageTitleCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        LXHomepageTitleCell *superCell = self;

        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = LX_TEXTSIZE_14;
        [self addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(PADDING);
            make.bottom.equalTo(-PADDING);
            make.width.equalTo(NoticeTxtWidth);
        }];

        self.moreStoresBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.moreStoresBtn.titleLabel.font = LX_TEXTSIZE_14;
        self.moreStoresBtn.tintColor = LX_THIRD_TEXT_COLOR;
        [self addSubview:self.moreStoresBtn];
        [self.moreStoresBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superCell.right).offset(-PADDING);
            make.top.equalTo(superCell.top);
            make.bottom.equalTo(superCell.bottom);
            make.width.equalTo(MoreStoresBtnWidth - 3);
        }];

        self.cellSeparator = [[UIView alloc]init];
        // [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0]
        self.cellSeparator.layer.borderColor = [LX_THIRD_TEXT_COLOR CGColor];
        self.cellSeparator.layer.borderWidth = BorderWidth05;
        [self addSubview:self.cellSeparator];
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

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
