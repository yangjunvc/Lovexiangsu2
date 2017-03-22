//
//  NSString+Custom.m
//  LoveXiangsu
//
//  Created by yangjun on 15/11/1.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "NSString+Custom.h"
#import "VertifyInputFormat.h"

static NSDictionary *tagDict = nil;
static NSArray *tagArray = nil;

@implementation NSString (Custom)

// JSON字符串转成Dict
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (err) {
        NSLog(@"json字符串解析失败：%@",err);
        return nil;
    }
    return dic;
}

// 字典或数组转JSON
+ (NSString *)toJSONData:(id)theData
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
    } else {
        return nil;
    }
}

// 判断是不是全空格字符串
+ (BOOL)isBlankString:(NSString *)string{
    // nil为空
    if (string == nil) {
        return YES;
    }
    
    // NULL为空
    if (string == NULL) {
        return YES;
    }
    
    // NSNull则为空
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    // 去掉空格和换行后长度为0，则为空
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    
    return NO;
}

// 对字符串进行URL编码
- (NSString *)URLEncodedString
{
//    NSString *encodedString = (__bridge_transfer NSString *)
//    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                            (CFStringRef)self,
//                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
//                                            NULL,
//                                            kCFStringEncodingUTF8);
    static NSString * const kAFCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";
    NSString *encodedString = (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, (__bridge CFStringRef)kAFCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return encodedString;
}

// 找出店铺可以显示的标签
- (NSArray *)getShowTags
{
    if (tagDict == nil) {
        tagDict = @{
          @"外送"  :@"store_tag_d2d",
          @"优惠"  :@"store_tag_sale",
          @"24小时":@"store_tag_24",
          @"团购"  :@"store_tag_tuan",
          };
    }

    NSMutableArray * imgNames = [NSMutableArray array];
    NSArray *tags = [self componentsSeparatedByString:@" "];
    for (int i = (int)tags.count - 1; i >= 0; i --) {
        id tag = tags[i];
        if ([tag isKindOfClass:[NSString class]]) {
            NSString *imgName = tagDict[(NSString *)tag];
            if (![VertifyInputFormat isEmpty:imgName]) {
                [imgNames addObject:imgName];
            }
        }
    }
    return imgNames;
}

// 分析店铺标签
- (NSArray *)analyzeStoreTags
{
    if (tagArray == nil) {
        tagArray = @[
                    @"外送",
                    @"24小时",
                    ];
    }
    
    NSMutableArray * switchArray = [NSMutableArray array];
    NSArray *tags = [self componentsSeparatedByString:@" "];
    for (int i = (int)tags.count - 1; i >= 0; i --) {
        id tag = tags[i];
        if ([tag isKindOfClass:[NSString class]]) {
            NSUInteger index = [tagArray indexOfObject:(NSString *)tag];
            switch (index) {
                case 0:
                    [switchArray addObject:@"外送"];
                    break;
                case 1:
                    [switchArray addObject:@"24小时"];
                    break;
                default:
                    break;
            }
        }
    }
    return switchArray;
}

// 判断是否包含字符串
- (BOOL)customContainsString:(NSString*)other
{
    NSRange range = [self rangeOfString:other];
    return range.length != 0;
}

// 返回文本行数
- (NSUInteger)numberOfLines {
    return [[self componentsSeparatedByString:@"\n"] count] + 1;
}

@end
