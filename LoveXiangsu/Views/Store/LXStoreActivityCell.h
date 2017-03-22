//
//  LXStoreActivityCell.h
//  LoveXiangsu
//
//  Created by yangjun on 16/2/20.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXStoreActivityCell : UITableViewCell

@property (nonatomic, strong) NSString    * activityId;

@property (nonatomic, strong) UIImageView * activityImg;
@property (nonatomic, strong) UILabel     * titleLabel;
@property (nonatomic, strong) UILabel     * contentLabel;

@property (nonatomic, strong) UILabel     * startTimeLabel;
@property (nonatomic, strong) UILabel     * endTimeLabel;

@property (nonatomic, strong) UIView      * cellSeparator;

@end
