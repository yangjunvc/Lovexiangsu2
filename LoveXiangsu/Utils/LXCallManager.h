//
//  LXCallManager.h
//  LoveXiangsu
//
//  Created by yangjun on 16/1/10.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXBaseRequest.h"

@interface LXCallManager : NSObject<LXRequestDelegate>

+ (LXCallManager *)sharedInstance;
- (void)asyncSaveCallRecordWithStoreId:(NSString *)store_id phonebookId:(NSString *)phonebook_id;

@end
