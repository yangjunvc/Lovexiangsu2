//
//  LXTabbarBtn.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/10/24.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXTabbarBtn.h"
#import "LXUICommon.h"

@implementation LXTabbarBtn

- (instancetype)init
{
    self = [LXTabbarBtn buttonWithType:UIButtonTypeCustom];
    if (self) {
        self.showBgImg = [[UIImageView alloc]init];
        self.tabBarTitle = [[UILabel alloc]init];

        [self.showBgImg setFrame:CGRectMake((self.frame.size.width-24)/2.0, TabBarIconTopMargin, TabBarIconSize, TabBarIconSize)];
        [self.tabBarTitle setFrame:CGRectMake(0, 33, self.frame.size.width, TabBarTitleHeight)];
        [self.tabBarTitle setTextAlignment:NSTextAlignmentCenter];
        [self.tabBarTitle setFont:LX_TEXTSIZE_BOLD_12];

        [self.showBgImg setCenter:self.center];

        [self addSubview:self.showBgImg];
        [self addSubview:self.tabBarTitle];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)setShowBgImg:(NSString *)normalBgImg SelectedImg:(NSString *)selectedBgImg forState:(BOOL)selected{
    if (!selected) {
        [self.showBgImg setImage:[UIImage imageNamed:normalBgImg]];
        [self.tabBarTitle setTextColor:LX_SECOND_TEXT_COLOR];
    }
    if (selected) {
        [self.showBgImg setImage:[UIImage imageNamed:selectedBgImg]];
        [self.tabBarTitle setTextColor:LX_PRIMARY_COLOR_DARK];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
