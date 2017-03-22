//
//  LXSettingViewController.m
//  LoveXiangsu
//
//  Created by ting.zhang on 15/10/31.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXSettingViewController.h"
#import "LXUserEditProfileViewController.h"
#import "LXUserLogoutRequest.h"
#import "LXContactUsViewController.h"
#import "LXLoginViewController.h"

#import "LXUserDefaultManager.h"
#import "VertifyInputFormat.h"
#import "LXNotificationCenterString.h"
#import "LXNetManager.h"
#import "LXUICommon.h"
#import "LXShareManager.h"

#import "UIViewController+MJPopupViewController.h"
#import "MJDetailViewController.h"

@interface LXSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UIView *emptyView;
@property (nonatomic, strong) NSMutableArray * tableArray;

@property (nonatomic, strong) UIButton * exitBtn;

/**
 *  面板
 */
@property (nonatomic, strong) UIView *panelView;

/**
 *  加载视图
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation LXSettingViewController

@synthesize tableView = _tableView;
@synthesize emptyView;
@synthesize tableArray;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self putNavigationBar];
    [self initLoadingView];
    [self createTableArray];
    [self putTableView];
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
    
    [self.lxTitleLabel setTitle:@"系统设置" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    self.emptyView = [[UIView alloc]init];
    self.emptyView.frame = CGRectMake(0, 0, 30, 30);
    //    self.emptyView.layer.borderWidth = 1;
    //    self.emptyView.layer.borderColor = [[UIColor yellowColor] CGColor];
    
    self.navigationController.navigationBar.translucent = NO;
    // 30 127 241
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30.0/255.0 green:127.0/255.0 blue:241.0/255.0 alpha:1.0];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxLeftBtnImg];
    self.navigationItem.titleView = self.lxTitleLabel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.emptyView];
}

#pragma mark - Table View

-(void)createTableArray{
    NSArray * sec = @[@{@"content":@"修改个人信息"},
                      @{@"content":@"联系我们"},
                      @{@"content":@"分享应用"},
                      @{@"content":@"版本信息"},
                      ];
    
    self.tableArray = [NSMutableArray array];
    [self.tableArray addObject:sec];
}

-(void)putTableView{
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 54.0 * 4) style:UITableViewStylePlain];
    self.tableView.sectionFooterHeight = 0;//去掉tableView自己加的区尾
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.scrollEnabled = NO;

    // 设置系统默认分割线从边线开始(1)
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    [self.tableView setBackgroundColor:[UIColor whiteColor]];

    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.view addSubview:self.tableView];
}

#pragma mark - Element of Page

- (void)putElements
{
    [self.view setBackgroundColor:[UIColor whiteColor]];

    self.exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.exitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    // 238 43 41
    [self.exitBtn setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:43.0/255.0 blue:41.0/255.0 alpha:1.0]];
    [self.exitBtn addTarget:self action:@selector(exitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.exitBtn];
    [self.exitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.tableView.bottom).offset(20);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(40);
    }];
}

// ShareSDK分享用
- (void)initLoadingView
{
    //加载等待视图
    self.panelView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.panelView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.panelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingView.frame = CGRectMake((self.view.frame.size.width - self.loadingView.frame.size.width) / 2, (self.view.frame.size.height - self.loadingView.frame.size.height) / 2, self.loadingView.frame.size.width, self.loadingView.frame.size.height);
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.panelView addSubview:self.loadingView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.exitBtn.layer.cornerRadius = CGRectGetHeight(self.exitBtn.frame)/8;
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)exitBtnClick:(id)sender{
    if ([VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self asyncConnectUserLogout];
    }
}

- (void)logoutAction
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        //设置是否自动登录
        [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];

        if (error && error.errorCode != EMErrorServerNotLogin) {
            NSLog(@"%@", error.description);
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
    } onQueue:nil];
}

#pragma mark - Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.tableArray[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingCell";
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView setFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(cell.frame))];
    }

    cell.textLabel.text = self.tableArray[indexPath.section][indexPath.row][@"content"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSLog(@"修改个人信息");
            if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
                LXUserEditProfileViewController * vc = [[LXUserEditProfileViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            
            LXLoginViewController *loginVC = [[LXLoginViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
            nav.navigationBarHidden = NO;
            
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
        if (indexPath.row == 1) {
            NSLog(@"联系我们");
            // http://download.21xiaoqu.com/page/contactUs
            LXContactUsViewController *contactUs = [[LXContactUsViewController alloc]init];
            [self.navigationController pushViewController:contactUs animated:YES];
        }
        if (indexPath.row == 2) {
            NSLog(@"分享应用");
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [[LXShareManager sharedInstance] showShareActionSheetOnView:cell withDelegate:self andTitle:@"i爱小区" andContent:@"大常营小区一公里，尽在掌握。" andURL:@"http://download.21xiaoqu.com/page/downloadselect" andIcon:@"app_start_180"];
        }
        if (indexPath.row == 3) {
            NSLog(@"版本信息");
            MJDetailViewController *detailViewController = [[MJDetailViewController alloc] initWithNibName:@"MJDetailViewController" bundle:nil];
            [self presentPopupViewController:detailViewController animationType:6];
        }
    }

    //    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 *  显示加载动画
 *
 *  @param flag YES 显示，NO 不显示
 */
- (void)showLoadingView:(BOOL)flag
{
    if (flag)
    {
        [self.view addSubview:self.panelView];
        [self.loadingView startAnimating];
    }
    else
    {
        [self.panelView removeFromSuperview];
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

-(void)asyncConnectUserLogout{
    LXUserLogoutRequest * logout = [[LXUserLogoutRequest alloc]init];//初始化网络请求
    
//    logout.requestMethod = LXRequestMethodGet;
//    logout.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
//    logout.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    logout.delegate = self;//代理设置
    logout.tag = 1000;//类型标识
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
    [logout setHeaderParam:paraDic];//设置Header入参
    
    [[LXNetManager sharedInstance] addRequest:logout];//发送网络请求
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

        // 需要清除登录信息
        [LXUserDefaultManager clearUserNonce];
        [LXUserDefaultManager clearUserInfo];

        // 发送用户登出成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_userLogoutSuccess object:nil userInfo:nil];

        // 环信登出
        [self logoutAction];

        // 登出成功后，返回到菜单页面
        [self dismissViewControllerAnimated:YES completion:nil];
    }

    return;
}

@end
