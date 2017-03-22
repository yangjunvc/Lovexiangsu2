//
//  LXForumTopicReplyCell.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/29.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXForumTopicReplyCell.h"
#import "LXUICommon.h"

@implementation LXForumTopicReplyCell

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    CGPoint buttonPoint = [self.headBtn convertPoint:point fromView:self.contentView];
    if ([self.headBtn pointInside:buttonPoint withEvent:event]) {
        return self.headBtn;
    }
    return result;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *superCell = self.contentView;

        self.headBtn = [[UIImageView alloc]init];
        self.headBtn.layer.borderColor = LX_DEBUG_COLOR;
        self.headBtn.layer.borderWidth = 1;
        [self.contentView addSubview:self.headBtn];
        [self.headBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(MARGIN);
            make.width.equalTo(HeadBigBtnSize);
            make.height.equalTo(HeadBigBtnSize);
        }];

        self.favourBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.favourBtn.layer.borderColor = LX_DEBUG_COLOR;
        self.favourBtn.layer.borderWidth = 1;
        [self.contentView addSubview:self.favourBtn];
        [self.favourBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(MARGIN);
            make.right.equalTo(superCell.right).offset(-MARGIN);
            make.width.equalTo(FavourBtnSize);
            make.height.equalTo(FavourBtnSize);
        }];

        self.favourCountLabel = [[UILabel alloc]init];
        self.favourCountLabel.font = LX_TEXTSIZE_12;
        self.favourCountLabel.textColor = LX_SECOND_TEXT_COLOR;
        self.favourCountLabel.textAlignment = NSTextAlignmentRight;
        self.favourCountLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.favourCountLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.favourCountLabel];
        [self.favourCountLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.favourBtn.bottom).offset(PADDING);
            make.right.equalTo(superCell.right).offset(-MARGIN);
            make.width.equalTo(80);
            make.height.equalTo(PADDING * 1.5);
        }];

        self.nicknameLabel = [[UILabel alloc]init];
        self.nicknameLabel.textColor = LX_MAIN_TEXT_COLOR;
        self.nicknameLabel.font = LX_TEXTSIZE_16;
        self.nicknameLabel.clipsToBounds = NO;
        self.nicknameLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.nicknameLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.nicknameLabel];
        [self.nicknameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headBtn.right).offset(PADDING);
            make.top.equalTo(MARGIN);
            make.right.equalTo(self.favourBtn.left).offset(-MARGIN);
            // 高度等于MARGIN即可
            make.height.equalTo(MARGIN * 1.5);
        }];

        self.floortimeLabel = [[UILabel alloc]init];
        self.floortimeLabel.font = LX_TEXTSIZE_12;
        self.floortimeLabel.textColor = LX_SECOND_TEXT_COLOR;
        self.floortimeLabel.textAlignment = NSTextAlignmentLeft;
        self.floortimeLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.floortimeLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.floortimeLabel];
        [self.floortimeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nicknameLabel.left);
            make.top.equalTo(self.nicknameLabel.bottom).offset(PADDING);
            make.width.equalTo(150);
            make.height.equalTo(PADDING * 1.5);
        }];

        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.numberOfLines = 4;
        self.contentLabel.font = LX_TEXTSIZE_16;
        self.contentLabel.textColor = LX_MAIN_TEXT_COLOR;
        self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.contentLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.contentLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.headBtn.bottom).offset(MARGIN);
            make.right.equalTo(superCell.right).offset(-MARGIN);
            make.height.greaterThanOrEqualTo(MARGIN);
            make.bottom.equalTo(superCell.bottom).offset(-MARGIN);
        }];
    }

    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.headBtn.layer.cornerRadius = CGRectGetWidth(self.headBtn.frame)/2.0;
    self.headBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headBtn.layer.borderWidth = 1;
    
    self.headBtn.clipsToBounds = YES;
}

@end
