//
//  VertifyInputFormat.h
//  LoveXiangsu
//
//  Created by yangjun on 15/10/31.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VertifyInputFormat : NSObject

// 校验空串
+ (BOOL)isEmpty:(NSString*)string;

// 校验纯整形
+ (BOOL)isPureInt:(NSString*)string;

// 校验手机号
+ (BOOL)isPhoneNum:(NSString*)string;

@end
