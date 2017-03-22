//
//  LXSearchPhoneResultViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 16/1/9.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXBaseRequest.h"

@interface LXSearchPhoneResultViewController : LXBaseViewController<LXRequestDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) NSString *keyword;

@end
