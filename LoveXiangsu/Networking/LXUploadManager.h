//
//  LXUploadManager.h
//  LoveXiangsu
//
//  Created by yangjun on 15/12/20.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXNetCommon.h"

@interface LXUploadManager : NSObject

+ (LXUploadManager *)sharedInstance;
- (BOOL)uploadObjectSync:(NSString *)objectKey source:(NSString *)sourcePath;
- (NSString *)makeObjectKey:(LXUPLOAD_TYPE)uploadType;

@end
