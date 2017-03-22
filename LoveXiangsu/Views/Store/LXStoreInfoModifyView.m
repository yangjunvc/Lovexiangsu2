//
//  LXStoreInfoModifyView.m
//  LoveXiangsu
//
//  Created by yangjun on 16/2/4.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreInfoModifyView.h"

#import "LXUICommon.h"

@implementation LXStoreInfoModifyView

#pragma mark - 生命周期

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        LXStoreInfoModifyView *superView = self;
        self.backgroundColor = [UIColor clearColor];
        
        self.storeName = [[UITextField alloc]init];
        self.storeName.placeholder = @"店铺名称...";
        self.storeName.backgroundColor = LX_BACKGROUND_COLOR;
        [self addSubview:self.storeName];
        [self.storeName makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(MARGIN);
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

        self.o2o = [[UILabel alloc]init];
        self.o2o.text = @"送货上门";
        self.o2o.textColor = LX_MAIN_TEXT_COLOR;
        self.o2o.backgroundColor = LX_BACKGROUND_COLOR;
        [self addSubview:self.o2o];
        [self.o2o makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.storePhone2.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(38);
        }];

        self.o2oSwitch = [[UISwitch alloc]init];
        [self addSubview:self.o2oSwitch];
        [self.o2oSwitch makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.o2o.centerY);
            make.right.equalTo(self.o2o.right).offset(-PADDING);
            make.height.equalTo(38 - 8);
        }];

        self.fullday = [[UILabel alloc]init];
        self.fullday.text = @"24小时营业";
        self.fullday.textColor = LX_MAIN_TEXT_COLOR;
        self.fullday.backgroundColor = LX_BACKGROUND_COLOR;
        [self addSubview:self.fullday];
        [self.fullday makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.o2o.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(38);
        }];

        self.fulldaySwitch = [[UISwitch alloc]init];
        [self addSubview:self.fulldaySwitch];
        [self.fulldaySwitch makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.fullday.centerY);
            make.right.equalTo(self.fullday.right).offset(-PADDING);
            make.height.equalTo(38 - 8);
        }];

        UITableViewCell * arrowCell = [[UITableViewCell alloc]init];
        arrowCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        arrowCell.backgroundColor = LX_BACKGROUND_COLOR;
        [self addSubview:arrowCell];
        [arrowCell makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.fullday.bottom).offset(MARGIN);
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
            make.top.equalTo(self.fullday.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(38);
        }];

        CGFloat imageBoardViewWidth = ScreenWidth - 2 * MARGIN;

        self.imageBoardView = [[LXForumImageBoardView alloc]init];
        self.imageBoardView.layer.borderColor = LX_DEBUG_COLOR;
        self.imageBoardView.layer.borderWidth = 1;
        [self addSubview:self.imageBoardView];
        [self.imageBoardView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.location.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.lessThanOrEqualTo(imageBoardViewWidth);
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
            make.top.equalTo(self.imageBoardView.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(150);
        }];

        self.closeStore = [UIButton buttonWithType:UIButtonTypeCustom];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"商家下线"];
        NSRange strRange = {0,[str length]};
        // 30 128 240
        NSDictionary *dict = @{NSForegroundColorAttributeName:LX_ACCENT_TEXT_COLOR,
                               NSBackgroundColorAttributeName:LX_ACCENT_COLOR,
                               NSFontAttributeName:LX_TEXTSIZE_16,
                               };
        [str addAttributes:dict range:strRange];
        [self.closeStore setAttributedTitle:str forState:UIControlStateNormal];
        [self.closeStore setBackgroundColor:LX_ACCENT_COLOR];
        [self addSubview:self.closeStore];
        [self.closeStore makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.right.equalTo(-MARGIN);
            make.top.equalTo(self.storeDescription.bottom).offset(MARGIN);
            make.height.equalTo(38);
        }];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
