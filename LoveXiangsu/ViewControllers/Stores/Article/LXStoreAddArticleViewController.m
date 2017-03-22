//
//  LXStoreAddArticleViewController.m
//  LoveXiangsu
//
//  Created by 张婷 on 16/2/29.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreAddArticleViewController.h"
#import "LXStoreAddArticleRequest.h"

#import "LXUICommon.h"
#import "LXNetManager.h"
#import "VertifyInputFormat.h"
#import "LXUserDefaultManager.h"
#import "LXNotificationCenterString.h"

#import "NSString+Custom.h"

@interface LXStoreAddArticleViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UITextField           * nameField;
@property (nonatomic, strong) UITextField           * priceField;

@end

@implementation LXStoreAddArticleViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self putNavigationBar];
    [self putElements];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.nameField becomeFirstResponder];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    
    [self.lxTitleLabel setTitle:@"添加商品" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];

    [self.lxRightBtnTitle setTitle:@"添加" forState:UIControlStateNormal];
    self.lxRightBtnTitle.titleLabel.font = LX_TEXTSIZE_20;
    [self.lxRightBtnTitle addTarget:self action:@selector(lxAddArticleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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

    UIView * superView = self.view;

    self.nameField = [[UITextField alloc]init];
    self.nameField.backgroundColor = LX_BACKGROUND_COLOR;
    self.nameField.placeholder = @"商品名称...";
    self.nameField.delegate = self;
    self.nameField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:self.nameField];
    [self.nameField makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(MARGIN);
        make.right.equalTo(superView.right).offset(-MARGIN);
        make.height.equalTo(38);
    }];

    self.priceField = [[UITextField alloc]init];
    self.priceField.backgroundColor = LX_BACKGROUND_COLOR;
    self.priceField.placeholder = @"商品价格...";
    self.priceField.delegate = self;
    self.priceField.returnKeyType = UIReturnKeyDone;
    self.priceField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.view addSubview:self.priceField];
    [self.priceField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(MARGIN);
        make.top.equalTo(self.nameField.bottom).offset(MARGIN);
        make.right.equalTo(superView.right).offset(-MARGIN);
        make.height.equalTo(38);
    }];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleClick:)];
    [self.view addGestureRecognizer:tap];
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
    if (textField == self.nameField) {
        [self.priceField becomeFirstResponder];
    } else if (textField == self.priceField) {
        [self.view endEditing:YES];
    }
    
    return YES;
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    [self.view endEditing:YES];
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    
    NSArray *arr = [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"arr = %@", arr);
    if (arr == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)lxAddArticleBtnClick:(id)sender{
    NSLog(@"添加商品按钮 Clicked");

    [self asyncConnectStoreAddArticle];
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

-(void)asyncConnectStoreAddArticle{
    [self showHUD:@"正在提交..." anim:YES];
    LXStoreAddArticleRequest * request = [[LXStoreAddArticleRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.store_id forKey:@"store_id"];
    [paraDic setObject:self.nameField.text forKey:@"name"];
    [paraDic setObject:self.priceField.text forKey:@"price"];

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

        [self showSuccess:@"添加成功！" delay:2 anim:YES];
        [self performSelector:@selector(sendNotification) withObject:nil afterDelay:2.0];
    }
    
    return;
}

- (void)sendNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_refreshArticleList object:nil userInfo:nil];
    [self lxLeftBtnImgClick:nil];
}

@end
