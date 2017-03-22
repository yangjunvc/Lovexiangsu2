//
//  LXBaseViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 15/10/18.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXBaseViewController : UIViewController

@property (nonatomic , assign) int keyboardMoveOffset;//键盘的偏移量
@property (nonatomic, assign) int keyBoardHeight;
@property (nonatomic, assign) int keyBoardEndY;//键盘弹起时的Y值

/**
 * newKeyBoard:一套新的键盘监控界面视图向上移动的机制，代替上面的有问题的键盘移动方式
 */
@property (nonatomic , assign) float currentViewMoveOffSetY;

/**
 * 键盘推动视图上移
 */
-(void)pullKryBoardUp;

/**
 * 键盘推动视图下移
 */
-(void)pullKryBoardDown;
-(void)pullKryBoardDownWithEditing;

/**
 * newKeyBoard:一套新的键盘监控界面视图向上移动的机制，代替上面的有问题的键盘移动方式
 */
-(void)dropCurrentViewUp:(float)controlViewMaxY;
-(void)resignCurrentViewFrame;

/**
 * 登陆注册模块的导航视图控制器
 */
@property (nonatomic , strong) UIView * lxTitleView;            //自定义titleView样式
@property (nonatomic , strong) UIButton * lxTitleLabel;          //自定义导航栏标题
@property (nonatomic , strong) UIButton * lxLeftBtnTitle;       //左导航栏按钮-文字
@property (nonatomic , strong) UIButton * lxLeftBtnImg;         //左导航栏按钮-图片
@property (nonatomic , strong) UIButton * lxLeftBtnTitleImg;    //左导航栏按钮-文字和图片

@property (nonatomic , strong) UIButton * searchBtn;            //导航栏中间搜索框（文字自定义）

@property (nonatomic , strong) UIButton * lxRightBtnTitle;      //右导航栏按钮-文字
@property (nonatomic , strong) UIButton * lxRightBtn1Img;        //右导航栏按钮-图片1
@property (nonatomic , strong) UIButton * lxRightBtn2Img;        //右导航栏按钮-图片2
@property (nonatomic , strong) UIButton * lxRightBtnTitleImg;   //右导航栏按钮-文字和图片

// SVProgressHUD
- (void)showHUD:(NSString *)note anim:(BOOL)anim;
- (void)hideHUD:(BOOL)anim;
- (void)showError:(NSString *)error delay:(NSInteger)delay anim:(BOOL)anim;
- (void)showSuccess:(NSString *)tips delay:(NSInteger)delay anim:(BOOL)anim;
- (void)showTips:(NSString *)tips delay:(NSInteger)delay anim:(BOOL)anim;
- (void)showTips:(NSString *)tips title:(NSString*)title delay:(NSInteger)delay anim:(BOOL)anim;

/**
 * 公有的登出方法
 */
-(void)logoutFromCurrentVeiwController:(id)viewController;

// 清SDImage缓存
-(void)clearMemory;

// 弹出窗体的点击事件处理
-(void)whenSelectBtnTouchUpInside:(int)BTNTYPE PopupType:(int)popupType;

// 隐藏侧滑菜单
- (void)hiddenMenuViewController;

@end
