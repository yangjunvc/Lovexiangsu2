//
//  LXForumNewTopicRequest.m
//  LoveXiangsu
//
//  Created by yangjun on 15/12/27.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXForumNewTopicRequest.h"
#import "NSDictionary+BeeExtension.h"

@implementation LXForumNewTopicRequest

-(id)init{
    self = [super init];
    if (self) {
        self.baseUrl    = HTTP_BASEURL;
        self.requestUrl = REQUESTURL_FORUMNEWTOPIC;
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
