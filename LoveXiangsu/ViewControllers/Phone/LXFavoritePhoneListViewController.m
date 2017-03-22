//
//  LXFavoritePhoneListViewController.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/14.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXFavoritePhoneListViewController.h"
#import "LXPhoneMenuViewController.h"
#import "LXPhoneInfoResponseModel.h"
#import "LXPhoneGetAllTagsResponseModel.h"
#import "LXPhoneListByTagRequest.h"
#import "LXPhoneGetAllTagsRequest.h"
#import "LXPhoneCell.h"
#import "LXSearchViewController.h"

#import "LXNotificationCenterString.h"
#import "LXCommon.h"
#import "LXUICommon.h"
#import "LXNetManager.h"
#import "LXMenuManager.h"
#import "VertifyInputFormat.h"
#import "UIViewController+MMDrawerController.h"
#import "LXMenuManager.h"
#import "LXCallManager.h"

@interface LXFavoritePhoneListViewController ()

//@property (nonatomic, strong) UITableView * tableView;
//@property (nonatomic, strong) NSArray * tableArray;

@end

@implementation LXFavoritePhoneListViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self putNavigationBar];

    // 首先网络请求菜单，然后会再请求具体列表内容
    [self asyncConnectPhoneGetAllTags];

    [self registerNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.mm_drawerController setLeftDrawerViewController:[LXMenuManager sharedInstance].phoneMenuVC];
    [self.mm_drawerController setMaximumLeftDrawerWidth:PhoneMenuWidth];
    [self.mm_drawerController setCenterInteractionEnable:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;

    [self removeNotification];
}

#pragma mark - Initialization

- (void)initProperties
{
    [super initProperties];
    
    self.tag = @"维修";
}

- (void)initPropertiesWithTag:(NSString *)tag
{
    [super initProperties];
    
    self.tag = tag;
}

#pragma mark - Notification

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneMenuSelected:) name:k_Noti_PhoneMenuSelected object:nil];
}

- (void)phoneMenuSelected:(NSNotification * )notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSLog(@"选择了电话菜单，参数：tag:%@", userInfo[@"tag"]);
    [self removeAllSubviews];
    [self initPropertiesWithTag:userInfo[@"tag"]];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_Noti_PhoneMenuSelected object:nil];
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    // [UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0]

    [self.searchBtn setTitle:@"关键字、电话号码" forState:UIControlStateNormal];
    [self.searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //    self.qrCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.qrCodeBtn.frame = CGRectMake(14, 7, 30, 30);
    //    [self.qrCodeBtn setBackgroundImage:[UIImage imageNamed:@"main_qrcode"] forState:UIControlStateNormal];
    [self.lxRightBtn2Img setImage:[UIImage imageNamed:@"main_search"] forState:UIControlStateNormal];
    [self.lxRightBtn2Img addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.qrCodeBtn setAdjustsImageWhenHighlighted:NO];
    //    [self.qrCodeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    //    self.lxRightBtn2Img.layer.borderWidth = 1;
    //    self.lxRightBtn2Img.layer.borderColor = [[UIColor yellowColor] CGColor];
    
    self.navigationController.navigationBar.translucent = NO;
    // 30 127 241
    self.navigationController.navigationBar.barTintColor = LX_PRIMARY_COLOR;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxLeftBtnImg];
    self.navigationItem.titleView = self.searchBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxRightBtn2Img];
}

#pragma mark - Element of Page

- (void)putElements
{
    [self.view setBackgroundColor:LX_BACKGROUND_COLOR];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 收藏店铺列表
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
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    [self.mm_drawerController closeDrawerAnimated:NO completion:^(BOOL finished) {
        UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"vc = %@", vc);
        if (vc == nil) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)searchBtnClick:(id)sender{
    NSLog(@"大搜索框按钮 Clicked");

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mm_drawerController closeDrawerAnimated:NO completion:^(BOOL finished) {
            [self.mm_drawerController setLeftDrawerViewController:nil];
            LXSearchViewController * vc = [[LXSearchViewController alloc]init];
            vc.searchType = LXSearchTypePhone;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    });
}

