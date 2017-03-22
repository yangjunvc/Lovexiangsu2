//
//  LXHomepageViewController.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/10/24.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXHomepageViewController.h"
#import "LXMainPageRequest.h"
#import "LXMainPageResponseModel.h"
#import "LXStoreInfoResponseModel.h"
#import "LXHomepageTableViewCell.h"
#import "LXHomepageHeaderView.h"
#import "LXHomepageFunctionCell.h"
#import "LXHomepageTitleCell.h"
#import "LXLoginViewController.h"
#import "LXShowNewsViewController.h"
#import "LXShowStoreDetailViewController.h"
#import "LXMyCollectStoresViewController.h"
#import "LXMainTabbarController.h"
#import "LXNewsListViewController.h"
#import "LXFavoritePhoneListViewController.h"
#import "LXNotificationCenterString.h"
#import "LXSearchViewController.h"

#import "LXCommon.h"
#import "LXUICommon.h"
#import "LXNetManager.h"
#import "LXMenuManager.h"
#import "LXUserDefaultManager.h"
#import "VertifyInputFormat.h"
#import "UIViewController+MMDrawerController.h"
#import "UIImageView+WebCache.h"
#import "UILabel+VerticalAlign.h"
#import "NSString+Custom.h"
#import "Utils.h"
#import "QRCodeReaderViewController.h"
#import "LXCallManager.h"

@interface LXHomepageViewController ()<QRCodeReaderDelegate>

//@property (strong, nonatomic) UIButton *menuBtn;
//@property (strong, nonatomic) UIButton *searchBtn;
//@property (strong, nonatomic) UIButton *qrCodeBtn;

@property (strong, nonatomic) LXHomepageHeaderView *headerView;
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSArray * tableArray;
@property (nonatomic, strong) NSArray * myCollectsArray;
@property (nonatomic, strong) LXNewsInfoResponseModel * news;

@property (nonatomic, strong) QRCodeReaderViewController *qrReaderVC;
@property (nonatomic, strong) NSString * qrReaderResult;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy)   AMapLocatingCompletionBlock completionBlock;


@end

@implementation LXHomepageViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 初始化高德地图定位
    [self initLocationManager];
    [self initCompleteBlock];
    [self configLocationManager];
    [self locAction];

    // 设置导航条
    [self putNavigationBar];

    // 获取推荐店铺列表及推荐新闻
//    [self asyncConnectMainPage];

    // 注册通知
    [self registerNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mm_drawerController setLeftDrawerViewController:[LXMenuManager sharedInstance].mainMenuNavVC];
    int menuWidth = MenuWidth;
    [self.mm_drawerController setMaximumLeftDrawerWidth:menuWidth];
    [self.mm_drawerController setCenterInteractionEnable:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // 首页显示完成后，发通知关闭APP自定义启动页
    [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_removeAppStartView object:nil];
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

    // 高德地图清理
    [self cleanUpAction];

    // 移除通知
    [self removeNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 高德地图

- (void)initLocationManager
{
    [self showHUD:@"努力定位中..." anim:YES];
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
}

- (void)initCompleteBlock
{
    __weak LXHomepageViewController *wSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error)
        {
            // 清除历史定位信息
            [LXUserDefaultManager clearLocationInfo];

            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                NSLog(@"错误类型:定位错误");
            }
        } else if (location)
        {
            // 保存定位信息
            [LXUserDefaultManager saveLocationInfo:location.coordinate];
        }

        LXHomepageViewController *sSelf = wSelf;
        // 获取推荐店铺列表及推荐新闻
        [sSelf asyncConnectMainPage];
    };
}

- (void)configLocationManager
{
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
}

- (void)locAction
{
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:self.completionBlock];
}

#pragma mark - MALocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    NSLog(@"%s, didUpdateLocation = {lat:%f; lon:%f;}", __func__, location.coordinate.latitude, location.coordinate.longitude);
}

#pragma mark - Notification

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomepage) name:k_Noti_changeTabBarToHomepage object:nil];
}

- (void)refreshHomepage
{
    // 先清空页面
    [self removeAllSubviews];

    // 重新请求网络加载主页的数据
    [self asyncConnectMainPage];
}

