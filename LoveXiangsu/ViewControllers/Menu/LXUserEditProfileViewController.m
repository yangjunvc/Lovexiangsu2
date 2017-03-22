//
//  LXUserEditProfileViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 16/1/9.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXUserEditProfileViewController.h"
#import "LXLoginResponseModel.h"
#import "LXUserEditProfileRequest.h"
#import "LXUserGetProfileRequest.h"
#import "LXNotificationCenterString.h"

#import "LXUICommon.h"
#import "LXUserDefaultManager.h"
#import "VertifyInputFormat.h"
#import "LXNetManager.h"

#define CELL_HEIGHT 60
#define LEFT_WIDTH  100

@interface LXUserEditProfileViewController ()
{
    NSArray * sexArray;
}

@property (nonatomic, strong) UITextField * nickname;
@property (nonatomic, strong) UITextField * sex;
@property (nonatomic, strong) UITextField * profession;
@property (nonatomic, strong) UITextField * email;

@property (nonatomic, strong) UIPickerView * sexPicker;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSArray     * textfieldArray;

@property (nonatomic, strong) LXLoginResponseModel * userModel;

@end

@implementation LXUserEditProfileViewController

@synthesize userModel = _userModel;

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self putNavigationBar];
//    [self putScrollView];
    [self putElements];
    [self putTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.nickname becomeFirstResponder];
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

#pragma mark - Setter/Getter

- (LXLoginResponseModel *)userModel
{
    if (_userModel) {
        return _userModel;
    }
    _userModel = [LXUserDefaultManager getUserInfo];
    return _userModel;
}

- (void)setUserModel:(LXLoginResponseModel *)userModel
{
    _userModel = userModel;
    [LXUserDefaultManager saveUserInfo:userModel];
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxTitleLabel setTitle:@"个人信息修改" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxRightBtnTitle setTitle:@"完成" forState:UIControlStateNormal];
    self.lxRightBtnTitle.frame = CGRectMake(0, 7, 60, 30);
    self.lxRightBtnTitle.titleLabel.font = LX_TEXTSIZE_16;
    [self.lxRightBtnTitle addTarget:self action:@selector(lxFixInfosBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.lxRightBtnTitle.layer.borderWidth = 1;
    self.lxRightBtnTitle.layer.borderColor = LX_DEBUG_COLOR;
    
    self.navigationController.navigationBar.translucent = NO;
    // 30 127 241
    self.navigationController.navigationBar.barTintColor = LX_PRIMARY_COLOR;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxLeftBtnImg];
    self.navigationItem.titleView = self.lxTitleLabel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxRightBtnTitle];
}

//- (void)putScrollView
//{
//    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
//    self.scrollView.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
//    [self.view addSubview:self.scrollView];
//}

#pragma mark - Element of Page

