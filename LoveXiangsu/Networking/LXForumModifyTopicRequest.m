//
//  LXForumModifyTopicRequest.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/12/28.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXForumModifyTopicRequest.h"
#import "NSDictionary+BeeExtension.h"

@implementation LXForumModifyTopicRequest

-(id)init{
    self = [super init];
    if (self) {
        self.baseUrl    = HTTP_BASEURL;
        self.requestUrl = REQUESTURL_FORUMMODIFYTOPIC;
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
