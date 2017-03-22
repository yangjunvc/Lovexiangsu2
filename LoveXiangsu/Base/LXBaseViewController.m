//
//  LXBaseViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 15/10/18.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"
#import "LXCommon.h"
#import "LXUICommon.h"
#import "LXDictCommon.h"
#import "LXNetCommon.h"
#import "SDImageCache.h"
#import "LXNotificationCenterString.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "UIViewController+MMDrawerController.h"

@interface LXBaseViewController ()

@end

@implementation LXBaseViewController

-(id)init{
    self = [super init];
    if (self) {
        self.keyBoardHeight = KeyBoard_Height;
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self.view setBackgroundColor:LX_BACKGROUND_COLOR];
    
    [self putNavigationBarStyle];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)clearMemory
{
    // 清缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.keyBoardEndY =   keyboardRect.origin.y;
    self.keyBoardHeight = keyboardRect.size.height;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
}

/**
 * 导航视图控制器样式设置
 */
-(void)putNavigationBarStyle{
    
    [self putlxTitleViewStyle];
    
    [self putlxTitleLabelStyle];
    
    [self putlxLeftBtnTitleStyle];
    [self putlxLeftBtnImgStyle];
    [self putlxLeftBtnTitleImgStyle];

    [self putSearchBtnStyle];

    [self putlxRightBtnTitleStyle];
    [self putlxRightBtnImgStyle];
    [self putlxRightBtnTitleImgStyle];
    
}

-(void)putlxTitleViewStyle{
    self.lxTitleView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2-60, 20, 120, 44)];
}

-(void)putlxTitleLabelStyle{
    self.lxTitleLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lxTitleLabel.frame = CGRectMake(0, 7, ScreenWidth - 2 * 44, 30);
    [self.lxTitleLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.lxTitleLabel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.lxTitleLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    self.lxTitleLabel.titleLabel.font = LX_TEXTSIZE_20;
}

-(void)putlxLeftBtnTitleStyle{
    self.lxLeftBtnTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lxLeftBtnTitle setFrame:CGRectMake(0, 0, 80,44)];
    self.lxLeftBtnTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.lxLeftBtnTitle setTitleEdgeInsets:UIEdgeInsetsMake(1, -3, 0, 0)];
    self.lxLeftBtnTitle.titleLabel.font = LX_TEXTSIZE_16;
    [self.lxLeftBtnTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.lxLeftBtnTitle setTitleColor:LX_ACCENT_TEXT_COLOR forState:UIControlStateHighlighted];
}

-(void)putlxLeftBtnImgStyle{
    self.lxLeftBtnImg = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lxLeftBtnImg.frame = CGRectMake(0, 10, IconSize, IconSize);
    [self.lxLeftBtnImg setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.lxLeftBtnImg setAdjustsImageWhenHighlighted:NO];
    [self.lxLeftBtnImg setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
}

-(void)putlxLeftBtnTitleImgStyle{
    self.lxLeftBtnTitleImg = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.lxLeftBtnTitleImg setTitle:@"返回" forState:UIControlStateNormal];
    [self.lxLeftBtnTitleImg setFrame:CGRectMake(0, 0, 80,44)];
    self.lxLeftBtnTitleImg.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.lxLeftBtnTitleImg setImage:[UIImage imageNamed:@"Login_backTint"] forState:UIControlStateNormal];
    [self.lxLeftBtnTitleImg setImage:[UIImage imageNamed:@"Login_backTintSelect"] forState:UIControlStateHighlighted];
    [self.lxLeftBtnTitleImg setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [self.lxLeftBtnTitleImg setTitleEdgeInsets:UIEdgeInsetsMake(1, -171, 0, 0)];
    self.lxLeftBtnTitleImg.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.lxLeftBtnTitleImg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.lxLeftBtnTitleImg setTitleColor:COLOR_RGB_HEX(0xcccccc) forState:UIControlStateHighlighted];
}

