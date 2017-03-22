//
//  LXStoreModifyServiceRequest.m
//  LoveXiangsu
//
//  Created by yangjun on 16/3/2.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreModifyServiceRequest.h"

@implementation LXStoreModifyServiceRequest

-(id)init{
    self = [super init];
    if (self) {
        self.baseUrl    = HTTP_BASEURL;
        self.requestUrl = REQUESTURL_STOREEDITSERVICE;
    }
    return self;
}

-(void)handleResponse:(LXBaseRequest*)request{
    NSError* headerError = [super handleResponseHeader:request];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestResult:withData:responseData:)]) {
        [self.delegate requestResult:headerError withData:nil responseData:request];
    }
}

@end
