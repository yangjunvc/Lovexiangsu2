//
//  LXPhoneCell.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/14.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXPhoneCell : UITableViewCell

@property (nonatomic, strong) NSString * phoneId;

@property (nonatomic, strong) NSString * phone;

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIImageView * callingImg;

@property (nonatomic, strong) UIView  * cellSeparator;

@property (nonatomic, strong) UIButton    * callingView;

@end
