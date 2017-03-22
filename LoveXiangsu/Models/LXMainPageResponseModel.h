//
//  LXMainPageResponseModel.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/3.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXStoreInfoResponseModel.h"
#import "LXNewsInfoResponseModel.h"
#import "NSObject+BeeJSON.h"
#import "NSDictionary+BeeExtension.h"

@interface LXMainPageResponseModel : NSObject

@property (nonatomic, strong) NSArray * stores;
@property (nonatomic, strong) LXNewsInfoResponseModel * news;
@property (nonatomic, strong) NSArray * my_collects;

@end
