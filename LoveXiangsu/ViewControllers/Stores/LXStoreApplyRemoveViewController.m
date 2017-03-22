//
//  LXStoreApplyRemoveViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 16/1/9.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreApplyRemoveViewController.h"
#import "LXStoreRemoveRequest.h"
#import "LXNotificationCenterString.h"
#import "LXUICommon.h"
#import "LXUserDefaultManager.h"
#import "LXNetManager.h"

#import "VertifyInputFormat.h"

#import "SZTextView.h"

@interface LXStoreApplyRemoveViewController ()

@end

@implementation LXStoreApplyRemoveViewController

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
    [self.applyReason becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxTitleLabel setTitle:@"商家下线申请" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxRightBtnTitle setTitle:@"申请下线" forState:UIControlStateNormal];
    self.lxRightBtnTitle.frame = CGRectMake(0, 7, 80, 30);
    self.lxRightBtnTitle.titleLabel.font = LX_TEXTSIZE_16;
    [self.lxRightBtnTitle addTarget:self action:@selector(lxApplyRemoveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.lxRightBtnTitle.layer.borderWidth = 1;
    self.lxRightBtnTitle.layer.borderColor = LX_DEBUG_COLOR;
    
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

    self.applyReason = [[SZTextView alloc]init];
    self.applyReason.textContainerInset = UIEdgeInsetsMake(0, -4.5, 0, 0);
    self.applyReason.backgroundColor = LX_BACKGROUND_COLOR;
    self.applyReason.placeholder = @"申请理由...";
    self.applyReason.font = FONT_SYSTEM(19);
    self.applyReason.layoutManager.allowsNonContiguousLayout = NO;
    [self.view addSubview:self.applyReason];
    [self.applyReason makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(MARGIN);
        make.top.equalTo(self.view.top).offset(MARGIN);
        make.right.equalTo(self.view.right).offset(-MARGIN);
        make.height.equalTo(StoreCommentHeight);
    }];
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    NSArray *arr = [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"arr = %@", arr);
    if (arr == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)lxApplyRemoveBtnClick:(id)sender{
    NSLog(@"申请下线按钮 Clicked");

    [self asyncConnectApplyRemove];
}

- (void)singleClick:(UITapGestureRecognizer * )recognizer
{
    [self.view endEditing:YES];
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

-(void)asyncConnectApplyRemove{
    [self showHUD:@"正在提交..." anim:YES];
    LXStoreRemoveRequest * request = [[LXStoreRemoveRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识
    
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.store_id forKey:@"store_id"];
    [paraDic setObject:self.applyReason.text forKey:@"description"];
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
        
//        [self showSuccess:@"感谢您的评论" delay:2 anim:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    return;
}

@end
