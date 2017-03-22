//
//  LXContactUsViewController.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/1.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXContactUsViewController.h"
#import "LXUICommon.h"

@interface LXContactUsViewController ()
@property (strong, nonatomic) UIView *emptyView;

@property (nonatomic, strong) UIWebView * webView;

@end

@implementation LXContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self putNavigationBar];
    [self putElements];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxTitleLabel setTitle:@"关于爱小区" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    self.emptyView = [[UIView alloc]init];
    self.emptyView.frame = CGRectMake(14, 7, 30, 30);
    //    self.emptyView.layer.borderWidth = 1;
    //    self.emptyView.layer.borderColor = [[UIColor yellowColor] CGColor];
    
    self.navigationController.navigationBar.translucent = NO;
    // 30 127 241
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30.0/255.0 green:127.0/255.0 blue:241.0/255.0 alpha:1.0];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxLeftBtnImg];
    self.navigationItem.titleView = self.lxTitleLabel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.emptyView];
}

- (void)putElements
{
    [self.view setBackgroundColor:LX_BACKGROUND_COLOR];

    self.webView = [[UIWebView alloc]init];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    self.webView.scalesPageToFit = NO;
    self.webView.backgroundColor = LX_BACKGROUND_COLOR;
    NSString *pathStr= [@"http://download.21xiaoqu.com/page/contactUs" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:pathStr];
    NSLog(@"url = %@",url);
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(MARGIN);
        make.right.equalTo(-MARGIN);
        make.bottom.equalTo(-MARGIN);
    }];
}

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

@end
