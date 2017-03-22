//
//  LXForumModifyTopicViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 15/12/28.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXForumModifyTopicViewController.h"
#import "LXNotificationCenterString.h"
#import "LXUICommon.h"
#import "LXUserDefaultManager.h"
#import "LXNetManager.h"
#import "LXForumImageBoardView.h"
#import "LXChooseImage.h"
#import "LXUploadManager.h"
#import "LXForumModifyTopicRequest.h"
#import "LXGetTopicImageResponseModel.h"

#import "VertifyInputFormat.h"
#import "NSFileManager+util.h"
#import "NSString+Custom.h"

#import "SZTextView.h"
#import "UIImageView+WebCache.h"

@interface LXForumModifyTopicViewController ()<UITextFieldDelegate, UIScrollViewDelegate, LXChooseImageDelegate, UIAlertViewDelegate>
{
    LXChooseImage       * chooseImg;
}

@property (strong, nonatomic) UIScrollView * scrollView;

@property (nonatomic, strong) LXForumImageBoardView  * imageBoardView;
@property (nonatomic, strong) NSMutableDictionary * oldObjectKeyDict;

@end

@implementation LXForumModifyTopicViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialization];
    [self putNavigationBar];
    [self putScrollView];
    [self putElements];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.topicTitle.text = self.topicTitleStr;
    self.topicContent.text = self.topicContentStr;
    [self.topicTitle becomeFirstResponder];
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
    self.scrollView.delegate = nil;
    self.scrollView = nil;
}

- (void)refreshContentSize
{
    //    UIView * view = self.scrollView.subviews[self.scrollView.subviews.count - 1];
    CGFloat height = CGRectGetMaxY(self.imageBoardView.frame);
    NSLog(@"最下方视图：%@", [self.imageBoardView class]);
    NSLog(@"视图最大高度：%f", height);
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, height + 64);
}

#pragma mark - Initialization

- (void)initialization
{
    self.oldObjectKeyDict = [NSMutableDictionary dictionary];
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxTitleLabel setTitle:@"修改帖子" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxRightBtn1Img setImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
    [self.lxRightBtn1Img addTarget:self action:@selector(lxAddImagesBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxRightBtn1Img.layer.borderWidth = 1;
    //    self.lxRightBtn1Img.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxRightBtnTitle setTitle:@"修改" forState:UIControlStateNormal];
    self.lxRightBtnTitle.titleLabel.font = LX_TEXTSIZE_20;
    [self.lxRightBtnTitle addTarget:self action:@selector(lxModifyTopicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - Element of Page

- (void)putElements
{
    [self.view setBackgroundColor:[UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0]];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleClick:)];
    [self.scrollView addGestureRecognizer:tap];

    self.topicTitle = [[UITextField alloc]init];
    self.topicTitle.delegate = self;
    self.topicTitle.backgroundColor = LX_BACKGROUND_COLOR;
    self.topicTitle.returnKeyType = UIReturnKeyNext;
    self.topicTitle.placeholder = @"请输入帖子标题...";
    [self.scrollView addSubview:self.topicTitle];
    [self.topicTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(MARGIN);
        make.top.equalTo(self.scrollView.top).offset(MARGIN);
        make.right.equalTo(self.view.right).offset(-MARGIN);
        make.height.equalTo(37);
    }];
    
    self.topicContent = [[SZTextView alloc]init];
    self.topicContent.textContainerInset = UIEdgeInsetsMake(0, -4.5, 0, 0);
    self.topicContent.backgroundColor = LX_BACKGROUND_COLOR;
    self.topicContent.placeholder = @"请输入帖子内容...";
    self.topicContent.font = FONT_SYSTEM(17);
    self.topicContent.layoutManager.allowsNonContiguousLayout = NO;
    [self.scrollView addSubview:self.topicContent];
    [self.topicContent makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(MARGIN);
        make.top.equalTo(self.topicTitle.bottom).offset(MARGIN);
        make.right.equalTo(self.view.right).offset(-MARGIN);
        make.height.equalTo(150);
    }];
    
    CGFloat imageBoardViewWidth = ScreenWidth - 2 * MARGIN;
    
    self.imageBoardView = [[LXForumImageBoardView alloc]init];
    self.imageBoardView.layer.borderColor = LX_DEBUG_COLOR;
    self.imageBoardView.layer.borderWidth = 1;
    for (int i = 0; i < self.imageArray.count; i++) {
        LXGetTopicImageResponseModel * imgModel = self.imageArray[i];
        [self.imageBoardView.imgArray addObject:imgModel.url];
        [self.oldObjectKeyDict setObject:imgModel.save_url forKey:imgModel.url];
    }
    [self.scrollView addSubview:self.imageBoardView];
    [self.imageBoardView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(MARGIN);
        make.top.equalTo(self.topicContent.bottom).offset(MARGIN);
        make.right.equalTo(self.view.right).offset(-MARGIN);
        make.height.lessThanOrEqualTo(imageBoardViewWidth);
    }];
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    // 物理点击返回键，并且标题或内容其中一项非空，则弹出提示
    if (sender &&
        (![VertifyInputFormat isEmpty:self.topicTitle.text]
         || ![VertifyInputFormat isEmpty:self.topicContent.text]
         || self.imageBoardView.imgArray.count > 0)) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未保存的资料会丢失，确认退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alertView show];
            return;
    }

    //    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.view endEditing:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_comebackToStoreList object:nil];
    NSArray *arr = [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"arr = %@", arr);
    if (arr == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)lxAddImagesBtnClick:(id)sender{
    NSLog(@"添加图片按钮 Clicked");
    self.topicTitleStr = self.topicTitle.text;
    self.topicContentStr = self.topicContent.text;
    [self.view endEditing:YES];
    chooseImg = [[LXChooseImage alloc]init];
    [chooseImg showOptionsOnDelegate:self editable:NO withImageTag:0 needMultiSelect:YES needFileType:UPLOAD_FORUM_TYPE completion:^{
        [self.view setNeedsLayout];
        if (IOS8_OR_LATER) {
            [self.imageBoardView setNeedsLayout];
        }
    }];
}

