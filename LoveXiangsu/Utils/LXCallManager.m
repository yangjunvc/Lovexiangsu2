//
//  LXCallManager.m
//  LoveXiangsu
//
//  Created by yangjun on 16/1/10.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXCallManager.h"
#import "LXPhoneSaveCallRecordRequest.h"

#import "LXUserDefaultManager.h"
#import "VertifyInputFormat.h"
#import "LXNetManager.h"

#import "FCUUID.h"

@implementation LXCallManager

+ (LXCallManager *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

-(void)asyncSaveCallRecordWithStoreId:(NSString *)store_id phonebookId:(NSString *)phonebook_id
{
    LXPhoneSaveCallRecordRequest * request = [[LXPhoneSaveCallRecordRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识

    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:[FCUUID uuidForDevice]                  forKey:@"IMEI"];
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        [paraDic setObject:[LXUserDefaultManager getUserPhone]     forKey:@"phone"];
        [paraDic setObject:[LXUserDefaultManager getUserID]        forKey:@"user_id"];
    }
    if (store_id) {
        [paraDic setObject:store_id                            forKey:@"store_id"];
    } else if (phonebook_id) {
        [paraDic setObject:phonebook_id                        forKey:@"phonebook_id"];
    }
    [request setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

// 网络请求回调
-(void)requestResult:(NSError*) error withData:(id)responseObject responseData:(LXBaseRequest*)requestData
{
    if (requestData.tag == 1000) {
        if (error) {
            //对error进行相应的处理
            NSLog(@"%@",[[error userInfo] objectForKey:@"NSLocalizedDescription"]);
            return;
        }
        
        // 成功时有时也会有成功Message
        if (![VertifyInputFormat isEmpty:requestData.successMsg]) {
            NSLog(@"%@",requestData.successMsg);
        }
    }

    return;
}

@end
