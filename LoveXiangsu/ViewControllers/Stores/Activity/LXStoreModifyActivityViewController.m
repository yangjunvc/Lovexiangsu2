//
//  LXStoreModifyActivityViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 16/2/21.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreModifyActivityViewController.h"
#import "LXStoreActivityView.h"
#import "LXStoreModifyActivityRequest.h"
#import "LXStoreGetActivityInfoRequest.h"
#import "LXStoreDeleteActivityRequest.h"
#import "LXActivityInfoResponseModel.h"

#import "LXUICommon.h"
#import "LXNetManager.h"
#import "VertifyInputFormat.h"
#import "LXUserDefaultManager.h"
#import "LXChooseImage.h"
#import "LXUploadManager.h"
#import "LXNotificationCenterString.h"

#import "NSString+Custom.h"
#import "NSFileManager+util.h"
#import "DateHelper.h"
#import "KMDatePicker.h"
#import "NSDate+CalculateDay.h"

static NSString * dateFormat = @"yyyy-MM-dd";

@interface LXStoreModifyActivityViewController ()<LXChooseImageDelegate, UIAlertViewDelegate, KMDatePickerDelegate>
{
    LXChooseImage * chooseImg;
}

@property (nonatomic, strong) UIScrollView          * scrollView;
@property (nonatomic, strong) LXStoreActivityView   * activityView;

@property (nonatomic, strong) NSString              * beginTime;
@property (nonatomic, strong) NSString              * finishTime;

@property (nonatomic, strong) NSMutableDictionary   * imagesDict;

@property (nonatomic)         CGPoint                 oldContentOffset;

@end

@implementation LXStoreModifyActivityViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialization];
    [self putNavigationBar];
    [self putScrollView];
    [self putElements];
    [self asyncConnectStoreGetActivityInfo];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityView.activityName becomeFirstResponder];
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

- (void)refreshContentSize
{
    self.activityView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(self.activityView.deleteActivity.frame) + MARGIN);
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(self.activityView.frame));
}

#pragma mark - Initialization

