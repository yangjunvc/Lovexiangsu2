//
//  AppDelegate.m
//  LoveXiangsu
//
//  Created by yangjun on 15/10/17.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "MMDrawerVisualStateManager.h"
#import "LXMainMenuViewController.h"
#import "LXMainTabbarController.h"
#import "LXNavigationController.h"

#import "LXUICommon.h"
#import "SVProgressHUD.h"
#import "LXMenuManager.h"
#import "LXUserDefaultManager.h"
#import "VertifyInputFormat.h"
#import "LXNotificationCenterString.h"
#import "NSFileManager+util.h"

#import "UIImageView+WebCache.h"

#import "EaseMob.h"
#import "AppDelegate+EaseMob.h"

//＝＝＝＝＝＝＝＝＝＝ShareSDK头文件＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//＝＝＝＝＝＝＝＝＝＝以下是各个平台SDK的头文件，根据需要继承的平台添加＝＝＝
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

@interface AppDelegate ()

@property (nonatomic, strong) MMDrawerController * drawerController;

@property (nonatomic, strong) UIView *launchView;

@end

static UIWindow *appStartWindow = nil;

static AppDelegate *mainAppDelegate = nil;

@implementation AppDelegate

#pragma mark - 程序实例

+ (instancetype)sharedInstance
{
    return mainAppDelegate;
}

#pragma mark - 第三方配置

// 配置高德地图API Key
- (void)configureAPIKey
{
    // 高德地图
    if ([MAMAP_APIKEY length] == 0)
    {
        NSString *reason = [NSString stringWithFormat:@"高德地图ApiKey为空，请检查key是否正确设置。"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    [MAMapServices sharedServices].apiKey = (NSString *)MAMAP_APIKEY;
    [AMapLocationServices sharedServices].apiKey = (NSString *)MAMAP_APIKEY;
}

// 配置环信
- (void)configureEaseMob
{
//    [[EaseMob sharedInstance] registerSDKWithAppKey:EASEMOB_APPKEY apnsCertName:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginCallback:)
                                                 name:KNOTIFICATION_LOGINFINISH
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registCallback:)
                                                 name:KNOTIFICATION_REGISTFINISH
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:k_Noti_userLoginSuccess
                                               object:nil];
}

// 注册ShareSDK
- (void)registerShareSDK
{
    [ShareSDK registerApp:SHARESDK_APPKEY
          activePlatforms:@[
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeTencentWeibo),
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class]
                                        tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"3946164336"
                                                appSecret:@"8c718070b631afff91566680f6b5506c"
                                              redirectUri:@"http://www.sharesdk.cn"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeTencentWeibo:
                      //设置腾讯微博应用信息，其中authType设置为只用Web形式授权
                      [appInfo SSDKSetupTencentWeiboByAppKey:@"1104776178"
                                                   appSecret:@"XzenZlTNVln8I0wP"
                                                 redirectUri:@"http://www.sharesdk.cn"];
                      break;
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx0c637b9a9e8c60d8"
                                            appSecret:@"c2af808671911204928f40f7ebdf808e"];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"1104776178"
                                           appKey:@"XzenZlTNVln8I0wP"
                                         authType:SSDKAuthTypeBoth];
                      break;
                  default:
                      break;
              }
          }];
}

#pragma mark - 清理缓存图片

- (void)cleanupCacheImages
{
    NSString * docDir = [NSFileManager getDocumentsPath];
    NSString * filePath = [docDir stringByAppendingFormat:@"/%@", SANDBOX_IMAGE_PATH];
    NSInteger count = [NSFileManager removeFromPath:filePath ofFile:nil];
    NSLog(@"清除图片文件个数：%d", count);
}

#pragma mark - 注册极光推送Alias

- (void)registerJPushAlias
{
    NSString * phone = [LXUserDefaultManager getUserPhone];
    if (![VertifyInputFormat isEmpty:phone]) {
        [JPUSHService setAlias:phone
              callbackSelector:nil
                        object:nil];
        NSLog(@"已向JPush注册推送Alias!");
    } else {
        NSLog(@"手机号为空，暂时无法向JPush注册推送Alias!");
    }
}

#pragma mark - 腾讯云分析初始化

- (void)initMTA
{
    [[MTAConfig getInstance] setDebugEnable:FALSE];

    [[MTAConfig getInstance] setReportStrategy:MTA_STRATEGY_INSTANT];

    //自定义crash处理函数，可以获取到mta生成的crash信息
    void (^errorCallback)(NSString *) = ^(NSString * errorString)
    {
        NSLog(@"error_callback %@",errorString);
    };
    [[MTAConfig getInstance] setCrashCallback:errorCallback];

    //开发key
    [MTA startWithAppkey:@"I446F1UABWBR"];
    // I77GLIW6V7RQ
//    [MTA startWithAppkey:@"I77GLIW6V7RQ"];
}

