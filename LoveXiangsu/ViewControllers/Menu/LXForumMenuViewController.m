//
//  LXForumMenuViewController.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/11.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXForumMenuViewController.h"
#import "LXForumMenuCell.h"
#import "LXForumGetAllTagsResponseModel.h"
#import "LXForumGetAllTagsRequest.h"

#import "LXNotificationCenterString.h"
#import "LXNetManager.h"
#import "VertifyInputFormat.h"
#import "LXUICommon.h"

@interface LXForumMenuViewController ()

@property (nonatomic, assign) BOOL needScrollToTop;
@property (nonatomic, strong) UIView * separatorView;

@end

@implementation LXForumMenuViewController

NSString * defaultForumName = @"";
NSInteger  defaultForumId = 1;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialize];
    [self drawRightseparator];
    [self asyncConnectForumGetAllTags];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.tableArray == nil) {
        NSLog(@"viewDidAppear:清空论坛菜单~~~");
        [self removeAllSubviews];
        [self asyncConnectForumGetAllTags];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.tableArray.count > 0 && self.tableView && self.needScrollToTop) {
        NSLog(@"viewDidLayoutSubviews:论坛菜单滚动到第一个~~~");
        if (![self.tableView indexPathForSelectedRow]) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

#pragma mark - 初始化

- (void)initialize
{
    self.needScrollToTop = YES;
}

#pragma mark - 右分隔线

- (void)drawRightseparator
{
    UIView * view = [[UIView alloc]init];
    view.layer.borderColor = [LX_THIRD_TEXT_COLOR CGColor];
    view.layer.borderWidth = BorderWidth05;
    [self.view addSubview:view];
    self.separatorView = view;
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(0);
        make.width.equalTo(0.5);
    }];
}

#pragma mark - Clean Work

- (void)removeAllSubviews
{
    for (UIView *view in self.view.subviews) {
        if (view == self.separatorView) {
            continue;
        }
        [view removeFromSuperview];
    }
}

- (void)setNeedsTableViewRefresh
{
    self.tableArray = nil;
    self.needScrollToTop = YES;
}

- (void)setDonotNeedScrollToTop
{
    if (self.tableArray.count > 0 && [self.tableView indexPathForSelectedRow]) {
        self.needScrollToTop = NO;
    }
}

#pragma mark - TableView初始化

-(void)putTableView{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ForumMenuWidth - 0.5, ScreenHeight + rectStatus.size.height) style:UITableViewStyleGrouped];
    self.tableView.sectionFooterHeight = 0;//去掉tableView自己加的区尾
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = YES;
    self.tableView.scrollEnabled = YES;
    
    //设置系统默认分割线从边线开始(1)
    //    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
    //
    //        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    //
    //    }
    //
    //    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
    //
    //        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    //
    //    }
    //
    [self.tableView setBackgroundColor:LX_BACKGROUND_COLOR];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
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
    static NSString *CellIdentifier = @"ForumMenuCell";
    
    LXForumMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LXForumMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setBackgroundColor:LX_BACKGROUND_COLOR];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView setFrame:CGRectMake(0, 0, ForumMenuWidth - 0.5, CGRectGetHeight(cell.frame))];
    }
    LXForumGetAllTagsResponseModel * model = self.tableArray[indexPath.row];
    NSString *origImgName = [NSString stringWithFormat:@"%@_off", model.resource_name];
    NSString *highImgName = [NSString stringWithFormat:@"%@_on", model.resource_name];
    [cell.contentImg setImage:[UIImage imageNamed:origImgName]];
    cell.origImg = [UIImage imageNamed:origImgName];
    cell.highlightImg = [UIImage imageNamed:highImgName];
    [cell.contentLabel setText:model.name];
    cell.id = model.id;
    //    [cell.contentLabel setBackgroundColor:[UIColor greenColor]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ForumMenuWidth;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    return PADDING + rectStatus.size.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ForumMenuWidth - 0.5, PADDING + rectStatus.size.height)];
    view.backgroundColor = LX_BACKGROUND_COLOR;
    //    view.layer.borderColor = LX_DEBUG_COLOR;
    //    view.layer.borderWidth = 1;
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Cell Selected!");
    LXForumMenuCell * cell = (LXForumMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *param = @{@"forum_id":cell.id,
                            @"name":cell.contentLabel.text,
                            };
    [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_ForumMenuSelected object:nil userInfo:param];
    //    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

-(void)asyncConnectForumGetAllTags{
    LXForumGetAllTagsRequest * getAllTags = [[LXForumGetAllTagsRequest alloc]init];//初始化网络请求
    
    getAllTags.requestMethod = LXRequestMethodGet;
    getAllTags.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    getAllTags.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    getAllTags.delegate = self;//代理设置
    getAllTags.tag = 1000;//类型标识

    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:@(COMMUNITY_ID) forKey:@"community_id"];
    [getAllTags setCustomRequestParams:paraDic];//设置入参

    [[LXNetManager sharedInstance] addRequest:getAllTags];//发送网络请求
}

// 网络请求回调
-(void)requestResult:(NSError*) error withData:(id)responseObject responseData:(LXBaseRequest*)requestData
{
    if (requestData.tag == 1000) {
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
        if ([responseObject isKindOfClass:[NSArray class]]) {
            self.tableArray = responseObject;

            // 获取缺省论坛信息（索引1）
            if (self.tableArray.count >= 2) {
                LXForumGetAllTagsResponseModel * model = self.tableArray[1];
                defaultForumId = [model.id integerValue];
                defaultForumName = model.name;
                NSLog(@"缺省论坛信息，ID：%ld，名称：%@", (long)defaultForumId, defaultForumName);
            }

            NSLog(@"requestResult:绘制论坛菜单~~~");
            [self putTableView];
            [self.view setNeedsLayout];
            [self.tableView layoutSubviews];
            return;
        }
    }
    
    return;
}

@end