- (void)lxModifyTopicBtnClick:(id)sender{
    NSLog(@"修改帖子按钮 Clicked");

    if (![self submitValidate]) {
        return;
    }

    if (self.imageBoardView.imgArray.count > 0) {
        [self showHUD:@"正在上传图片..." anim:YES];
    } else {
        [self showHUD:@"请稍候..." anim:YES];
    }
    
    NSMutableArray * uploadArray = [NSMutableArray array];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // 1.上传图片文件
        for (int i = 0; i < self.imageBoardView.imgArray.count; i ++) {
            NSString * imgPathStr = self.imageBoardView.imgArray[i];
            NSString * objectKey = [self.imageBoardView.objectKeyDict objectForKey:imgPathStr];
            if (objectKey) {
                NSString * tip = [NSString stringWithFormat:@"正在上传图片...%d/%lu", (i+1), (unsigned long)self.imageBoardView.imgArray.count];
                [self showHUD:tip anim:YES];
                if ([[LXUploadManager sharedInstance] uploadObjectSync:objectKey source:imgPathStr]) {
                    NSString * save_url = [NSString stringWithFormat:@"/%@", objectKey];
                    NSDictionary * uploadDict = @{@"url":save_url};
                    [uploadArray addObject:uploadDict];
                }
            } else if ([imgPathStr hasPrefix:@"http"]) {
                NSString * save_url = [self.oldObjectKeyDict objectForKey:imgPathStr];
                NSDictionary * uploadDict = @{@"url":save_url};
                [uploadArray addObject:uploadDict];
            }
        }
        
        NSString * json = [NSString toJSONData:uploadArray];
        NSLog(@"json = %@", json);
        
        // 2.调用发帖子接口
        [self asyncConnectModifyTopic:json];
    });
}

- (void)singleClick:(UITapGestureRecognizer * )recognizer
{
    [self.view endEditing:YES];
}

#pragma mark - Validation

- (BOOL)submitValidate
{
    if ([self.topicTitle.text length] < 4) {
        [self showTips:@"标题不能少于4个汉字" delay:2.0 anim:YES];
        return NO;
    }
    if ([VertifyInputFormat isEmpty:self.topicContent.text]) {
        [self showTips:@"内容不能为空" delay:2.0 anim:YES];
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

#pragma mark - UIScrollView

- (void)putScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    self.scrollView.layer.borderColor = LX_DEBUG_COLOR;
    self.scrollView.layer.borderWidth = 1;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"视图开始滚动！！！");
    [self refreshContentSize];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.topicTitle) {
        [self.topicContent becomeFirstResponder];
        return NO;
    }
    return YES;
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
    
    NSString * objectKey = [[LXUploadManager sharedInstance] makeObjectKey:LXUPLOAD_FORUM];
    
    NSString * filePath = [docDir stringByAppendingFormat:@"/%@/%@", SANDBOX_IMAGE_PATH, objectKey];
    NSLog(@"图片文件路径： %@", filePath);
    
    [NSFileManager createFilePath:filePath deleteOldFile:YES];
    
    [imageData writeToFile:filePath atomically:YES];
    
    if (self.imageBoardView.imgArray.count >= 9) {
        [self showError:@"最多可以添加9张图片" delay:2 anim:YES];
    } else {
        [self.imageBoardView.imgArray addObject:filePath];
        [self.imageBoardView.objectKeyDict setObject:objectKey forKey:filePath];
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

-(void)asyncConnectModifyTopic:(NSString *)imageJSON{
    [self showHUD:@"请稍候..." anim:YES];
    LXForumModifyTopicRequest * request = [[LXForumModifyTopicRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识
    
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.topicTitle.text forKey:@"title"];
    [paraDic setObject:self.topicContent.text forKey:@"content"];
    [paraDic setObject:imageJSON forKey:@"images"];
    [paraDic setObject:self.topicId forKey:@"topic_id"];
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
        
        [self showSuccess:@"帖子修改成功" delay:2 anim:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_refreshTopicDetail object:nil userInfo:nil];
        [self lxLeftBtnImgClick:nil];
    }
    
    return;
}

@end
