//
//  LXStoreAddCommentViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 16/1/6.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreAddCommentViewController.h"
#import "LXStoreAddCommentRequest.h"
#import "LXNotificationCenterString.h"
#import "LXUICommon.h"
#import "LXUserDefaultManager.h"
#import "LXNetManager.h"

#import "VertifyInputFormat.h"

#import "SZTextView.h"

@interface LXStoreAddCommentViewController ()
{
    NSArray * starImgArray;
    NSInteger selectedStarLevel;
}
@end

@implementation LXStoreAddCommentViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self putNavigationBar];
    [self putElements];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.storeComment becomeFirstResponder];
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
    
    [self.lxTitleLabel setTitle:@"商户评论" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];

    [self.lxRightBtnTitle setTitle:@"评论" forState:UIControlStateNormal];
    self.lxRightBtnTitle.titleLabel.font = LX_TEXTSIZE_20;
    [self.lxRightBtnTitle addTarget:self action:@selector(lxAddCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxRightBtn2Img.layer.borderWidth = 1;
    //    self.lxRightBtn2Img.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    self.navigationController.navigationBar.translucent = NO;
    // 30 127 241
    self.navigationController.navigationBar.barTintColor = LX_PRIMARY_COLOR;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxLeftBtnImg];
    self.navigationItem.titleView = self.lxTitleLabel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxRightBtnTitle];
}

#pragma mark - Element of Page

- (void)putElements
{
    [self.view setBackgroundColor:[UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0]];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleClick:)];
    [self.view addGestureRecognizer:tap];

    self.star1 = [[UIImageView alloc]init];
    self.star1.tag = 1;
    self.star1.image = [UIImage imageNamed:@"rating"];
    self.star1.layer.borderColor = LX_DEBUG_COLOR;
    self.star1.layer.borderWidth = 1;
    [self.view addSubview:self.star1];
    [self.star1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(MARGIN);
        make.width.equalTo(StoreStarImgSize);
        make.height.equalTo(StoreStarImgSize);
    }];

    self.star2 = [[UIImageView alloc]init];
    self.star2.tag = 2;
    self.star2.image = [UIImage imageNamed:@"rating"];
    self.star2.layer.borderColor = LX_DEBUG_COLOR;
    self.star2.layer.borderWidth = 1;
    [self.view addSubview:self.star2];
    [self.star2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.star1.right).offset(0);
        make.top.equalTo(MARGIN);
        make.width.equalTo(StoreStarImgSize);
        make.height.equalTo(StoreStarImgSize);
    }];

    self.star3 = [[UIImageView alloc]init];
    self.star3.tag = 3;
    self.star3.image = [UIImage imageNamed:@"rating"];
    self.star3.layer.borderColor = LX_DEBUG_COLOR;
    self.star3.layer.borderWidth = 1;
    [self.view addSubview:self.star3];
    [self.star3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.star2.right).offset(0);
        make.top.equalTo(MARGIN);
        make.width.equalTo(StoreStarImgSize);
        make.height.equalTo(StoreStarImgSize);
    }];

    self.star4 = [[UIImageView alloc]init];
    self.star4.tag = 4;
    self.star4.image = [UIImage imageNamed:@"rating"];
    self.star4.layer.borderColor = LX_DEBUG_COLOR;
    self.star4.layer.borderWidth = 1;
    [self.view addSubview:self.star4];
    [self.star4 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.star3.right).offset(0);
        make.top.equalTo(MARGIN);
        make.width.equalTo(StoreStarImgSize);
        make.height.equalTo(StoreStarImgSize);
    }];

    self.star5 = [[UIImageView alloc]init];
    self.star5.tag = 5;
    self.star5.image = [UIImage imageNamed:@"rating"];
    self.star5.layer.borderColor = LX_DEBUG_COLOR;
    self.star5.layer.borderWidth = 1;
    [self.view addSubview:self.star5];
    [self.star5 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.star4.right).offset(0);
        make.top.equalTo(MARGIN);
        make.width.equalTo(StoreStarImgSize);
        make.height.equalTo(StoreStarImgSize);
    }];

    starImgArray = @[self.star1, self.star2, self.star3, self.star4, self.star5];

    for (UIImageView * starImgView in starImgArray) {
        starImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer * imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(starImgViewClick:)];
        [starImgView addGestureRecognizer:imgTap];
    }

    self.storeComment = [[SZTextView alloc]init];
    self.storeComment.textContainerInset = UIEdgeInsetsMake(0, -4.5, 0, 0);
    self.storeComment.backgroundColor = LX_BACKGROUND_COLOR;
    self.storeComment.placeholder = @"评论内容...";
    self.storeComment.font = FONT_SYSTEM(19);
    self.storeComment.layoutManager.allowsNonContiguousLayout = NO;
    [self.view addSubview:self.storeComment];
    [self.storeComment makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(MARGIN);
        make.top.equalTo(self.star1.bottom).offset(MARGIN);
        make.right.equalTo(self.view.right).offset(-MARGIN);
        make.height.equalTo(StoreCommentHeight);
    }];
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    NSArray *arr = [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"arr = %@", arr);
    if (arr == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)lxAddCommentBtnClick:(id)sender{
    NSLog(@"发送评论按钮 Clicked");

    if (selectedStarLevel == 0) {
        [self showTips:@"请选择评分" delay:2 anim:YES];
        return;
    }
    if ([VertifyInputFormat isEmpty:self.storeComment.text]) {
        [self showTips:@"内容不能为空" delay:2 anim:YES];
        return;
    }

    [self.view endEditing:YES];

    [self asyncConnectSendComment];
}

- (void)singleClick:(UITapGestureRecognizer * )recognizer
{
    [self.view endEditing:YES];
}

- (void)starImgViewClick:(UITapGestureRecognizer * )recognizer
{
    if ([recognizer.view isKindOfClass:[UIImageView class]]) {
        UIImageView * starView = (UIImageView *)recognizer.view;
        NSLog(@"点击了星级：%ld", (long)starView.tag);
        selectedStarLevel = starView.tag;
        for (UIImageView * starImgView in starImgArray) {
            if (starImgView.tag <= selectedStarLevel) {
                starImgView.image = [UIImage imageNamed:@"rating_show"];
            } else {
                starImgView.image = [UIImage imageNamed:@"rating"];
            }
        }
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

-(void)asyncConnectSendComment{
    [self showHUD:@"请稍候..." anim:YES];
    LXStoreAddCommentRequest * request = [[LXStoreAddCommentRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识
    
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.storeComment.text forKey:@"comment"];
    [paraDic setObject:@(selectedStarLevel) forKey:@"grade"];
    [paraDic setObject:self.store_id forKey:@"store_id"];
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
        
        [self showSuccess:@"感谢您的评论" delay:2 anim:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_refreshStoreDetail object:nil userInfo:nil];
        [self lxLeftBtnImgClick:nil];
    }
    
    return;
}

@end
