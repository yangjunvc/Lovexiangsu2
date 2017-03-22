//
//  LXGetChatGroupOccupantsRequest.m
//  LoveXiangsu
//
//  Created by yangjun on 15/12/11.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXGetChatGroupOccupantsRequest.h"
#import "LXGetChatGroupOccupantsResponseModel.h"
#import "NSDictionary+BeeExtension.h"

@implementation LXGetChatGroupOccupantsRequest

-(id)init{
    self = [super init];
    if (self) {
        self.baseUrl    = HTTP_BASEURL;
        self.requestUrl = REQUESTURL_GETHEADBYPHONE;
    }
    return self;
}

-(void)handleResponse:(LXBaseRequest*)request{
    NSError* responseError = nil;
    NSError* headerError = [super handleResponseHeader:request];
    if (!headerError) {
        NSDictionary* responseDictionary = request.requestOperation.responseObject;
        NSDictionary* contentDic = [responseDictionary dictAtPath:@"data"];
        LXGetChatGroupOccupantsResponseModel * responseModel = [LXGetChatGroupOccupantsResponseModel objectFromDictionary:contentDic];
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
