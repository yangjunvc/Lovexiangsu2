//
//  LXRegistAgreementViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 15/10/30.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXRegistAgreementViewController.h"
#import "LXUserRegistViewController.h"
#import "LXUICommon.h"

@interface LXRegistAgreementViewController ()

@property (strong, nonatomic) UIView *emptyView;

@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, strong) UIButton * nextBtn;

@end

@implementation LXRegistAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self putNavigationBar];
    [self putElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxTitleLabel setTitle:@"用户许可协议" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    self.emptyView = [[UIView alloc]init];
    self.emptyView.frame = CGRectMake(14, 7, 30, 30);
    //    self.emptyView.layer.borderWidth = 1;
    //    self.emptyView.layer.borderColor = [[UIColor yellowColor] CGColor];
    
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

    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextBtn setTitle:@"同意，下一步" forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextBtn.titleLabel.font = LX_TEXTSIZE_16;
    // 31 229 98
    [self.nextBtn setBackgroundColor:[UIColor colorWithRed:31.0/255.0 green:229.0/255.0 blue:98.0/255.0 alpha:1.0]];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
    [self.nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(MARGIN);
        make.bottom.right.equalTo(-MARGIN);
        make.height.equalTo(LoginClassBtnHeight);
    }];

    self.webView = [[UIWebView alloc]init];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    self.webView.scalesPageToFit = NO;
    self.webView.backgroundColor = LX_BACKGROUND_COLOR;
    NSString *pathStr= [@"http://download.21xiaoqu.com/user/licence" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:pathStr];
    NSLog(@"url = %@",url);
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(MARGIN);
        make.right.equalTo(-MARGIN);
        make.bottom.equalTo(self.nextBtn.top).offset(-MARGIN);
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    self.nextBtn.layer.cornerRadius = CGRectGetHeight(self.nextBtn.frame)/8;
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextBtnClick:(id)sender{
    LXUserRegistViewController *registVC = [[LXUserRegistViewController alloc]init];
    registVC.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:registVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 网络请求

// 网络请求回调
-(void)requestResult:(NSError*) error withData:(id)responseObject responseData:(LXBaseRequest*)requestData
{
    return;
}

@end
