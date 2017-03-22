//
//  LXForumTopicDetailView.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/28.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXForumTopicDetailView.h"
#import "LXUICommon.h"
#import "LXCommon.h"
#import "LXForumTopicReplyCell.h"

static NSString *replyCellIdentifier = @"ReplyCell";

@implementation LXForumTopicDetailView

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *result = [super hitTest:point withEvent:event];
//    CGPoint buttonPoint = [self.tableView convertPoint:point fromView:self];
//    if ([self.tableView pointInside:buttonPoint withEvent:event]) {
//        return self.tableView;
//    }
//    return result;
//}

- (id)initWithFrame:(CGRect)frame andImageNumber:(NSInteger)imgNumber
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        LXForumTopicDetailView *superView = self;

        self.imageviewArray = [NSMutableArray array];

        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textColor = LX_MAIN_TEXT_COLOR;
        self.titleLabel.font = LX_TEXTSIZE_20;
        self.titleLabel.clipsToBounds = NO;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.titleLabel.layer.borderWidth = 1;
        [self addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            // 高度等于MARGIN即可
//            make.height.equalTo(MARGIN * 1.5);
            make.height.greaterThanOrEqualTo(1);
        }];

        self.headBtn = [[UIImageView alloc]init];
        [self addSubview:self.headBtn];
        [self.headBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.titleLabel.bottom).offset(MARGIN);
            make.width.height.equalTo(HeadBtnSize);
        }];

        self.nicknameLabel = [[UILabel alloc]init];
        self.nicknameLabel.textColor = LX_SECOND_TEXT_COLOR;
        self.nicknameLabel.font = LX_TEXTSIZE_14;
        self.nicknameLabel.clipsToBounds = NO;
        self.nicknameLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.nicknameLabel.layer.borderWidth = 1;
        [self addSubview:self.nicknameLabel];
        [self.nicknameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headBtn.right).offset(PADDING);
            make.centerY.equalTo(self.headBtn.centerY);
            // 宽度等于MARGIN即可
            make.width.equalTo(150);
        }];

        self.updatetimeLabel = [[UILabel alloc]init];
        self.updatetimeLabel.textColor = LX_SECOND_TEXT_COLOR;
        self.updatetimeLabel.font = LX_TEXTSIZE_12;
        self.updatetimeLabel.textAlignment = NSTextAlignmentRight;
        self.updatetimeLabel.clipsToBounds = NO;
        self.updatetimeLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.updatetimeLabel.layer.borderWidth = 1;
        [self addSubview:self.updatetimeLabel];
        [self.updatetimeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.centerY.equalTo(self.headBtn.centerY);
            // 宽度等于MARGIN即可
            make.width.equalTo(100);
        }];

        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.textColor = LX_MAIN_TEXT_COLOR;
        self.contentLabel.font = LX_TEXTSIZE_16;
        self.contentLabel.clipsToBounds = NO;
        self.contentLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.contentLabel.layer.borderWidth = 1;
        [self addSubview:self.contentLabel];
        [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.headBtn.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            // 高度大于等于MARGIN即可
            make.height.greaterThanOrEqualTo(MARGIN);
        }];

//        NSUInteger idx = 0;

        for (int i = 0; i < imgNumber; i ++) {
            UIImageView * image = [[UIImageView alloc]init];
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.tag = i;
            image.layer.borderColor = LX_DEBUG_COLOR;
            image.layer.borderWidth = 1;
            [self addSubview:image];
            [self.imageviewArray addObject:image];
            [image makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(MARGIN);
                make.right.equalTo(superView.right).offset(-MARGIN);
                if (i == 0) {
                    make.top.equalTo(self.contentLabel.bottom).offset(MARGIN);
                } else {
                    make.top.equalTo(((UIImageView *)self.imageviewArray[i-1]).bottom).offset(1);
                }
                
                // 高度大于等于MARGIN即可
                make.height.greaterThanOrEqualTo(0);
            }];
        }

