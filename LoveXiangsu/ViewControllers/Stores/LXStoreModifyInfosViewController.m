//
//  LXStoreModifyInfosViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 16/2/3.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreModifyInfosViewController.h"
#import "LXStoreSelectLocationViewController.h"
#import "LXStoreInfoModifyView.h"
#import "LXStoreGetInfoRequest.h"
#import "LXStoreModifyInfoRequest.h"
#import "LXStoreModifyOnlineRequest.h"
#import "LXStoreInfoResponseModel.h"
#import "LXStoreImageResponseModel.h"

#import "LXUICommon.h"
#import "LXNetManager.h"
#import "VertifyInputFormat.h"
#import "LXUserDefaultManager.h"
#import "LXChooseImage.h"
#import "LXUploadManager.h"
#import "LXNotificationCenterString.h"

#import "NSString+Custom.h"
#import "NSFileManager+util.h"

@interface LXStoreModifyInfosViewController ()<LXStoreSelectLocationDelegate, LXChooseImageDelegate, UIAlertViewDelegate>
{
    LXChooseImage * chooseImg;
}

@property (nonatomic, strong) UIScrollView          * scrollView;
@property (nonatomic, strong) LXStoreInfoModifyView * infoView;
@property (nonatomic)         CLLocationDegrees       lng;
@property (nonatomic)         CLLocationDegrees       lat;
@property (nonatomic, strong) NSMutableDictionary   * imagesDict;

@property (nonatomic)         CGPoint                 oldContentOffset;

@end

@implementation LXStoreModifyInfosViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initialization];
    [self putNavigationBar];
    [self putScrollView];
    [self putElements];
    [self asyncConnectStoreGetInfo];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.infoView.storeName becomeFirstResponder];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshContentSize];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
}

- (void)initialization
{
    if (self.imagesDict == nil) {
        self.imagesDict = [NSMutableDictionary dictionary];
    }
}

