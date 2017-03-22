//
//  LXStoreAddArticleRequest.m
//  LoveXiangsu
//
//  Created by 张婷 on 16/2/29.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreAddArticleRequest.h"
#import "NSDictionary+BeeExtension.h"

@implementation LXStoreAddArticleRequest

-(id)init{
    self = [super init];
    if (self) {
        self.baseUrl    = HTTP_BASEURL;
        self.requestUrl = REQUESTURL_STOREADDGOODS;
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