- (void)putElements
{
    [self.view setBackgroundColor:[UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0]];

    UIView * nicknameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LEFT_WIDTH + MARGIN, CELL_HEIGHT)];
    UILabel * nicknameLeft = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN, 0, LEFT_WIDTH, CELL_HEIGHT)];
    nicknameLeft.text = @"昵称";
    nicknameLeft.font = LX_TEXTSIZE_20;
    nicknameLeft.textAlignment = NSTextAlignmentLeft;
    [nicknameView addSubview:nicknameLeft];

    self.nickname = [[UITextField alloc]initWithFrame:CGRectZero];
    self.nickname.leftView = nicknameView;
    self.nickname.placeholder = @"昵称";
    self.nickname.returnKeyType = UIReturnKeyNext;
    self.nickname.text = self.userModel.nickname;
    self.nickname.font = LX_TEXTSIZE_20;

    sexArray = @[@"男", @"女"];

    UIView * sexView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LEFT_WIDTH + MARGIN, CELL_HEIGHT)];
    UILabel * sexLeft = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN, 0, LEFT_WIDTH, CELL_HEIGHT)];
    sexLeft.text = @"性别";
    sexLeft.font = LX_TEXTSIZE_20;
    sexLeft.textAlignment = NSTextAlignmentLeft;
    [sexView addSubview:sexLeft];

    self.sexPicker = [[UIPickerView alloc]init];
    self.sexPicker.backgroundColor = LX_BACKGROUND_COLOR;
    self.sexPicker.delegate = self;
    self.sexPicker.dataSource = self;
    
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    toolbar.barTintColor = LX_BACKGROUND_COLOR;
    toolbar.translucent = YES;
    
    UIBarButtonItem *spaceItem1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *spaceItem2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    UIButton * last = [UIButton buttonWithType:UIButtonTypeCustom];
    [last setFrame:CGRectMake(0, 0, 70, 40)];
    [last setTitle:@"上一项" forState:UIControlStateNormal];
    [last setTitleColor:LX_SECOND_TEXT_COLOR forState:UIControlStateNormal];
    [last.titleLabel setFont:LX_TEXTSIZE_20];
    //    finish.layer.borderColor = LX_DEBUG_COLOR;
    //    finish.layer.borderWidth = 1;
    [last addTarget:self action:@selector(pickerViewLast) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:last];

    UIButton * finish = [UIButton buttonWithType:UIButtonTypeCustom];
    [finish setFrame:CGRectMake(0, 0, 70, 40)];
    [finish setTitle:@"完成" forState:UIControlStateNormal];
    [finish setTitleColor:LX_SECOND_TEXT_COLOR forState:UIControlStateNormal];
    [finish.titleLabel setFont:LX_TEXTSIZE_20];
    //    finish.layer.borderColor = LX_DEBUG_COLOR;
    //    finish.layer.borderWidth = 1;
    [finish addTarget:self action:@selector(pickerViewDone) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *centerBtn = [[UIBarButtonItem alloc]initWithCustomView:finish];
    
    UIButton * next = [UIButton buttonWithType:UIButtonTypeCustom];
    [next setFrame:CGRectMake(0, 0, 70, 40)];
    [next setTitle:@"下一项" forState:UIControlStateNormal];
    [next setTitleColor:LX_SECOND_TEXT_COLOR forState:UIControlStateNormal];
    [next.titleLabel setFont:LX_TEXTSIZE_20];
    //    finish.layer.borderColor = LX_DEBUG_COLOR;
    //    finish.layer.borderWidth = 1;
    [next addTarget:self action:@selector(pickerViewNext) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:next];
    [toolbar setItems:@[leftBtn, spaceItem1, centerBtn, spaceItem2, rightBtn]];

    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(toolbar.frame), ScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [toolbar addSubview:lineView];

    self.sex = [[UITextField alloc]initWithFrame:CGRectZero];
    self.sex.leftView = sexView;
    self.sex.inputView = self.sexPicker;
    self.sex.inputAccessoryView = toolbar;
    self.sex.tintColor = [UIColor clearColor];
    self.sex.placeholder = @"性别";
    self.sex.text = self.userModel.sex;
    self.sex.font = LX_TEXTSIZE_20;

    UIView * professionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LEFT_WIDTH + MARGIN, CELL_HEIGHT)];
    UILabel * professionLeft = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN, 0, LEFT_WIDTH, CELL_HEIGHT)];
    professionLeft.text = @"行业";
    professionLeft.font = LX_TEXTSIZE_20;
    professionLeft.textAlignment = NSTextAlignmentLeft;
    [professionView addSubview:professionLeft];

    self.profession = [[UITextField alloc]initWithFrame:CGRectZero];
    self.profession.leftView = professionView;
    self.profession.placeholder = @"行业";
    self.profession.returnKeyType = UIReturnKeyNext;
    self.profession.text = self.userModel.profession;
    self.profession.font = LX_TEXTSIZE_20;

    UIView * emailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LEFT_WIDTH + MARGIN, CELL_HEIGHT)];
    UILabel * emailLeft = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN, 0, LEFT_WIDTH, CELL_HEIGHT)];
    emailLeft.text = @"e-mail";
    emailLeft.font = LX_TEXTSIZE_20;
    emailLeft.textAlignment = NSTextAlignmentLeft;
    [emailView addSubview:emailLeft];

    self.email = [[UITextField alloc]initWithFrame:CGRectZero];
    self.email.leftView = emailView;
    self.email.placeholder = @"e-mail";
    self.email.returnKeyType = UIReturnKeyDone;
    self.email.text = self.userModel.email;
    self.email.font = LX_TEXTSIZE_20;

    self.textfieldArray = @[self.nickname, self.sex, self.profession, self.email];
}

- (void)putTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 列表
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    //    self.tableView.sectionFooterHeight = 0;//去掉tableView自己加的区尾
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = YES;
    self.tableView.scrollEnabled = YES;
    
    //设置系统默认分割线从边线开始(1)
    //    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
    //        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    //    }
    //
    //    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
    //        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    //    }
    
    [self.tableView setBackgroundColor:LX_BACKGROUND_COLOR];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleClick:)];
    [self.tableView addGestureRecognizer:tap];
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
    if (textField == self.nickname)
    {
        [self.sex becomeFirstResponder];
    }
    else if (textField == self.profession)
    {
        [self.email becomeFirstResponder];
    }
    else if (textField == self.email)
    {
        [self.email resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.sex) {
        for (int i = 0; i < sexArray.count; i ++) {
            NSString * sex = sexArray[i];
            if ([sex isEqualToString:self.sex.text]) {
                [self.sexPicker selectRow:i inComponent:0 animated:NO];
                return YES;
            }
        }
    }

    return YES;
}

