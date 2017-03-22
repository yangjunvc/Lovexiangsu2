//
//  LXMyStoresRequest.m
//  LoveXiangsu
//
//  Created by yangjun on 16/3/4.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXMyStoresRequest.h"
#import "LXStoreInfoResponseModel.h"
#import "NSDictionary+BeeExtension.h"

@implementation LXMyStoresRequest

-(id)init{
    self = [super init];
    if (self) {
        self.baseUrl    = HTTP_BASEURL;
        self.requestUrl = REQUESTURL_MYSTORES;
    }
    return self;
}

-(void)handleResponse:(LXBaseRequest*)request{
    NSError* responseError = nil;
    NSError* headerError = [super handleResponseHeader:request];
    if (!headerError) {
        NSMutableArray * contentArr = [[NSMutableArray alloc] init];
        NSDictionary* responseDictionary = request.requestOperation.responseObject;
        NSArray* contentArray = [responseDictionary arrayAtPath:@"data"];
        for (int i=0; i<contentArray.count;i++) {
            NSDictionary* contentItemDic = [contentArray objectAtIndex:i];
            LXStoreInfoResponseModel* contentmodel = [LXStoreInfoResponseModel objectFromDictionary:contentItemDic];
            [contentArr addObject:contentmodel];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestResult:withData:responseData:)]) {
            [self.delegate requestResult:responseError withData:contentArr responseData:request];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestResult:withData:responseData:)]) {
            [self.delegate requestResult:headerError withData:nil responseData:request];
        }
    }
}

@end
