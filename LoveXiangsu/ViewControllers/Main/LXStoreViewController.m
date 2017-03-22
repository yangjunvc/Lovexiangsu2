//
//  LXStoreViewController.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/10/24.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreViewController.h"
#import "LXHomepageTableViewCell.h"
#import "LXStoreInfoResponseModel.h"
#import "LXShowStoreDetailViewController.h"
#import "LXStoreListByTagRequest.h"
#import "LXStoreGetAllTagsRequest.h"
#import "LXStoreGetAllTagsResponseModel.h"
#import "LXStoreMenuViewController.h"
#import "LXSearchViewController.h"
#import "LXStoreNewStoreViewController.h"

#import "LXUserDefaultManager.h"
#import "VertifyInputFormat.h"
#import "LXNetManager.h"
#import "LXMenuManager.h"
#import "LXNotificationCenterString.h"
#import "LXCallManager.h"

#import "LXUICommon.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+MMDrawerController.h"
#import "NSString+Custom.h"

@interface LXStoreViewController ()

@property (strong, nonatomic) UIView *emptyView;

//@property (nonatomic, strong) UITableView * tableView;
//@property (nonatomic, strong) NSArray * tableArray;

@end

@implementation LXStoreViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self putNavigationBar];

    // 首先网络请求菜单，然后会再请求具体列表内容
    [self asyncConnectStoreGetAllTags];

    [self registerNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mm_drawerController setLeftDrawerViewController:[LXMenuManager sharedInstance].storeMenuVC];
    [self.mm_drawerController setMaximumLeftDrawerWidth:StoreMenuWidth];
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

    self.tag = @"优惠";
    self.order = @"0";
}

- (void)initPropertiesWithTag:(NSString *)tag AndOrder:(NSString *)order
{
    [super initProperties];

    self.tag = tag;
    self.order = order;
}

#pragma mark - Notification

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStoreList) name:k_Noti_changeTabBarToStoreList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeMenuSelected:) name:k_Noti_StoreMenuSelected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comebackToStoreList) name:k_Noti_comebackToStoreList object:nil];
}

- (void)refreshStoreList
{
    [((LXStoreMenuViewController *)[LXMenuManager sharedInstance].storeMenuVC) setNeedsTableViewRefresh];
    [self removeAllSubviews];
    [self initProperties];
    // Tabbar切换需要重新获取菜单
    [self asyncConnectStoreGetAllTags];
}

- (void)comebackToStoreList
{
    [((LXStoreMenuViewController *)[LXMenuManager sharedInstance].storeMenuVC) setDonotNeedScrollToTop];
}

- (void)storeMenuSelected:(NSNotification * )notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSLog(@"选择了店铺菜单，参数：tag:%@，order:%@", userInfo[@"tag"], userInfo[@"order"]);
    [self removeAllSubviews];
    [self initPropertiesWithTag:userInfo[@"tag"] AndOrder:userInfo[@"order"]];
    [self asyncConnectGetStores];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_Noti_changeTabBarToStoreList object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_Noti_StoreMenuSelected object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_Noti_comebackToStoreList object:nil];
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    //    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.menuBtn.frame = CGRectMake(0, 7, 30, 30);
    //    [self.menuBtn setBackgroundImage:[UIImage imageNamed:@"main_profile"] forState:UIControlStateNormal];
    [self.lxLeftBtnImg setImage:[UIImage imageNamed:@"main_category"] forState:UIControlStateNormal];
    //    [self.menuBtn setAdjustsImageWhenHighlighted:NO];
    //    [self.menuBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [self.lxLeftBtnImg addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor yellowColor] CGColor];
    
    // [UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0]
    
    [self.searchBtn setTitle:@"搜索：店铺名、经营项目" forState:UIControlStateNormal];
    [self.searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //    self.qrCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.qrCodeBtn.frame = CGRectMake(14, 7, 30, 30);
    //    [self.qrCodeBtn setBackgroundImage:[UIImage imageNamed:@"main_qrcode"] forState:UIControlStateNormal];
    [self.lxRightBtn2Img setImage:[UIImage imageNamed:@"chat_group_add"] forState:UIControlStateNormal];
    [self.lxRightBtn2Img addTarget:self action:@selector(addStoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.qrCodeBtn setAdjustsImageWhenHighlighted:NO];
    //    [self.qrCodeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    //    self.lxRightBtn2Img.layer.borderWidth = 1;
    //    self.lxRightBtn2Img.layer.borderColor = [[UIColor yellowColor] CGColor];

    self.emptyView = [[UIView alloc]init];
    self.emptyView.frame = CGRectMake(0, 10, IconSize, IconSize);

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
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49) style:UITableViewStylePlain];
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
    UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"vc = %@", vc);
    if (vc == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)menuBtnClick:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)searchBtnClick:(id)sender{
    NSLog(@"大搜索框按钮 Clicked");

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mm_drawerController closeDrawerAnimated:NO completion:^(BOOL finished) {
            [self.mm_drawerController setLeftDrawerViewController:nil];
            LXSearchViewController * vc = [[LXSearchViewController alloc]init];
            vc.searchType = LXSearchTypeStore;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    });
}

