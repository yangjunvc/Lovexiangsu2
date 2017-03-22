//
//  LXCommentInfoResponseModel.h
//  LoveXiangsu
//
//  Created by yangjun on 16/3/3.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+BeeJSON.h"
#import "NSDictionary+BeeExtension.h"

@interface LXCommentInfoResponseModel : NSObject

@property (nonatomic, strong) NSString    * id;
@property (nonatomic, strong) NSString    * store_id;
@property (nonatomic, strong) NSString    * user_id;
@property (nonatomic, strong) NSString    * comment;
@property (nonatomic, strong) NSString    * created_at;
@property (nonatomic, strong) NSString    * reply;
@property (nonatomic, strong) NSString    * reply_at;
@property (nonatomic, strong) NSString    * owner_id;
@property (nonatomic, strong) NSString    * nickname;

@end
