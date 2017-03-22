//
//  LXForumTopicDetailView.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/28.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXForumTopicDetailView : UIView

@property (nonatomic, strong) UILabel      * titleLabel;

@property (nonatomic, strong) UIImageView  * headBtn;
@property (nonatomic, strong) UILabel      * nicknameLabel;

@property (nonatomic, strong) UILabel      * updatetimeLabel;

@property (nonatomic, strong) UILabel      * contentLabel;

@property (nonatomic, strong) NSMutableArray * imageviewArray;

//@property (nonatomic, strong) UIImageView  * image1;
//@property (nonatomic, strong) UIImageView  * image2;
//@property (nonatomic, strong) UIImageView  * image3;
//@property (nonatomic, strong) UIImageView  * image4;
//@property (nonatomic, strong) UIImageView  * image5;
//@property (nonatomic, strong) UIImageView  * image6;
//@property (nonatomic, strong) UIImageView  * image7;
//@property (nonatomic, strong) UIImageView  * image8;
//@property (nonatomic, strong) UIImageView  * image9;

@property (nonatomic, strong) UITableView  * tableView;

- (id)initWithFrame:(CGRect)frame andImageNumber:(NSInteger)imgNumber;

@end
