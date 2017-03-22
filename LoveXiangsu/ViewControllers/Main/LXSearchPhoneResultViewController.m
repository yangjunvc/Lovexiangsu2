//
//  LXSearchPhoneResultViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 16/1/9.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXSearchPhoneResultViewController.h"
#import "LXPhoneCell.h"
#import "LXPhoneInfoResponseModel.h"
#import "LXPhoneListByTagRequest.h"

#import "LXUICommon.h"
#import "LXNetManager.h"
#import "LXUserDefaultManager.h"
#import "VertifyInputFormat.h"
#import "LXCallManager.h"

#import "NSString+Custom.h"

@interface LXSearchPhoneResultViewController ()

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSArray * phoneArray;

@end

@implementation LXSearchPhoneResultViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置导航条
    [self putNavigationBar];
    
    // 先获取电话列表，然后会自动获取店铺列表
    [self asyncConnectGetPhoneList];
    
    // 注册通知
    [self registerNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

-(void)dealloc{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    
    // 移除通知
    [self removeNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification

- (void)registerNotification
{
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomepage) name:k_Noti_changeTabBarToHomepage object:nil];
}

- (void)refreshHomepage
{
    // 先清空页面
    [self removeAllSubviews];
    
    [self asyncConnectGetPhoneList];
}

#pragma mark - Clean Work

- (void)removeAllSubviews
{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
}

- (void)removeNotification
{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_Noti_changeTabBarToHomepage object:nil];
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    NSString * title = [NSString stringWithFormat:@"关键字：%@", self.keyword ? self.keyword : @""];
    [self.lxTitleLabel setTitle:title forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxRightBtnTitle setTitle:@"关闭" forState:UIControlStateNormal];
    self.lxRightBtnTitle.titleLabel.font = LX_TEXTSIZE_16;
    [self.lxRightBtnTitle addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxRightBtn2Img.layer.borderWidth = 1;
    //    self.lxRightBtn2Img.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    self.navigationController.navigationBar.translucent = NO;
    // 30 127 241
    self.navigationController.navigationBar.barTintColor = LX_PRIMARY_COLOR;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxLeftBtnImg];
    self.navigationItem.titleView = self.lxTitleLabel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxRightBtnTitle];
}

#pragma mark - TableView初始化

