//
//  LXForumListByForumIdRequest.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/26.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXForumListByForumIdRequest.h"
#import "LXForumInfoResponseModel.h"
#import "NSDictionary+BeeExtension.h"

@implementation LXForumListByForumIdRequest

-(id)init{
    self = [super init];
    if (self) {
        self.baseUrl    = HTTP_BASEURL;
        self.requestUrl = REQUESTURL_FORUMLISTBYID;
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
