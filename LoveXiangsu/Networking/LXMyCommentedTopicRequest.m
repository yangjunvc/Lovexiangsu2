//
//  LXMyCommentedTopicRequest.m
//  LoveXiangsu
//
//  Created by yangjun on 16/1/5.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXMyCommentedTopicRequest.h"
#import "LXForumInfoResponseModel.h"
#import "NSDictionary+BeeExtension.h"

@implementation LXMyCommentedTopicRequest

-(id)init{
    self = [super init];
    if (self) {
        self.baseUrl    = HTTP_BASEURL;
        self.requestUrl = REQUESTURL_MYCOMMENTEDTOPIC;
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
            LXForumInfoResponseModel * contentmodel = [LXForumInfoResponseModel objectFromDictionary:contentItemDic];
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
