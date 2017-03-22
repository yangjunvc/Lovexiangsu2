//
//  LXSubmitReportViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 16/2/2.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXSubmitReportViewController.h"
#import "LXSubmitReportRequest.h"

#import "LXUICommon.h"
#import "LXNetManager.h"

#import "VertifyInputFormat.h"

@interface LXSubmitReportViewController ()

@end

@implementation LXSubmitReportViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self putNavigationBar];
    [self putElements];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.reportContent becomeFirstResponder];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxTitleLabel setTitle:@"举报" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];

    [self.lxRightBtnTitle setTitle:@"提交" forState:UIControlStateNormal];
    self.lxRightBtnTitle.titleLabel.font = LX_TEXTSIZE_20;
    [self.lxRightBtnTitle addTarget:self action:@selector(lxSubmitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxRightBtn2Img.layer.borderWidth = 1;
    //    self.lxRightBtn2Img.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    self.navigationController.navigationBar.translucent = NO;
    // 30 127 241
    self.navigationController.navigationBar.barTintColor = LX_PRIMARY_COLOR;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxLeftBtnImg];
    self.navigationItem.titleView = self.lxTitleLabel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxRightBtnTitle];
}

#pragma mark - Element of Page

- (void)putElements
{
    [self.view setBackgroundColor:[UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0]];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleClick:)];
    [self.view addGestureRecognizer:tap];

    self.reportContent = [[SZTextView alloc]init];
    self.reportContent.textContainerInset = UIEdgeInsetsMake(0, -4.5, 0, 0);
    self.reportContent.backgroundColor = LX_BACKGROUND_COLOR;
    self.reportContent.placeholder = @"请输入举报原因...";
    self.reportContent.font = FONT_SYSTEM(17);
    self.reportContent.layoutManager.allowsNonContiguousLayout = NO;
    [self.view addSubview:self.reportContent];
    [self.reportContent makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(MARGIN);
        make.top.equalTo(MARGIN);
        make.right.equalTo(self.view.right).offset(-MARGIN);
        make.height.equalTo(131);
    }];
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    [self.view endEditing:YES];
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_comebackToStoreList object:nil];
    UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"vc = %@", vc);
    if (vc == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)lxSubmitBtnClick:(id)sender{
    NSLog(@"提交举报按钮 Clicked");
    
    if (![self submitValidate]) {
        return;
    }

    // 调用举报接口
    [self asyncConnectSubmitReport:self.reportContent.text];
}

- (void)singleClick:(UITapGestureRecognizer * )recognizer
{
    [self.view endEditing:YES];
}

#pragma mark - Validation

- (BOOL)submitValidate
{
    if ([VertifyInputFormat isEmpty:self.reportContent.text]) {
        [self showTips:@"举报原因不能为空" delay:2.0 anim:YES];
        return NO;
    }
    
    return YES;
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

-(void)asyncConnectSubmitReport:(NSString *)content{
    [self showHUD:@"请稍候..." anim:YES];
    LXSubmitReportRequest * request = [[LXSubmitReportRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识

    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    if (![VertifyInputFormat isEmpty:self.topicId]) {
        [paraDic setObject:self.topicId forKey:@"id"];
    } else if (![VertifyInputFormat isEmpty:self.replyId]) {
        [paraDic setObject:self.replyId forKey:@"reply_id"];
    } else if (![VertifyInputFormat isEmpty:self.userId]) {
        [paraDic setObject:self.userId forKey:@"user_id"];
    }
    [paraDic setObject:self.reportContent.text forKey:@"reason"];

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
            [self lxLeftBtnImgClick:nil];
            return;
        }
        
        // 成功时有时也会有成功Message
        if (![VertifyInputFormat isEmpty:requestData.successMsg]) {
            [self showSuccess:requestData.successMsg delay:2 anim:YES];
        }
        
//        [self showSuccess:@"发新帖成功" delay:2 anim:YES];
        [self lxLeftBtnImgClick:nil];
    }
    
    return;
}

@end
