//
//  LXStoreInfoResponseModel.h
//  LoveXiangsu
//
//  Created by yangjun on 15/11/2.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXStoreImageResponseModel.h"
#import "NSObject+BeeJSON.h"
#import "NSDictionary+BeeExtension.h"

@interface LXStoreInfoResponseModel : NSObject

@property (nonatomic, strong) NSString * newid;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * lng;
@property (nonatomic, strong) NSString * lat;

@property (nonatomic, strong) NSString * phone1;
@property (nonatomic, strong) NSString * grade;
@property (nonatomic, strong) NSString * name;

@property (nonatomic, strong) NSArray  * images;

@property (nonatomic, strong) NSString * recommend;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * description;
@property (nonatomic, strong) NSString * begin_at;
@property (nonatomic, strong) NSString * finish_at;
@property (nonatomic, strong) NSString * distance;
@property (nonatomic, strong) NSString * tags;
@property (nonatomic, strong) NSString * thumbnail;
@property (nonatomic, strong) NSString * call_times;
@property (nonatomic, strong) NSString * distanceM;

@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * cer_v;
@property (nonatomic, strong) NSString * online;
@property (nonatomic, strong) NSString * geohash;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * contact;
@property (nonatomic, strong) NSString * phone2;
@property (nonatomic, strong) NSString * updateUser_id;

@end
