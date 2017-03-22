//
//  LXStoreReplyCommentRequest.m
//  LoveXiangsu
//
//  Created by yangjun on 16/3/4.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreReplyCommentRequest.h"

@implementation LXStoreReplyCommentRequest

-(id)init{
    self = [super init];
    if (self) {
        self.baseUrl    = HTTP_BASEURL;
        self.requestUrl = REQUESTURL_STOREREPLYCOMMENT;
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
