//
//  VertifyInputFormat.m
//  LoveXiangsu
//
//  Created by yangjun on 15/10/31.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "VertifyInputFormat.h"

@implementation VertifyInputFormat

// 校验空串
+ (BOOL)isEmpty:(NSString*)string{
    if (string == nil || [string isEqualToString:@""]
        || [string isEqualToString:@"<null>"]
        || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

// 校验纯整形
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

// 校验手机号
+ (BOOL)isPhoneNum:(NSString*)string{
    if (![VertifyInputFormat isPureInt:string]
        || (string.length != 11)
        || ![[string substringToIndex:1] isEqualToString:@"1"]) {
        return NO;
    } else {
        return YES;
    }
}

@end
