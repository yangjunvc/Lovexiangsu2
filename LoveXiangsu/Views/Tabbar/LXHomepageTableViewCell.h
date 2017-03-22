//
//  LXHomepageTableViewCell.h
//  LoveXiangsu
//
//  Created by yangjun on 15/11/2.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXHomepageTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString    * storeId;
@property (nonatomic, strong) UIImageView * storeImg;
@property (nonatomic, strong) UIImageView * storeStarLvImg;
@property (nonatomic, strong) UILabel     * storeNameLabel;
@property (nonatomic, strong) UIImageView * storeTag1Img;
@property (nonatomic, strong) UIImageView * storeTag2Img;
@property (nonatomic, strong) UIImageView * storeTag3Img;
@property (nonatomic, strong) UIImageView * storeTag4Img;
@property (nonatomic, strong) UILabel     * storeDescLabel;
@property (nonatomic, strong) UIImageView * callingImg;
@property (nonatomic, strong) UILabel     * callTimesLabel;
@property (nonatomic, strong) UILabel     * distanceLabel;
@property (nonatomic, strong) UIView      * cellSeparator;

@property (nonatomic, strong) UIButton    * callingView;

@property (nonatomic, strong) NSString    * phone1;
@property (nonatomic, strong) NSString    * phone2;

@end
