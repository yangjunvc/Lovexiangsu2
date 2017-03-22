//
//  Utils.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/14.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

/**
 * 根据字体和宽度，计算字符串内容最终到底是几行的高度
 */
+(double)calcLabelHeight:(NSString *)text withFont:(UIFont *)font withWidth:(CGFloat)width numberOfLines:(int)num;

/**
 * 根据字体和宽度，计算字符串内容最终到底是几行的高度
 */
+(CGSize)calcLabelHeight:(NSString *)text withFont:(UIFont *)font withWidth:(CGFloat)width;

/**
 * 根据字体和宽度，计算字符串内容最终到底需要几行显示
 */
+(int)calcLabelRowNum:(NSString *)text withFont:(UIFont *)font withWidth:(CGFloat)width numberOfLines:(int)num;

/**
 * 根据字体和宽度，计算字符串内容最终到底需要几行显示
 */
+(int)calcLabelRowNum:(NSString *)text withFont:(UIFont *)font withWidth:(CGFloat)width;

/**
 * 根据上下限值，生成随机数
 */
+(int)getRandomNumber:(int)from to:(int)to;

@end
