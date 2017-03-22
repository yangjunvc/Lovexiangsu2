//
//  LXStoreSimpleCell.h
//  LoveXiangsu
//
//  Created by yangjun on 16/2/29.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXStoreSimpleCell : UITableViewCell

@property (nonatomic, strong) NSString    * relative_id;
@property (nonatomic, strong) NSString    * order_id;

@property (nonatomic, strong) UILabel     * nameLabel;
@property (nonatomic, strong) UILabel     * priceLabel;

@property (nonatomic, strong) UIView      * cellSeparator;

@end
