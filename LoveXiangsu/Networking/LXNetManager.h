//
//  LXNetManager.h
//  LoveXiangsu
//
//  Created by yangjun on 15/10/18.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXBaseRequest.h"

@interface LXNetManager : NSObject

@property(nonatomic,assign)int requestTimeInterval;

+ (LXNetManager *)sharedInstance;

- (void)addRequest:(LXBaseRequest *)request;
- (void)addUploadRequest:(LXBaseRequest *)request;
- (void)addDownloadRequest:(LXBaseRequest*)request;
- (void)cancelRequest:(NSInteger)tag;
- (void)cancelAllRequests;

@end
