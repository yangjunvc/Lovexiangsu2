//
//  LXArticleInfoResponseModel.h
//  LoveXiangsu
//
//  Created by yangjun on 16/2/29.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+BeeJSON.h"
#import "NSDictionary+BeeExtension.h"

@interface LXArticleInfoResponseModel : NSObject

@property (nonatomic, strong) NSString    * id;
@property (nonatomic, strong) NSString    * store_id;
@property (nonatomic, strong) NSString    * name;
@property (nonatomic, strong) NSString    * price;
@property (nonatomic, strong) NSString    * description;
@property (nonatomic, strong) NSString    * created_at;
@property (nonatomic, strong) NSString    * online;
@property (nonatomic, strong) NSString    * order_id;

@end
