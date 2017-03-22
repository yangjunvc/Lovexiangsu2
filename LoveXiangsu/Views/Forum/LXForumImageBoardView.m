//
//  LXForumImageBoardView.m
//  LoveXiangsu
//
//  Created by yangjun on 15/12/25.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXForumImageBoardView.h"

#import "LXUICommon.h"

#import "UIImageView+WebCache.h"
#import "UIImageView+Resize.h"

@interface LXForumImageBoardView()<UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray * imgViewArray;
@property (nonatomic, strong) NSMutableArray * delBtnArray;

@end

@implementation LXForumImageBoardView

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *result = [super hitTest:point withEvent:event];
//    CGPoint buttonPoint = [self.tableView convertPoint:point fromView:self];
//    if ([self.tableView pointInside:buttonPoint withEvent:event]) {
//        return self.tableView;
//    }
//    return result;
//}

#pragma mark - 生命周期

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        LXForumImageBoardView *superView = self;
        self.backgroundColor = LX_BACKGROUND_COLOR;

        self.imgArray = [NSMutableArray array];
        self.imgViewArray = [NSMutableArray array];
        self.delBtnArray = [NSMutableArray array];
        self.objectKeyDict = [NSMutableDictionary dictionary];

        CGFloat imageBoardViewWidth = ScreenWidth - 2 * MARGIN;
        CGFloat imageViewSize = imageBoardViewWidth / 3;

        NSUInteger idx = 0;
        
        self.imgView1 = [[UIImageView alloc]init];
        self.imgView1.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView1.clipsToBounds = YES;
        self.imgView1.tag = idx++;
        self.imgView1.layer.borderColor = LX_DEBUG_COLOR;
        self.imgView1.layer.borderWidth = 1;
        [self addSubview:self.imgView1];
        [self.imgView1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(0);
            make.width.equalTo(imageViewSize);
            make.height.lessThanOrEqualTo(imageViewSize);
        }];
        
        self.imgView2 = [[UIImageView alloc]init];
        self.imgView2.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView2.clipsToBounds = YES;
        self.imgView2.tag = idx++;
        self.imgView2.layer.borderColor = LX_DEBUG_COLOR;
        self.imgView2.layer.borderWidth = 1;
        [self addSubview:self.imgView2];
        [self.imgView2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgView1.right).offset(0);
            make.top.equalTo(0);
            make.width.equalTo(imageViewSize);
            make.height.lessThanOrEqualTo(imageViewSize);
        }];
        
        self.imgView3 = [[UIImageView alloc]init];
        self.imgView3.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView3.clipsToBounds = YES;
        self.imgView3.tag = idx++;
        self.imgView3.layer.borderColor = LX_DEBUG_COLOR;
        self.imgView3.layer.borderWidth = 1;
        [self addSubview:self.imgView3];
        [self.imgView3 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgView2.right).offset(0);
            make.top.equalTo(0);
            make.width.equalTo(imageViewSize);
            make.height.lessThanOrEqualTo(imageViewSize);
        }];
        
        self.imgView4 = [[UIImageView alloc]init];
        self.imgView4.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView4.clipsToBounds = YES;
        self.imgView4.tag = idx++;
        self.imgView4.layer.borderColor = LX_DEBUG_COLOR;
        self.imgView4.layer.borderWidth = 1;
        [self addSubview:self.imgView4];
        [self.imgView4 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(self.imgView1.bottom).offset(0);
            make.width.equalTo(imageViewSize);
            make.height.lessThanOrEqualTo(imageViewSize);
        }];
        
        self.imgView5 = [[UIImageView alloc]init];
        self.imgView5.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView5.clipsToBounds = YES;
        self.imgView5.tag = idx++;
        self.imgView5.layer.borderColor = LX_DEBUG_COLOR;
        self.imgView5.layer.borderWidth = 1;
        [self addSubview:self.imgView5];
        [self.imgView5 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgView4.right).offset(0);
            make.top.equalTo(self.imgView2.bottom).offset(0);
            make.width.equalTo(imageViewSize);
            make.height.lessThanOrEqualTo(imageViewSize);
        }];
        
        self.imgView6 = [[UIImageView alloc]init];
        self.imgView6.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView6.clipsToBounds = YES;
        self.imgView6.tag = idx++;
        self.imgView6.layer.borderColor = LX_DEBUG_COLOR;
        self.imgView6.layer.borderWidth = 1;
        [self addSubview:self.imgView6];
        [self.imgView6 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgView5.right).offset(0);
            make.top.equalTo(self.imgView3.bottom).offset(0);
            make.width.equalTo(imageViewSize);
            make.height.lessThanOrEqualTo(imageViewSize);
        }];
        
        self.imgView7 = [[UIImageView alloc]init];
        self.imgView7.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView7.clipsToBounds = YES;
        self.imgView7.tag = idx++;
        self.imgView7.layer.borderColor = LX_DEBUG_COLOR;
        self.imgView7.layer.borderWidth = 1;
        [self addSubview:self.imgView7];
        [self.imgView7 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(self.imgView4.bottom).offset(0);
            make.width.equalTo(imageViewSize);
            make.height.lessThanOrEqualTo(imageViewSize);
        }];
        
        self.imgView8 = [[UIImageView alloc]init];
        self.imgView8.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView8.clipsToBounds = YES;
        self.imgView8.tag = idx++;
        self.imgView8.layer.borderColor = LX_DEBUG_COLOR;
        self.imgView8.layer.borderWidth = 1;
        [self addSubview:self.imgView8];
        [self.imgView8 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgView7.right).offset(0);
            make.top.equalTo(self.imgView5.bottom).offset(0);
            make.width.equalTo(imageViewSize);
            make.height.lessThanOrEqualTo(imageViewSize);
        }];
        
        self.imgView9 = [[UIImageView alloc]init];
        self.imgView9.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView9.clipsToBounds = YES;
        self.imgView9.tag = idx++;
        self.imgView9.layer.borderColor = LX_DEBUG_COLOR;
        self.imgView9.layer.borderWidth = 1;
        [self addSubview:self.imgView9];
        [self.imgView9 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgView8.right).offset(0);
            make.top.equalTo(self.imgView6.bottom).offset(0);
            make.width.equalTo(imageViewSize);
            make.height.lessThanOrEqualTo(imageViewSize);
        }];

        [self.imgViewArray addObjectsFromArray:@[self.imgView1, self.imgView2, self.imgView3, self.imgView4, self.imgView5,
                              self.imgView6, self.imgView7, self.imgView8, self.imgView9]];

        for (int i = 0; i < self.imgViewArray.count; i ++) {
            UIImageView * imgView = self.imgViewArray[i];
            imgView.userInteractionEnabled = YES;
            [imgView setAutoresize:YES];

            UIButton * delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            delBtn.tag = i;
            [delBtn setImage:[UIImage imageNamed:@"delete_btn"] forState:UIControlStateNormal];
            [delBtn setAdjustsImageWhenHighlighted:NO];
            [delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [imgView addSubview:delBtn];
            [delBtn makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(25);
                make.top.equalTo(imgView.top).offset(0);
                make.right.equalTo(imgView.right).offset(0);
            }];
            [self.delBtnArray addObject:delBtn];
        }

        [superView updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.imgView7.bottom).offset(0);
        }];
    }
    return self;
}