- (void)initialization
{
    NSDate * localDate = [DateHelper localeDate];
    self.beginTime = [DateHelper dateToString:localDate withFormat:dateFormat];
    NSDate * monthAfterDate = [localDate addMonthAndDay:1 days:1];
    self.finishTime = [DateHelper dateToString:monthAfterDate withFormat:dateFormat];

    if (self.imagesDict == nil) {
        self.imagesDict = [NSMutableDictionary dictionary];
    }
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxTitleLabel setTitle:@"修改优惠活动" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxRightBtn1Img setImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
    [self.lxRightBtn1Img addTarget:self action:@selector(lxAddImagesBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxRightBtn1Img.layer.borderWidth = 1;
    //    self.lxRightBtn1Img.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxRightBtnTitle setTitle:@"修改" forState:UIControlStateNormal];
    self.lxRightBtnTitle.titleLabel.font = LX_TEXTSIZE_20;
    [self.lxRightBtnTitle addTarget:self action:@selector(lxModifyActivityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
    
    self.activityView = [[LXStoreActivityView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    
    self.activityView.activityName.delegate = self;
    [self.activityView.activityName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.activityView.activityName.returnKeyType = UIReturnKeyNext;
    
    [self.activityView.beginTimeLabel setText:[NSString stringWithFormat:@"活动开始时间：%@", self.beginTime]];
    
    //开始年月日
    KMDatePicker *beginDatePicker = [[KMDatePicker alloc]
                                     initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, 216.0)
                                     delegate:self
                                     datePickerStyle:KMDatePickerStyleYearMonthDay];
    beginDatePicker.minLimitedDate = [DateHelper localeDate];
    self.activityView.beginTimeLabel.inputView = beginDatePicker;
    self.activityView.beginTimeLabel.delegate = self;
    
    [self.activityView.endTimeLabel setText:[NSString stringWithFormat:@"活动结束时间：%@", self.finishTime]];
    
    //截止年月日
    KMDatePicker *endDatePicker = [[KMDatePicker alloc]
                                   initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, 216.0)
                                   delegate:self
                                   datePickerStyle:KMDatePickerStyleYearMonthDay];
    endDatePicker.minLimitedDate = [DateHelper localeDate];
    self.activityView.endTimeLabel.inputView = endDatePicker;
    self.activityView.endTimeLabel.delegate = self;
    
    self.activityView.activityDescription.delegate = self;

    [self.activityView.deleteActivity addTarget:self action:@selector(deleteActivityClick:) forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleClick:)];
    [self.activityView addGestureRecognizer:tap];
    [self.scrollView addGestureRecognizer:tap];
    
    self.activityView.layer.borderColor = LX_DEBUG_COLOR;
    self.activityView.layer.borderWidth = 1;
    [self.scrollView addSubview:self.activityView];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.activityView.beginTimeLabel) {
        KMDatePicker *beginDatePicker = (KMDatePicker *)self.activityView.beginTimeLabel.inputView;
        beginDatePicker.scrollToDate = [DateHelper dateFromString:self.beginTime withFormat:dateFormat];
        [beginDatePicker updateShowTime];
    } else if (textField == self.activityView.endTimeLabel) {
        KMDatePicker *endDatePicker = (KMDatePicker *)self.activityView.endTimeLabel.inputView;
        endDatePicker.scrollToDate = [DateHelper dateFromString:self.finishTime withFormat:dateFormat];
        [endDatePicker updateShowTime];
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 32) {
        textField.text = [textField.text substringToIndex:32];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.activityView.activityName) {
        [self.activityView.activityDescription becomeFirstResponder];
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
                         self.scrollView.contentOffset = CGPointMake(0, CGRectGetMaxY(self.activityView.endTimeLabel.frame));
                     }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.scrollView.contentOffset = self.oldContentOffset;
                     }];
}

#pragma mark - KMDatePicker Delegate

- (void)datePicker:(KMDatePicker *)datePicker didSelectDate:(KMDatePickerDateModel *)datePickerDate
{
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",
                         datePickerDate.year,
                         datePickerDate.month,
                         datePickerDate.day
                         ];
    if (self.activityView.beginTimeLabel.inputView == datePicker) {
        self.beginTime = dateStr;
        [self.activityView.beginTimeLabel setText:[NSString stringWithFormat:@"活动开始时间：%@", self.beginTime]];
    } else if (self.activityView.endTimeLabel.inputView == datePicker) {
        self.finishTime = dateStr;
        [self.activityView.endTimeLabel setText:[NSString stringWithFormat:@"活动结束时间：%@", self.finishTime]];
    }
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    // 物理点击返回键，并且标题或内容其中一项非空，则弹出提示
    [self.view endEditing:YES];
    if (sender &&
        (![VertifyInputFormat isEmpty:self.activityView.activityName.text]
         || ![VertifyInputFormat isEmpty:self.activityView.activityDescription.text]
         || self.activityView.imageBoardView.imgArray.count > 0)) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未保存的资料会丢失，确认退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alertView.tag = 1;
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
    [chooseImg showOptionsOnDelegate:self editable:NO withImageTag:0 needMultiSelect:NO needFileType:UPLOAD_OTHER_TYPE completion:^{
        [self refreshView];
    }];
}

- (void)lxModifyActivityBtnClick:(id)sender{
    NSLog(@"修改活动按钮 Clicked");
    
    if (![self submitValidate]) {
        return;
    }
    
    if (self.activityView.imageBoardView.imgArray.count > 0) {
        [self showHUD:@"正在上传图片..." anim:YES];
    } else {
        [self showHUD:@"请稍候..." anim:YES];
    }
    
    NSMutableArray * uploadArray = [NSMutableArray array];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // 1.上传图片文件
        for (int i = 0; i < self.activityView.imageBoardView.imgArray.count; i ++) {
            NSString * imgPathStr = self.activityView.imageBoardView.imgArray[i];
            NSString * objectKey = [self.activityView.imageBoardView.objectKeyDict objectForKey:imgPathStr];
            if (objectKey) {
                NSString * tip = [NSString stringWithFormat:@"正在上传图片...%d/%lu", (i+1), (unsigned long)self.activityView.imageBoardView.imgArray.count];
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
        [self asyncConnectStoreModifyActivity:json];
    });
}

- (void)deleteActivityClick:(id)sender
{
    NSLog(@"删除活动按钮 Clicked");
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认要删除这条优惠活动吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.tag = 2;
    [alertView show];
}

- (void)singleClick:(UITapGestureRecognizer * )recognizer
{
    [self.view endEditing:YES];
}

- (void)refreshView
{
    [self.view setNeedsLayout];
//    if (IOS8_OR_LATER) {
        [self.activityView.imageBoardView setNeedsLayout];
//    }
}

#pragma mark - Validation

