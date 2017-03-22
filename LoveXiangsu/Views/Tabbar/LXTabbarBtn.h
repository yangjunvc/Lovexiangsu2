//
//  LXTabbarBtn.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/10/24.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXTabbarBtn : UIButton

@property (nonatomic , strong) UIImageView * showBgImg;
@property (nonatomic , strong) UILabel * tabBarTitle;

-(void)setShowBgImg:(NSString *)normalBgImg SelectedImg:(NSString *)selectedBgImg forState:(BOOL)selected;

@end
