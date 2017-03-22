//
//  NSString+Custom.h
//  LoveXiangsu
//
//  Created by yangjun on 15/11/1.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Custom)

// JSON字符串转成Dict
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

// 字典或数组转JSON
+ (NSString *)toJSONData:(id)theData;

// 判断是不是全空格字符串
+ (BOOL)isBlankString:(NSString *)string;

// 对字符串进行URL编码
- (NSString *)URLEncodedString;

// 找出店铺可以显示的标签
- (NSArray *)getShowTags;

// 分析店铺标签
- (NSArray *)analyzeStoreTags;

// 判断是否包含字符串
- (BOOL)customContainsString:(NSString*)other;

// 返回文本行数
- (NSUInteger)numberOfLines;

@end
