//
//  LXForumTopicReplyCell.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/29.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXForumTopicReplyCell : UITableViewCell

@property (nonatomic, strong) NSString * reply_id;

@property (nonatomic, strong) UIImageView * headBtn;
@property (nonatomic, strong) UILabel  * nicknameLabel;
@property (nonatomic, strong) UILabel  * floortimeLabel;

@property (nonatomic, strong) UIButton * favourBtn;
@property (nonatomic, strong) UILabel  * favourCountLabel;

@property (nonatomic, strong) UILabel  * contentLabel;

@end
