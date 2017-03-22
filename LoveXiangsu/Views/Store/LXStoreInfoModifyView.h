//
//  LXStoreInfoModifyView.h
//  LoveXiangsu
//
//  Created by yangjun on 16/2/4.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LXForumImageBoardView.h"

#import "SZTextView.h"

@interface LXStoreInfoModifyView : UIView

@property (nonatomic, strong) UITextField  * storeName;
@property (nonatomic, strong) UITextField  * storeAddress;
@property (nonatomic, strong) UITextField  * storePhone1;
@property (nonatomic, strong) UITextField  * storePhone2;

@property (nonatomic, strong) UILabel      * o2o;
@property (nonatomic, strong) UISwitch     * o2oSwitch;
@property (nonatomic, strong) UILabel      * fullday;
@property (nonatomic, strong) UISwitch     * fulldaySwitch;

@property (nonatomic, strong) UILabel      * location;

@property (nonatomic, strong) LXForumImageBoardView  * imageBoardView;

@property (nonatomic, strong) SZTextView   * storeDescription;
@property (nonatomic, strong) UIButton     * closeStore;

@end
