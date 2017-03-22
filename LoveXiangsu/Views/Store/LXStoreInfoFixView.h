//
//  LXStoreInfoFixView.h
//  LoveXiangsu
//
//  Created by yangjun on 16/1/8.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LXTextView.h"

@interface LXStoreInfoFixView : UIView

@property (nonatomic, strong) UITextField  * storeName;
@property (nonatomic, strong) UITextField  * storeAddress;
@property (nonatomic, strong) UITextField  * storePhone1;
@property (nonatomic, strong) UITextField  * storePhone2;
@property (nonatomic, strong) LXTextView   * storeDescription;
@property (nonatomic, strong) UIButton     * closeStore;
@property (nonatomic, strong) UILabel      * tipLabel;

@end
