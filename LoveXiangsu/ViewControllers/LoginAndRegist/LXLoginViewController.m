//
//  LXLoginViewController.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/10/26.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXLoginViewController.h"
#import "LXRegistAgreementViewController.h"
#import "LXPasswordResetViewController.h"
#import "LXUserGetNonceRequest.h"
#import "LXUserLoginRequest.h"
#import "LXLoginResponseModel.h"

#import "LXUICommon.h"
#import "LXNetManager.h"
#import "VertifyInputFormat.h"
#import "LXUserDefaultManager.h"
#import "LXNotificationCenterString.h"

#import "AppDelegate+EaseMob.h"

@interface LXLoginViewController ()
{
    UIView *frameView;
}

@property (strong, nonatomic) UIView *emptyView;

@property (nonatomic, strong) UITextField * phoneNumField;
@property (nonatomic, strong) UITextField * passwordField;
@property (nonatomic, strong) UIButton * loginBtn;
@property (nonatomic, strong) UIButton * registBtn;
@property (nonatomic, strong) UIButton * forgetPwdBtn;

@end

@implementation LXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self putNavigationBar];
    [self putElements];
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

    [self.lxTitleLabel setTitle:@"用户登陆" forState:UIControlStateNormal];
//    self.lxTitleLabel.layer.borderWidth = 1;
//    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];

    self.emptyView = [[UIView alloc]init];
    self.emptyView.frame = CGRectMake(14, 7, 30, 30);
//    self.emptyView.layer.borderWidth = 1;
//    self.emptyView.layer.borderColor = [[UIColor yellowColor] CGColor];

    self.navigationController.navigationBar.translucent = NO;
    // 30 127 241
    self.navigationController.navigationBar.barTintColor = LX_PRIMARY_COLOR;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxLeftBtnImg];
    self.navigationItem.titleView = self.lxTitleLabel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.emptyView];
}

#pragma mark - Element of Page

- (void)putElements
{
    [self.view setBackgroundColor:LX_BACKGROUND_COLOR];

    frameView = [[UIView alloc]init];
    frameView.layer.borderWidth = BorderWidth05;
    // 189 189 192
    frameView.layer.borderColor = [[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:192.0/255.0 alpha:1.0] CGColor];
    [self.view addSubview:frameView];
    [frameView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(MARGIN);
        make.right.equalTo(-MARGIN);
        make.height.equalTo(MARGIN * 4 + IconSize * 2 + SeparatorHeight);
    }];

    UIView *separator = [[UIView alloc]init];
    separator.layer.borderWidth = BorderWidth05;
    // 163 164 163
    separator.layer.borderColor = [[UIColor colorWithRed:163.0/255.0 green:164.0/255.0 blue:163.0/255.0 alpha:1.0] CGColor];
    [frameView addSubview:separator];
    [separator makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(frameView);
        make.left.equalTo(MARGIN);
        make.right.equalTo(-MARGIN);
        make.height.equalTo(BorderWidth05);
    }];

    UIImageView *usernameImg = [[UIImageView alloc]init];
    usernameImg.image = [UIImage imageNamed:@"login_phone"];
    [frameView addSubview:usernameImg];
//    usernameImg.layer.borderColor = [[UIColor redColor] CGColor];
//    usernameImg.layer.borderWidth = 1;
    [usernameImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(MARGIN);
        make.top.equalTo(MARGIN);
        make.bottom.equalTo(separator.top).offset(-MARGIN);
        make.width.equalTo(IconSize);
    }];
    
    UIImageView *passwordImg = [[UIImageView alloc]init];
    passwordImg.image = [UIImage imageNamed:@"login_password"];
    [frameView addSubview:passwordImg];
//    passwordImg.layer.borderColor = [[UIColor redColor] CGColor];
//    passwordImg.layer.borderWidth = 1;
    [passwordImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(MARGIN);
        make.top.equalTo(separator.bottom).offset(MARGIN);
        make.bottom.equalTo(frameView.bottom).offset(-MARGIN);
        make.width.equalTo(IconSize);
    }];

    self.phoneNumField = [[UITextField alloc]init];
    self.phoneNumField.placeholder = @"请输入手机号...";
    self.phoneNumField.font = LX_TEXTSIZE_20;
    self.phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumField.delegate = self;
