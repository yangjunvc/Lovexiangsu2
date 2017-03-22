//
//  LXStoreActivityView.h
//  LoveXiangsu
//
//  Created by yangjun on 16/2/20.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LXForumImageBoardView.h"

#import "SZTextView.h"

#import "LXTextField.h"

@interface LXStoreActivityView : UIView

@property (nonatomic, strong) UITextField            * activityName;

@property (nonatomic, strong) LXTextField            * beginTimeLabel;
@property (nonatomic, strong) LXTextField            * endTimeLabel;

@property (nonatomic, strong) SZTextView             * activityDescription;

@property (nonatomic, strong) LXForumImageBoardView  * imageBoardView;

@property (nonatomic, strong) UIButton               * deleteActivity;

@end