- (void)refreshContentSize
{
    self.infoView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(self.infoView.closeStore.frame) + MARGIN);
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(self.infoView.frame));
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxTitleLabel setTitle:@"修改店铺信息" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];

    [self.lxRightBtn1Img setImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
    [self.lxRightBtn1Img addTarget:self action:@selector(lxAddImagesBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxRightBtn1Img.layer.borderWidth = 1;
    //    self.lxRightBtn1Img.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];

    [self.lxRightBtnTitle setTitle:@"修改" forState:UIControlStateNormal];
    self.lxRightBtnTitle.titleLabel.font = LX_TEXTSIZE_20;
    [self.lxRightBtnTitle addTarget:self action:@selector(lxModifyInfosBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxRightBtn2Img.layer.borderWidth = 1;
    //    self.lxRightBtn2Img.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];

    self.navigationController.navigationBar.translucent = NO;
    // 30 127 241
    self.navigationController.navigationBar.barTintColor = LX_PRIMARY_COLOR;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxLeftBtnImg];
    self.navigationItem.titleView = self.lxTitleLabel;
    NSArray * rightBtnItems = @[[[UIBarButtonItem alloc]initWithCustomView:self.lxRightBtnTitle],
                                [[UIBarButtonItem alloc]initWithCustomView:self.lxRightBtn1Img]];
    [self.navigationItem setRightBarButtonItems:rightBtnItems animated:YES];
}

- (void)putScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    self.scrollView.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    [self.view addSubview:self.scrollView];
}

#pragma mark - Element of Page

- (void)putElements
{
    [self.view setBackgroundColor:[UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0]];
    
    self.infoView = [[LXStoreInfoModifyView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    
    self.infoView.storeName.delegate = self;
    [self.infoView.storeName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.infoView.storeName.returnKeyType = UIReturnKeyNext;
    
    self.infoView.storeAddress.delegate = self;
    [self.infoView.storeAddress addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.infoView.storeAddress.returnKeyType = UIReturnKeyNext;
    
    self.infoView.storePhone1.delegate = self;
    [self.infoView.storePhone1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.infoView.storePhone1.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.infoView.storePhone1.returnKeyType = UIReturnKeyNext;
    
    self.infoView.storePhone2.delegate = self;
    [self.infoView.storePhone2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.infoView.storePhone2.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.infoView.storePhone2.returnKeyType = UIReturnKeyNext;

    UITapGestureRecognizer * mapTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mapClick:)];
    self.infoView.location.userInteractionEnabled = YES;
    [self.infoView.location addGestureRecognizer:mapTap];

    self.infoView.storeDescription.delegate = self;

    [self.infoView.closeStore addTarget:self action:@selector(closeStoreClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleClick:)];
    [self.infoView addGestureRecognizer:tap];
    [self.scrollView addGestureRecognizer:tap];
    
    self.infoView.layer.borderColor = LX_DEBUG_COLOR;
    self.infoView.layer.borderWidth = 1;
    [self.scrollView addSubview:self.infoView];
}

#pragma mark - UITextField Delegate

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 32) {
        textField.text = [textField.text substringToIndex:32];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.infoView.storeName) {
        [self.infoView.storeAddress becomeFirstResponder];
    } else if (textField == self.infoView.storeAddress)
    {
        [self.infoView.storePhone1 becomeFirstResponder];
    } else if (textField == self.infoView.storePhone1)
    {
        [self.infoView.storePhone2 becomeFirstResponder];
    } else if (textField == self.infoView.storePhone2)
    {
        [self.infoView.storeDescription becomeFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.oldContentOffset = self.scrollView.contentOffset;

    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.scrollView.contentOffset = CGPointMake(0, CGRectGetMaxY(self.infoView.imageBoardView.frame));
                     }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.scrollView.contentOffset = self.oldContentOffset;
                     }];
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    // 物理点击返回键，并且标题或内容其中一项非空，则弹出提示
    [self.view endEditing:YES];
    if (sender &&
        (![VertifyInputFormat isEmpty:self.infoView.storeName.text]
         || ![VertifyInputFormat isEmpty:self.infoView.storeAddress.text]
         || ![VertifyInputFormat isEmpty:self.infoView.storePhone1.text]
         || ![VertifyInputFormat isEmpty:self.infoView.storePhone2.text]
         || ![VertifyInputFormat isEmpty:self.infoView.storeDescription.text]
         || self.infoView.imageBoardView.imgArray.count > 0)) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未保存的资料会丢失，确认退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alertView show];
            return;
    }
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];

    NSArray *arr = [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"arr = %@", arr);
    if (arr == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)lxAddImagesBtnClick:(id)sender{
    NSLog(@"添加图片按钮 Clicked");
    [self.view endEditing:YES];
    chooseImg = [[LXChooseImage alloc]init];
    [chooseImg showOptionsOnDelegate:self editable:NO withImageTag:0 needMultiSelect:YES needFileType:UPLOAD_OTHER_TYPE completion:^{
        [self refreshView];
    }];
}

- (void)lxModifyInfosBtnClick:(id)sender{
    NSLog(@"申请修改按钮 Clicked");
    
    if (![self submitValidate]) {
        return;
    }
    
    if (self.infoView.imageBoardView.imgArray.count > 0) {
        [self showHUD:@"正在上传图片..." anim:YES];
    } else {
        [self showHUD:@"请稍候..." anim:YES];
    }
    
    NSMutableArray * uploadArray = [NSMutableArray array];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // 1.上传图片文件
        for (int i = 0; i < self.infoView.imageBoardView.imgArray.count; i ++) {
            NSString * imgPathStr = self.infoView.imageBoardView.imgArray[i];
            NSString * objectKey = [self.infoView.imageBoardView.objectKeyDict objectForKey:imgPathStr];
            if (objectKey) {
                NSString * tip = [NSString stringWithFormat:@"正在上传图片...%d/%lu", (i+1), (unsigned long)self.infoView.imageBoardView.imgArray.count];
                [self showHUD:tip anim:YES];
                if ([[LXUploadManager sharedInstance] uploadObjectSync:objectKey source:imgPathStr]) {
                    //                NSString * save_url = [NSString stringWithFormat:@"%@", objectKey];
                    NSDictionary * uploadDict = @{@"url":objectKey};
                    [uploadArray addObject:uploadDict];
                }
            } else {
                NSString * objectKey = [self.imagesDict objectForKey:imgPathStr];
                if (objectKey) {
                    //                NSString * save_url = [NSString stringWithFormat:@"%@", objectKey];
                    NSDictionary * uploadDict = @{@"url":objectKey};
                    [uploadArray addObject:uploadDict];
                }
            }
        }
        
        NSString * json = [NSString toJSONData:uploadArray];
        NSLog(@"json = %@", json);
        
        // 2.调用发帖子接口
        [self asyncConnectStoreModifyInfo:json];
    });
}

