//
//  LXNewsCell.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/14.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXNewsCell : UITableViewCell

@property (nonatomic, strong) NSString * id;

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UILabel * timeLabel;
//@property (nonatomic, strong) UIView  * cellSeparator;

@end