- (BOOL)submitValidate
{
    if ([self.activityView.activityName.text length] < 4) {
        [self showTips:@"活动名称不能少于4个汉字" delay:2.0 anim:YES];
        return NO;
    }
    if ([VertifyInputFormat isEmpty:self.activityView.activityDescription.text]) {
        [self showTips:@"活动详情描述不能为空" delay:2.0 anim:YES];
        return NO;
    }
    NSDate * beginDate = [DateHelper dateFromString:self.beginTime withFormat:dateFormat];
    NSString * nowDate = [DateHelper dateToString:[DateHelper localeDate] withFormat:dateFormat];
    if ([beginDate isEarlierThan:[DateHelper dateFromString:nowDate withFormat:dateFormat]]) {
        [self showTips:@"活动开始时间必须大于当前时间。" delay:2.0 anim:YES];
        return NO;
    }
    NSDate * finishDate = [DateHelper dateFromString:self.finishTime withFormat:dateFormat];
    if (![beginDate isEarlierThanOrEqualTo:finishDate]) {
        [self showTips:@"开始时间必须小于结束时间。" delay:2.0 anim:YES];
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
            if (alertView.tag == 1) {
                [self lxLeftBtnImgClick:nil];
            } else if (alertView.tag == 2) {
                [self asyncConnectStoreDeleteActivity];
            }
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
    
    if (self.activityView.imageBoardView.imgArray.count >= 1) {
        [self showError:@"最多可以添加1张图片" delay:2 anim:YES];
    } else {
        [self.activityView.imageBoardView.imgArray addObject:filePath];
        [self.activityView.imageBoardView.objectKeyDict setObject:objectKey forKey:filePath];
    }
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

-(void)asyncConnectStoreGetActivityInfo{
    [self showHUD:@"正在加载..." anim:YES];
    LXStoreGetActivityInfoRequest * request = [[LXStoreGetActivityInfoRequest alloc]init];//初始化网络请求
    
    request.requestMethod = LXRequestMethodGet;
    request.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    request.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    request.delegate = self;//代理设置
    request.tag = 1001;//类型标识
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.activity_id forKey:@"activity_id"];
    [request setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

-(void)asyncConnectStoreModifyActivity:(NSString *)imageJSON{
    [self showHUD:@"正在提交..." anim:YES];
    LXStoreModifyActivityRequest * request = [[LXStoreModifyActivityRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识

    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }

    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.activity_id forKey:@"activity_id"];
    [paraDic setObject:self.activityView.activityName.text forKey:@"name"];
    [paraDic setObject:self.activityView.activityDescription.text forKey:@"description"];
    
    [paraDic setObject:self.beginTime forKey:@"begin_at"];
    [paraDic setObject:self.finishTime forKey:@"finish_at"];
    
    [paraDic setObject:imageJSON forKey:@"images"];
    [request setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

-(void)asyncConnectStoreDeleteActivity{
    [self showHUD:@"正在提交..." anim:YES];
    LXStoreDeleteActivityRequest * request = [[LXStoreDeleteActivityRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1002;//类型标识
    
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.activity_id forKey:@"activity_id"];
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

        [self performSelector:@selector(sendNotification) withObject:nil afterDelay:2.0];
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
        LXActivityInfoResponseModel * model = nil;
        if ([responseObject isKindOfClass:[LXActivityInfoResponseModel class]]) {
            model = (LXActivityInfoResponseModel *)responseObject;
            self.activityView.activityName.text = model.name;
            self.activityView.activityDescription.text = model.description;

            self.beginTime = model.begin_at;
            [self.activityView.beginTimeLabel setText:[NSString stringWithFormat:@"活动开始时间：%@", self.beginTime]];

            self.finishTime = model.finish_at;
            [self.activityView.endTimeLabel setText:[NSString stringWithFormat:@"活动结束时间：%@", self.finishTime]];

            for (LXStoreImageResponseModel * imgModel in model.images) {
                [self.imagesDict setObject:imgModel.save_url forKey:imgModel.url];
                [self.activityView.imageBoardView.imgArray addObject:imgModel.url];
            }
            
            [self refreshView];
            
            [self hideHUD:YES];
            
            return;
        } else {
            [self showError:@"获取店铺活动信息失败" delay:2 anim:YES];
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
            [self showSuccess:requestData.successMsg delay:2 anim:YES];
        }

        [self performSelector:@selector(sendNotification) withObject:nil afterDelay:2.0];
    }

    return;
}

- (void)sendNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_refreshActivityList object:nil userInfo:nil];
    [self lxLeftBtnImgClick:nil];
}

@end
