//
//  LXTextField.m
//  LoveXiangsu
//
//  Created by yangjun on 16/2/21.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXTextField.h"

@implementation LXTextField

- (id)init
{
    self = [super init];
    if (self) {
        self.canPaste = YES;
        self.canSelect = YES;
        self.showMenu = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.canPaste = YES;
        self.canSelect = YES;
        self.showMenu = YES;
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:) && self.canPaste == NO)
        return NO;
    if (action == @selector(select:) && self.canSelect == NO)
        return NO;
    if (action == @selector(selectAll:) && self.canSelect == NO)
        return NO;
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController && self.showMenu == NO) {
        [UIMenuController sharedMenuController].menuVisible = NO;
        return NO;
    }

    return [super canPerformAction:action withSender:sender];
}

@end