- (void)addStoreBtnClick:(id)sender{
    NSLog(@"添加店铺按钮 Clicked");
    // 检查用户Nonce
    if ([VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        [self showTips:@"登陆后才能添加店铺。" delay:2 anim:YES];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        LXStoreNewStoreViewController * vc = [[LXStoreNewStoreViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        nav.navigationBarHidden = NO;
        [self presentViewController:nav animated:YES completion:nil];
    });
}

- (void)callingViewClick:(id)sender{
    NSLog(@"拨打店铺电话 Calling...");
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        id superView = [btn superview];
        int loopCnt = 0;
        while (![superView isKindOfClass:[LXHomepageTableViewCell class]] && loopCnt < 4) {
            superView = [superView superview];
            loopCnt ++;
        }
        if ([superView isKindOfClass:[LXHomepageTableViewCell class]]) {
            LXHomepageTableViewCell *cell = (LXHomepageTableViewCell *)superView;
            if (!cell.phone1) {
                return;
            }
            [[LXCallManager sharedInstance] asyncSaveCallRecordWithStoreId:cell.storeId phonebookId:nil];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",cell.phone1]]];
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
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *storeCellIdentifier = @"StoreCell";
    
    LXHomepageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:storeCellIdentifier];
    if (cell == nil) {
        cell = [[LXHomepageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:storeCellIdentifier];
        [cell setBackgroundColor:LX_BACKGROUND_COLOR];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"ScreenWidth = %f", ScreenWidth);
        NSLog(@"CellHeight = %f", CGRectGetHeight(cell.frame));
        [cell.contentView setFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(cell.frame))];
    }
    
    LXStoreInfoResponseModel *model = self.tableArray[indexPath.row];

    // 电话1
    cell.phone1 = model.phone1;
    // 电话2
    cell.phone2 = model.phone2;

    // 店铺图片
    [cell.storeImg sd_setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:[UIImage imageNamed:@"default_image"]];
    
    // 星级（整数化）
    int starLevel = round([model.grade floatValue]);
    [cell.storeStarLvImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"star%d", starLevel]]];
    
    // 店铺名称
    [cell.storeNameLabel setText:model.name];
    
    NSArray * imgNames = [model.tags getShowTags];
    
    // 店铺标签一
    if (imgNames.count >= 1) {
        [cell.storeTag1Img setImage:[UIImage imageNamed:imgNames[0]]];
        cell.storeTag1Img.hidden = NO;
    } else {
        cell.storeTag1Img.hidden = YES;
    }
    
    // 店铺标签二
    if (imgNames.count >= 2) {
        [cell.storeTag2Img setImage:[UIImage imageNamed:imgNames[1]]];
        cell.storeTag2Img.hidden = NO;
    } else {
        cell.storeTag2Img.hidden = YES;
    }
    
    // 店铺标签三
    if (imgNames.count >= 3) {
        [cell.storeTag3Img setImage:[UIImage imageNamed:imgNames[2]]];
        cell.storeTag3Img.hidden = NO;
    } else {
        cell.storeTag3Img.hidden = YES;
    }
    
    // 店铺标签四
    if (imgNames.count >= 4) {
        [cell.storeTag4Img setImage:[UIImage imageNamed:imgNames[3]]];
        cell.storeTag4Img.hidden = NO;
    } else {
        cell.storeTag4Img.hidden = YES;
    }

    // 店铺描述
    [cell.storeDescLabel setText:model.description];
    
    // 拨打电话图标
    if (!cell.phone1) {
        [cell.callingImg setImage:[UIImage imageNamed:@"main_store_call_disable"]];
    } else {
        [cell.callingImg setImage:[UIImage imageNamed:@"main_store_call"]];
    }
    
    // 被呼叫次数
    [cell.callTimesLabel setText:[NSString stringWithFormat:@"%@次", model.call_times]];
    
    // 店铺距离
    [cell.distanceLabel setText:model.distance];

    // 拨打电话
    [cell.callingView addTarget:self action:@selector(callingViewClick:) forControlEvents:UIControlEventTouchUpInside];

    // 店铺ID
    cell.storeId = model.id;
    
    if (indexPath.row == 0) {
        cell.cellSeparator.hidden = YES;
    } else {
        cell.cellSeparator.hidden = NO;
    }

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
                [self asyncConnectGetStores];
            });
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 店铺Cell区高度
    CGFloat height = MARGIN * 2 + MARGIN + StoreRowGap * 2 + MARGIN + MARGIN * 2;
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
    LXHomepageTableViewCell * cell = (LXHomepageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    dispatch_async(dispatch_get_main_queue(), ^{
        LXShowStoreDetailViewController * storeVC = [[LXShowStoreDetailViewController alloc]init];
        storeVC.storeId = cell.storeId;
        storeVC.storeName = cell.storeNameLabel.text;
        storeVC.storeDesc = cell.storeDescLabel.text;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:storeVC];
        nav.navigationBarHidden = NO;
        [self presentViewController:nav animated:YES completion:nil];
    });
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

