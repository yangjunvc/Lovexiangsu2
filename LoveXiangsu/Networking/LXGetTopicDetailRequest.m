//
//  LXGetTopicDetailRequest.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/28.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXGetTopicDetailRequest.h"
#import "LXGetTopicDetailResponseModel.h"
#import "NSDictionary+BeeExtension.h"

@implementation LXGetTopicDetailRequest

-(id)init{
    self = [super init];
    if (self) {
        self.baseUrl    = HTTP_BASEURL;
        self.requestUrl = REQUESTURL_GETTOPICDETAIL;
    }
    return self;
}

-(void)handleResponse:(LXBaseRequest*)request{
    NSError* responseError = nil;
    NSError* headerError = [super handleResponseHeader:request];
    if (!headerError) {
        NSDictionary* responseDictionary = request.requestOperation.responseObject;
        NSDictionary* contentDic = [responseDictionary dictAtPath:@"data"];
        LXGetTopicDetailResponseModel * responseModel = [LXGetTopicDetailResponseModel objectFromDictionary:contentDic];
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestResult:withData:responseData:)]) {
            [self.delegate requestResult:responseError withData:responseModel responseData:request];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestResult:withData:responseData:)]) {
            [self.delegate requestResult:headerError withData:nil responseData:request];
        }
    }
}

@end
