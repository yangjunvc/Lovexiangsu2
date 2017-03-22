//
//  LXMyCollectStoresViewController.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/8.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXMyCollectStoresViewController.h"
#import "LXHomepageTableViewCell.h"
#import "LXStoreInfoResponseModel.h"
#import "LXShowStoreDetailViewController.h"
#import "LXMyCollectStoresRequest.h"
#import "LXUserDefaultManager.h"
#import "VertifyInputFormat.h"
#import "LXNetManager.h"
#import "LXCallManager.h"

#import "LXUICommon.h"
#import "UIImageView+WebCache.h"
#import "NSString+Custom.h"

@interface LXMyCollectStoresViewController ()

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * tableArray;

@property (strong, nonatomic) UIView *emptyView;

@end

@implementation LXMyCollectStoresViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self hiddenMenuViewController];
    [self putNavigationBar];
    [self asyncConnectGetMyCollectStores];
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
    
    [self.lxTitleLabel setTitle:@"我收藏的店铺" forState:UIControlStateNormal];
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
    static NSString *storeCellIdentifier = @"CollectCell";
    
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

-(void)asyncConnectGetMyCollectStores{
    [self showHUD:@"正在加载..." anim:YES];
    LXMyCollectStoresRequest * myCollect = [[LXMyCollectStoresRequest alloc]init];//初始化网络请求
    
    myCollect.delegate = self;//代理设置
    myCollect.tag = 1000;//类型标识
    
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [myCollect setHeaderParam:headDic];//设置Header入参
    }

    [[LXNetManager sharedInstance] addRequest:myCollect];//发送网络请求
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
            [self showError:@"获取我收藏的店铺列表失败" delay:2 anim:YES];
        }
    }

    return;
}

@end
