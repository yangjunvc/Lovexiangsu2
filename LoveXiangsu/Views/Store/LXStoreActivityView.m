//
//  LXStoreActivityView.m
//  LoveXiangsu
//
//  Created by yangjun on 16/2/20.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreActivityView.h"

#import "LXUICommon.h"

@implementation LXStoreActivityView

#pragma mark - 生命周期

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        LXStoreActivityView *superView = self;
        self.backgroundColor = [UIColor clearColor];
        
        self.activityName = [[UITextField alloc]init];
        self.activityName.placeholder = @"活动名称...";
        self.activityName.backgroundColor = LX_BACKGROUND_COLOR;
        [self addSubview:self.activityName];
        [self.activityName makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(38);
        }];

        UITableViewCell * beginTimeCell = [[UITableViewCell alloc]init];
        beginTimeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        beginTimeCell.backgroundColor = LX_BACKGROUND_COLOR;
        [self addSubview:beginTimeCell];
        [beginTimeCell makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.activityName.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(38);
        }];
        
        self.beginTimeLabel = [[LXTextField alloc]init];
        self.beginTimeLabel.canPaste = NO;
        self.beginTimeLabel.canSelect = NO;
        self.beginTimeLabel.showMenu = NO;
        self.beginTimeLabel.tintColor = [UIColor clearColor];
        self.beginTimeLabel.text = @"活动开始时间：";
        self.beginTimeLabel.textColor = LX_MAIN_TEXT_COLOR;
        self.beginTimeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.beginTimeLabel];
        [self.beginTimeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.activityName.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(38);
        }];
        
        UITableViewCell * endTimeCell = [[UITableViewCell alloc]init];
        endTimeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        endTimeCell.backgroundColor = LX_BACKGROUND_COLOR;
        [self addSubview:endTimeCell];
        [endTimeCell makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.beginTimeLabel.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(38);
        }];
        
        self.endTimeLabel = [[LXTextField alloc]init];
        self.endTimeLabel.canPaste = NO;
        self.endTimeLabel.canSelect = NO;
        self.endTimeLabel.showMenu = NO;
        self.endTimeLabel.tintColor = [UIColor clearColor];
        self.endTimeLabel.text = @"活动结束时间：";
        self.endTimeLabel.textColor = LX_MAIN_TEXT_COLOR;
        self.endTimeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.endTimeLabel];
        [self.endTimeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.beginTimeLabel.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(38);
        }];

        self.activityDescription = [[SZTextView alloc]init];
        self.activityDescription.textContainerInset = UIEdgeInsetsMake(8, -4.5, 0, 0);
        self.activityDescription.backgroundColor = LX_BACKGROUND_COLOR;
        self.activityDescription.placeholder = @"活动详细描述...";
        // 193 194 196
        self.activityDescription.placeholderTextColor = [UIColor colorWithRed:193.0/255.0 green:194.0/255.0 blue:196.0/255.0 alpha:1.0];
        self.activityDescription.font = FONT_SYSTEM(17);
        self.activityDescription.layoutManager.allowsNonContiguousLayout = NO;
        //        self.storeDescription.layer.borderColor = LX_DEBUG_COLOR;
        //        self.storeDescription.layer.borderWidth = 1;
        [self addSubview:self.activityDescription];
        [self.activityDescription updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.endTimeLabel.bottom).offset(MARGIN);
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
            make.top.equalTo(self.activityDescription.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.lessThanOrEqualTo(imageBoardViewWidth);
        }];

        self.deleteActivity = [UIButton buttonWithType:UIButtonTypeCustom];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"删除活动"];
        NSRange strRange = {0,[str length]};
        // 30 128 240
        NSDictionary *dict = @{NSForegroundColorAttributeName:LX_ACCENT_TEXT_COLOR,
                               NSBackgroundColorAttributeName:LX_ACCENT_COLOR,
                               NSFontAttributeName:LX_TEXTSIZE_16,
                               };
        [str addAttributes:dict range:strRange];
        [self.deleteActivity setAttributedTitle:str forState:UIControlStateNormal];
        [self.deleteActivity setBackgroundColor:LX_ACCENT_COLOR];
        [self addSubview:self.deleteActivity];
        [self.deleteActivity makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.right.equalTo(-MARGIN);
            make.top.equalTo(self.imageBoardView.bottom).offset(MARGIN);
            make.height.equalTo(38);
        }];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