-(void)asyncConnectStoreGetAllTags{
    [self showHUD:@"请稍候..." anim:YES];
    LXStoreGetAllTagsRequest * getAllTags = [[LXStoreGetAllTagsRequest alloc]init];//初始化网络请求
    
    getAllTags.requestMethod = LXRequestMethodGet;
    getAllTags.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    getAllTags.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    getAllTags.delegate = self;//代理设置
    getAllTags.tag = 1001;//类型标识
    
    [[LXNetManager sharedInstance] addRequest:getAllTags];//发送网络请求
}

-(void)asyncConnectGetStores{
    [self showHUD:@"正在加载..." anim:YES];
    LXStoreListByTagRequest * storeList = [[LXStoreListByTagRequest alloc]init];//初始化网络请求
    
    storeList.requestMethod = LXRequestMethodGet;
    storeList.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    storeList.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    storeList.delegate = self;//代理设置
    storeList.tag = 1000;//类型标识

    CLLocationCoordinate2D coordinate;
    if ([LXUserDefaultManager haveLocationInfo]) {
        coordinate = [LXUserDefaultManager getLocationInfo];
    } else {
        coordinate.latitude = 39.937953;
        coordinate.longitude = 116.610807;
    }

    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:@(self.pageNum * self.amountPerPage) forKey:@"offset"];
    [paraDic setObject:@(self.amountPerPage) forKey:@"num"];
    [paraDic setObject:self.tag forKey:@"tag"];
    [paraDic setObject:self.order forKey:@"order"];
    [paraDic setObject:@(coordinate.longitude).stringValue forKey:@"lng"];
    [paraDic setObject:@(coordinate.latitude).stringValue forKey:@"lat"];
    [paraDic setObject:@(COMMUNITY_ID) forKey:@"id"];
    [storeList setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:storeList];//发送网络请求
}

// 网络请求回调
-(void)requestResult:(NSError*) error withData:(id)responseObject responseData:(LXBaseRequest*)requestData
{
    if (requestData.tag == 1001) {
        if (error) {
            //对error进行相应的处理
            NSLog(@"%@",[[error userInfo] objectForKey:@"NSLocalizedDescription"]);
            
            //            [self showError:[[error userInfo] objectForKey:@"NSLocalizedDescription"] delay:2 anim:YES];
            [self asyncConnectGetStores];
            return;
        }
        
        // 成功时有时也会有成功Message
        if (![VertifyInputFormat isEmpty:requestData.successMsg]) {
            [self showSuccess:requestData.successMsg delay:2 anim:YES];
        }
        
        // 将返回的数据进行model转换（注意：要加上对model类型的校验）
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (((NSArray *)responseObject).count > 0) {
                LXStoreGetAllTagsResponseModel * model = ((NSArray *)responseObject)[0];
//                self.tag = model.name;
                NSDictionary *param = @{@"tag":model.name,
                                        @"order":@"0",
                                        };
                [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_StoreMenuSelected object:nil userInfo:param];
            }
        }
//        [self asyncConnectGetStores];

        return;
    }

    return [super requestResult:error withData:responseObject responseData:requestData];
}

@end
