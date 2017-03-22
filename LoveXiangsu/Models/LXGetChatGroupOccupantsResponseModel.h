//
//  LXGetChatGroupOccupantsResponseModel.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/12/10.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+BeeJSON.h"

@interface LXGetChatGroupOccupantsResponseModel : NSObject

@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * icon_url;
@property (nonatomic, assign) NSTimeInterval updatetime;

@end
