//
//  UIImageView+Resize.m
//  LoveXiangsu
//
//  Created by yangjun on 15/12/27.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "UIImageView+Resize.h"
#import "LXUICommon.h"

#import <objc/runtime.h>

static const void *autoresizeKey = (void *)@"AutoresizeKey";

@implementation UIImageView (Resize)

-(void)setAutoresize:(BOOL)autoresize
{
    objc_setAssociatedObject(self, autoresizeKey, @(autoresize), OBJC_ASSOCIATION_ASSIGN);
    if (autoresize) {
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    } else {
        [self removeObserver:self forKeyPath:@"image" context:nil];
    }
}

-(BOOL)autoresize
{
    return objc_getAssociatedObject(self, autoresizeKey);
}

-(void)dealloc
{
    if (self.autoresize) {
        [self setAutoresize:NO];
    }
}

#pragma mark - KVO for image field

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"image"]) {
        if (change && change[@"old"] && change[@"new"]) {
            UIImage * new = change[@"new"];

            CGFloat imageBoardViewWidth = ScreenWidth - 2 * MARGIN;
            CGFloat imageViewSize = imageBoardViewWidth / 3;

            if (new && ![new isKindOfClass:[NSNull class]]) {
                NSLog(@"UIImage有内容了！");
                [self updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(imageViewSize);
                }];
            } else {
                NSLog(@"UIImage变成空的了！");
                [self updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(0);
                }];
            }
        }
    }
}

@end
