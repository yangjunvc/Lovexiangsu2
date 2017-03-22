//
//  LXUserGetProfileRequest.m
//  LoveXiangsu
//
//  Created by yangjun on 16/1/10.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXUserGetProfileRequest.h"
#import "LXLoginResponseModel.h"
#import "NSDictionary+BeeExtension.h"

@implementation LXUserGetProfileRequest

-(id)init{
    self = [super init];
    if (self) {
        self.baseUrl    = HTTP_BASEURL;
        self.requestUrl = REQUESTURL_USERPROFILE;
    }
    return self;
}

-(void)handleResponse:(LXBaseRequest*)request{
    NSError* responseError = nil;
    NSError* headerError = [super handleResponseHeader:request];
    if (!headerError) {
        NSDictionary* responseDictionary = request.requestOperation.responseObject;
        NSDictionary* contentDic = [responseDictionary dictAtPath:@"data"];
        LXLoginResponseModel* responseModel = [LXLoginResponseModel objectFromDictionary:contentDic];
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
