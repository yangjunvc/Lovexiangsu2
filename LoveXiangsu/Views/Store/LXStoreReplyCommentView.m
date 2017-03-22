//
//  LXStoreReplyCommentView.m
//  LoveXiangsu
//
//  Created by yangjun on 16/3/4.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreReplyCommentView.h"
#import "LXUICommon.h"

@implementation LXStoreReplyCommentView

#pragma mark - 生命周期

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        LXStoreReplyCommentView *superView = self;
        self.backgroundColor = [UIColor clearColor];

        self.nicknameLabel = [[UILabel alloc]init];
        self.nicknameLabel.font = LX_TEXTSIZE_14;
        self.nicknameLabel.textColor = LX_SECOND_TEXT_COLOR;
        self.nicknameLabel.textAlignment = NSTextAlignmentLeft;
        self.nicknameLabel.adjustsFontSizeToFitWidth = YES;
        self.nicknameLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.nicknameLabel.layer.borderWidth = 1;
        [self addSubview:self.nicknameLabel];
        [self.nicknameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(MARGIN);
            make.width.greaterThanOrEqualTo(0);
            make.height.equalTo(MARGIN);
        }];
        
        self.commentLabel = [[TTTAttributedLabel alloc]init];
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.font = LX_TEXTSIZE_14;
        self.commentLabel.textColor = LX_MAIN_TEXT_COLOR;
        self.commentLabel.adjustsFontSizeToFitWidth = YES;
        self.commentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        self.commentLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.commentLabel.layer.borderWidth = 1;
        [self addSubview:self.commentLabel];
        [self.commentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nicknameLabel.right).offset(0);
            make.top.equalTo(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
//            make.width.greaterThanOrEqualTo(0);
            make.height.greaterThanOrEqualTo(MARGIN);
        }];
        
        self.createdatLabel = [[UILabel alloc]init];
        self.createdatLabel.font = LX_TEXTSIZE_12;
        self.createdatLabel.textColor = LX_SECOND_TEXT_COLOR;
        self.createdatLabel.textAlignment = NSTextAlignmentRight;
        self.createdatLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.createdatLabel.layer.borderWidth = 1;
        [self addSubview:self.createdatLabel];
        [self.createdatLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.top.equalTo(self.commentLabel.bottom).offset(MARGIN);
            make.width.equalTo(150);
            make.height.equalTo(MARGIN);
        }];
        
        self.replyContent = [[SZTextView alloc]init];
        self.replyContent.textContainerInset = UIEdgeInsetsMake(8, -4.5, 0, 0);
        self.replyContent.backgroundColor = LX_BACKGROUND_COLOR;
        self.replyContent.placeholder = @"答复内容...";
        // 193 194 196
        self.replyContent.placeholderTextColor = [UIColor colorWithRed:193.0/255.0 green:194.0/255.0 blue:196.0/255.0 alpha:1.0];
        self.replyContent.font = FONT_SYSTEM(17);
        self.replyContent.layoutManager.allowsNonContiguousLayout = NO;
        [self addSubview:self.replyContent];
        [self.replyContent updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.createdatLabel.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(150);
        }];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
