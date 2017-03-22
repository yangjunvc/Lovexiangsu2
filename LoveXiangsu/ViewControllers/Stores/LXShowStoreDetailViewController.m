//
//  LXShowStoreDetailViewController.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/8.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXShowStoreDetailViewController.h"
#import "LXStoreAddCommentViewController.h"
#import "LXStoreFixInfosViewController.h"
#import "LXNotificationCenterString.h"
#import "LXStoreCheckCollectRequest.h"
#import "LXStoreAddCollectRequest.h"
#import "LXStoreRemoveCollectRequest.h"
#import "LXStoreCheckCollectResponseModel.h"
#import "LXStoreGetInfoRequest.h"
#import "LXStoreInfoResponseModel.h"
#import "LXStoreSelectLocationViewController.h"
#import "LXStoreModifyInfosViewController.h"
#import "LXStoreActivityListViewController.h"
#import "LXStoreArticleListViewController.h"
#import "LXStoreServiceListViewController.h"
#import "LXStoreCommentListViewController.h"

#import "VertifyInputFormat.h"
#import "LXNetManager.h"
#import "LXUICommon.h"
#import "LXUserDefaultManager.h"

@interface LXShowStoreDetailViewController ()

@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, strong) UIButton  * commentBtn;
@property (nonatomic, strong) UIButton  * editBtn;

@property (nonatomic, strong) UIButton  * fixBtn;

@property (nonatomic, assign) BOOL        isCollect;

@property (strong, nonatomic) NSString  * phone1;
@property (strong, nonatomic) NSString  * phone2;

/**
 *  面板
 */
@property (nonatomic, strong) UIView    * panelView;

