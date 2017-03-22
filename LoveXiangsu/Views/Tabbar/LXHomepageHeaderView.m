//
//  LXHomepageHeaderView.m
//  LoveXiangsu
//
//  Created by yangjun on 15/11/2.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXHomepageHeaderView.h"
#import "LXUICommon.h"
#import "UILabel+VerticalAlign.h"

@implementation LXHomepageHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        LXHomepageHeaderView *superView = self;

        self.trumpetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.trumpetBtn.layer.borderColor = LX_DEBUG_COLOR;
        self.trumpetBtn.layer.borderWidth = 1;
        [self addSubview:self.trumpetBtn];
        [self.trumpetBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.centerY.equalTo(superView.centerY);
            make.width.height.equalTo(TrumpetImgSize);
        }];

        self.moreNewsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.moreNewsBtn.titleLabel.font = LX_TEXTSIZE_14;
        self.moreNewsBtn.layer.borderColor = LX_DEBUG_COLOR;
        self.moreNewsBtn.layer.borderWidth = 1;
        [self addSubview:self.moreNewsBtn];
        [self.moreNewsBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView.right);
            make.top.equalTo(superView.top).offset(PADDING);
            make.bottom.equalTo(superView.bottom).offset(-PADDING);
            make.width.equalTo(MoreNewsBtnWidth);
        }];

        UIView *separator = [[UIView alloc]init];
        // [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0]
        separator.layer.borderColor = [LX_THIRD_TEXT_COLOR CGColor];
        separator.layer.borderWidth = BorderWidth05;
        [self addSubview:separator];
        [separator makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.moreNewsBtn.left).offset(-BorderWidth05);
            make.top.equalTo(superView.top);
            make.bottom.equalTo(superView.bottom);
            make.width.equalTo(BorderWidth05);
        }];

        self.newsLabel = [[UILabel alloc]init];
        self.newsLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.newsLabel.layer.borderWidth = 1;
        [self addSubview:self.newsLabel];
        [self.newsLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.trumpetBtn.right).offset(PADDING);
            make.top.equalTo(superView.top).offset(PADDING);
            make.bottom.equalTo(superView.bottom).offset(-PADDING);
            make.right.equalTo(separator.left).offset(-MARGIN);
        }];

        UIView *cellSeparator = [[UIView alloc]init];
        // [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0]
        cellSeparator.layer.borderColor = [LX_THIRD_TEXT_COLOR CGColor];
        cellSeparator.layer.borderWidth = BorderWidth05;
        [self addSubview:cellSeparator];
        [cellSeparator makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left);
            make.right.equalTo(superView.right);
            make.bottom.equalTo(superView.bottom);
            make.height.equalTo(BorderWidth05);
            make.width.equalTo(ScreenWidth);
        }];
    }

    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)updateConstraints
{
    [super updateConstraints];

    [self.newsLabel updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.newsLabelRealHeight);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
