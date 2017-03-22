//
//  LXStoreActivityListViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 16/2/20.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreActivityListViewController.h"
#import "LXStoreActivityCell.h"
#import "LXActivityListByStoreIdRequest.h"
#import "LXActivityInfoResponseModel.h"
#import "LXStoreAddActivityViewController.h"
#import "LXStoreModifyActivityViewController.h"

#import "LXUserDefaultManager.h"
#import "VertifyInputFormat.h"
#import "LXNetManager.h"
#import "LXNotificationCenterString.h"

#import "LXUICommon.h"
#import "UIImageView+WebCache.h"
#import "NSString+Custom.h"
#import "Utils.h"
#import "UILabel+VerticalAlign.h"
#import "UITableView+FDTemplateLayoutCell.h"

static NSString *activityCellIdentifier = @"ActivityCell";

@interface LXStoreActivityListViewController ()

@property (strong, nonatomic) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * tableArray;

@end

@implementation LXStoreActivityListViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self putNavigationBar];
    [self asyncConnectGetActivityList];
    
    [self registerNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

#pragma mark - Notification

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshActivityList) name:k_Noti_refreshActivityList object:nil];
}

- (void)refreshActivityList
{
    [self removeAllSubviews];
    [self asyncConnectGetActivityList];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_Noti_refreshActivityList object:nil];
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];

    [self.lxTitleLabel setTitle:@"活动列表" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];

    [self.lxRightBtn2Img setImage:[UIImage imageNamed:@"chat_group_add"] forState:UIControlStateNormal];
    [self.lxRightBtn2Img setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.lxRightBtn2Img addTarget:self action:@selector(newActivityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxRightBtn2Img.layer.borderWidth = 1;
    //    self.lxRightBtn2Img.layer.borderColor = LX_DEBUG_COLOR;
    
    self.navigationController.navigationBar.translucent = NO;
    // 30 127 241
    self.navigationController.navigationBar.barTintColor = LX_PRIMARY_COLOR;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxLeftBtnImg];
    self.navigationItem.titleView = self.lxTitleLabel;
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
    
    //    if (IOS8_OR_LATER) {
    //        CGFloat height = MARGIN * 2 + MARGIN * 2 + MARGIN * 2 + ActivityImgHeight;
    //        self.tableView.estimatedRowHeight = height;
    //        self.tableView.rowHeight = UITableViewAutomaticDimension;
    //    }
    
    //设置系统默认分割线从边线开始(1)
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.tableView setBackgroundColor:LX_BACKGROUND_COLOR];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView registerClass:[LXStoreActivityCell class] forCellReuseIdentifier:activityCellIdentifier];
    
    [self.view addSubview:self.tableView];
}

- (void)refreshTableView
{
    if (self.tableView) {
        [self.tableView reloadData];
    }
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_refreshStoreDetail object:nil userInfo:nil];

    NSArray *arr = [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"arr = %@", arr);
    if (arr == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)newActivityBtnClick:(id)sender{
    NSLog(@"发新活动按钮 Clicked");
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            LXStoreAddActivityViewController * vc = [[LXStoreAddActivityViewController alloc]init];
            vc.store_id = self.storeId;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            nav.navigationBarHidden = NO;
            [self presentViewController:nav animated:YES completion:nil];
        });
        return;
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
    LXStoreActivityCell * cell = [tableView dequeueReusableCellWithIdentifier:activityCellIdentifier];
    
    [self setupModelOfCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void) setupModelOfCell:(LXStoreActivityCell *) cell atIndexPath:(NSIndexPath *) indexPath {
    
    // 采用计算frame模式还是自动布局模式，默认为NO，自动布局模式
    //    cell.fd_enforceFrameLayout = NO;
    
    [cell setBackgroundColor:LX_BACKGROUND_COLOR];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@"ScreenWidth = %f", ScreenWidth);
    NSLog(@"CellHeight = %f", CGRectGetHeight(cell.frame));
    [cell.contentView setFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(cell.frame))];
    
    LXActivityInfoResponseModel *model = self.tableArray[indexPath.row];
    NSLog(@"活动名称：%@", model.name);
    
    // 活动图标
    [cell.activityImg sd_setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:[UIImage imageNamed:@"default_image"]];

    // 帖子标题
    [cell.titleLabel setText:model.name];
    
    // 帖子内容
    [cell.contentLabel setText:model.description];
    
    int numberOfLines = [Utils calcLabelRowNum:model.description withFont:cell.contentLabel.font withWidth:ScreenWidth - MARGIN * 2 - ActivityImgWidth - PADDING numberOfLines:3];
    if (numberOfLines < 2) {
        numberOfLines = 2;
    }
    cell.contentLabel.numberOfLines = numberOfLines;
    double finalWidth = ScreenWidth - MARGIN * 2 - ActivityImgWidth - PADDING;
    [cell.contentLabel alignTop:finalWidth];

    // 开始时间标签
    [cell.startTimeLabel setText:[NSString stringWithFormat:@"开始时间：%@", model.begin_at]];
    
    // 截止时间标签
    [cell.endTimeLabel setText:[NSString stringWithFormat:@"截止时间：%@", model.finish_at]];

    // 活动ID
    cell.activityId = model.id;

    //    if (indexPath.row == 0) {
    //        cell.cellSeparator.hidden = YES;
    //    } else {
    //        cell.cellSeparator.hidden = NO;
    //    }
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // 帖子Cell区高度
//    CGFloat height = MARGIN * 2 + MARGIN * 2 + MARGIN * 2 + TopicImgHeight;
//    return height;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (IOS8_OR_LATER) {
    //        return UITableViewAutomaticDimension;
    //    }
    //
    //    // 帖子Cell区高度
    //    CGFloat height = MARGIN * 2 + MARGIN * 2 + MARGIN * 2 + TopicImgHeight;
    //    return height;
    return [self.tableView fd_heightForCellWithIdentifier:activityCellIdentifier cacheByIndexPath:indexPath configuration:^(LXStoreActivityCell *cell) {
        
        // 在这个block中，重新cell配置数据源
        [self setupModelOfCell:cell atIndexPath:indexPath];
    }];
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
    LXStoreActivityCell * cell = (LXStoreActivityCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"活动ID：%@ 被选择", cell.activityId);
        LXStoreModifyActivityViewController * vc = [[LXStoreModifyActivityViewController alloc]init];
        vc.activity_id = cell.activityId;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        nav.navigationBarHidden = NO;
        [self presentViewController:nav animated:YES completion:nil];
    });
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //* 设置系统默认分割线从边线开始(2)
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
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

-(void)asyncConnectGetActivityList{
    [self showHUD:@"正在加载..." anim:YES];
    LXActivityListByStoreIdRequest * request = [[LXActivityListByStoreIdRequest alloc]init];//初始化网络请求
    
    request.requestMethod = LXRequestMethodGet;
    request.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    request.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.storeId forKey:@"store_id"];
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
            
            //            [self showSuccess:@"获取主页内容成功" delay:2 anim:YES];
            [self hideHUD:YES];
            
            return;
        } else {
            [self showError:@"获取店铺活动列表失败" delay:2 anim:YES];
        }
    }
    
    return;
}

@end
