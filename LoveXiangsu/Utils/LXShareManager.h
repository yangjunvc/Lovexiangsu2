//
//  LXShareManager.h
//  LoveXiangsu
//
//  Created by yangjun on 16/1/13.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LXShareActionDelegate <NSObject>

@required

- (void)showLoadingView:(BOOL)flag;

@end

@interface LXShareManager : NSObject

@property (nonatomic, weak) id <LXShareActionDelegate> delegate;

+ (LXShareManager *)sharedInstance;
- (void)showShareActionSheetOnView:(UIView *)view withDelegate:(id)delegate andTitle:(NSString *)title andContent:(NSString *)text andURL:(NSString *)url andIcon:(NSString *)iconfile;

@end
