//
//  LXStoreMenuCell.h
//  LoveXiangsu
//
//  Created by yangjun on 15/11/10.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXStoreMenuCell : UITableViewCell

@property (nonatomic, strong) UIImageView * contentImg;
@property (nonatomic, strong) UIImage * origImg;

@property (nonatomic, strong) UILabel * contentLabel;

@property (nonatomic, assign) BOOL isByHot;

@end