- (void)singleClick:(UITapGestureRecognizer * )recognizer
{
    [self.view endEditing:YES];
}

- (void)mapClick:(UITapGestureRecognizer * )recognizer
{
    NSLog(@"进入高德地图按钮 Clicked");
    LXStoreSelectLocationViewController * vc = [[LXStoreSelectLocationViewController alloc]init];
    CLLocationCoordinate2D storeCoordinate = CLLocationCoordinate2DMake(self.lat, self.lng);
    vc.storeCoordinate = storeCoordinate;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)closeStoreClick:(id)sender
{
    NSLog(@"商家下线按钮 Clicked");
    [self asyncConnectStoreModifyOnline];
}

- (void)refreshView
{
    [self.view setNeedsLayout];
//    if (IOS8_OR_LATER) {
        [self.infoView.imageBoardView setNeedsLayout];
//    }
}

#pragma mark - Validation

- (BOOL)submitValidate
{
    if ([self.infoView.storeName.text length] < 4) {
        [self showTips:@"店名不能少于4个汉字" delay:2.0 anim:YES];
        return NO;
    }
    if ([VertifyInputFormat isEmpty:self.infoView.storeDescription.text]) {
        [self showTips:@"店铺详情描述不能为空" delay:2.0 anim:YES];
        return NO;
    }
    
    return YES;
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"点击了取消！");
        }
            break;
        case 1:
        {
            NSLog(@"点击了确认！");
            [self lxLeftBtnImgClick:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Image Picker Delegate

/**
 * 图片选择结束后，回调压缩后的图片data,tag用于区分不同的选择图片
 */
- (void)chooseImageDidGetImageData:(NSData *)imageData withImageTag:(int)tag
{
    if (!imageData) {
        NSLog(@"错误：所选择的图片数据为空！");
        return;
    }
    
    NSString * docDir = [NSFileManager getDocumentsPath];
    
    NSString * objectKey = [[LXUploadManager sharedInstance] makeObjectKey:LXUPLOAD_OTHER];
    
    NSString * filePath = [docDir stringByAppendingFormat:@"/%@/%@", SANDBOX_IMAGE_PATH, objectKey];
    NSLog(@"图片文件路径： %@", filePath);
    
    [NSFileManager createFilePath:filePath deleteOldFile:YES];
    
    [imageData writeToFile:filePath atomically:YES];
    
    if (self.infoView.imageBoardView.imgArray.count >= 9) {
        [self showError:@"最多可以添加9张图片" delay:2 anim:YES];
    } else {
        [self.infoView.imageBoardView.imgArray addObject:filePath];
        [self.infoView.imageBoardView.objectKeyDict setObject:objectKey forKey:filePath];
    }
}

#pragma mark -高德地图选择器回调

- (void)mapView:(MAMapView *)mapView didSelectLocation:(CLLocationCoordinate2D)coordinate
{
    self.lat = coordinate.latitude;
    self.lng = coordinate.longitude;
    self.infoView.location.text = [NSString stringWithFormat:@"位置：%.6f,%.6f", self.lng, self.lat];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - 网络请求及相应的回调方法

-(void)asyncConnectStoreGetInfo{
    [self showHUD:@"正在加载..." anim:YES];
    LXStoreGetInfoRequest * request = [[LXStoreGetInfoRequest alloc]init];//初始化网络请求
    
    request.requestMethod = LXRequestMethodGet;
    request.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    request.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    request.delegate = self;//代理设置
    request.tag = 1001;//类型标识
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.store_id forKey:@"store_id"];
    [request setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

-(void)asyncConnectStoreModifyInfo:(NSString *)imageJSON{
    [self showHUD:@"正在提交..." anim:YES];
    LXStoreModifyInfoRequest * request = [[LXStoreModifyInfoRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识
    
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.store_id forKey:@"store_id"];
    [paraDic setObject:self.infoView.storeName.text forKey:@"name"];
    [paraDic setObject:self.infoView.storeDescription.text forKey:@"description"];

    [paraDic setObject:imageJSON forKey:@"images"];

    [paraDic setObject:self.infoView.storePhone1.text forKey:@"phone1"];
    [paraDic setObject:self.infoView.storePhone2.text forKey:@"phone2"];

    [paraDic setObject:[NSString stringWithFormat:@"%f", self.lng] forKey:@"lng"];
    [paraDic setObject:[NSString stringWithFormat:@"%f", self.lat] forKey:@"lat"];

    [paraDic setObject:self.infoView.storeAddress.text forKey:@"address"];

    [paraDic setObject:self.infoView.fulldaySwitch.on?@"true":@"false" forKey:@"fullday"];
    [paraDic setObject:self.infoView.o2oSwitch.on?@"true":@"false" forKey:@"d2d"];
    
    [request setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

-(void)asyncConnectStoreModifyOnline{
    [self showHUD:@"正在提交..." anim:YES];
    LXStoreModifyOnlineRequest * request = [[LXStoreModifyOnlineRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1002;//类型标识
    
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.store_id forKey:@"store_id"];
    [paraDic setObject:@"0"          forKey:@"online"];
    [request setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

// 网络请求回调
-(void)requestResult:(NSError*) error withData:(id)responseObject responseData:(LXBaseRequest*)requestData
{
    if (requestData.tag == 1000) {
        if (error) {
            //对error进行相应的处理
            NSLog(@"%@",[[error userInfo] objectForKey:@"NSLocalizedDescription"]);
            
            [self showError:[[error userInfo] objectForKey:@"NSLocalizedDescription"] delay:2 anim:YES];
            return;
        }
        
        // 成功时有时也会有成功Message
        if (![VertifyInputFormat isEmpty:requestData.successMsg]) {
            [self showSuccess:requestData.successMsg delay:2 anim:YES];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_refreshStoreDetail object:nil userInfo:nil];
        [self lxLeftBtnImgClick:nil];
    } else if (requestData.tag == 1001) {
        if (error) {
            //对error进行相应的处理
            NSLog(@"%@",[[error userInfo] objectForKey:@"NSLocalizedDescription"]);
            
            [self showError:[[error userInfo] objectForKey:@"NSLocalizedDescription"] delay:2 anim:YES];
            return;
        }
        
        // 成功时有时也会有成功Message
        if (![VertifyInputFormat isEmpty:requestData.successMsg]) {
            [self showSuccess:requestData.successMsg delay:2 anim:YES];
        }
        
        // 将返回的数据进行model转换（注意：要加上对model类型的校验）
        LXStoreInfoResponseModel * model = nil;
        if ([responseObject isKindOfClass:[LXStoreInfoResponseModel class]]) {
            model = (LXStoreInfoResponseModel *)responseObject;
            self.infoView.storeName.text = model.name;
            self.infoView.storeAddress.text = model.address;
            self.infoView.storePhone1.text = model.phone1;
            self.infoView.storePhone2.text = model.phone2;
            NSArray *switchArray = [model.tags analyzeStoreTags];
            if ([switchArray indexOfObject:@"外送"] != NSNotFound) {
                [self.infoView.o2oSwitch setOn:YES animated:NO];
            }
            if ([switchArray indexOfObject:@"24小时"] != NSNotFound) {
                [self.infoView.fulldaySwitch setOn:YES animated:NO];
            }
            self.infoView.location.text = [NSString stringWithFormat:@"位置：%@,%@", model.lng, model.lat];
            self.lng = [model.lng doubleValue];
            self.lat = [model.lat doubleValue];

            self.infoView.storeDescription.text = model.description;

            for (LXStoreImageResponseModel * imgModel in model.images) {
                [self.imagesDict setObject:imgModel.save_url forKey:imgModel.url];
                [self.infoView.imageBoardView.imgArray addObject:imgModel.url];
            }

            [self refreshView];

            [self hideHUD:YES];
            
            return;
        } else {
            [self showError:@"获取店铺信息失败" delay:2 anim:YES];
        }
    } else if (requestData.tag == 1002) {
        if (error) {
            //对error进行相应的处理
            NSLog(@"%@",[[error userInfo] objectForKey:@"NSLocalizedDescription"]);
            
            [self showError:[[error userInfo] objectForKey:@"NSLocalizedDescription"] delay:2 anim:YES];
            return;
        }
        
        // 成功时有时也会有成功Message
        if (![VertifyInputFormat isEmpty:requestData.successMsg]) {
            NSLog(@"%@", requestData.successMsg);
            [self showSuccess:@"店铺已下线" delay:2 anim:YES];
        }
        
        [self lxLeftBtnImgClick:nil];
    }

    return;
}

@end
