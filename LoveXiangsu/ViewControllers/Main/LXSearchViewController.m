//
//  LXSearchViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 16/1/9.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXSearchViewController.h"
#import "LXHistorySearchKeyResponseModel.h"
#import "LXHistorySearchKeyRequest.h"
#import "LXSearchKeyResultViewController.h"
#import "LXSearchPhoneResultViewController.h"

#import "LXUICommon.h"
#import "LXNetManager.h"
#import "VertifyInputFormat.h"
#import "UIViewController+MMDrawerController.h"

#import "FCUUID.h"

@interface LXSearchViewController ()

@property (strong, nonatomic) UIView * searchView;
@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableArray;

@end

@implementation LXSearchViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self hiddenMenuViewController];
    [self putNavigationBar];

    [self asyncConnectHistorySearchKey];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.searchTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)hiddenMenuViewController
{
    [self.mm_drawerController setLeftDrawerViewController:nil];
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];

    self.searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 7, ScreenWidth - 2 * 44, 30)];
    self.searchView.backgroundColor = LX_BACKGROUND_COLOR;
    self.searchView.layer.cornerRadius = CGRectGetHeight(self.searchView.frame)/2;
    self.searchView.clipsToBounds = NO;

    CGFloat offset = 10;
    self.searchTextField = [[UITextField alloc]init];
    self.searchTextField.backgroundColor = LX_BACKGROUND_COLOR;

    if (self.searchType == LXSearchTypeStore) {
        self.searchTextField.placeholder = @"搜索：店铺名、经营项目";
    } else if (self.searchType == LXSearchTypePhone) {
        self.searchTextField.placeholder = @"关键字、电话号码";
    }

    self.searchTextField.font = LX_TEXTSIZE_16;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.delegate = self;
    self.searchTextField.layer.borderWidth = 1;
    self.searchTextField.layer.borderColor = LX_DEBUG_COLOR;
    [self.searchView addSubview:self.searchTextField];
    [self.searchTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchView.left).offset(offset);
        make.top.equalTo(1);
        make.bottom.equalTo(-1);
        make.right.equalTo(self.searchView.right).offset(-offset);
    }];

    [self.lxRightBtnTitle setTitle:@"搜索" forState:UIControlStateNormal];
    self.lxRightBtnTitle.titleLabel.font = LX_TEXTSIZE_16;
    [self.lxRightBtnTitle addTarget:self action:@selector(lxDoSearchClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxRightBtn2Img.layer.borderWidth = 1;
    //    self.lxRightBtn2Img.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];

    self.navigationController.navigationBar.translucent = NO;
    // 30 127 241
    self.navigationController.navigationBar.barTintColor = LX_PRIMARY_COLOR;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxLeftBtnImg];
    self.navigationItem.titleView = self.searchView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxRightBtnTitle];
}

#pragma mark - Element of Page

- (void)putElements
{
    [self.view setBackgroundColor:COLOR_RGBA(249.0, 249.0, 249.0, 1.0)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 搜索历史列表
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
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
}

#pragma mark - Jump to ResultList

- (void)pushResultList:(NSString *)keyword
{
    [self.searchTextField resignFirstResponder];

    if (self.searchType == LXSearchTypeStore) {
        LXSearchKeyResultViewController * vc = [[LXSearchKeyResultViewController alloc]init];
        vc.keyword = keyword;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (self.searchType == LXSearchTypePhone) {
        LXSearchPhoneResultViewController * vc = [[LXSearchPhoneResultViewController alloc]init];
        vc.keyword = keyword;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    [self.searchTextField resignFirstResponder];

    UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"vc = %@", vc);
    if (vc == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)lxDoSearchClick:(id)sender{
    NSLog(@"搜索按钮 Clicked");
    if ([VertifyInputFormat isEmpty:self.searchTextField.text]) {
        [self showTips:@"搜索不能为空" delay:2 anim:YES];
        return;
    } else {
        [self pushResultList:self.searchTextField.text];
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"搜索框点击了键盘-搜索按钮");
    if ([VertifyInputFormat isEmpty:self.searchTextField.text]) {
        [self showTips:@"搜索不能为空" delay:2 anim:YES];
        return NO;
    } else {
        [self pushResultList:self.searchTextField.text];
    }
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *storeCellIdentifier = @"KeyCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:storeCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:storeCellIdentifier];
        [cell setBackgroundColor:LX_BACKGROUND_COLOR];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"ScreenWidth = %f", ScreenWidth);
        NSLog(@"CellHeight = %f", CGRectGetHeight(cell.frame));
        [cell.contentView setFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(cell.frame))];
    }

    LXHistorySearchKeyResponseModel *model = self.tableArray[indexPath.row];
    cell.textLabel.text = model.keyword;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 2 * MARGIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return MARGIN;
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
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MARGIN)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LXHistorySearchKeyResponseModel * model = self.tableArray[indexPath.row];
    NSLog(@"关键字：%@", model.keyword);

    [self pushResultList:model.keyword];
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

-(void)asyncConnectHistorySearchKey{
    [self showHUD:@"请稍候..." anim:YES];
    LXHistorySearchKeyRequest * request = [[LXHistorySearchKeyRequest alloc]init];//初始化网络请求
    
    request.requestMethod = LXRequestMethodGet;
    request.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    request.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识

    NSString * uuid = [FCUUID uuidForDevice];
    NSLog(@"UUID: %@", uuid);
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:uuid forKey:@"mid"];
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
        
        // 将返回的数据进行model转换（注意：要加上对model类型的校验）
        if ([responseObject isKindOfClass:[NSArray class]]) {
            self.tableArray = responseObject;

            [self putElements];

            [self hideHUD:YES];
        }

        return;
    }
}

@end