-(void)putTableView{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 推荐店铺列表
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    //    self.tableView.sectionFooterHeight = 0;//去掉tableView自己加的区尾
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
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

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    NSArray *vc = [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"vc = %@", vc);
    if (vc == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)callingPhoneViewClick:(id)sender{
    NSLog(@"拨打服务电话 Calling...");
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        id superView = [btn superview];
        int loopCnt = 0;
        while (![superView isKindOfClass:[LXPhoneCell class]] && loopCnt < 4) {
            superView = [superView superview];
            loopCnt ++;
        }
        if ([superView isKindOfClass:[LXPhoneCell class]]) {
            LXPhoneCell *cell = (LXPhoneCell *)superView;
            NSLog(@"%@", [NSString stringWithFormat:@"telprompt://%@",cell.phone]);
            if (!cell.phone) {
                return;
            }
            [[LXCallManager sharedInstance] asyncSaveCallRecordWithStoreId:nil phonebookId:cell.phoneId];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",cell.phone]]];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        // 推荐店铺数组数量
        return self.phoneArray.count;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *phoneCellIdentifier = @"PhoneCell";

    if (indexPath.section == 0) {
        LXPhoneCell * cell = [tableView dequeueReusableCellWithIdentifier:phoneCellIdentifier];
        if (cell == nil) {
            cell = [[LXPhoneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:phoneCellIdentifier];
            [cell setBackgroundColor:LX_BACKGROUND_COLOR];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSLog(@"ScreenWidth = %f", ScreenWidth);
            NSLog(@"CellHeight = %f", CGRectGetHeight(cell.frame));
            [cell.contentView setFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(cell.frame))];
        }
        
        LXPhoneInfoResponseModel *model = self.phoneArray[indexPath.row];

        cell.phoneId = model.id;

        // 名称
        [cell.nameLabel setText:model.name];
        
        // 电话号码
        cell.phone = model.phone;
        
        // 拨打电话图标
        if (!cell.phone) {
            [cell.callingImg setImage:[UIImage imageNamed:@"main_store_call_disable"]];
        } else {
            [cell.callingImg setImage:[UIImage imageNamed:@"main_store_call"]];
        }
        
        // 拨打电话
        [cell.callingView addTarget:self action:@selector(callingPhoneViewClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //    if (indexPath.row == 0) {
        //        cell.cellSeparator.hidden = YES;
        //    } else {
        //        cell.cellSeparator.hidden = NO;
        //    }
        return cell;
    }

    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        // 电话Cell区高度
        CGFloat height = MARGIN * 2 + MARGIN * 2.5;
        return height;
    }

    return 0.0;
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
    UITableViewCell * sourceCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([sourceCell isKindOfClass:[LXPhoneCell class]]) {
        LXPhoneCell * cell = (LXPhoneCell *)sourceCell;
        // 去掉末尾的"\n "
        NSString *newNum = [cell.nameLabel.text stringByReplacingOccurrencesOfString:@"\n " withString:@""];
        NSLog(@"newNum = %@!!!!!", newNum);
        
        NSMutableArray *numberArr = [NSMutableArray array];
        NSError *error = NULL;
        // 根据匹配条件,创建了一个正则表达式(类方法,实例方法类似)
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:PhoneRegex options:NSRegularExpressionCaseInsensitive error:&error];
        if (regex != nil) {
            NSArray * arr = [regex matchesInString:newNum options:0 range:NSMakeRange(0, [newNum length])];
            for (NSTextCheckingResult *match in arr) {
                if (match) {
                    NSRange resultRange = [match rangeAtIndex:0];
                    NSString *result = [newNum substringWithRange:resultRange];
                    NSLog(@"result = %@",result);
                    [numberArr addObject:result];
                }
            }
        }
        
        if (numberArr.count == 1) {
            NSLog(@"%@!!!!!", [NSString stringWithFormat:@"telprompt://%@",numberArr[0]]);
            if (!numberArr[0]) {
                return;
            }
            [[LXCallManager sharedInstance] asyncSaveCallRecordWithStoreId:nil phonebookId:cell.phoneId];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",numberArr[0]]]];
        } else if (numberArr.count > 1) {
            [[LXCallManager sharedInstance] asyncSaveCallRecordWithStoreId:nil phonebookId:cell.phoneId];
            UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择拨打号码" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            for (NSString *phoneNum in numberArr) {
                [actionsheet addButtonWithTitle:phoneNum];
            }
            [actionsheet addButtonWithTitle:@"取消"];
            actionsheet.cancelButtonIndex = actionsheet.numberOfButtons - 1;
            actionsheet.tag = 1;
            actionsheet.actionSheetStyle = UIActionSheetStyleAutomatic;
            [actionsheet showInView:self.view];
        }
    }
}

#pragma mark - ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex == actionSheet.numberOfButtons - 1) {
        NSLog(@"取消按钮：%@", title);
    } else {
        NSLog(@"电话号码: %@", title);
        if (!title) {
            return;
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",title]]];
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

-(void)asyncConnectGetPhoneList{
    [self showHUD:@"正在搜索..." anim:YES];
    LXPhoneListByTagRequest * request = [[LXPhoneListByTagRequest alloc]init];//初始化网络请求
    
    request.requestMethod = LXRequestMethodGet;
    request.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    request.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:@(COMMUNITY_ID) forKey:@"id"];
    [paraDic setObject:self.keyword forKey:@"keyword"];
    [paraDic setObject:@(0) forKey:@"offset"];
    [paraDic setObject:@(80) forKey:@"num"];
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
            self.phoneArray = responseObject;

            [self putTableView];

            [self hideHUD:YES];
        }
    }

    return;
}

@end
