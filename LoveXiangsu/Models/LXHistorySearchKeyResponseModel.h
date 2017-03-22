//
//  LXHistorySearchKeyResponseModel.h
//  LoveXiangsu
//
//  Created by yangjun on 16/1/9.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+BeeJSON.h"
#import "NSDictionary+BeeExtension.h"

@interface LXHistorySearchKeyResponseModel : NSObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * offset;
@property (nonatomic, strong) NSString * num;
@property (nonatomic, strong) NSString * order_id;
@property (nonatomic, strong) NSString * tag;
@property (nonatomic, strong) NSString * keyword;
@property (nonatomic, strong) NSString * mid;
@property (nonatomic, strong) NSString * lng;
@property (nonatomic, strong) NSString * lat;
@property (nonatomic, strong) NSString * community_id;
@property (nonatomic, strong) NSString * created_at;

@end
