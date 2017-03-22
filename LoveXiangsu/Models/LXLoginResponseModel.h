//
//  LXLoginResponseModel.h
//  LoveXiangsu
//
//  Created by yangjun on 15/11/1.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+BeeJSON.h"

@interface LXLoginResponseModel : NSObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * email;

@property (nonatomic, strong) NSString * sex;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * profession;

@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * updated_at;
@property (nonatomic, strong) NSString * ip;
@property (nonatomic, strong) NSString * ip_city;
@property (nonatomic, strong) NSString * cookie;
@property (nonatomic, strong) NSString * last_login;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * birthday;
@property (nonatomic, strong) NSString * online;

@property (nonatomic, strong) NSString * icon_url;
@property (nonatomic, strong) NSString * icon_full_url;

@end
