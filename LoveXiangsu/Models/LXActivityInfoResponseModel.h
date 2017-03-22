//
//  LXActivityInfoResponseModel.h
//  LoveXiangsu
//
//  Created by yangjun on 16/2/20.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXStoreImageResponseModel.h"
#import "NSObject+BeeJSON.h"
#import "NSDictionary+BeeExtension.h"

@interface LXActivityInfoResponseModel : NSObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * store_id;

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * description;

@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * begin_at;
@property (nonatomic, strong) NSString * finish_at;
@property (nonatomic, strong) NSString * online;

@property (nonatomic, strong) NSArray  * images;

@property (nonatomic, strong) NSString * thumbnail;

@property (nonatomic, strong) NSString * expired;

@end
