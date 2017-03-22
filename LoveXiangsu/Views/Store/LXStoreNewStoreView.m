//
//  LXStoreNewStoreView.m
//  LoveXiangsu
//
//  Created by yangjun on 16/2/22.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreNewStoreView.h"

#import "LXUICommon.h"

@implementation LXStoreNewStoreView

#pragma mark - 生命周期

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        LXStoreNewStoreView *superView = self;
        self.backgroundColor = [UIColor clearColor];

        UIView *boardView = [[UIView alloc]init];
        boardView.backgroundColor = LX_BACKGROUND_COLOR;
        [self addSubview:boardView];
        [boardView makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(37);
        }];
        
        UILabel *boardLabel = [[UILabel alloc]init];
        boardLabel.text = @"店铺类型：";
        boardLabel.textColor = LX_SECOND_TEXT_COLOR;
        boardLabel.textAlignment = NSTextAlignmentLeft;
        boardLabel.font = LX_TEXTSIZE_16;
        boardLabel.layer.borderColor = LX_DEBUG_COLOR;
        boardLabel.layer.borderWidth = 1;
        [boardView addSubview:boardLabel];
        [boardLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(0);
            make.bottom.equalTo(boardView.bottom).offset(0);
            make.width.equalTo(85);
        }];

        self.boardTypeName = [[LXTextField alloc]init];
        self.boardTypeName.canPaste = NO;
        self.boardTypeName.canSelect = NO;
        self.boardTypeName.showMenu = NO;
        self.boardTypeName.tintColor = [UIColor clearColor];
        self.boardTypeName.userInteractionEnabled = YES;
        self.boardTypeName.layer.borderColor = LX_DEBUG_COLOR;
        self.boardTypeName.layer.borderWidth = 1;
        [boardView addSubview:self.boardTypeName];
        [self.boardTypeName makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(boardLabel.right).offset(0);
            make.top.equalTo(0);
            make.bottom.equalTo(boardView.bottom).offset(0);
            make.right.equalTo(boardView.right).offset(0);
        }];

        self.storeName = [[UITextField alloc]init];
        self.storeName.placeholder = @"店铺名称...";
        self.storeName.backgroundColor = LX_BACKGROUND_COLOR;
        [self addSubview:self.storeName];
        [self.storeName makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(boardView.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(38);
        }];
        
        self.storeAddress = [[UITextField alloc]init];
        self.storeAddress.placeholder = @"店铺地址...";
        self.storeAddress.backgroundColor = LX_BACKGROUND_COLOR;
        [self addSubview:self.storeAddress];
        [self.storeAddress makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.storeName.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(38);
        }];
        
        self.storePhone1 = [[UITextField alloc]init];
        self.storePhone1.placeholder = @"默认电话...";
        self.storePhone1.backgroundColor = LX_BACKGROUND_COLOR;
        [self addSubview:self.storePhone1];
        [self.storePhone1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.storeAddress.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(38);
        }];
        
        self.storePhone2 = [[UITextField alloc]init];
        self.storePhone2.placeholder = @"额外电话...";
        self.storePhone2.backgroundColor = LX_BACKGROUND_COLOR;
        [self addSubview:self.storePhone2];
        [self.storePhone2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.storePhone1.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(38);
        }];

        UITableViewCell * arrowCell = [[UITableViewCell alloc]init];
        arrowCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        arrowCell.backgroundColor = LX_BACKGROUND_COLOR;
        [self addSubview:arrowCell];
        [arrowCell makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.storePhone2.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(38);
        }];
        
        self.location = [[UILabel alloc]init];
        self.location.text = @"位置：";
        self.location.textColor = LX_MAIN_TEXT_COLOR;
        self.location.backgroundColor = [UIColor clearColor];
        [self addSubview:self.location];
        [self.location makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.storePhone2.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(38);
        }];

        self.storeDescription = [[SZTextView alloc]init];
        self.storeDescription.textContainerInset = UIEdgeInsetsMake(8, -4.5, 0, 0);
        self.storeDescription.backgroundColor = LX_BACKGROUND_COLOR;
        self.storeDescription.placeholder = @"店铺经营内容描述...";
        // 193 194 196
        self.storeDescription.placeholderTextColor = [UIColor colorWithRed:193.0/255.0 green:194.0/255.0 blue:196.0/255.0 alpha:1.0];
        self.storeDescription.font = FONT_SYSTEM(17);
        self.storeDescription.layoutManager.allowsNonContiguousLayout = NO;
        //        self.storeDescription.layer.borderColor = LX_DEBUG_COLOR;
        //        self.storeDescription.layer.borderWidth = 1;
        [self addSubview:self.storeDescription];
        [self.storeDescription updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.location.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(150);
        }];

        CGFloat imageBoardViewWidth = ScreenWidth - 2 * MARGIN;
        
        self.imageBoardView = [[LXForumImageBoardView alloc]init];
        self.imageBoardView.layer.borderColor = LX_DEBUG_COLOR;
        self.imageBoardView.layer.borderWidth = 1;
        [self addSubview:self.imageBoardView];
        [self.imageBoardView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.storeDescription.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.lessThanOrEqualTo(imageBoardViewWidth);
        }];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