#pragma mark - 程序生命周期

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [SDImageCache sharedImageCache].shouldDecompressImages = NO;
    [SDWebImageDownloader sharedDownloader].shouldDecompressImages = NO;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
                                          green:173.0/255.0
                                           blue:234.0/255.0
                                          alpha:1.0];
    [self.window setTintColor:tintColor];
    self.window.backgroundColor = LX_BACKGROUND_COLOR;
    [self.window makeKeyAndVisible];

    [self launchStartView];

    mainAppDelegate  = self;

    _connectionState = eEMConnectionConnected;

    // 腾讯云分析初始化
    [self initMTA];

    // 配置高德APIKEY
    [self configureAPIKey];

    // 注册ShareSDK
    [self registerShareSDK];

    // 配置环信
    [self configureEaseMob];

    // 清理缓存图片
    [self cleanupCacheImages];

    // 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];

    // 主Tabbar页面
    self.tabbarDrawerViewController = [[LXMainTabbarController alloc] init];
    UINavigationController * tabbarNavController = [[LXNavigationController alloc] initWithRootViewController:self.tabbarDrawerViewController];
    [tabbarNavController setRestorationIdentifier:@"LXMainTabbarControllerRestorationKey"];
    tabbarNavController.navigationBarHidden = YES;

    // 抽屉控制器
    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:tabbarNavController
                             leftDrawerViewController:[LXMenuManager sharedInstance].mainMenuNavVC];
    [self.drawerController setShowsShadow:NO];
    [self.drawerController setRestorationIdentifier:@"LXDrawerController"];
    int menuWidth = MenuWidth;
    [self.drawerController setMaximumLeftDrawerWidth:menuWidth];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
//    [self.drawerController setCenterHiddenInteractionMode:MMDrawerOpenCenterInteractionModeFull];
    [self.drawerController setCenterInteractionEnable:NO];
    [[MMDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeParallax];
    
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];

    [self loginStateChange:nil];

    [self.window setRootViewController:self.drawerController];

    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    // Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:isProduction];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerJPushAlias) name:kJPFNetworkDidLoginNotification object:nil];

    return YES;
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder{
    return YES;
}

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    NSString * key = [identifierComponents lastObject];
    if([key isEqualToString:@"LXDrawerController"]){
        return self.window.rootViewController;
    }
    else if ([key isEqualToString:@"LXMainTabbarControllerRestorationKey"]) {
        return ((MMDrawerController *)self.window.rootViewController).centerViewController;
    }
    else if ([key isEqualToString:@"LXMainMenuNavigationControllerRestorationKey"]) {
        return ((MMDrawerController *)self.window.rootViewController).leftDrawerViewController;
    }
    else if ([key isEqualToString:@"LXMainMenuDrawerController"]){
        UIViewController * leftVC = ((MMDrawerController *)self.window.rootViewController).leftDrawerViewController;
        if([leftVC isKindOfClass:[UINavigationController class]]){
            return [(UINavigationController*)leftVC topViewController];
        }
        else {
            return leftVC;
        }
        
    }

    return nil;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (self.tabbarDrawerViewController) {
        [self.tabbarDrawerViewController jumpToChatList];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (self.tabbarDrawerViewController) {
        [self.tabbarDrawerViewController didReceiveLocalNotification:notification];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);

    NSLog(@"RemoteNotification:%@", userInfo);
}

#pragma mark - APP启动页面

