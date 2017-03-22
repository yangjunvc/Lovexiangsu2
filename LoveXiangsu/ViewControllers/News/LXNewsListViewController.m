//
//  LXNewsListViewController.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/14.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXNewsListViewController.h"
#import "LXNewsCell.h"
#import "LXGetNewsListResponseModel.h"
#import "LXGetNewsRequest.h"
#import "LXShowNewsViewController.h"

#import "LXUserDefaultManager.h"
#import "VertifyInputFormat.h"
#import "LXNetManager.h"
#import "LXUICommon.h"
#import "Utils.h"
#import "UITableView+FDTemplateLayoutCell.h"

static NSString *storeCellIdentifier = @"NewsCell";

@interface LXNewsListViewController ()

@property (strong, nonatomic) UIView *emptyView;

@end

@implementation LXNewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self hiddenMenuViewController];
    [self putNavigationBar];
    [self asyncConnectGetNews];
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

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxTitleLabel setTitle:@"新闻" forState:UIControlStateNormal];
    [self.lxTitleLabel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.lxTitleLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    self.lxTitleLabel.layer.borderWidth = 1;
//    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    self.emptyView = [[UIView alloc]init];
    self.emptyView.frame = CGRectMake(14, 7, 30, 30);

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
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 列表
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    //    self.tableView.sectionFooterHeight = 0;//去掉tableView自己加的区尾
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.bounces = YES;
    self.tableView.scrollEnabled = YES;

//    if (IOS8_OR_LATER) {
//        CGFloat height = MARGIN * 2 + MARGIN * 2 + PADDING * 3 + MARGIN;
//        self.tableView.estimatedRowHeight = height;
//        self.tableView.rowHeight = UITableViewAutomaticDimension;
//    }

    // 设置系统默认分割线从边线开始(1)
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

    [self.tableView registerClass:[LXNewsCell class] forCellReuseIdentifier:storeCellIdentifier];

    [self.view addSubview:self.tableView];
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"vc = %@", vc);
    if (vc == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
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
    LXNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:storeCellIdentifier];

    [self setupModelOfCell:cell atIndexPath:indexPath];

    return cell;
}

- (void) setupModelOfCell:(LXNewsCell *) cell atIndexPath:(NSIndexPath *) indexPath {
    
    // 采用计算frame模式还是自动布局模式，默认为NO，自动布局模式
    //    cell.fd_enforceFrameLayout = NO;

    [cell setBackgroundColor:LX_BACKGROUND_COLOR];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@"ScreenWidth = %f", ScreenWidth);
    NSLog(@"CellHeight = %f", CGRectGetHeight(cell.frame));
    [cell.contentView setFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(cell.frame))];

    LXGetNewsListResponseModel *model = self.tableArray[indexPath.row];
    
    cell.nameLabel.text = model.name;
    int numberOfLines = [Utils calcLabelRowNum:model.name withFont:cell.nameLabel.font withWidth:ScreenWidth - MARGIN * 2 numberOfLines:2];
    cell.nameLabel.numberOfLines = numberOfLines;
    
    cell.contentLabel.text = model.content;
    numberOfLines = [Utils calcLabelRowNum:model.content withFont:cell.contentLabel.font withWidth:ScreenWidth - MARGIN * 2 numberOfLines:2];
    cell.contentLabel.numberOfLines = numberOfLines;
    
    cell.timeLabel.text = model.created_at;
    
    cell.id = model.id;
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
                [self asyncConnectGetNews];
            });
        }
    }
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // 店铺Cell区高度
////    CGFloat height = MARGIN * 2 + MARGIN * 2 + PADDING * 3 + MARGIN;
//    CGFloat height = MARGIN * 2 + MARGIN * 2.5 + PADDING * 4.5 + PADDING * 2;
//    return height;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (IOS8_OR_LATER) {
//        return UITableViewAutomaticDimension;
//    }
//
//    // 店铺Cell区高度
//    CGFloat height = MARGIN * 2 + MARGIN * 2.5 + PADDING * 4.5 + PADDING * 2;
//    return height;
    return [self.tableView fd_heightForCellWithIdentifier:storeCellIdentifier cacheByIndexPath:indexPath configuration:^(LXNewsCell *cell) {
        
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
    LXNewsCell * cell = (LXNewsCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    LXShowNewsViewController *newsVC = [[LXShowNewsViewController alloc]init];
    newsVC.id = cell.id;
    newsVC.name = cell.nameLabel.text;
    [self.navigationController pushViewController:newsVC animated:YES];
    
    //    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

-(void)asyncConnectGetNews{
    [self showHUD:@"正在加载..." anim:YES];
    LXGetNewsRequest * request = [[LXGetNewsRequest alloc]init];//初始化网络请求

    request.requestMethod = LXRequestMethodGet;
    request.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    request.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是HTTP类型响应
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识

    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:@(self.pageNum * self.amountPerPage) forKey:@"offset"];
    [paraDic setObject:@(self.amountPerPage) forKey:@"num"];
    [request setCustomRequestParams:paraDic];//设置入参

    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

@end