-(void)putSearchBtnStyle
{
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchBtn.frame = CGRectMake(0, 7, ScreenWidth - 2 * 44, 30);
    [self.searchBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.searchBtn setTitleColor:[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.searchBtn.titleLabel.font = LX_TEXTSIZE_16;
    self.searchBtn.layer.borderWidth = 1;
    self.searchBtn.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    self.searchBtn.layer.cornerRadius = CGRectGetHeight(self.searchBtn.frame)/2;
    self.searchBtn.clipsToBounds = YES;
}

-(void)putlxRightBtnTitleStyle{
    self.lxRightBtnTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lxRightBtnTitle.frame = CGRectMake(0, 7, 40, 30);
    self.lxRightBtnTitle.titleLabel.font = LX_TEXTSIZE_16;
    [self.lxRightBtnTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)putlxRightBtnImgStyle{
    self.lxRightBtn1Img = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lxRightBtn1Img.frame = CGRectMake(0, 10, IconSize, IconSize);
    [self.lxRightBtn1Img setAdjustsImageWhenHighlighted:NO];
    [self.lxRightBtn1Img setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];

    self.lxRightBtn2Img = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lxRightBtn2Img.frame = CGRectMake(0, 10, IconSize, IconSize);
    [self.lxRightBtn2Img setAdjustsImageWhenHighlighted:NO];
    [self.lxRightBtn2Img setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
}

-(void)putlxRightBtnTitleImgStyle{
    self.lxRightBtnTitleImg = [UIButton buttonWithType:UIButtonTypeCustom];
    //    相应样式未定
}

- (void)hiddenMenuViewController
{
    [self.mm_drawerController setLeftDrawerViewController:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self clearMemory];
}

-(void)pullKryBoardUp{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    if(self.keyboardMoveOffset>0)
    {
        CGRect rect = CGRectMake(0, self.view.frame.origin.y-(self.keyboardMoveOffset+50),self.view.bounds.size.width,self.view.bounds.size.height);
        self.view.frame = rect;
    }
    
    [UIView commitAnimations];
}
-(void)pullKryBoardDown{
    //结束视图可编辑状态
    [self.view endEditing:YES];
    
    //键盘下降动画
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    if(self.keyboardMoveOffset>0){
        [self.view setFrame:CGRectMake(0, self.view.frame.origin.y+(self.keyboardMoveOffset+50), self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    self.keyboardMoveOffset = 0;
    [UIView commitAnimations];
}
-(void)pullKryBoardDownWithEditing{
    
    //键盘下降动画
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    if(self.keyboardMoveOffset>0){
        [self.view setFrame:CGRectMake(0, self.view.frame.origin.y+(self.keyboardMoveOffset+50), self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    self.keyboardMoveOffset = 0;
    [UIView commitAnimations];
}

#pragma mark - HUD
- (void)showHUD:(NSString*)note anim:(BOOL)anim
{
    [SVProgressHUD showWithStatus:note];
}

- (void)hideHUD:(BOOL)anim
{
    [SVProgressHUD dismiss];
}

- (void)showError:(NSString*)error delay:(NSInteger)delay anim:(BOOL)anim
{
    [SVProgressHUD showWithMessage:error afterDelay:delay];
}

- (void)showSuccess:(NSString *)tips delay:(NSInteger)delay anim:(BOOL)anim
{
    [SVProgressHUD showWithMessage:tips afterDelay:delay];
}

- (void)showTips:(NSString *)tips delay:(NSInteger)delay anim:(BOOL)anim
{
    [self showTips:tips title:@"提示" delay:delay anim:anim];
}

- (void)showTips:(NSString *)tips title:(NSString*)title delay:(NSInteger)delay anim:(BOOL)anim
{
    [SVProgressHUD showWithMessage:tips afterDelay:delay];
}

-(void)logoutFromCurrentVeiwController:(id)viewController{

}

-(void)showPopupWindow:(id)VC type:(LXPOPUPVIEW_TYPE)type
{
    if ([NSStringFromClass([VC class]) isEqualToString:@"PLUICameraViewController"]//相机
               || [NSStringFromClass([VC class]) isEqualToString:@"PUUIAlbumListViewController"]) {//相册
        UIViewController *uivc = (UIViewController *)VC;
        NSLog(@"VC = %@", uivc);
//        [uivc.view.window showPopupWithStyle:type deledge:self];
//        [uivc dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        UIViewController *uivc = (UIViewController *)VC;
        NSLog(@"VC = %@", uivc);
//        [uivc.view endEditing:YES];
//        [self.view.window showPopupWithStyle:type deledge:VC];
    }
}

/**
 * 错误码弹窗的回调
 */
-(void)whenSelectBtnTouchUpInside:(int)BTNTYPE PopupType:(int)popupType{
    if (popupType == LXPOPUPVIEW_TYPE_DIFFERENTPOSITIONLOGIN || popupType == LXPOPUPVIEW_TYPE_ACCOUNTSTOP) {
        if (BTNTYPE == 1) {
            //调用拨号
            
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",LXSERVER_TELEPHONE]]];
        }
        if (BTNTYPE == 2) {
            
            //异地登陆 登出+账户停用
//            [self logoutFromCurrentVeiwController:[[AppDelegate sharedInstance] getCurrentVC]];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
//            [self logoutFromCurrentVeiwController:nil];
        }
    }
    if (alertView.tag == 2) {
        if (buttonIndex == 0) {
//            [self logoutFromCurrentVeiwController:nil];
        }
    }
    if (alertView.tag == 3) {
        if (buttonIndex == 0) {
//            [self logoutFromCurrentVeiwController:nil];
        }
    }
}

#pragma mark -新的键盘影响界面移动的机制
/**
 * newKeyBoard:一套新的键盘监控界面视图向上移动的机制，代替上面的有问题的键盘移动方式
 */
-(void)dropCurrentViewUp:(float)controlViewMaxY{
    
}

-(void)resignCurrentViewFrame{
    
}

@end
