//
//  LXStoreInfoFixView.m
//  LoveXiangsu
//
//  Created by yangjun on 16/1/8.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreInfoFixView.h"

#import "LXUICommon.h"

@implementation LXStoreInfoFixView

#pragma mark - 生命周期

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        LXStoreInfoFixView *superView = self;
        self.backgroundColor = [UIColor clearColor];

        self.storeName = [[UITextField alloc]init];
        self.storeName.placeholder = @"商家名称...";
        self.storeName.backgroundColor = LX_BACKGROUND_COLOR;
        [self addSubview:self.storeName];
        [self.storeName makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(38);
        }];
        
        self.storeAddress = [[UITextField alloc]init];
        self.storeAddress.placeholder = @"商家地址...";
        self.storeAddress.backgroundColor = LX_BACKGROUND_COLOR;
        [self addSubview:self.storeAddress];
        [self.storeAddress makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.storeName.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(38);
        }];
        
        self.storePhone1 = [[UITextField alloc]init];
        self.storePhone1.placeholder = @"电话1...";
        self.storePhone1.backgroundColor = LX_BACKGROUND_COLOR;
        [self addSubview:self.storePhone1];
        [self.storePhone1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.storeAddress.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(38);
        }];
        
        self.storePhone2 = [[UITextField alloc]init];
        self.storePhone2.placeholder = @"电话2...";
        self.storePhone2.backgroundColor = LX_BACKGROUND_COLOR;
        [self addSubview:self.storePhone2];
        [self.storePhone2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.storePhone1.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(38);
        }];

        self.storeDescription = [[LXTextView alloc]init];
        self.storeDescription.textContainerInset = UIEdgeInsetsMake(8, -4.5, 0, 0);
        self.storeDescription.backgroundColor = LX_BACKGROUND_COLOR;
        self.storeDescription.placeHolder = @"商家信息描述...";
        // 193 194 196
        self.storeDescription.placeHolderTextColor = [UIColor colorWithRed:193.0/255.0 green:194.0/255.0 blue:196.0/255.0 alpha:1.0];
        self.storeDescription.font = FONT_SYSTEM(17);
        self.storeDescription.layoutManager.allowsNonContiguousLayout = NO;
//        self.storeDescription.layer.borderColor = LX_DEBUG_COLOR;
//        self.storeDescription.layer.borderWidth = 1;
        [self addSubview:self.storeDescription];
        [self.storeDescription updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.storePhone2.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.greaterThanOrEqualTo(38);
        }];

        self.closeStore = [UIButton buttonWithType:UIButtonTypeCustom];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"申请下线"];
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

        self.tipLabel = [[UILabel alloc]init];
        self.tipLabel.text = @"对店铺的修改需要后台审核通过方能生效，如果您是店主，可以使用你的店铺预留的两个电话号码登录，可以即时修改生效。其他问题可以联系客服，电话：010-56286112";
        self.tipLabel.font = LX_TEXTSIZE_14;
        self.tipLabel.textColor = LX_THIRD_TEXT_COLOR;
        self.tipLabel.numberOfLines = 0;
        [self addSubview:self.tipLabel];
        [self.tipLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.right.equalTo(-MARGIN);
            make.top.equalTo(self.closeStore.bottom).offset(MARGIN);
        }];
    }
    return self;
}

-(void)layoutSubviews{
    LXStoreInfoFixView *superView = self;

    if (self.storeDescription.contentSize.height > 0) {
        [self.storeDescription updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.storePhone2.bottom).offset(MARGIN);
            make.right.equalTo(superView.right).offset(-MARGIN);
            make.height.equalTo(CGRectGetHeight(self.storeDescription.frame));
        }];
    }

    [super layoutSubviews];
}

@end
