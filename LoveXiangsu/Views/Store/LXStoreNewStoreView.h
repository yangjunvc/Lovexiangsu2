//
//  LXStoreNewStoreView.h
//  LoveXiangsu
//
//  Created by yangjun on 16/2/22.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LXForumImageBoardView.h"

#import "LXTextField.h"

#import "SZTextView.h"

@interface LXStoreNewStoreView : UIView

@property (nonatomic, strong) LXTextField  * boardTypeName;

@property (nonatomic, strong) UITextField  * storeName;
@property (nonatomic, strong) UITextField  * storeAddress;
@property (nonatomic, strong) UITextField  * storePhone1;
@property (nonatomic, strong) UITextField  * storePhone2;

@property (nonatomic, strong) UILabel      * location;

@property (nonatomic, strong) LXForumImageBoardView  * imageBoardView;

@property (nonatomic, strong) SZTextView   * storeDescription;

@end
