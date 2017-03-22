//
//  LXGetTopicDetailResponseModel.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/28.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXGetTopicImageResponseModel.h"
#import "NSObject+BeeJSON.h"
#import "NSDictionary+BeeExtension.h"

@interface LXGetTopicDetailResponseModel : NSObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * forum_id;
@property (nonatomic, strong) NSString * user_id;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSArray  * images;
@property (nonatomic, strong) NSString * top;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * top_all;
@property (nonatomic, strong) NSString * icon_url;
@property (nonatomic, strong) NSString * nickname;

@end