//    self.phoneNumField.layer.borderColor = [[UIColor redColor] CGColor];
//    self.phoneNumField.layer.borderWidth = 1;
    [frameView addSubview:self.phoneNumField];
    [self.phoneNumField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(usernameImg.right).offset(PADDING);
        make.top.equalTo(MARGIN);
        make.bottom.equalTo(separator.top).offset(-MARGIN);
        make.right.equalTo(-MARGIN);
    }];
    
    self.passwordField = [[UITextField alloc]init];
    self.passwordField.placeholder = @"请输入密码...";
    self.passwordField.font = LX_TEXTSIZE_20;
    self.passwordField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.delegate = self;
    self.passwordField.secureTextEntry = YES;
//    self.passwordField.layer.borderColor = [[UIColor redColor] CGColor];
//    self.passwordField.layer.borderWidth = 1;
    [frameView addSubview:self.passwordField];
    [self.passwordField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordImg.right).offset(PADDING);
        make.top.equalTo(separator.bottom).offset(MARGIN);
        make.bottom.equalTo(frameView.bottom).offset(-MARGIN);
        make.right.equalTo(-MARGIN);
    }];

    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = LX_TEXTSIZE_16;
    // 31 229 98
    [self.loginBtn setBackgroundColor:[UIColor colorWithRed:31.0/255.0 green:229.0/255.0 blue:98.0/255.0 alpha:1.0]];
    [self.loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    [self.loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(frameView.left);
        make.top.equalTo(frameView.bottom).offset(MARGIN);
        make.height.equalTo(LoginClassBtnHeight);
        int width = (ScreenWidth - 3 * MARGIN) * 3 / 5;
        make.width.equalTo(width);
    }];

    self.registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.registBtn.titleLabel.font = LX_TEXTSIZE_16;
    // 23 95 199
    [self.registBtn setBackgroundColor:LX_PRIMARY_COLOR_DARK];
    [self.registBtn addTarget:self action:@selector(registBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registBtn];
    [self.registBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginBtn.right).offset(MARGIN);
        make.top.equalTo(frameView.bottom).offset(MARGIN);
        make.height.equalTo(self.loginBtn.height);
        make.right.equalTo(-MARGIN);
    }];

    self.forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"忘记密码？"];
    NSRange strRange = {0,[str length]};
    // 30 128 240
    NSDictionary *dict = @{NSForegroundColorAttributeName:LX_PRIMARY_COLOR,
                           NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                           NSFontAttributeName:LX_TEXTSIZE_16,
                           };
    [str addAttributes:dict range:strRange];
    [self.forgetPwdBtn setAttributedTitle:str forState:UIControlStateNormal];
    [self.forgetPwdBtn addTarget:self action:@selector(forgetPwdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetPwdBtn];
    [self.forgetPwdBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registBtn.bottom).offset(MARGIN);
        make.height.equalTo(self.loginBtn.height);
        make.right.equalTo(-MARGIN);
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    frameView.layer.cornerRadius = CGRectGetHeight(frameView.frame)/18;
    self.loginBtn.layer.cornerRadius = CGRectGetHeight(self.loginBtn.frame)/8;
    self.registBtn.layer.cornerRadius = CGRectGetHeight(self.registBtn.frame)/8;
    self.forgetPwdBtn.layer.cornerRadius = CGRectGetHeight(self.forgetPwdBtn.frame)/8;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phoneNumField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [self loginBtnClick:textField];
    }

    return YES;
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginBtnClick:(id)sender{
    [self pullKryBoardDown];
    
    //校验输入的手机号
    if ([VertifyInputFormat isEmpty:self.phoneNumField.text]) {
        NSLog(@"提示：请输入手机号...");
        [self showTips:@"请输入手机号..." delay:2 anim:YES];
        return;
    }

    //校验输入的密码
    if ([VertifyInputFormat isEmpty:self.passwordField.text]) {
        NSLog(@"提示：请输入密码...");
        [self showTips:@"请输入密码..." delay:2 anim:YES];
        return;
    }
    
    [self asyncConnectGetUserNonce];
}

