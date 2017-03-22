//
//  LXChooseImage.m
//  LoveXiangsu
//
//  Created by yangjun on 15/12/21.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "UIImage+Resize.h"
#import "DoImagePickerController.h"

#import "LXNotificationCenterString.h"
#import "LXBaseViewController.h"
#import "AppDelegate.h"
#import "LXChooseImage.h"
#import "LXCommon.h"

typedef void (^CompletionBlock)(void);

@interface LXChooseImage()<UIActionSheetDelegate, DoImagePickerControllerDelegate>

@property (nonatomic, assign) int imageTag;
@property (nonatomic, assign) BOOL editable; // 是否可编辑
@property (nonatomic, assign) BOOL multiSelect; // 是否可多选
@property (nonatomic, strong) NSString * fileType; // 要求返回的文件类型

@property (readwrite, nonatomic, copy) CompletionBlock completionBlock;

@end

@implementation LXChooseImage

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageCompressioRatio = 0.00001;
        self.imageTag = 1;
    }
    return self;
}

- (void)showOptionsOnDelegate:(id<LXChooseImageDelegate>)delegate editable:(BOOL)editable withImageTag:(int)tag needMultiSelect:(BOOL)multiSelect needFileType:(NSString *)fileType completion: (void (^)(void))completion
{
    if (!delegate) {
        return;
    }

    self.imageTag = tag;
    self.delegate = delegate;
    self.editable = editable;
    self.multiSelect = multiSelect;
    self.fileType = fileType;
    self.completionBlock = completion;

    UIActionSheet *imageActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"选择本地图片", nil];
    imageActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    imageActionSheet.destructiveButtonIndex = 3;
    [imageActionSheet showInView:((LXBaseViewController *)self.delegate).view];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    switch (buttonIndex) {
        case 0: // 相机
        {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
            {
//                NSString * msg = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”选项中，允许i%@访问你的相机", COMMUNITY_APPNAME];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:CAMERA_TIP_MSG delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                
                return;
            }
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
            break;
        case 1: // 相册
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                if (self.multiSelect) {
                    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
                    cont.delegate = self;
                    cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
                    cont.nMaxCount = MAX_UPLOAD_IMAGE;
//                    if (MAX_UPLOAD_IMAGE >= 9)
//                    {
//                        cont.nResultType = DO_PICKER_RESULT_ASSET;  // if you want to get lots photos, you'd better use this mode for memory!!!
//                    }
                    cont.nColumnCount = 3;

                    [(LXBaseViewController *)self.delegate presentViewController:cont animated:YES completion:nil];
                    return;
                }
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            } else {
//                NSString * msg = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-照片”选项中，允许i%@访问你的手机相册", COMMUNITY_APPNAME];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:ALBUM_TIP_MSG delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];

                return;
            }
        }
            break;
        case 2:
            return;
    }

    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = self.editable;
    imagePickerController.sourceType = sourceType;
    if (self.delegate) {
        [(LXBaseViewController *)self.delegate presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = nil;
    if ([picker allowsEditing]){
        selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }

    NSData *imageData = [self compressImage:selectedImage];
    NSLog(@"质量压缩后分辨率:%f  %f",[UIImage imageWithData:imageData].size.width, [UIImage imageWithData:imageData].size.height);

    // 回调协议方法，选择图片完成
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseImageDidGetImageData:withImageTag:)]) {
        [self.delegate chooseImageDidGetImageData:imageData withImageTag:self.imageTag];
    }

    [picker dismissViewControllerAnimated:YES completion:nil];

    if (self.completionBlock) {
        self.completionBlock();
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //用户取消操作
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DoImagePicker Delegate

- (void)didCancelDoImagePickerController:(DoImagePickerController *)picker
{
    //用户取消操作
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    for (UIImage * selectedImage in aSelected) {
        NSData *imageData = [self compressImage:selectedImage];
        NSLog(@"质量压缩后分辨率:%f  %f",[UIImage imageWithData:imageData].size.width, [UIImage imageWithData:imageData].size.height);
        
        // 回调协议方法，选择图片完成
        if (self.delegate && [self.delegate respondsToSelector:@selector(chooseImageDidGetImageData:withImageTag:)]) {
            [self.delegate chooseImageDidGetImageData:imageData withImageTag:self.imageTag];
        }
    }

    [picker dismissViewControllerAnimated:YES completion:nil];

    if (self.completionBlock) {
        self.completionBlock();
    }
}

#pragma mark - 图片压缩处理

- (NSData *)compressImage:(UIImage *)sourceImg
{
    //解决图片其他平台显示旋转的问题
    UIImage * selectedImage = [sourceImg fixOrientation];
    
    
    //压缩图片，默认压缩比为万分之一
    //    if (selectedImage.) {//判断是否小于500k 是则不压缩
    //        <#statements#>
    //    }
    NSLog(@"压缩前分辨率:%f  %f",selectedImage.size.width, selectedImage.size.height);
    
    CGFloat width = selectedImage.size.width;
    CGFloat height = selectedImage.size.height;
    
    // 图片的长边不能超过1440
    if (width >= height && width > (CGFloat)MAX_IMAGE_SIZE) {
        CGFloat radio = width / (CGFloat)MAX_IMAGE_SIZE;
        width = (CGFloat)MAX_IMAGE_SIZE;
        height = height / radio;
    } else if (height > (CGFloat)MAX_IMAGE_SIZE) {
        CGFloat radio = height / (CGFloat)MAX_IMAGE_SIZE;
        height = (CGFloat)MAX_IMAGE_SIZE;
        width = width / radio;
    }
    selectedImage = [selectedImage resizedImage:CGSizeMake(width, height) interpolationQuality:kCGInterpolationMedium];
    
    NSLog(@"压缩后分辨率:%f  %f",selectedImage.size.width, selectedImage.size.height);

    NSData *imageData = nil;
    if ([self.fileType hasSuffix:@"png"]) {
        // 生成PNG文件
        imageData = UIImagePNGRepresentation(selectedImage);
    } else if ([self.fileType hasSuffix:@"jpg"]) {
        // 生成JPG文件，并进行质量压缩
        imageData = UIImageJPEGRepresentation(selectedImage, _imageCompressioRatio);
    }
    return imageData;
}

@end
