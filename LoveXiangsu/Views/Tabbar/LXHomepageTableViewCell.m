//
//  LXHomepageTableViewCell.m
//  LoveXiangsu
//
//  Created by yangjun on 15/11/2.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXHomepageTableViewCell.h"
#import "LXUICommon.h"
#import "UILabel+VerticalAlign.h"

@implementation LXHomepageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        LXHomepageTableViewCell *superCell = self;
        self.storeImg = [[UIImageView alloc]init];
        [self addSubview:self.storeImg];
        [self.storeImg makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(MARGIN);
            make.width.equalTo(StoreImgWidth);
            make.height.equalTo(StoreImgHeight);
        }];
        
        self.storeStarLvImg = [[UIImageView alloc]init];
        self.storeStarLvImg.layer.borderColor = LX_DEBUG_COLOR;
        self.storeStarLvImg.layer.borderWidth = 1;
        [self addSubview:self.storeStarLvImg];
        [self.storeStarLvImg makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(MARGIN);
            make.top.equalTo(self.storeImg.bottom).offset(StoreRowGap);
            make.width.equalTo(self.storeImg.width);
            make.height.equalTo(StoreStarHeight);
        }];

        self.callingImg = [[UIImageView alloc]init];
        self.callingImg.layer.borderColor = LX_DEBUG_COLOR;
        self.callingImg.layer.borderWidth = 1;
        [self addSubview:self.callingImg];
        [self.callingImg makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(MARGIN);
            make.right.equalTo(self.right).offset(-MARGIN);
            make.width.height.equalTo(CallingImgSize);
        }];

        self.callTimesLabel = [[UILabel alloc]init];
        self.callTimesLabel.font = LX_TEXTSIZE_12;
        self.callTimesLabel.textColor = LX_THIRD_TEXT_COLOR;
        self.callTimesLabel.textAlignment = NSTextAlignmentRight;
        self.callTimesLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.callTimesLabel.layer.borderWidth = 1;
        [self addSubview:self.callTimesLabel];
        [self.callTimesLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.callingImg.bottom).offset(StoreRowGap/2);
            make.right.equalTo(self.right).offset(-MARGIN);
            make.width.equalTo(CallingImgSize + MARGIN);
            make.height.equalTo(CallTimesHeight);
        }];

        self.distanceLabel = [[UILabel alloc]init];
        self.distanceLabel.font = LX_TEXTSIZE_12;
        self.distanceLabel.textColor = LX_THIRD_TEXT_COLOR;
        self.distanceLabel.textAlignment = NSTextAlignmentRight;
        self.distanceLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.distanceLabel.layer.borderWidth = 1;
        [self addSubview:self.distanceLabel];
        [self.distanceLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.callTimesLabel.bottom).offset(StoreRowGap/2);
            make.right.equalTo(self.right).offset(-MARGIN);
            make.width.equalTo(CallingImgSize + MARGIN);
            make.height.equalTo(CallTimesHeight);
        }];

        self.callingView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.callingView.layer.borderColor = LX_DEBUG_COLOR;
        self.callingView.layer.borderWidth = 1;
        [self addSubview:self.callingView];
        [self.callingView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.callingImg.top);
            make.right.equalTo(superCell.right);
            make.bottom.equalTo(self.distanceLabel.bottom);
            make.left.equalTo(self.distanceLabel.left);
        }];

        self.storeNameLabel = [[UILabel alloc]init];
        self.storeNameLabel.textColor = LX_SECOND_TEXT_COLOR;
        self.storeNameLabel.clipsToBounds = NO;
        self.storeNameLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.storeNameLabel.layer.borderWidth = 1;
        [self addSubview:self.storeNameLabel];
        [self.storeNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.storeImg.right).offset(PADDING);
            make.top.equalTo(MARGIN);
            make.right.equalTo(self.callingImg.left).offset(-MARGIN);
            // 高度等于MARGIN即可
            make.height.equalTo(MARGIN);
        }];

        self.storeTag1Img = [[UIImageView alloc]init];
        [self addSubview:self.storeTag1Img];
        [self.storeTag1Img makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.storeImg.right).offset(PADDING);
            make.top.equalTo(self.storeNameLabel.bottom).offset(StoreRowGap);
            // 宽度和高度等于MARGIN即可
            make.width.height.equalTo(MARGIN);
        }];

        self.storeTag2Img = [[UIImageView alloc]init];
        [self addSubview:self.storeTag2Img];
        [self.storeTag2Img makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.storeTag1Img.right).offset(0);
            make.top.equalTo(self.storeNameLabel.bottom).offset(StoreRowGap);
            // 宽度和高度等于MARGIN即可
            make.width.height.equalTo(MARGIN);
        }];

        self.storeTag3Img = [[UIImageView alloc]init];
        [self addSubview:self.storeTag3Img];
        [self.storeTag3Img makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.storeTag2Img.right).offset(0);
            make.top.equalTo(self.storeNameLabel.bottom).offset(StoreRowGap);
            // 宽度和高度等于MARGIN即可
            make.width.height.equalTo(MARGIN);
        }];

        self.storeTag4Img = [[UIImageView alloc]init];
        [self addSubview:self.storeTag4Img];
        [self.storeTag4Img makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.storeTag3Img.right).offset(0);
            make.top.equalTo(self.storeNameLabel.bottom).offset(StoreRowGap);
            // 宽度和高度等于MARGIN即可
            make.width.height.equalTo(MARGIN);
        }];

        self.storeDescLabel = [[UILabel alloc]init];
        self.storeDescLabel.numberOfLines = 2;
        self.storeDescLabel.font = LX_TEXTSIZE_12;
        self.storeDescLabel.textColor = LX_THIRD_TEXT_COLOR;
        self.storeDescLabel.layer.borderColor = LX_DEBUG_COLOR;
        self.storeDescLabel.layer.borderWidth = 1;
        [self addSubview:self.storeDescLabel];
        [self.storeDescLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.storeImg.right).offset(PADDING);
            make.top.equalTo(self.storeNameLabel.bottom).offset(StoreRowGap * 2 + MARGIN);
            make.right.equalTo(self.callingImg.left).offset(-MARGIN);
            make.height.equalTo(MARGIN * 2);
        }];

        self.cellSeparator = [[UIView alloc]init];
        // [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0]
        self.cellSeparator.layer.borderColor = [LX_THIRD_TEXT_COLOR CGColor];
        self.cellSeparator.layer.borderWidth = BorderWidth05;
        [self addSubview:self.cellSeparator];
        [self.cellSeparator makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superCell.left);
            make.right.equalTo(superCell.right);
            make.top.equalTo(superCell.top);
            make.height.equalTo(BorderWidth05);
            make.width.equalTo(ScreenWidth);
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

    if (self.storeTag1Img.hidden) {
        [self.storeDescLabel updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.storeNameLabel.bottom).offset(StoreRowGap * 2);
        }];
    } else {
        [self.storeDescLabel updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.storeNameLabel.bottom).offset(StoreRowGap * 2 + MARGIN);
        }];
    }
    if ([self.storeDescLabel.text hasSuffix:@"\n "]) {
        NSLog(@"店铺描述：%@，无需再次处理~~~~~", self.storeDescLabel.text);
        return;
    }
    NSLog(@"(Before)StoreDescription = %@!!!!!", self.storeDescLabel.text);
    double finalWidth = ScreenWidth - MARGIN * 2 - StoreImgWidth - PADDING - CallingImgSize - MARGIN;
    double realHeight = [self.storeDescLabel alignTop:finalWidth];
    NSLog(@"(After )StoreDescription = %@!!!!!", self.storeDescLabel.text);
    [self.storeDescLabel updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(realHeight + 0.5);
    }];
}

//- (void)updateConstraints
//{
//    [super updateConstraints];
//
//    NSLog(@"(Before)StoreDescription = %@!!!!!", self.storeDescLabel.text);
//    double realHeight = [self.storeDescLabel alignTop];
//    NSLog(@"(After )StoreDescription = %@!!!!!", self.storeDescLabel.text);
//    [self.storeDescLabel updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(realHeight + 0.5);
//    }];
//}

@end