- (void)registBtnClick:(id)sender{
    LXRegistAgreementViewController *registVC = [[LXRegistAgreementViewController alloc]init];
    registVC.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:registVC animated:YES];
}

- (void)forgetPwdBtnClick:(id)sender{
    LXPasswordResetViewController *pwdResetVC = [[LXPasswordResetViewController alloc]init];
    pwdResetVC.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:pwdResetVC animated:YES];
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

-(void)asyncConnectGetUserNonce{
    [self showHUD:@"请稍候..." anim:YES];
    LXUserGetNonceRequest * getNonce = [[LXUserGetNonceRequest alloc]init];//初始化网络请求
    
    getNonce.requestMethod = LXRequestMethodGet;
    getNonce.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    getNonce.responseSerializer = [AFHTTPResponseSerializer serializer];// 这里必须是HTTP类型响应
    getNonce.delegate = self;//代理设置
    getNonce.tag = 1000;//类型标识
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.phoneNumField.text forKey:@"phone"];
    [paraDic setObject:self.passwordField.text forKey:@"password"];
    [getNonce setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:getNonce];//发送网络请求
}

-(void)asyncConnectUserLogin{
    LXUserLoginRequest * login = [[LXUserLoginRequest alloc]init];//初始化网络请求

    login.requestMethod = LXRequestMethodGet;
    login.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    login.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    login.delegate = self;//代理设置
    login.tag = 1001;//类型标识

    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
    [login setHeaderParam:paraDic];//设置Header入参

    [[LXNetManager sharedInstance] addRequest:login];//发送网络请求
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

        // 如果有用户Nonce，则保存
        if (![VertifyInputFormat isEmpty:requestData.responseString]) {
            [LXUserDefaultManager saveUserNonce:requestData.responseString];
            // 使用用户nonce进行登陆
            [self asyncConnectUserLogin];
        } else {
            [self showError:@"获取用户nonce失败" delay:2 anim:YES];
            return;
        }
    } else if (requestData.tag == 1001) {
        if (error) {
            //对error进行相应的处理
            NSLog(@"%@",[[error userInfo] objectForKey:@"NSLocalizedDescription"]);
            
            [self showError:[[error userInfo] objectForKey:@"NSLocalizedDescription"] delay:2 anim:YES];
            // 只要是没有登录成功，都需要清除nonce
            [LXUserDefaultManager clearUserNonce];
            return;
        }
        
        // 成功时有时也会有成功Message
        if (![VertifyInputFormat isEmpty:requestData.successMsg]) {
            [self showSuccess:requestData.successMsg delay:2 anim:YES];
        }
        
        // 将返回的数据进行model转换（注意：要加上对model类型的校验）
        LXLoginResponseModel * responseModel = nil;
        if ([responseObject isKindOfClass:[LXLoginResponseModel class]]) {
            responseModel = (LXLoginResponseModel *)responseObject;
            NSLog(@"nickName = %@", responseModel.nickname);
            // 保存用户信息
            [LXUserDefaultManager saveUserInfo:responseModel];

            // 清理环信数据
            [self clearEaseMob];

            // 发送用户登陆成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_userLoginSuccess object:nil userInfo:nil];

            [self showSuccess:@"登陆成功" delay:2 anim:YES];

            // 注册极光推送Alias
            [self registerJPushAlias];

            // 登陆成功后，返回到菜单页面
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        } else {
            [self showError:@"获取用户登陆信息失败" delay:2 anim:YES];
        }
        // 只要是没有登录成功，都需要清除nonce
        [LXUserDefaultManager clearUserNonce];
    }

    return;
}

#pragma mark - 清理环信数据

- (void)clearEaseMob
{
    // 环信自动登录暂时关闭
    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
}

#pragma mark - 注册极光推送Alias

- (void)registerJPushAlias
{
    NSString * phone = [LXUserDefaultManager getUserPhone];
    if (![VertifyInputFormat isEmpty:phone]) {
        [JPUSHService setAlias:phone
              callbackSelector:nil
                        object:nil];
        NSLog(@"已向JPush注册推送Alias!");
    } else {
        NSLog(@"手机号为空，暂时无法向JPush注册推送Alias!");
    }
}

@end
