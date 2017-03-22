//
//  UILabel+VerticalAlign.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/7.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "UILabel+VerticalAlign.h"
#import "LXUICommon.h"
#import "NSString+Custom.h"

@implementation UILabel (VerticalAlign)

-(double)getFittingWidth
{
    CGSize fontSize = [self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil]];
    return round(fontSize.width);
}

-(double)alignTop:(double)width
{
    NSString *txt = self.text;
    if ([self.text customContainsString:@"\r"]) {
        if ([self.text customContainsString:@"\r\n"]) {
            txt = [self.text stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n"];
        } else {
            txt = [self.text stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r"];
        }
    } else if ([self.text customContainsString:@"\n"]) {
        txt = [self.text stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n"];
    }

    CGSize fontSize = [txt sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil]];
    if (fontSize.height >= 20) {
        fontSize = [@"爱小区" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil]];
    }
    double finalHeight = fontSize.height * self.numberOfLines;
//    double finalWidth = self.frame.size.width;
//    CGSize theStringSize =[self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    CGRect theStringSize = [txt boundingRectWithSize:CGSizeMake(width, finalHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil] context:nil];
    int newLinesToPad = round((finalHeight - theStringSize.size.height) / fontSize.height);
    for (int i = 0; i < newLinesToPad; i++)
        self.text = [self.text stringByAppendingString:@"\n \n "];
    return finalHeight;
}

-(double)alignBottom:(double)width
{
    NSString *txt = self.text;
    if ([self.text customContainsString:@"\r"]) {
        if ([self.text customContainsString:@"\r\n"]) {
            txt = [self.text stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n"];
        } else {
            txt = [self.text stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r\\r"];
        }
    } else if ([self.text customContainsString:@"\n"]) {
        txt = [self.text stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n"];
    }

    CGSize fontSize = [txt sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil]];
    if (fontSize.height >= 20) {
        fontSize = [@"爱小区" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil]];
    }
    double finalHeight = fontSize.height * self.numberOfLines;
//    double finalWidth = self.frame.size.width;
//    double finalWidth = ScreenWidth - MARGIN * 2 - StoreImgWidth - PADDING - CallingImgSize - MARGIN;
//    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    CGRect theStringSize = [txt boundingRectWithSize:CGSizeMake(width, finalHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil] context:nil];
    int newLinesToPad = (finalHeight - theStringSize.size.height) / fontSize.height;
    for (int i = 0; i < newLinesToPad; i++)
        self.text = [NSString stringWithFormat:@" \n%@", self.text];
    return finalHeight;
}

@end