-(void)launchStartView {
    if (appStartWindow == nil) {
        appStartWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        appStartWindow.backgroundColor = [UIColor clearColor];
        appStartWindow.userInteractionEnabled = YES;
        appStartWindow.windowLevel = UIWindowLevelStatusBar + 1;
    }
    [appStartWindow setHidden:NO];

    if (self.launchView == nil) {
        self.launchView = [[NSBundle mainBundle ]loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
    }
    self.launchView.frame = CGRectMake(0, 0, appStartWindow.screen.bounds.size.width, appStartWindow.screen.bounds.size.height);
    [appStartWindow addSubview:self.launchView];
    [appStartWindow bringSubviewToFront:self.launchView];

    [self createLaunchView];

//    [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(removeStartView) userInfo:nil repeats:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willRemoveStartView) name:k_Noti_removeAppStartView object:nil];
}

-(void)createLaunchView {
    // 网络获取各个小区图片
    UIImageView * subdistrictImgView = [[UIImageView alloc]init];
//    subdistrictImgView.layer.borderColor = LX_DEBUG_COLOR;
//    subdistrictImgView.layer.borderWidth = 1;
    subdistrictImgView.contentMode = UIViewContentModeCenter;
    [self.launchView addSubview:subdistrictImgView];
    [subdistrictImgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.launchView.centerX);
        make.centerY.equalTo(self.launchView.centerY);
        make.width.equalTo(ScreenWidth);
        make.height.equalTo(ScreenHeight);
    }];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[NSDate date]];
    NSString * url = [NSString stringWithFormat:@"http://image.21xiaoqu.com/main/%d/%d/%d.jpg", components.year, components.month, COMMUNITY_ID];
    // http://image.21xiaoqu.com/main/2016/1/1.jpg
    NSLog(@"首页广告页URL：%@", url);
    [subdistrictImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"app_start"]];

    // 小区图标
    UIImageView * subdistrictIcon = [[UIImageView alloc]init];
    [self.launchView addSubview:subdistrictIcon];
    [subdistrictIcon makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.launchView.right).offset(-(ScreenWidth / 2 + PADDING));
        make.bottom.equalTo(self.launchView.bottom).offset(-MARGIN);
        make.width.height.equalTo(73);
    }];
    subdistrictIcon.image = [UIImage imageNamed:COMMUNITY_ICON];

    // 小区名称
    UILabel * nameLabel = [[UILabel alloc]init];
    nameLabel.text = COMMUNITY_APPNAME;
    nameLabel.font = LX_TEXTSIZE_BOLD_20;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.launchView addSubview:nameLabel];
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(subdistrictIcon.centerY);
        make.left.equalTo(subdistrictIcon.right).offset(MARGIN);
        make.width.equalTo(150);
    }];
}

-(void)willRemoveStartView {
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeStartView) userInfo:nil repeats:NO];
}

-(void)removeStartView {
    [UIView animateWithDuration:1.0 animations:^{
        self.launchView.alpha = 0;
        appStartWindow.alpha = 0;
    } completion:^(BOOL finished) {
        [self.launchView removeFromSuperview];
    }];
}

#pragma mark - 环信用方法

//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification
{
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    //登陆成功
    if (isAutoLogin || loginSuccess) {
        NSLog(@"自动登录或者登录成功！");
    } else {
        //登陆失败，则先尝试注册新用户，如果重复注册，再重新登录
        NSString *userPhone = [LXUserDefaultManager getUserPhone];
        if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]] &&
            ![VertifyInputFormat isEmpty:userPhone]) {
            [self registerWithUsername:userPhone password:EASEMOB_PASSWORD];
        } else {
            NSLog(@"用户尚未登录APP，无法注册环信！");
        }
    }
}

-(void)registCallback:(NSNotification *)notification
{
    LXEaseMobRegistStatus registStatus = [notification.object integerValue];
    NSString *userPhone = [LXUserDefaultManager getUserPhone];
    switch (registStatus) {
        case LXEaseMobErrorServerDuplicatedAccount:
        case LXEaseMobRegistSuccess:
            [self loginWithUsername:userPhone password:EASEMOB_PASSWORD];
            break;
        case LXEaseMobErrorServerNotReachable:
            NSLog(@"环信注册无法连接服务器，用户名：%@", userPhone);
            break;
        case LXEaseMobErrorNetworkNotConnected:
            NSLog(@"环信注册网络连接失败，用户名：%@", userPhone);
            break;
        case LXEaseMobErrorServerTimeout:
            NSLog(@"环信注册服务器超时，用户名：%@", userPhone);
            break;
        case LXEaseMobErrorServerRegistFailed:
            NSLog(@"环信注册失败，用户名：%@", userPhone);
            break;
            
        default:
            NSLog(@"环信注册未知错误！");
            break;
    }
}

-(void)loginCallback:(NSNotification *)notification
{
    LXEaseMobLoginStatus loginStatus = [notification.object integerValue];
    switch (loginStatus) {
        case LXEaseMobLoginSuccess:
            NSLog(@"环信登录成功");
            break;
        case LXEaseMobErrorLoginNetworkFail:
            NSLog(@"环信登录网络连接失败");
            break;
        case LXEaseMobErrorLoginServerFail:
            NSLog(@"环信登录无法连接服务器");
            break;
        case LXEaseMobErrorLoginAuthenticationFail:
            NSLog(@"环信登录认证失败");
            break;
        case LXEaseMobErrorLoginServerTimeout:
            NSLog(@"环信登录服务器超时");
            break;
        case LXEaseMobErrorLoginLoginFailure:
            NSLog(@"环信登录失败");
            break;
        case LXEaseMobErrorLoginNotExists:
            NSLog(@"环信登录用户不存在");
            break;
            
        default:
            NSLog(@"环信登录未知错误！");
            break;
    }
}

@end
