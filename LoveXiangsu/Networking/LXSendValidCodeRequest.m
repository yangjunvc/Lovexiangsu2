//
//  LXSendValidCodeRequest.m
//  LoveXiangsu
//
//  Created by yangjun on 15/10/31.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXSendValidCodeRequest.h"

@implementation LXSendValidCodeRequest

-(id)init{
    self = [super init];
    if (self) {
        self.baseUrl    = HTTP_BASEURL;
        self.requestUrl = REQUESTURL_SENTVALIDCODE;
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