-(void)layoutSubviews{
    for (int i = 0; i < self.imgViewArray.count; i ++) {
        UIImageView * imgView = self.imgViewArray[i];
        if (i < self.imgArray.count) {
            NSString * imgPathStr = self.imgArray[i];
            if ([imgPathStr hasPrefix:@"http"]) {
                [imgView sd_setImageWithURL:[NSURL URLWithString:imgPathStr] placeholderImage:[UIImage imageNamed:@"default_image"]];
            } else {
                imgView.image = [UIImage imageWithContentsOfFile:imgPathStr];
            }
            UIButton * delBtn = self.delBtnArray[i];
            delBtn.hidden = NO;
//            [imgView bringSubviewToFront:delBtn];
        } else {
            imgView.image = nil;
            UIButton * delBtn = self.delBtnArray[i];
            delBtn.hidden = YES;
        }
    }

    [super layoutSubviews];
}

#pragma mark - 按钮点击事件

-(void)delBtnClick:(UIButton *)sender
{
    NSLog(@"删除按钮被点击！");
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"取消上传图片：" message:@"您确定不上传这张图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.tag = sender.tag;
    [alertView show];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"点击了取消按钮！");
        }
            break;
        case 1:
        {
            NSLog(@"点击了确定按钮！");
            NSInteger index = alertView.tag;
            NSString * imgPathStr = self.imgArray[index];
            if ([self.objectKeyDict objectForKey:imgPathStr]) {
                [self.objectKeyDict removeObjectForKey:imgPathStr];
            }
            if (index < self.imgArray.count) {
                [self.imgArray removeObjectAtIndex:index];
            }
            [self setNeedsLayout];
        }
            break;
        default:
            break;
    }
}

@end
