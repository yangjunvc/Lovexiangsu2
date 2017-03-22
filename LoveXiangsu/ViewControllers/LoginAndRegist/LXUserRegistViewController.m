//
//  LXUserRegistViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 15/10/30.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXUserRegistViewController.h"
#import "LXSendValidCodeRequest.h"
#import "LXUserRegisterRequest.h"
#import "LXNetManager.h"
#import "VertifyInputFormat.h"
#import "LXUICommon.h"

@interface LXUserRegistViewController ()
{
    UIView *frameView;
}

@property (nonatomic, strong) UITextField * phoneNumField;
@property (nonatomic, strong) UITextField * codeField;
@property (nonatomic, strong) UITextField * passwordField;

@property (nonatomic, strong) UIButton * codeBtn;

@end

@implementation LXUserRegistViewController

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
    
    [self.lxTitleLabel setTitle:@"用户注册" forState:UIControlStateNormal];
//    self.lxTitleLabel.layer.borderWidth = 1;
//    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];

    
    [self.lxRightBtnTitle setTitle:@"完成" forState:UIControlStateNormal];
    [self.lxRightBtnTitle addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.lxRightBtnTitle.layer.borderWidth = 1;
//    self.lxRightBtnTitle.layer.borderColor = [[UIColor yellowColor] CGColor];

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
    [self.view setBackgroundColor:LX_BACKGROUND_COLOR];

    // 外框高度
    int height = MARGIN * 6 + IconSize * 3 + SeparatorHeight * 2;
    // 每个单元格高度
    int cellHeight = (height - SeparatorHeight * 2) / 3;

    frameView = [[UIView alloc]init];
    frameView.layer.borderWidth = BorderWidth05;
    // 189 189 192
    frameView.layer.borderColor = [[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:192.0/255.0 alpha:1.0] CGColor];
    [self.view addSubview:frameView];
    [frameView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(MARGIN);
        make.right.equalTo(-MARGIN);
        make.height.equalTo(height);
    }];

    UIView *separatorUp = [[UIView alloc]init];
    separatorUp.layer.borderWidth = BorderWidth05;
    // 163 164 163
    separatorUp.layer.borderColor = [[UIColor colorWithRed:163.0/255.0 green:164.0/255.0 blue:163.0/255.0 alpha:1.0] CGColor];
    [frameView addSubview:separatorUp];
    [separatorUp makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(MARGIN);
        make.right.equalTo(-MARGIN);
        make.top.equalTo(frameView.top).offset(cellHeight);
        make.height.equalTo(BorderWidth05);
    }];
    
    UIView *separatorDown = [[UIView alloc]init];
    separatorDown.layer.borderWidth = BorderWidth05;
    // 163 164 163
    separatorDown.layer.borderColor = [[UIColor colorWithRed:163.0/255.0 green:164.0/255.0 blue:163.0/255.0 alpha:1.0] CGColor];
    [frameView addSubview:separatorDown];
    [separatorDown makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(MARGIN);
        make.right.equalTo(-MARGIN);
        make.bottom.equalTo(-cellHeight);
        make.height.equalTo(BorderWidth05);
    }];

    UIImageView *usernameImg = [[UIImageView alloc]init];
    usernameImg.image = [UIImage imageNamed:@"login_phone"];
//    usernameImg.layer.borderColor = [[UIColor redColor] CGColor];
//    usernameImg.layer.borderWidth = 1;
    [frameView addSubview:usernameImg];
    [usernameImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(MARGIN);
        make.top.equalTo(MARGIN);
        make.bottom.equalTo(separatorUp.top).offset(-MARGIN);
        make.width.equalTo(IconSize);
    }];

    UIImageView *codeImg = [[UIImageView alloc]init];
    codeImg.image = [UIImage imageNamed:@"login_password"];
//    codeImg.layer.borderColor = [[UIColor redColor] CGColor];
//    codeImg.layer.borderWidth = 1;
    [frameView addSubview:codeImg];
    [codeImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(MARGIN);
        make.top.equalTo(separatorUp.bottom).offset(MARGIN);
        make.bottom.equalTo(separatorDown.top).offset(-MARGIN);
        make.width.equalTo(IconSize);
    }];

    UIImageView *passwordImg = [[UIImageView alloc]init];
    passwordImg.image = [UIImage imageNamed:@"login_password"];
