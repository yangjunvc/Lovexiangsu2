//
//  LXMainMenuHeaderView.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/10/21.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXMainMenuHeaderView.h"
#import "LXUICommon.h"

@interface LXMainMenuHeaderView()

@end

@implementation LXMainMenuHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        LXMainMenuHeaderView *superView = self;

        self.headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.headBtn];
        [self.headBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(MARGIN * 2);
            make.width.height.equalTo(62);
        }];

        self.nickNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nickNameBtn.titleLabel.font = LX_TEXTSIZE_16;
        self.nickNameBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.nickNameBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.nickNameBtn.layer.borderColor = LX_DEBUG_COLOR;
        self.nickNameBtn.layer.borderWidth = 1;
        [self addSubview:self.nickNameBtn];
        [self.nickNameBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.headBtn.centerX);
            make.top.equalTo(superView.headBtn.bottom).offset(PADDING);
            make.width.equalTo(92);
        }];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];

    self.headBtn.layer.cornerRadius = CGRectGetWidth(self.headBtn.frame)/2.0;
    self.headBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headBtn.layer.borderWidth = 1;
    
    self.headBtn.clipsToBounds = YES;
}

@end
