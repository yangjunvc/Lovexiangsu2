//
//  LXNewsInfoResponseModel.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/3.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+BeeJSON.h"

@interface LXNewsInfoResponseModel : NSObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * online;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * type_id;

@end
