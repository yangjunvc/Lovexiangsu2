//
//  LXStoreModifyArticleViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 16/3/1.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreModifyArticleViewController.h"
#import "LXArticleInfoResponseModel.h"
#import "LXStoreGetArticleInfoRequest.h"
#import "LXStoreModifyArticleRequest.h"
#import "LXStoreDeleteArticleRequest.h"

#import "LXUICommon.h"
#import "LXNetManager.h"
#import "VertifyInputFormat.h"
#import "LXUserDefaultManager.h"
#import "LXNotificationCenterString.h"

#import "NSString+Custom.h"

@interface LXStoreModifyArticleViewController ()

@property (nonatomic, strong) UITextField           * nameField;
@property (nonatomic, strong) UITextField           * priceField;
@property (nonatomic, strong) UIButton              * delArticle;

@end

@implementation LXStoreModifyArticleViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self putNavigationBar];
    [self putElements];
    [self asyncConnectStoreGetArticleInfo];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.nameField becomeFirstResponder];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxTitleLabel setTitle:@"修改商品信息" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxRightBtnTitle setTitle:@"修改" forState:UIControlStateNormal];
    self.lxRightBtnTitle.titleLabel.font = LX_TEXTSIZE_20;
    [self.lxRightBtnTitle addTarget:self action:@selector(lxModifyArticleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
    
    UIView * superView = self.view;
    
    self.nameField = [[UITextField alloc]init];
    self.nameField.backgroundColor = LX_BACKGROUND_COLOR;
    self.nameField.placeholder = @"商品名称...";
    self.nameField.delegate = self;
    self.nameField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:self.nameField];
    [self.nameField makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(MARGIN);
        make.right.equalTo(superView.right).offset(-MARGIN);
        make.height.equalTo(38);
    }];
    
    self.priceField = [[UITextField alloc]init];
    self.priceField.backgroundColor = LX_BACKGROUND_COLOR;
    self.priceField.placeholder = @"商品价格...";
    self.priceField.delegate = self;
    self.priceField.returnKeyType = UIReturnKeyDone;
    self.priceField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.view addSubview:self.priceField];
    [self.priceField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(MARGIN);
        make.top.equalTo(self.nameField.bottom).offset(MARGIN);
        make.right.equalTo(superView.right).offset(-MARGIN);
        make.height.equalTo(38);
    }];

    self.delArticle = [UIButton buttonWithType:UIButtonTypeCustom];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"删除商品"];
    NSRange strRange = {0,[str length]};
    // 30 128 240
    NSDictionary *dict = @{NSForegroundColorAttributeName:LX_ACCENT_TEXT_COLOR,
                           NSBackgroundColorAttributeName:LX_ACCENT_COLOR,
                           NSFontAttributeName:LX_TEXTSIZE_16,
                           };
    [str addAttributes:dict range:strRange];
    [self.delArticle setAttributedTitle:str forState:UIControlStateNormal];
    [self.delArticle setBackgroundColor:LX_ACCENT_COLOR];
    [self.delArticle addTarget:self action:@selector(delArticleClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.delArticle];
    [self.delArticle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(MARGIN);
        make.right.equalTo(-MARGIN);
        make.top.equalTo(self.priceField.bottom).offset(MARGIN);
        make.height.equalTo(38);
    }];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleClick:)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - UITextField Delegate

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 32) {
        textField.text = [textField.text substringToIndex:32];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameField) {
        [self.priceField becomeFirstResponder];
    } else if (textField == self.priceField) {
        [self.view endEditing:YES];
    }
    
    return YES;
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    [self.view endEditing:YES];
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    
    NSArray *arr = [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"arr = %@", arr);
    if (arr == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)lxModifyArticleBtnClick:(id)sender{
    NSLog(@"修改商品按钮 Clicked");
    
    [self asyncConnectStoreModifyArticle];
}

- (void)delArticleClick:(id)sender
{
    NSLog(@"删除商品按钮 Clicked");
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认要删除这条商品吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}

- (void)singleClick:(UITapGestureRecognizer * )recognizer
{
    [self.view endEditing:YES];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"点击了取消！");
        }
            break;
        case 1:
        {
            NSLog(@"点击了确认！");
            [self asyncConnectStoreDeleteArticle];
        }
            break;
        default:
            break;
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

-(void)asyncConnectStoreGetArticleInfo{
    [self showHUD:@"正在加载..." anim:YES];
    LXStoreGetArticleInfoRequest * request = [[LXStoreGetArticleInfoRequest alloc]init];//初始化网络请求
    
    request.requestMethod = LXRequestMethodGet;
    request.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    request.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    request.delegate = self;//代理设置
    request.tag = 1001;//类型标识
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.goods_id forKey:@"goods_id"];
    [request setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

-(void)asyncConnectStoreModifyArticle{
    [self showHUD:@"正在提交..." anim:YES];
    LXStoreModifyArticleRequest * request = [[LXStoreModifyArticleRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识

    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }

    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.goods_id forKey:@"goods_id"];
    [paraDic setObject:self.nameField.text forKey:@"name"];
    [paraDic setObject:self.priceField.text forKey:@"price"];
    
    [request setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

-(void)asyncConnectStoreDeleteArticle{
    [self showHUD:@"正在提交..." anim:YES];
    LXStoreDeleteArticleRequest * request = [[LXStoreDeleteArticleRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1002;//类型标识
    
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.goods_id forKey:@"goods_id"];
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

        [self performSelector:@selector(sendNotification) withObject:nil afterDelay:2.0];
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
        
        // 将返回的数据进行model转换（注意：要加上对model类型的校验）
        LXArticleInfoResponseModel * model = nil;
        if ([responseObject isKindOfClass:[LXArticleInfoResponseModel class]]) {
            model = (LXArticleInfoResponseModel *)responseObject;
            self.nameField.text = model.name;
            self.priceField.text = model.price;

            [self hideHUD:YES];
            
            return;
        } else {
            [self showError:@"获取店铺商品信息失败" delay:2 anim:YES];
        }
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

        [self performSelector:@selector(sendNotification) withObject:nil afterDelay:2.0];
    }

    return;
}

- (void)sendNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_refreshArticleList object:nil userInfo:nil];
    [self lxLeftBtnImgClick:nil];
}

@end
