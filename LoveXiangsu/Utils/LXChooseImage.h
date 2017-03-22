//
//  LXChooseImage.h
//  LoveXiangsu
//
//  Created by yangjun on 15/12/21.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LXBaseViewController;

@protocol LXChooseImageDelegate <NSObject>

@required

/**
 * 图片选择结束后，回调压缩后的图片data,tag用于区分不同的选择图片
 */
- (void)chooseImageDidGetImageData:(NSData *)imageData withImageTag:(int)tag;

@end

@interface LXChooseImage : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) float imageCompressioRatio; // 压缩比,默认万分之一
@property (nonatomic, weak) id <LXChooseImageDelegate> delegate;

/**
 * 显示ActionSheet，让用户选择照片来源，注意ARC模式下要把本类的对象设置为全局变量或属性，否则会因为对象被释放而不调系统代理
 */
- (void)showOptionsOnDelegate:(id<LXChooseImageDelegate>)delegate editable:(BOOL)editable withImageTag:(int)tag needMultiSelect:(BOOL)multiSelect needFileType:(NSString *)fileType completion: (void (^)(void))completion;

@end