//        self.image1 = [[UIImageView alloc]init];
//        self.image1.contentMode = UIViewContentModeScaleAspectFill;
//        self.image1.tag = idx++;
//        self.image1.layer.borderColor = LX_DEBUG_COLOR;
//        self.image1.layer.borderWidth = 1;
//        [self addSubview:self.image1];
//        [self.image1 makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(MARGIN);
//            make.right.equalTo(superView.right).offset(-MARGIN);
//            make.top.equalTo(self.contentLabel.bottom).offset(MARGIN);
//
//            // 高度大于等于MARGIN即可
//            make.height.greaterThanOrEqualTo(0);
//        }];
//
//        self.image2 = [[UIImageView alloc]init];
//        self.image2.tag = idx++;
//        self.image2.layer.borderColor = LX_DEBUG_COLOR;
//        self.image2.layer.borderWidth = 1;
//        [self addSubview:self.image2];
//        [self.image2 makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(MARGIN);
//            make.right.equalTo(superView.right).offset(-MARGIN);
//            make.top.equalTo(self.image1.bottom).offset(1);
//            
//            // 高度大于等于MARGIN即可
//            make.height.greaterThanOrEqualTo(0);
//        }];
//        
//        self.image3 = [[UIImageView alloc]init];
//        self.image3.tag = idx++;
//        self.image3.layer.borderColor = LX_DEBUG_COLOR;
//        self.image3.layer.borderWidth = 1;
//        [self addSubview:self.image3];
//        [self.image3 makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(MARGIN);
//            make.right.equalTo(superView.right).offset(-MARGIN);
//            make.top.equalTo(self.image2.bottom).offset(1);
//            
//            // 高度大于等于MARGIN即可
//            make.height.greaterThanOrEqualTo(0);
//        }];
//        
//        self.image4 = [[UIImageView alloc]init];
//        self.image4.tag = idx++;
//        self.image4.layer.borderColor = LX_DEBUG_COLOR;
//        self.image4.layer.borderWidth = 1;
//        [self addSubview:self.image4];
//        [self.image4 makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(MARGIN);
//            make.right.equalTo(superView.right).offset(-MARGIN);
//            make.top.equalTo(self.image3.bottom).offset(1);
//            
//            // 高度大于等于MARGIN即可
//            make.height.greaterThanOrEqualTo(0);
//        }];
//        
//        self.image5 = [[UIImageView alloc]init];
//        self.image5.tag = idx++;
//        self.image5.layer.borderColor = LX_DEBUG_COLOR;
//        self.image5.layer.borderWidth = 1;
//        [self addSubview:self.image5];
//        [self.image5 makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(MARGIN);
//            make.right.equalTo(superView.right).offset(-MARGIN);
//            make.top.equalTo(self.image4.bottom).offset(1);
//            
//            // 高度大于等于MARGIN即可
//            make.height.greaterThanOrEqualTo(0);
//        }];
//        
//        self.image6 = [[UIImageView alloc]init];
//        self.image6.tag = idx++;
//        self.image6.layer.borderColor = LX_DEBUG_COLOR;
//        self.image6.layer.borderWidth = 1;
//        [self addSubview:self.image6];
//        [self.image6 makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(MARGIN);
//            make.right.equalTo(superView.right).offset(-MARGIN);
//            make.top.equalTo(self.image5.bottom).offset(1);
//            
//            // 高度大于等于MARGIN即可
//            make.height.greaterThanOrEqualTo(0);
//        }];
//        
//        self.image7 = [[UIImageView alloc]init];
//        self.image7.tag = idx++;
//        self.image7.layer.borderColor = LX_DEBUG_COLOR;
//        self.image7.layer.borderWidth = 1;
//        [self addSubview:self.image7];
//        [self.image7 makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(MARGIN);
//            make.right.equalTo(superView.right).offset(-MARGIN);
//            make.top.equalTo(self.image6.bottom).offset(1);
//            
//            // 高度大于等于MARGIN即可
//            make.height.greaterThanOrEqualTo(0);
//        }];
//        
//        self.image8 = [[UIImageView alloc]init];
//        self.image8.tag = idx++;
//        self.image8.layer.borderColor = LX_DEBUG_COLOR;
//        self.image8.layer.borderWidth = 1;
//        [self addSubview:self.image8];
//        [self.image8 makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(MARGIN);
//            make.right.equalTo(superView.right).offset(-MARGIN);
//            make.top.equalTo(self.image7.bottom).offset(1);
//            
//            // 高度大于等于MARGIN即可
//            make.height.greaterThanOrEqualTo(0);
//        }];
//        
//        self.image9 = [[UIImageView alloc]init];
//        self.image9.tag = idx++;
//        self.image9.layer.borderColor = LX_DEBUG_COLOR;
//        self.image9.layer.borderWidth = 1;
//        [self addSubview:self.image9];
//        [self.image9 makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(MARGIN);
//            make.right.equalTo(superView.right).offset(-MARGIN);
//            make.top.equalTo(self.image8.bottom).offset(1);
//            
//            // 高度大于等于MARGIN即可
//            make.height.greaterThanOrEqualTo(0);
//        }];

        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.bounces = NO;
        self.tableView.scrollEnabled = NO;
        
//        if (IOS8_OR_LATER) {
//            CGFloat height = MARGIN * 2 + HeadBigBtnSize + MARGIN * 5 + PADDING * 2;
//            self.tableView.estimatedRowHeight = height;
//            self.tableView.rowHeight = UITableViewAutomaticDimension;
//        }
        
        // 设置系统默认分割线从边线开始(1)
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [self.tableView setBackgroundColor:LX_BACKGROUND_COLOR];
        
        self.tableView.showsVerticalScrollIndicator = NO;

        self.tableView.layer.borderColor = LX_DEBUG_COLOR;
        self.tableView.layer.borderWidth = 1;

        [self.tableView registerClass:[LXForumTopicReplyCell class] forCellReuseIdentifier:replyCellIdentifier];

        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(superView.right).offset(0);
            if (self.imageviewArray.count > 0) {
                make.top.equalTo(((UIImageView *)self.imageviewArray[self.imageviewArray.count - 1]).bottom).offset(MARGIN);
            } else {
                make.top.equalTo(self.contentLabel.bottom).offset(MARGIN);
            }
            // 高度大于等于1即可
            make.height.greaterThanOrEqualTo(1);
        }];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];

    self.headBtn.layer.cornerRadius = CGRectGetWidth(self.headBtn.frame)/2.0;
    self.headBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headBtn.layer.borderWidth = 1;
    
    self.headBtn.clipsToBounds = YES;
}

@end