/**
 *  加载视图
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation LXShowStoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    [self hiddenMenuViewController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStoreDetail) name:k_Noti_refreshStoreDetail object:nil];

    [self putNavigationBar];
    [self initLoadingView];
    [self putElements];

    [self asyncConnectStoreCheckCollect];

    // 从二维码扫描进入时，无法从上一页面传入店铺信息，需重新获取
//    if ([VertifyInputFormat isEmpty:self.storeName] || [VertifyInputFormat isEmpty:self.storeDesc]) {
        [self asyncConnectStoreGetInfo];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.webView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_Noti_refreshStoreDetail object:nil];
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.lxLeftBtnImg.layer.borderWidth = 1;
//    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxTitleLabel setTitle:@"店铺详情" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];

    [self.lxRightBtn1Img setImage:[UIImage imageNamed:@"store_detail_checkbox_unchecked"] forState:UIControlStateNormal];
    [self.lxRightBtn1Img addTarget:self action:@selector(lxAddCollectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.lxRightBtn1Img.layer.borderWidth = 1;
//    self.lxRightBtn1Img.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxRightBtn2Img setImage:[UIImage imageNamed:@"store_detail_share"] forState:UIControlStateNormal];
    [self.lxRightBtn2Img addTarget:self action:@selector(lxShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.lxRightBtn2Img.layer.borderWidth = 1;
//    self.lxRightBtn2Img.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];

    self.navigationController.navigationBar.translucent = NO;
    // 30 127 241
    self.navigationController.navigationBar.barTintColor = LX_PRIMARY_COLOR;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxLeftBtnImg];
    self.navigationItem.titleView = self.lxTitleLabel;
    NSArray * rightBtnItems = @[[[UIBarButtonItem alloc]initWithCustomView:self.lxRightBtn2Img],
                                [[UIBarButtonItem alloc]initWithCustomView:self.lxRightBtn1Img]];
    [self.navigationItem setRightBarButtonItems:rightBtnItems animated:YES];
}

#pragma mark - Element of Page

- (void)putElements
{
    [self.view setBackgroundColor:LX_BACKGROUND_COLOR];

    self.webView = [[UIWebView alloc]init];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    self.webView.scalesPageToFit = NO;
    self.webView.backgroundColor = LX_BACKGROUND_COLOR;
    NSString *detailURL = [NSString stringWithFormat:@"http://download.21xiaoqu.com/store/detail?id=%@&apptype=iOS", self.storeId];
    NSString *pathStr= [detailURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:pathStr];
    NSLog(@"url = %@",url);
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(0);
    }];

    self.fixBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"纠错"];
    NSRange strRange = {0,[str length]};
    NSDictionary *dict = @{NSForegroundColorAttributeName:LX_PRIMARY_COLOR,
                           NSFontAttributeName:LX_TEXTSIZE_16,
                           };
    [str addAttributes:dict range:strRange];
    [self.fixBtn setAttributedTitle:str forState:UIControlStateNormal];
    [self.fixBtn addTarget:self action:@selector(fixBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.fixBtn.layer.borderColor = LX_DEBUG_COLOR;
    self.fixBtn.layer.borderWidth = 1;
    [self.view addSubview:self.fixBtn];
    [self.fixBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(PADDING);
        make.right.equalTo(self.view.right).offset(-PADDING);
        make.width.equalTo(55);
        make.height.equalTo(35);
    }];
    self.fixBtn.hidden = YES;

    self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentBtn setImage:[UIImage imageNamed:@"float_comment"] forState:UIControlStateNormal];
    [self.commentBtn setAdjustsImageWhenHighlighted:NO];
    [self.commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.commentBtn];
    [self.commentBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-MARGIN);
        make.bottom.equalTo(self.view.bottom).offset(-MARGIN);
        make.width.height.equalTo(62);
    }];
    self.commentBtn.hidden = YES;

    self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editBtn setImage:[UIImage imageNamed:@"float_edit"] forState:UIControlStateNormal];
    [self.editBtn setAdjustsImageWhenHighlighted:NO];
    [self.editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.editBtn];
    [self.editBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-MARGIN);
        make.bottom.equalTo(self.view.bottom).offset(-MARGIN);
        make.width.height.equalTo(62);
    }];
    self.editBtn.hidden = YES;
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

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
//    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_comebackToStoreList object:nil];
    NSArray *arr = [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"arr = %@", arr);
    if (arr == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)lxAddCollectBtnClick:(id)sender{
    NSLog(@"收藏按钮 Clicked");
    if (self.isCollect) {
        [self asyncConnectStoreRemoveCollect];
    } else {
        [self asyncConnectStoreAddCollect];
    }
}

- (void)lxShareBtnClick:(id)sender{
    NSLog(@"分享按钮 Clicked");
    [[LXShareManager sharedInstance] showShareActionSheetOnView:self.view withDelegate:self andTitle:self.storeName andContent:self.storeDesc andURL:[NSString stringWithFormat:@"http://download.21xiaoqu.com/store/detail?id=%@", self.storeId] andIcon:nil];
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

- (void)commentBtnClick:(id)sender{
    NSLog(@"商户评论按钮 Clicked");
    LXStoreAddCommentViewController * vc = [[LXStoreAddCommentViewController alloc]init];
    vc.store_id = self.storeId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editBtnClick:(id)sender{
    NSLog(@"商户编辑按钮 Clicked");

//    LXStoreSelectLocationViewController * vc = [[LXStoreSelectLocationViewController alloc]init];
//    vc.storeCoordinate = CLLocationCoordinate2DMake(39.927193, 116.615746);
//    [self.navigationController pushViewController:vc animated:YES];

    UIActionSheet * actionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"商家信息纠错", @"活动管理", @"商品管理", @"服务管理", @"评论答复", nil];
    [actionsheet showInView:self.view];
}

- (void)fixBtnClick:(id)sender{
    NSLog(@"纠错按钮 Clicked");
    LXStoreFixInfosViewController * vc = [[LXStoreFixInfosViewController alloc]init];
    vc.store_id = self.storeId;
    [self.navigationController pushViewController:vc animated:YES];
}

// 刷新店铺详情页面
- (void)refreshStoreDetail
{
    [self.webView reload];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"点击了 商家信息纠错 选项");
            dispatch_async(dispatch_get_main_queue(), ^{
                LXStoreModifyInfosViewController * vc = [[LXStoreModifyInfosViewController alloc]init];
                vc.store_id = self.storeId;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                nav.navigationBarHidden = NO;
                [self presentViewController:nav animated:YES completion:nil];
            });
        }
            break;
        case 1:
        {
            NSLog(@"点击了 活动管理 选项");
            dispatch_async(dispatch_get_main_queue(), ^{
                LXStoreActivityListViewController * vc = [[LXStoreActivityListViewController alloc]init];
                vc.storeId = self.storeId;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                nav.navigationBarHidden = NO;
                [self presentViewController:nav animated:YES completion:nil];
            });
        }
            break;
        case 2:
        {
            NSLog(@"点击了 商品管理 选项");
            dispatch_async(dispatch_get_main_queue(), ^{
                LXStoreArticleListViewController * vc = [[LXStoreArticleListViewController alloc]init];
                vc.storeId = self.storeId;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                nav.navigationBarHidden = NO;
                [self presentViewController:nav animated:YES completion:nil];
            });
        }
            break;
        case 3:
        {
            NSLog(@"点击了 服务管理 选项");
            dispatch_async(dispatch_get_main_queue(), ^{
                LXStoreServiceListViewController * vc = [[LXStoreServiceListViewController alloc]init];
                vc.storeId = self.storeId;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                nav.navigationBarHidden = NO;
                [self presentViewController:nav animated:YES completion:nil];
            });
        }
            break;
        case 4:
        {
            NSLog(@"点击了 评论答复 选项");
            dispatch_async(dispatch_get_main_queue(), ^{
                LXStoreCommentListViewController * vc = [[LXStoreCommentListViewController alloc]init];
                vc.storeId = self.storeId;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                nav.navigationBarHidden = NO;
                [self presentViewController:nav animated:YES completion:nil];
            });
        }
            break;
        case 5:
            NSLog(@"点击了 取消");
            break;
            
        default:
            break;
    }
}

#pragma mark - UIWebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"店铺详情页面加载完成！");
//    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
//        self.commentBtn.hidden = NO;
//        self.fixBtn.hidden = NO;
//    }
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

-(void)asyncConnectStoreCheckCollect{
    if ([VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        return;
    }
    [self showHUD:@"请稍候..." anim:YES];
    LXStoreCheckCollectRequest * request = [[LXStoreCheckCollectRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识
    
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }

    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.storeId forKey:@"store_id"];
    [request setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

-(void)asyncConnectStoreAddCollect{
    [self showHUD:@"正在添加到收藏..." anim:YES];
    LXStoreAddCollectRequest * request = [[LXStoreAddCollectRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1001;//类型标识
    
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    } else {
        [self showTips:@"请先登录" delay:2 anim:YES];
        return;
    }
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.storeId forKey:@"store_id"];
    [request setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

-(void)asyncConnectStoreRemoveCollect{
    [self showHUD:@"正在从收藏中移除..." anim:YES];
    LXStoreRemoveCollectRequest * request = [[LXStoreRemoveCollectRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1002;//类型标识
    
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    } else {
        [self showTips:@"请先登录" delay:2 anim:YES];
        return;
    }
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.storeId forKey:@"store_id"];
    [request setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

-(void)asyncConnectStoreGetInfo{
    [self showHUD:@"正在加载..." anim:YES];
    LXStoreGetInfoRequest * request = [[LXStoreGetInfoRequest alloc]init];//初始化网络请求
    
    request.requestMethod = LXRequestMethodGet;
    request.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    request.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    request.delegate = self;//代理设置
    request.tag = 1003;//类型标识
    
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
            
//            [self showError:[[error userInfo] objectForKey:@"NSLocalizedDescription"] delay:2 anim:YES];
            return;
        }
        
        // 成功时有时也会有成功Message
        if (![VertifyInputFormat isEmpty:requestData.successMsg]) {
            [self showSuccess:requestData.successMsg delay:2 anim:YES];
        }

        // 将返回的数据进行model转换（注意：要加上对model类型的校验）
        LXStoreCheckCollectResponseModel * model = nil;
        if ([responseObject isKindOfClass:[LXStoreCheckCollectResponseModel class]]) {
            model = (LXStoreCheckCollectResponseModel *)responseObject;
            if ([model.collect isEqualToString:@"true"]) {
                self.isCollect = YES;
                [self.lxRightBtn1Img setImage:[UIImage imageNamed:@"store_detail_checkbox_checked"] forState:UIControlStateNormal];
            } else if ([model.collect isEqualToString:@"false"]) {
                self.isCollect = NO;
                [self.lxRightBtn1Img setImage:[UIImage imageNamed:@"store_detail_checkbox_unchecked"] forState:UIControlStateNormal];
            }

            [self hideHUD:YES];
            
            return;
        } else {
            [self showError:@"获取店铺收藏状态失败" delay:2 anim:YES];
        }
    } else if (requestData.tag == 1001) {
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

        self.isCollect = YES;
        [self.lxRightBtn1Img setImage:[UIImage imageNamed:@"store_detail_checkbox_checked"] forState:UIControlStateNormal];
    } else if (requestData.tag == 1002) {
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

        self.isCollect = NO;
        [self.lxRightBtn1Img setImage:[UIImage imageNamed:@"store_detail_checkbox_unchecked"] forState:UIControlStateNormal];
    } else if (requestData.tag == 1003) {
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
        LXStoreInfoResponseModel * model = nil;
        if ([responseObject isKindOfClass:[LXStoreInfoResponseModel class]]) {
            model = (LXStoreInfoResponseModel *)responseObject;
            self.storeName = model.name;
            self.storeDesc = model.description;
            self.phone1    = model.phone1;
            self.phone2    = model.phone2;

            NSString * userphone = [LXUserDefaultManager getUserPhone];
            if ([userphone isEqualToString:self.phone1] || [userphone isEqualToString:self.phone2]) {
                self.editBtn.hidden = NO;
            }
            else if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
                self.commentBtn.hidden = NO;
                self.fixBtn.hidden = NO;
            }

            [self hideHUD:YES];
            
            return;
        } else {
            [self showError:@"获取商家信息失败" delay:2 anim:YES];
        }
    }

    return;
}

@end