- (void)callingViewClick:(id)sender{
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
    static NSString *storeCellIdentifier = @"PhoneCell";
    
    LXPhoneCell * cell = [tableView dequeueReusableCellWithIdentifier:storeCellIdentifier];
    if (cell == nil) {
        cell = [[LXPhoneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:storeCellIdentifier];
        [cell setBackgroundColor:LX_BACKGROUND_COLOR];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"ScreenWidth = %f", ScreenWidth);
        NSLog(@"CellHeight = %f", CGRectGetHeight(cell.frame));
        [cell.contentView setFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(cell.frame))];
    }
    
    LXPhoneInfoResponseModel *model = self.tableArray[indexPath.row];

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
    [cell.callingView addTarget:self action:@selector(callingViewClick:) forControlEvents:UIControlEventTouchUpInside];

//    if (indexPath.row == 0) {
//        cell.cellSeparator.hidden = YES;
//    } else {
//        cell.cellSeparator.hidden = NO;
//    }
    
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"TableView滚动结束！");
    UITableView *tableview = (UITableView *) scrollView;
    NSArray *visibleRows = [tableview indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visibleRows) {
        if ((indexPath.row + 1 == self.tableArray.count) &&
            (self.tableArray.count == (self.pageNum + 1) * self.amountPerPage)) {
            self.pageNum ++;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self asyncConnectGetPhoneList];
            });
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Cell区高度
    CGFloat height = MARGIN * 2 + MARGIN * 2.5;
    return height;
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
    LXPhoneCell * cell = (LXPhoneCell *)[tableView cellForRowAtIndexPath:indexPath];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - 网络请求及相应的回调方法

-(void)asyncConnectPhoneGetAllTags{
    LXPhoneGetAllTagsRequest * request = [[LXPhoneGetAllTagsRequest alloc]init];//初始化网络请求
    
    request.requestMethod = LXRequestMethodGet;
    request.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    request.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    request.delegate = self;//代理设置
    request.tag = 1001;//类型标识
    
    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

-(void)asyncConnectGetPhoneList{
    [self showHUD:@"正在加载..." anim:YES];
    LXPhoneListByTagRequest * request = [[LXPhoneListByTagRequest alloc]init];//初始化网络请求
    
    request.requestMethod = LXRequestMethodGet;
    request.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    request.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:@(self.pageNum * self.amountPerPage) forKey:@"offset"];
    [paraDic setObject:@(self.amountPerPage) forKey:@"num"];
    [paraDic setObject:self.tag forKey:@"tag"];
    [paraDic setObject:@(COMMUNITY_ID) forKey:@"id"];
    [request setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

// 网络请求回调
-(void)requestResult:(NSError*) error withData:(id)responseObject responseData:(LXBaseRequest*)requestData
{
    if (requestData.tag == 1001) {
        if (error) {
            //对error进行相应的处理
            NSLog(@"%@",[[error userInfo] objectForKey:@"NSLocalizedDescription"]);
            
            //            [self showError:[[error userInfo] objectForKey:@"NSLocalizedDescription"] delay:2 anim:YES];
            [self asyncConnectGetPhoneList];
            return;
        }
        
        // 成功时有时也会有成功Message
        if (![VertifyInputFormat isEmpty:requestData.successMsg]) {
            [self showSuccess:requestData.successMsg delay:2 anim:YES];
        }
        
        // 将返回的数据进行model转换（注意：要加上对model类型的校验）
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (((NSArray *)responseObject).count > 0) {
                LXPhoneGetAllTagsResponseModel * model = ((NSArray *)responseObject)[0];
                self.tag = model.name;
            }
        }
        [self asyncConnectGetPhoneList];
        
        return;
    }
    
    return [super requestResult:error withData:responseObject responseData:requestData];
}

@end