//    passwordImg.layer.borderColor = [[UIColor redColor] CGColor];
//    passwordImg.layer.borderWidth = 1;
    [frameView addSubview:passwordImg];
    [passwordImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(MARGIN);
        make.top.equalTo(separatorDown.bottom).offset(MARGIN);
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
        make.bottom.equalTo(separatorUp.top).offset(-MARGIN);
        make.right.equalTo(-MARGIN);
    }];

    self.codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.codeBtn.titleLabel.font = LX_TEXTSIZE_12;
    // 31 229 98
    self.codeBtn.layer.borderColor = [[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:192.0/255.0 alpha:1.0] CGColor];
    self.codeBtn.layer.borderWidth = BorderWidth05;
    [self.codeBtn addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [frameView addSubview:self.codeBtn];
    [self.codeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-MARGIN);
        make.top.equalTo(separatorUp.bottom).offset(PADDING);
        make.bottom.equalTo(separatorDown.top).offset(-PADDING);
        make.width.equalTo(80);
    }];

    self.codeField = [[UITextField alloc]init];
    self.codeField.placeholder = @"验证码";
    self.codeField.font = LX_TEXTSIZE_20;
    self.codeField.keyboardType = UIKeyboardTypeASCIICapable;
    self.codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeField.delegate = self;
//    self.codeField.layer.borderColor = [[UIColor redColor] CGColor];
//    self.codeField.layer.borderWidth = 1;
    [frameView addSubview:self.codeField];
    [self.codeField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeImg.right).offset(PADDING);
        make.top.equalTo(separatorUp.bottom).offset(MARGIN);
        make.bottom.equalTo(separatorDown.top).offset(-MARGIN);
        make.right.equalTo(self.codeBtn.left).offset(-MARGIN);
    }];

    // 验证码前的占位图片无需显示
    codeImg.hidden = YES;

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
        make.top.equalTo(separatorDown.bottom).offset(MARGIN);
        make.bottom.equalTo(frameView.bottom).offset(-MARGIN);
        make.right.equalTo(-MARGIN);
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    frameView.layer.cornerRadius = CGRectGetHeight(frameView.frame)/24;
    self.codeBtn.layer.cornerRadius = CGRectGetHeight(self.codeBtn.frame)/8;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phoneNumField) {
        [self.codeField becomeFirstResponder];
    } else if (textField == self.codeField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [self finishBtnClick:textField];
    }

    return YES;
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)codeBtnClick:(id)sender{
    [self pullKryBoardDown];

    //校验输入的手机号
    if ([VertifyInputFormat isEmpty:self.phoneNumField.text]) {
        NSLog(@"提示：请输入手机号...");
        [self showTips:@"请输入手机号..." delay:2 anim:YES];
        return;
    }

//    if (![VertifyInputFormat isPhoneNum:self.phoneNumField.text]) {
//        NSLog(@"提示：电话号码格式不正确");
//        [self showTips:@"电话号码格式不正确。" delay:2 anim:YES];
//        return;
//    }

    [self asyncConnectGetValidCode];
}

- (void)finishBtnClick:(id)sender{
    [self pullKryBoardDown];

    //校验输入的手机号
    if ([VertifyInputFormat isEmpty:self.phoneNumField.text]) {
        NSLog(@"提示：请输入手机号...");
        [self showTips:@"请输入手机号..." delay:2 anim:YES];
        return;
    }

    //校验输入的验证码
    if ([VertifyInputFormat isEmpty:self.codeField.text]) {
        NSLog(@"提示：请输入验证码...");
        [self showTips:@"请输入验证码..." delay:2 anim:YES];
        return;
    }

    //校验输入的密码
    if ([VertifyInputFormat isEmpty:self.passwordField.text]) {
        NSLog(@"提示：请输入密码...");
        [self showTips:@"请输入密码..." delay:2 anim:YES];
        return;
    }

    [self asyncConnectUserRegist];
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

-(void)asyncConnectGetValidCode{
    [self showHUD:@"请稍候..." anim:YES];
    LXSendValidCodeRequest * getValid = [[LXSendValidCodeRequest alloc]init];//初始化网络请求

    getValid.delegate = self;//代理设置
    getValid.tag = 1000;//类型标识

    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.phoneNumField.text forKey:@"phone"];
    [getValid setCustomRequestParams:paraDic];//设置入参

    [[LXNetManager sharedInstance] addRequest:getValid];//发送网络请求
}

-(void)asyncConnectUserRegist{
    [self showHUD:@"请稍候..." anim:YES];
    LXUserRegisterRequest * userRegist = [[LXUserRegisterRequest alloc]init];//初始化网络请求
    
    userRegist.delegate = self;//代理设置
    userRegist.tag = 1001;//类型标识
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.phoneNumField.text forKey:@"phone"];
    [paraDic setObject:self.codeField.text forKey:@"validate"];
    [paraDic setObject:self.passwordField.text forKey:@"password"];
    [userRegist setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:userRegist];//发送网络请求
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
        } else {
            [self hideHUD:YES];
        }

        //获取验证码倒计时操作
//        [[LXFindPasswordValidManager sharedInstance] beginTimer];
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
        } else {
            [self showSuccess:@"注册成功" delay:2 anim:YES];
        }
        
        // 注册成功后，返回到登陆页面
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

    return;
}

@end
