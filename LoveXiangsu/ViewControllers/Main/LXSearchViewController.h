//
//  LXSearchViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 16/1/9.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

typedef NS_ENUM(NSUInteger, LXSearchType) {
    LXSearchTypeStore = 0,
    LXSearchTypePhone,
};

@interface LXSearchViewController : LXBaseViewController<LXRequestDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, assign) LXSearchType searchType;

@end
