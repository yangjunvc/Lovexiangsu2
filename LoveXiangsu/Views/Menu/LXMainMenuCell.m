//
//  LXMainMenuCell.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/10/21.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXMainMenuCell.h"
#import "LXUICommon.h"

@implementation LXMainMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        LXMainMenuCell *superCell = self;

        self.contentImg = [[UIImageView alloc]init];
        [self addSubview:self.contentImg];
        [self.contentImg makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(MARGIN);
            make.bottom.equalTo(superCell).offset(-MARGIN);
            make.width.height.equalTo(IconSize);
        }];

        self.contentLabel = [[UILabel alloc]init];
        [self addSubview:self.contentLabel];
        [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superCell).offset(MARGIN);
            make.bottom.equalTo(superCell).offset(-MARGIN);
            make.right.equalTo(superCell).offset(-MARGIN);
            make.left.equalTo(superCell.contentImg.right).offset(PADDING);
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

@end
