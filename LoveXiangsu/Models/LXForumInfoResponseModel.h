//
//  LXForumInfoResponseModel.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/26.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+BeeJSON.h"

@interface LXForumInfoResponseModel : NSObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * forum_id;
@property (nonatomic, strong) NSString * user_id;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * top;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * top_all;
@property (nonatomic, strong) NSString * forum_name;
@property (nonatomic, strong) NSString * thumbnail;
@property (nonatomic, strong) NSString * original;
@property (nonatomic, strong) NSString * update;
@property (nonatomic, strong) NSString * reply;

@end