#pragma mark - Clean Work

- (void)cleanUpAction
{
    [self.locationManager stopUpdatingLocation];
    self.completionBlock = nil;
    
    //Restore Default Value
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setPausesLocationUpdatesAutomatically:YES];
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    
    self.locationManager.delegate = nil;
}

- (void)removeAllSubviews
{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_Noti_changeTabBarToHomepage object:nil];
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
//    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.menuBtn.frame = CGRectMake(0, 7, 30, 30);
//    [self.menuBtn setBackgroundImage:[UIImage imageNamed:@"main_profile"] forState:UIControlStateNormal];
    [self.lxLeftBtnImg setImage:[UIImage imageNamed:@"main_profile"] forState:UIControlStateNormal];
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
    [self.lxRightBtn2Img setImage:[UIImage imageNamed:@"main_qrcode"] forState:UIControlStateNormal];
    [self.lxRightBtn2Img addTarget:self action:@selector(qrcodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - NewsBar初始化

-(void)putNewsBar{
    // HeaderView
    self.headerView = [[LXHomepageHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 51)];
    self.headerView.backgroundColor = LX_BACKGROUND_COLOR;
    self.headerView.userInteractionEnabled = YES;
    
    // 小喇叭
    [self.headerView.trumpetBtn setImage:[UIImage imageNamed:@"main_home_trumpet"] forState:UIControlStateNormal];
    [self.headerView.trumpetBtn setAdjustsImageWhenHighlighted:NO];
    [self.headerView.trumpetBtn addTarget:self action:@selector(trumpetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 新闻链接
    NSString *text = nil;
    if ([VertifyInputFormat isEmpty:self.news.name]) {
        text = @"网络不给力哦~~";
    } else {
        text = self.news.name;
    }
    [self.headerView.newsLabel setText:text];
    self.headerView.newsLabel.font = LX_TEXTSIZE_16;
    self.headerView.newsLabel.textColor = LX_MAIN_TEXT_COLOR;
    double finalWidth = ScreenWidth - MARGIN - TrumpetImgSize - PADDING - (MoreNewsBtnWidth + 1) - MARGIN;
    double realHeight = [Utils calcLabelHeight:text withFont:LX_TEXTSIZE_16 withWidth:finalWidth numberOfLines:2];
    CGSize fontSize = [self.headerView.newsLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.headerView.newsLabel.font,NSFontAttributeName, nil]];
    int numOfLines = ((double)realHeight) / fontSize.height;
    self.headerView.newsLabel.numberOfLines = numOfLines;
    self.headerView.newsLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(newsLabelTap:)];
    [self.headerView.newsLabel addGestureRecognizer:tap];
    self.headerView.newsLabelRealHeight = realHeight + 0.5;
    
    // 根据新闻链接最终高度，修改HeaderView的高度
    CGRect headerFrame = CGRectMake(0, 0, ScreenWidth, self.headerView.newsLabelRealHeight + PADDING * 2);
    self.headerView.frame = headerFrame;
    
    // 更多新闻
    [self.headerView.moreNewsBtn setTitle:@"更多>" forState:UIControlStateNormal];
    [self.headerView.moreNewsBtn setTitleColor:LX_THIRD_TEXT_COLOR forState:UIControlStateNormal];
    [self.headerView.moreNewsBtn addTarget:self action:@selector(moreNewsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.headerView];
}

#pragma mark - TableView初始化

-(void)putTableView{
    self.edgesForExtendedLayout = UIRectEdgeNone;

    // 推荐店铺列表
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.headerView.frame.size.height, ScreenWidth, ScreenHeight-64-49-self.headerView.frame.size.height) style:UITableViewStyleGrouped];
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

- (void)menuBtnClick:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)searchBtnClick:(id)sender{
    NSLog(@"大搜索框按钮 Clicked");

    LXSearchViewController * vc = [[LXSearchViewController alloc]init];
    vc.searchType = LXSearchTypeStore;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)qrcodeBtnClick:(id)sender{
    NSLog(@"扫二维码按钮 Clicked");
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
//        NSString * msg = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”选项中，允许i%@访问你的相机", COMMUNITY_APPNAME];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:CAMERA_TIP_MSG delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
        [alert show];
        return;
    }
    else{
        self.qrReaderVC = [QRCodeReaderViewController new];
        self.qrReaderVC.modalPresentationStyle = UIModalPresentationFormSheet;
        self.qrReaderVC.delegate = self;
        [self.navigationController pushViewController:self.qrReaderVC animated:YES];
    }
}

