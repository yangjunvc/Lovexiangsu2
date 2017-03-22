//
//  Utils.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/14.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "Utils.h"
#import "NSString+Custom.h"

@implementation Utils

/**
 * 根据字体和宽度，计算字符串内容最终到底是几行的高度
 */
+(double)calcLabelHeight:(NSString *)text withFont:(UIFont *)font withWidth:(CGFloat)width numberOfLines:(int)num
{
    NSString *txt = text;
    if ([text customContainsString:@"\r"]) {
        if ([text customContainsString:@"\r\n"]) {
            txt = [text stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n"];
        } else {
            txt = [text stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r"];
        }
    } else if ([text customContainsString:@"\n"]) {
        txt = [text stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n"];
    }

    CGSize fontSize = [txt sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGRect theStringSize = [txt boundingRectWithSize:CGSizeMake(width, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    int numberOfLines = round(theStringSize.size.height / fontSize.height);
    if (numberOfLines > num) {
        numberOfLines = num;
    }
    //    else {
    //        numberOfLines = 1;
    //    }
    return ((double)numberOfLines) * fontSize.height;
}

/**
 * 根据字体和宽度，计算字符串内容最终到底是几行的高度
 */
+(CGSize)calcLabelHeight:(NSString *)text withFont:(UIFont *)font withWidth:(CGFloat)width
{
    NSString *txt = text;
    if ([text customContainsString:@"\r"]) {
        if ([text customContainsString:@"\r\n"]) {
            txt = [text stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n"];
        } else {
            txt = [text stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r"];
        }
    } else if ([text customContainsString:@"\n"]) {
        txt = [text stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n"];
    }
    
//    CGSize fontSize = [txt sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGRect theStringSize = [txt boundingRectWithSize:CGSizeMake(width, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
//    if (theStringSize.size.width < round(width)) {
//        CGSize realSize = [txt sizeWithFont:font constrainedToSize:CGSizeMake(round(width), 100000) lineBreakMode:NSLineBreakByCharWrapping];
//        return realSize.height;
//    }
    return CGSizeMake(theStringSize.size.width, theStringSize.size.height);
}

/**
 * 根据字体和宽度，计算字符串内容最终到底需要几行显示
 */
+(int)calcLabelRowNum:(NSString *)text withFont:(UIFont *)font withWidth:(CGFloat)width numberOfLines:(int)num
{
    NSString *txt = text;
    if ([text customContainsString:@"\r"]) {
        if ([text customContainsString:@"\r\n"]) {
            txt = [text stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n"];
        } else {
            txt = [text stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r"];
        }
    } else if ([text customContainsString:@"\n"]) {
        txt = [text stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n"];
    }

    CGSize fontSize = [txt sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGRect theStringSize = [txt boundingRectWithSize:CGSizeMake(width, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    int numberOfLines = round(theStringSize.size.height / fontSize.height);
    if (numberOfLines > num) {
        numberOfLines = num;
    }
    //    else {
    //        numberOfLines = 1;
    //    }
    return numberOfLines;
}

/**
 * 根据字体和宽度，计算字符串内容最终到底需要几行显示
 */
+(int)calcLabelRowNum:(NSString *)text withFont:(UIFont *)font withWidth:(CGFloat)width
{
    NSString *txt = text;
    if ([text customContainsString:@"\r"]) {
        if ([text customContainsString:@"\r\n"]) {
            txt = [text stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n"];
        } else {
            txt = [text stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r"];
        }
    } else if ([text customContainsString:@"\n"]) {
        txt = [text stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n"];
    }
    
    CGSize fontSize = [txt sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGRect theStringSize = [txt boundingRectWithSize:CGSizeMake(width, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    int numberOfLines = round(theStringSize.size.height / fontSize.height);
    return numberOfLines;
}

/**
 * 根据上下限值，生成随机数
 */
+(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

@end
