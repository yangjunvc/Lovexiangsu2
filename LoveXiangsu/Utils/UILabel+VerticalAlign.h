//
//  UILabel+VerticalAlign.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/7.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (VerticalAlign)

-(double)getFittingWidth;
-(double)alignTop:(double)width;
-(double)alignBottom:(double)width;

@end
