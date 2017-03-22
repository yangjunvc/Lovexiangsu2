//
//  LXShowNewsViewController.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/8.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXShowNewsViewController.h"
#import "LXGetNewsDetailRequest.h"
#import "LXGetNewsListResponseModel.h"

#import "LXUICommon.h"
#import "VertifyInputFormat.h"
#import "LXNetManager.h"

@interface LXShowNewsViewController ()

//@property (strong, nonatomic) UIView * emptyView;
@property (nonatomic, strong) UIWebView * webView;

@end

@implementation LXShowNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self hiddenMenuViewController];
    [self putNavigationBar];

    if ([VertifyInputFormat isEmpty:self.htmlContent]) {
        [self asyncConnectGetNews];
    } else {
        [self putElements];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.webView = nil;
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxTitleLabel setTitle:self.name forState:UIControlStateNormal];
    self.lxTitleLabel.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.lxTitleLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
//    self.emptyView = [[UIView alloc]init];
//    self.emptyView.frame = CGRectMake(14, 7, 30, 30);
    //    self.emptyView.layer.borderWidth = 1;
    //    self.emptyView.layer.borderColor = [[UIColor yellowColor] CGColor];
    
    self.navigationController.navigationBar.translucent = NO;
    // 30 127 241
    self.navigationController.navigationBar.barTintColor = LX_PRIMARY_COLOR;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxLeftBtnImg];
    self.navigationItem.titleView = self.lxTitleLabel;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.emptyView];
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
    NSLog(@"htmlContent = %@",self.htmlContent);
    [self.webView loadHTMLString:self.htmlContent baseURL:nil];
    [self.view addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(0);
    }];
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
    LXGetNewsDetailRequest * request = [[LXGetNewsDetailRequest alloc]init];//初始化网络请求
    
    request.requestMethod = LXRequestMethodGet;
    request.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    request.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是HTTP类型响应
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.id forKey:@"id"];
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
        LXGetNewsListResponseModel * model = nil;
        if ([responseObject isKindOfClass:[LXGetNewsListResponseModel class]]) {
            model = (LXGetNewsListResponseModel *)responseObject;
            self.htmlContent = model.content;
            
            [self putElements];

            [self hideHUD:YES];
            
            return;
        } else {
            [self showError:@"获取新闻详情失败" delay:2 anim:YES];
        }
    }
    
    return;
}

@end
