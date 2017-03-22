//
//  LXStoreListByTagRequest.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/9.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreListByTagRequest.h"
#import "LXStoreInfoResponseModel.h"
#import "NSDictionary+BeeExtension.h"

@implementation LXStoreListByTagRequest

-(id)init{
    self = [super init];
    if (self) {
        self.baseUrl    = HTTP_BASEURL;
        self.requestUrl = REQUESTURL_STORELISTBYTAG;
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