#pragma mark - UIPickerView DataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

#pragma mark - UIPickerView Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * sex = sexArray[row];
    return sex;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
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

- (void)lxFixInfosBtnClick:(id)sender{
    NSLog(@"个人信息修改完成按钮 Clicked");
    [self asyncConnectUserEditProfile];
}

- (void)singleClick:(UITapGestureRecognizer * )recognizer
{
    [self.view endEditing:YES];
}

- (void)pickerViewLast
{
    NSInteger row = [self.sexPicker selectedRowInComponent:0];
    NSString * sex = sexArray[row];
    self.sex.text = sex;

    [self.nickname becomeFirstResponder];
}

- (void)pickerViewDone
{
    NSInteger row = [self.sexPicker selectedRowInComponent:0];
    NSString * sex = sexArray[row];
    self.sex.text = sex;

    [self.sex resignFirstResponder];
}

- (void)pickerViewNext
{
    NSInteger row = [self.sexPicker selectedRowInComponent:0];
    NSString * sex = sexArray[row];
    self.sex.text = sex;

    [self.profession becomeFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.textfieldArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *infoCellIdentifier = @"InfoCell";

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:infoCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoCellIdentifier];
        [cell setBackgroundColor:LX_BACKGROUND_COLOR];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"ScreenWidth = %f", ScreenWidth);
        NSLog(@"CellHeight = %f", CGRectGetHeight(cell.frame));
        [cell.contentView setFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(cell.frame))];
    }

    UITextField * textfield = self.textfieldArray[indexPath.row];
    textfield.backgroundColor = LX_BACKGROUND_COLOR;
    textfield.delegate = self;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    textfield.layer.borderColor = LX_DEBUG_COLOR;
    textfield.layer.borderWidth = 1;

    [cell.contentView addSubview:textfield];

    textfield.frame = CGRectMake(0, 0, CGRectGetWidth(cell.contentView.frame), CELL_HEIGHT);

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了单元格");
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

-(void)asyncConnectUserGetProfile{
//    [self showHUD:@"正在加载..." anim:YES];
    LXUserGetProfileRequest * request = [[LXUserGetProfileRequest alloc]init];//初始化网络请求

    request.requestMethod = LXRequestMethodGet;
    request.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    request.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    request.delegate = self;//代理设置
    request.tag = 1001;//类型标识

    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }

    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

-(void)asyncConnectUserEditProfile{
    [self showHUD:@"正在提交..." anim:YES];
    LXUserEditProfileRequest * request = [[LXUserEditProfileRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识
    
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    if (self.userModel.name) {
        [paraDic setObject:self.userModel.name     forKey:@"name"];
    }
    if (self.userModel.city) {
        [paraDic setObject:self.userModel.city     forKey:@"city"];
    }
    if (self.userModel.birthday) {
        [paraDic setObject:self.userModel.birthday forKey:@"birthday"];
    }
    if (self.userModel.icon_url) {
        [paraDic setObject:self.userModel.icon_url forKey:@"icon_url"];
    }
    [paraDic setObject:self.nickname.text   forKey:@"nickname"];// 用新值
    [paraDic setObject:self.sex.text        forKey:@"sex"];// 用新值
    [paraDic setObject:self.profession.text forKey:@"profession"];//用新值
    [paraDic setObject:self.email.text      forKey:@"email"];//用新值

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
            [self showSuccess:requestData.successMsg delay:3 anim:YES];
        }

        [self asyncConnectUserGetProfile];
    } else if (requestData.tag == 1001) {
        if (error) {
            //对error进行相应的处理
            NSLog(@"%@",[[error userInfo] objectForKey:@"NSLocalizedDescription"]);
            
//            [self showError:[[error userInfo] objectForKey:@"NSLocalizedDescription"] delay:2 anim:YES];
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
            self.userModel = responseModel;

            // 获取个人信息成功后，通知菜单页面更新头像及昵称
            [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_userLoginSuccess object:nil userInfo:nil];

            // 获取个人信息成功后，返回到设置菜单页面
            [self lxLeftBtnImgClick:nil];
        } else {
            [self showError:@"获取个人信息失败" delay:2 anim:YES];
        }
    }
    
    return;
}

@end