- (void)trumpetBtnClick:(id)sender{
    NSLog(@"小喇叭按钮 Clicked");
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSLog(@"已经是登录状态");
        return;
    }
    LXLoginViewController *loginVC = [[LXLoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    nav.navigationBarHidden = NO;

    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)newsLabelTap:(UITapGestureRecognizer *)tap
{
    NSLog(@"新闻标签 Taped");
    if ([VertifyInputFormat isEmpty:self.news.name] ||
        [VertifyInputFormat isEmpty:self.news.content]) {
        NSLog(@"新闻链接为空，无法跳转！");
        return;
    }
    LXShowNewsViewController *newsVC = [[LXShowNewsViewController alloc]init];
    newsVC.htmlContent = self.news.content;
    newsVC.name = self.news.name;
    [self.navigationController pushViewController:newsVC animated:YES];
}

- (void)moreNewsBtnClick:(id)sender{
    NSLog(@"更多新闻按钮 Clicked");
    LXNewsListViewController *newsVC = [[LXNewsListViewController alloc]init];
    [self.navigationController pushViewController:newsVC animated:YES];
}

- (void)noticeBtnClick:(id)sender{
    NSLog(@"小区公告按钮 Clicked");
    LXNewsListViewController *newsVC = [[LXNewsListViewController alloc]init];
    [self.navigationController pushViewController:newsVC animated:YES];
}

- (void)phoneBtnClick:(id)sender{
    NSLog(@"常用电话按钮 Clicked");
    LXFavoritePhoneListViewController *phoneVC = [[LXFavoritePhoneListViewController alloc]init];
    [self.navigationController pushViewController:phoneVC animated:YES];
}

- (void)moreStoresBtnClick:(id)sender{
    NSLog(@"更多店铺按钮 Clicked");
    [((LXMainTabbarController *)self.tabBarController) selectAnotherViewController:1];
}

- (void)moreCollectsBtnClick:(id)sender{
    NSLog(@"更多收藏按钮 Clicked");
    LXMyCollectStoresViewController * collectVC = [[LXMyCollectStoresViewController alloc]init];
    [self.navigationController pushViewController:collectVC animated:YES];
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

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    self.qrReaderResult = result;

    // 解析二维码内容，判断是否是i爱像素的URL
    if ([result rangeOfString:QRCODE_PREFIX].location != NSNotFound) {
        NSArray *arr = [result componentsSeparatedByString:QRCODE_PREFIX];
        if (arr.count == 2) {
            NSString *id = arr[1];
            LXShowStoreDetailViewController * storeVC = [[LXShowStoreDetailViewController alloc]init];
            storeVC.storeId = id;
            [self.navigationController pushViewController:storeVC animated:YES];
            return;
        }
    }
    
    // 不在处理范围内的二维码内容，弹窗显示内容并支持复制
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"复制",nil];
    alert.tag = 10;
    [alert show];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 10){
        if (buttonIndex == 1) {
            //复制文字
            [[UIPasteboard generalPasteboard] setString:self.qrReaderResult];
        }

        //继续扫码
        [self.qrReaderVC startScanning];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 一个固定推荐店铺Section + 一个收藏店铺Section（没有则不显示此Section）
    return 1 + (self.myCollectsArray.count > 0 ? 1 : 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        // 推荐店铺数组数量
        return self.tableArray.count;
    } else if (section == 1) {
        // 收藏店铺数组数量
        return self.myCollectsArray.count;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *storeCellIdentifier = @"StoreCell";

    if (indexPath.section == 0) {
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
    } else if (indexPath.section == 1) {
        LXHomepageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:storeCellIdentifier];
        if (cell == nil) {
            cell = [[LXHomepageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:storeCellIdentifier];
            [cell setBackgroundColor:LX_BACKGROUND_COLOR];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSLog(@"ScreenWidth = %f", ScreenWidth);
            NSLog(@"CellHeight = %f", CGRectGetHeight(cell.frame));
            [cell.contentView setFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(cell.frame))];
        }
        
        LXStoreInfoResponseModel *model = self.myCollectsArray[indexPath.row];

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

    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < 2) {
        // 店铺Cell区高度
        CGFloat height = MARGIN * 2 + MARGIN + StoreRowGap * 2 + MARGIN + MARGIN * 2;
        return height;
    } else {
        return 0.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    double finalWidth = ScreenWidth - MARGIN - TrumpetImgSize - PADDING - (MoreNewsBtnWidth + 1) - MARGIN;
//    double realHeight = [Utils calcLabelHeight:self.news.name withFont:LX_TEXTSIZE_16 withWidth:finalWidth numberOfLines:2];
//    return realHeight + 0.5 + PADDING * 2;
    if (section == 0) {
        return MARGIN * 2 + MARGIN * 2 + NoticeImgSize;
    } else if (section == 1) {
        return MARGIN * 2;
    }

    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 7.5;
    } else {
        return 0.1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.myCollectsArray.count == 0) {
            return nil;
        }
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 7.5)];
        view.backgroundColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0];
        return view;
    } else if (section == 1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
        return view;
    }

    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc]init];

        LXHomepageFunctionCell * functionCell = [[LXHomepageFunctionCell alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MARGIN * 2 + NoticeImgSize)];
        [functionCell setBackgroundColor:LX_BACKGROUND_COLOR];

        // 小区公告
        [functionCell.noticeImgBtn setImage:[UIImage imageNamed:@"main_home_news"] forState:UIControlStateNormal];
        [functionCell.noticeImgBtn setAdjustsImageWhenHighlighted:NO];
        [functionCell.noticeImgBtn addTarget:self action:@selector(noticeBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        [functionCell.noticeTxtBtn setTitle:@"小区公告" forState:UIControlStateNormal];
        [functionCell.noticeTxtBtn setTitleColor:LX_SECOND_TEXT_COLOR forState:UIControlStateNormal];
        [functionCell.noticeTxtBtn addTarget:self action:@selector(noticeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        functionCell.noticeTxtBtn.layer.borderColor = LX_DEBUG_COLOR;
        functionCell.noticeTxtBtn.layer.borderWidth = 1;

        // 常用电话
        [functionCell.phoneImgBtn setImage:[UIImage imageNamed:@"main_home_phone"] forState:UIControlStateNormal];
        [functionCell.phoneImgBtn setAdjustsImageWhenHighlighted:NO];
        [functionCell.phoneImgBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        [functionCell.phoneTxtBtn setTitle:@"常用电话" forState:UIControlStateNormal];
        [functionCell.phoneTxtBtn setTitleColor:LX_SECOND_TEXT_COLOR forState:UIControlStateNormal];
        [functionCell.phoneTxtBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        functionCell.phoneTxtBtn.layer.borderColor = LX_DEBUG_COLOR;
        functionCell.phoneTxtBtn.layer.borderWidth = 1;

        [view addSubview:functionCell];

        LXHomepageTitleCell * titleCell = [[LXHomepageTitleCell alloc]initWithFrame:CGRectMake(0, functionCell.frame.size.height, ScreenWidth, MARGIN * 2)];
        [titleCell setBackgroundColor:LX_BACKGROUND_COLOR];

        // 店铺区域标题
        titleCell.titleLabel.text = @"最新优惠";
        titleCell.titleLabel.textColor = LX_THIRD_TEXT_COLOR;
        titleCell.titleLabel.layer.borderColor = LX_DEBUG_COLOR;
        titleCell.titleLabel.layer.borderWidth = 1;

        [titleCell.moreStoresBtn setTitle:@"更多>" forState:UIControlStateNormal];
        [titleCell.moreStoresBtn setTitleColor:LX_THIRD_TEXT_COLOR forState:UIControlStateNormal];
        [titleCell.moreStoresBtn addTarget:self action:@selector(moreStoresBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        titleCell.moreStoresBtn.layer.borderColor = LX_DEBUG_COLOR;
        titleCell.moreStoresBtn.layer.borderWidth = 1;

        [view addSubview:titleCell];

        view.frame = CGRectMake(0, 0, ScreenWidth, functionCell.frame.size.height + titleCell.frame.size.height);
        NSLog(@"heightForHeader = %f", view.frame.size.height);

        return view;
    } else if (section == 1) {
        LXHomepageTitleCell * titleCell = [[LXHomepageTitleCell alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MARGIN * 2)];
        [titleCell setBackgroundColor:LX_BACKGROUND_COLOR];
        
        // 店铺区域标题
        titleCell.titleLabel.text = @"我的收藏";
        titleCell.titleLabel.textColor = LX_THIRD_TEXT_COLOR;
        titleCell.titleLabel.layer.borderColor = LX_DEBUG_COLOR;
        titleCell.titleLabel.layer.borderWidth = 1;
        
        [titleCell.moreStoresBtn setTitle:@"更多>" forState:UIControlStateNormal];
        [titleCell.moreStoresBtn setTitleColor:LX_THIRD_TEXT_COLOR forState:UIControlStateNormal];
        [titleCell.moreStoresBtn addTarget:self action:@selector(moreCollectsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        titleCell.moreStoresBtn.layer.borderColor = LX_DEBUG_COLOR;
        titleCell.moreStoresBtn.layer.borderWidth = 1;

        return titleCell;
    }

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

-(void)asyncConnectMainPage{
    [self showHUD:@"正在加载..." anim:YES];
    LXMainPageRequest * mainPage = [[LXMainPageRequest alloc]init];//初始化网络请求

    mainPage.delegate = self;//代理设置
    mainPage.tag = 1000;//类型标识

    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [mainPage setHeaderParam:headDic];//设置Header入参
    }

    CLLocationCoordinate2D coordinate;
    if ([LXUserDefaultManager haveLocationInfo]) {
        coordinate = [LXUserDefaultManager getLocationInfo];
    } else {
        coordinate.latitude = 39.937953;
        coordinate.longitude = 116.610807;
    }

    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:@(COMMUNITY_ID) forKey:@"id"];
    [paraDic setObject:@(coordinate.longitude).stringValue forKey:@"lng"];
    [paraDic setObject:@(coordinate.latitude).stringValue forKey:@"lat"];
    [mainPage setCustomRequestParams:paraDic];//设置入参

    [[LXNetManager sharedInstance] addRequest:mainPage];//发送网络请求
}

// 网络请求回调
-(void)requestResult:(NSError*) error withData:(id)responseObject responseData:(LXBaseRequest*)requestData
{
    if (requestData.tag == 1000) {
        if (error) {
            //对error进行相应的处理
            NSLog(@"%@",[[error userInfo] objectForKey:@"NSLocalizedDescription"]);
            [self putNewsBar];
            [self putTableView];
            [self showError:[[error userInfo] objectForKey:@"NSLocalizedDescription"] delay:2 anim:YES];
            return;
        }
        
        // 成功时有时也会有成功Message
        if (![VertifyInputFormat isEmpty:requestData.successMsg]) {
            [self showSuccess:requestData.successMsg delay:2 anim:YES];
        }
        
        // 将返回的数据进行model转换（注意：要加上对model类型的校验）
        LXMainPageResponseModel * responseModel = nil;
        if ([responseObject isKindOfClass:[LXMainPageResponseModel class]]) {
            responseModel = (LXMainPageResponseModel *)responseObject;

            self.tableArray = responseModel.stores;
            self.news = responseModel.news;
            self.myCollectsArray = responseModel.my_collects;

            [self putNewsBar];
            [self putTableView];

//            [self showSuccess:@"获取主页内容成功" delay:2 anim:YES];
            [self hideHUD:YES];

            return;
        } else {
            [self showError:@"获取主页内容失败" delay:2 anim:YES];
        }
    }

    return;
}

@end
