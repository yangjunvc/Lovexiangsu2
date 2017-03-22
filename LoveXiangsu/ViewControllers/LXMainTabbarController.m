//
//  LXMainTabbarController.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/10/22.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXMainTabbarController.h"
#import "LXHomepageViewController.h"
#import "LXStoreViewController.h"
#import "LXChatRoomsViewController.h"
#import "LXForumViewController.h"
#import "LXStoreMenuViewController.h"
#import "LXGetChatGroupOccupantsResponseModel.h"

#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "EMCDDeviceManager.h"
#import "UserProfileManager.h"

#import "JSBadgeView.h"
#import "UIViewController+MMDrawerController.h"
#import "LXUICommon.h"
#import "AppDelegate.h"
#import "LXCommon.h"
#import "LXNotificationCenterString.h"
#import "LXTabbarBtn.h"
#import "LXMenuManager.h"
#import "AppDelegate+EaseMob.h"
#import "VertifyInputFormat.h"

static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@interface LXMainTabbarController ()<UITabBarControllerDelegate, ChatViewControllerDelegate>{
    UIView * _tintBgView;

    ChatListViewController *_chatVC;
}
@property (nonatomic , assign) int preSelectedIndex;
@property (nonatomic , strong) NSArray * imageArray;
@property (strong , nonatomic) NSDate *lastPlaySoundDate;
@property (strong , nonatomic) JSBadgeView *badgeView;

@end

@implementation LXMainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self registerNotifications];
    [self registerNotify];
    [self createLXTabBarViewControllers];
    [self createLXTabBarViews];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    if ([LXUserDefaultManager needShowTintImgForCerrentViewWithStyle:0]) {
        //添加引导视图
//        _tintBgView = [[UIView alloc]initWithFrame:self.view.bounds];
//        
//        UIView * halfBlackView = [[UIView alloc]initWithFrame:_tintBgView.bounds];
//        [halfBlackView setBackgroundColor:[UIColor blackColor]];
//        halfBlackView.alpha = 0.7;
//        [_tintBgView addSubview:halfBlackView];
//        
//        //        9+(ScreenWidth-18)/4.0*i, 202*(ScreenWidth/375)
//        UIImageView * tintImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 202*(ScreenWidth/375)-5, 590/2.0, 285/2)];
//        [tintImg1 setImage:[UIImage imageNamed:@"tint_inquiry"]];
//        [_tintBgView addSubview:tintImg1];
//        
//        UIImageView * tintImg2 = [[UIImageView alloc]initWithFrame:CGRectMake(20+(ScreenWidth-40-4*60)/3.0 + 60, 202*(ScreenWidth/375)+77, 430/2.0 , 340/2.0)];
//        [tintImg2 setImage:[UIImage imageNamed:@"tint_offlineInquiry"]];
//        [_tintBgView addSubview:tintImg2];
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeTintViewAction:)];
//        [_tintBgView addGestureRecognizer:tap];
//        
//        [self.view addSubview:_tintBgView];
    
//    }else{
//        NSLog(@"我已经不需要引导视图了");
//    }
}

-(void)removeTintViewAction:(id)sender{
    if (_tintBgView) {
        [_tintBgView removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"currentSelectedIndex" context:nil];
}

#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadChatGroupInfos:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].callManager removeDelegate:self];
}

/**
 * 注册通知
 */
-(void)registerNotify{
    // 增加KVO为currentSelectedIndex字段
    [self addObserver:self forKeyPath:@"currentSelectedIndex" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

#pragma mark -网络状态监控

- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_chatVC networkChanged:connectionState];
}

#pragma mark -初始化标签视图控制器

-(void)createLXTabBarViewControllers{
    LXHomepageViewController * home = [[LXHomepageViewController alloc]init];
    home.hidesBottomBarWhenPushed = NO;
    UINavigationController * homeNav = [[UINavigationController alloc]initWithRootViewController:home];
    homeNav.navigationBarHidden = NO;

    LXStoreViewController * store = [[LXStoreViewController alloc]init];
    store.hidesBottomBarWhenPushed = NO;
    UINavigationController * storeNav = [[UINavigationController alloc]initWithRootViewController:store];
    storeNav.navigationBarHidden = NO;

//    LXChatRoomsViewController * chat = [[LXChatRoomsViewController alloc]init];//test
//    chat.hidesBottomBarWhenPushed = NO;
    _chatVC = [[ChatListViewController alloc]init];
//    _chatVC.hidesBottomBarWhenPushed = NO;
    UINavigationController * chatNav = [[UINavigationController alloc]initWithRootViewController:_chatVC];
    chatNav.navigationBarHidden = NO;

    LXForumViewController * forum = [[LXForumViewController alloc]init];
    forum.hidesBottomBarWhenPushed = NO;
    UINavigationController * forumNav = [[UINavigationController alloc]initWithRootViewController:forum];
    forumNav.navigationBarHidden = NO;

    self.delegate = self;
    self.viewControllers = [[NSArray alloc]initWithObjects:homeNav, storeNav, chatNav, forumNav, nil];
    
    UITabBar *tabBar = self.tabBar;
    //    tabBar addSubview:
    UITabBarItem *aTabBarItem = [tabBar.items objectAtIndex:0];
    UITabBarItem *bTabBarItem = [tabBar.items objectAtIndex:1];
    UITabBarItem *cTabBarItem = [tabBar.items objectAtIndex:2];
    UITabBarItem *dTabBarItem = [tabBar.items objectAtIndex:3];
    
    aTabBarItem.title = @"";
    bTabBarItem.title = @"";
    cTabBarItem.title = @"";
    dTabBarItem.title = @"";

    [[UITabBar appearance] setBackgroundColor:LX_BACKGROUND_COLOR];
    
    self.selectedIndex = 0;
    self.currentSelectedIndex = 1;
}

#pragma mark -初始化标签栏

-(void)createLXTabBarViews{
    self.imageArray = [NSArray arrayWithObjects:
                       @{@"normal": @"main_radio_home_off",@"selected":@"main_radio_home_on",@"title":@"主页"},
                       @{@"normal": @"main_radio_store_off",@"selected":@"main_radio_store_on",@"title":@"店铺"},
                       @{@"normal": @"main_radio_chat_off",@"selected":@"main_radio_chat_on",@"title":@"聊天"},
                       @{@"normal": @"main_radio_forum_off",@"selected":@"main_radio_forum_on",@"title":@"论坛"},
                       nil];
    float marginWidth = 0;
    
    float  tabBarWidth = ScreenWidth - marginWidth;
    float  centerSpace = (ScreenWidth - (TabBarIconSize * 4))/4.0f;
    
    for (int i = 0; i<self.imageArray.count; i++) {
        LXTabbarBtn * tabBarBtn = [[LXTabbarBtn alloc]init];
        [tabBarBtn setFrame:CGRectMake(marginWidth/2.0+i*tabBarWidth/self.imageArray.count,0,tabBarWidth/self.imageArray.count,TabBarHeight)];
        if (i == 0) {
            self.preSelectedIndex = 1;
            tabBarBtn.selected = YES;
        }else{
        }
        tabBarBtn.tabBarTitle.text = self.imageArray[i][@"title"];
        [tabBarBtn setShowBgImg:self.imageArray[i][@"normal"] SelectedImg:self.imageArray[i][@"selected"] forState:tabBarBtn.selected];

        tabBarBtn.tag = 1+i;

        if (i == 0 ) {
            
            tabBarBtn.frame = CGRectMake(centerSpace/2.0f, 0, TabBarIconSize, TabBarBtnHeight);
            tabBarBtn.showBgImg.frame = CGRectMake(0, TabBarIconTopMargin, TabBarIconSize, TabBarIconSize);
        }
        else if (i == 1){
            tabBarBtn.frame = CGRectMake(centerSpace/2.0f + TabBarIconSize + centerSpace, 0, TabBarIconSize, TabBarBtnHeight);
            tabBarBtn.showBgImg.frame = CGRectMake(0, TabBarIconTopMargin, TabBarIconSize, TabBarIconSize);
        }
        else if (i == 2){
            tabBarBtn.frame = CGRectMake(centerSpace/2.0f + TabBarIconSize * 2 + centerSpace * 2, 0, TabBarIconSize, TabBarBtnHeight);
            tabBarBtn.showBgImg.frame = CGRectMake(0, TabBarIconTopMargin, TabBarIconSize, TabBarIconSize);
        }
        if (i == 3) {
            tabBarBtn.frame = CGRectMake(centerSpace/2.0f + TabBarIconSize * 3 + centerSpace * 3, 0, TabBarIconSize, TabBarBtnHeight);
            tabBarBtn.showBgImg.frame = CGRectMake(0, TabBarIconTopMargin, TabBarIconSize, TabBarIconSize);
        }

//        tabBarBtn.showBgImg.layer.borderColor = [[UIColor redColor] CGColor];
//        tabBarBtn.showBgImg.layer.borderWidth = 1;

        tabBarBtn.tabBarTitle.frame = CGRectMake(0, 33, 50, TabBarTitleHeight);
        tabBarBtn.tabBarTitle.font = LX_TEXTSIZE_BOLD_12;
        tabBarBtn.tabBarTitle.center = CGPointMake(tabBarBtn.bounds.size.width/2.0f, tabBarBtn.tabBarTitle.center.y);
//        tabBarBtn.tabBarTitle.layer.borderColor = [[UIColor redColor] CGColor];
//        tabBarBtn.tabBarTitle.layer.borderWidth = 1;

        tabBarBtn.userInteractionEnabled = NO;

//        tabBarBtn.layer.borderColor = [[UIColor redColor] CGColor];
//        tabBarBtn.layer.borderWidth = 1;

        [self.tabBar addSubview:tabBarBtn];
    }
}

// 代码控制切换标签
-(void)selectAnotherViewController:(NSUInteger)selectedIndex
{
    self.selectedIndex = selectedIndex;
    
    self.currentSelectedIndex = (int)self.selectedIndex + 1;
    
    switch (self.currentSelectedIndex) {
        case 1:
        {
            [self.mm_drawerController setLeftDrawerViewController:[LXMenuManager sharedInstance].mainMenuNavVC];
            int menuWidth = MenuWidth;
            [self.mm_drawerController setMaximumLeftDrawerWidth:menuWidth];
            [self.mm_drawerController setCenterInteractionEnable:NO];
        }
            break;
        case 2:
        {
            [self.mm_drawerController setLeftDrawerViewController:[LXMenuManager sharedInstance].storeMenuVC];
            [self.mm_drawerController setMaximumLeftDrawerWidth:StoreMenuWidth];
            [self.mm_drawerController setCenterInteractionEnable:YES];
        }
            break;
        case 3:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mm_drawerController closeDrawerAnimated:NO completion:^(BOOL finished) {
                    [self.mm_drawerController setLeftDrawerViewController:nil];
                }];
            });
        }
            break;
        case 4:
        {
            [self.mm_drawerController setLeftDrawerViewController:[LXMenuManager sharedInstance].forumMenuVC];
            [self.mm_drawerController setMaximumLeftDrawerWidth:ForumMenuWidth];
            [self.mm_drawerController setCenterInteractionEnable:YES];
        }
            break;
            
        default:
            break;
    }

    if (self.currentSelectedIndex != self.preSelectedIndex) {
        
        LXTabbarBtn * preBtn = (LXTabbarBtn *)[self.tabBar viewWithTag:self.preSelectedIndex];
        [preBtn setShowBgImg:self.imageArray[self.preSelectedIndex-1][@"normal"] SelectedImg:self.imageArray[self.preSelectedIndex-1][@"selected"] forState:NO];
        
        self.preSelectedIndex = self.currentSelectedIndex;
        
        LXTabbarBtn * currentBtn = (LXTabbarBtn *)[self.tabBar viewWithTag:self.currentSelectedIndex];
        [currentBtn setShowBgImg:self.imageArray[self.currentSelectedIndex-1][@"normal"] SelectedImg:self.imageArray[self.currentSelectedIndex-1][@"selected"] forState:YES];
    }
}

#pragma mark -tabBar协议方法

// 手动点击切换标签
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = (UINavigationController *)viewController;
        if ([nav.viewControllers[0] isKindOfClass:[LXHomepageViewController class]]) {
            //首页
            [self.mm_drawerController closeDrawerAnimated:NO completion:^(BOOL finished) {
                [self.mm_drawerController setLeftDrawerViewController:[LXMenuManager sharedInstance].mainMenuNavVC];
                int menuWidth = MenuWidth;
                [self.mm_drawerController setMaximumLeftDrawerWidth:menuWidth];
                [self.mm_drawerController setCenterInteractionEnable:NO];
            }];
            self.currentSelectedIndex = 1;
        }
        if ([nav.viewControllers[0] isKindOfClass:[LXStoreViewController class]]) {
            //店铺
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mm_drawerController closeDrawerAnimated:NO completion:^(BOOL finished) {
                    [self.mm_drawerController setLeftDrawerViewController:[LXMenuManager sharedInstance].storeMenuVC];
                    [self.mm_drawerController setMaximumLeftDrawerWidth:StoreMenuWidth];
                    [self.mm_drawerController setCenterInteractionEnable:YES];
                }];
            });
            self.currentSelectedIndex = 2;
        }
        if ([nav.viewControllers[0] isKindOfClass:[ChatListViewController class]]) {
            //聊天
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mm_drawerController closeDrawerAnimated:NO completion:^(BOOL finished) {
                    [self.mm_drawerController setLeftDrawerViewController:nil];
                }];
            });
            self.currentSelectedIndex = 3;
        }
        if ([nav.viewControllers[0] isKindOfClass:[LXForumViewController class]]) {
            //论坛
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mm_drawerController closeDrawerAnimated:NO completion:^(BOOL finished) {
                    [self.mm_drawerController setLeftDrawerViewController:[LXMenuManager sharedInstance].forumMenuVC];
                    [self.mm_drawerController setMaximumLeftDrawerWidth:ForumMenuWidth];
                    [self.mm_drawerController setCenterInteractionEnable:YES];
                }];
            });
            self.currentSelectedIndex = 4;
        }

        if (self.currentSelectedIndex != self.preSelectedIndex) {
            
            LXTabbarBtn * preBtn = (LXTabbarBtn *)[self.tabBar viewWithTag:self.preSelectedIndex];
            [preBtn setShowBgImg:self.imageArray[self.preSelectedIndex-1][@"normal"] SelectedImg:self.imageArray[self.preSelectedIndex-1][@"selected"] forState:NO];
            
            self.preSelectedIndex = self.currentSelectedIndex;
            
            LXTabbarBtn * currentBtn = (LXTabbarBtn *)[self.tabBar viewWithTag:self.currentSelectedIndex];
            [currentBtn setShowBgImg:self.imageArray[self.currentSelectedIndex-1][@"normal"] SelectedImg:self.imageArray[self.currentSelectedIndex-1][@"selected"] forState:YES];
        }
    }
}

#pragma mark -KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentSelectedIndex"]) {
        if (change && change[@"old"] && change[@"new"]) {
            int old = [change[@"old"] intValue];
            int new = [change[@"new"] intValue];
            
            // 离开用户首页时
            if (old == 1) {

            }
            // 回到用户首页时
            if (new == 1 && old != 1) {
                NSLog(@"切换到主页");
                [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_changeTabBarToHomepage object:nil];
            } else if (new == 2 && old != 2) {
                NSLog(@"切换到店铺列表页");
                [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_changeTabBarToStoreList object:nil];
            } else if (new == 3) {
                NSLog(@"切换到聊天列表页");
                [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_changeTabBarToChatList object:nil];
            } else if (new == 4) {
                NSLog(@"切换到论坛列表页");
                [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_changeTabBarToForumList object:nil];
            }
        }
        
        // 发送Tabbar改变通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_changeTabBarButton object:nil userInfo:change];

        // 每次点击“XXX”页面均刷新界面
        if (self.currentSelectedIndex == 5-1) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_reConnectUserMineViewController object:nil];
        }
    }
}

#pragma mark - 加载聊天群组信息

- (void)loadChatGroupInfos:(NSNotification *)notification
{
    NSLog(@"调用loadChatGroupInfos方法。");
    BOOL loginSuccess = [notification.object boolValue];
    //登陆成功
    if (loginSuccess) {
        NSLog(@"环信用户登录成功！");
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        int i = 0;
        for (EMGroup *group in groupArray) {
            i++;
            NSString * groupId = group.groupId;
            NSLog(@"群组%d：%@", i, groupId);
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

#pragma mark - IChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    NSLog(@"会话列表更新了：didUpdateConversationList");
    [self setupUnreadMessageCount];
    [_chatVC refreshDataSource];
}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    NSLog(@"未读消息数量变化回调：didUnreadMessagesCountChanged");
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages
{
    NSLog(@"离线消息接收完成：didFinishedReceiveOfflineMessages");
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineCmdMessages
{
    NSLog(@"离线命令消息接收完成：didFinishedReceiveOfflineCmdMessages");
}

- (void)setBadgeViewOnParentView:(UIView *)parentView with:(NSString *)badgeText
{
    if (self.badgeView == nil) {
        self.badgeView = [[JSBadgeView alloc] initWithParentView:parentView alignment:JSBadgeViewAlignmentTopRight];
    }
    self.badgeView.badgePositionAdjustment = CGPointMake(0, 10);
    self.badgeView.badgeText = badgeText;
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (_chatVC) {
        if (unreadCount > 0) {
            LXTabbarBtn * currentBtn = (LXTabbarBtn *)[_chatVC.tabBarController.tabBar viewWithTag:3];
            NSString * badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
            [self setBadgeViewOnParentView:currentBtn with:badgeValue];
        } else {
            LXTabbarBtn * currentBtn = (LXTabbarBtn *)[_chatVC.tabBarController.tabBar viewWithTag:3];
            [self setBadgeViewOnParentView:currentBtn with:@""];
        }
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    return ret;
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    BOOL needShowNotification = (message.messageType != eMessageTypeChat) ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
        
        //        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        //        if (!isAppActivity) {
        //            [self showNotificationWithMessage:message];
        //        }else {
        //            [self playSoundAndVibration];
        //        }
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        switch (state) {
            case UIApplicationStateActive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateInactive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateBackground:
                [self showNotificationWithMessage:message];
                break;
            default:
                break;
        }
#endif
    }
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
//    [self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
    NSLog(@"%@", NSLocalizedString(@"receiveCmd", @"receive cmd message"));
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
        if (message.messageType == eMessageTypeGroupChat) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        else if (message.messageType == eMessageTypeChatRoom)
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username" ]];
            NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
            NSString *chatroomName = [chatrooms objectForKey:message.conversationChatter];
            if (chatroomName)
            {
                title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, chatroomName];
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:kMessageType];
    [userInfo setObject:message.conversationChatter forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
}

#pragma mark - IChatManagerDelegate 登陆回调（主要用于监听自动登录是否成功）

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error) {
#warning 这里会弹出AlertView，根据情况改为NSLog
        NSString *hintText = NSLocalizedString(@"reconnection.retry", @"Fail to log in your account, is try again... \nclick 'logout' button to jump to the login page \nclick 'continue to wait for' button for reconnection successful");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                                            message:hintText
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"reconnection.wait", @"continue to wait")
                                                  otherButtonTitles:NSLocalizedString(@"logout", @"Logout"),
                                  nil];
        alertView.tag = 99;
        [alertView show];
        [_chatVC isConnect:NO];
    }
}

#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        NSLog(@"%@", NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places"));
    } onQueue:nil];
}

- (void)didRemovedFromServer
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        NSLog(@"%@", NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side"));
    } onQueue:nil];
}

- (void)didServersChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

- (void)didAppkeyChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
//        [self showHint:NSLocalizedString(@"reconnection.ongoing", @"reconnecting...")];
        NSLog(@"%@", NSLocalizedString(@"reconnection.ongoing", @"reconnecting..."));
    }
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        if (error) {
#warning 自动重连出错的情况，看是否需要弹出错误信息，还是只打Log
            [self showHint:NSLocalizedString(@"reconnection.fail", @"reconnection failure, later will continue to reconnection")];
            NSLog(@"%@", NSLocalizedString(@"reconnection.fail", @"reconnection failure, later will continue to reconnection"));
        }else{
//            [self showHint:NSLocalizedString(@"reconnection.success", @"reconnection successful！")];
            NSLog(@"%@", NSLocalizedString(@"reconnection.success", @"reconnection successful！"));
        }
    }
}

#pragma mark - public

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
        [chatController hideImagePicker];
    }
    else if(_chatVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self selectAnotherViewController:2];
    }
}

- (EMConversationType)conversationTypeFromMessageType:(EMMessageType)type
{
    EMConversationType conversatinType = eConversationTypeChat;
    switch (type) {
        case eMessageTypeChat:
            conversatinType = eConversationTypeChat;
            break;
        case eMessageTypeGroupChat:
            conversatinType = eConversationTypeGroupChat;
            break;
        case eMessageTypeChatRoom:
            conversatinType = eConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

//- (void)didReceiveLocalNotification:(UILocalNotification *)notification
//{
//    NSDictionary *userInfo = notification.userInfo;
//    if (userInfo)
//    {
//        typeof(self) tabBar = (typeof(self))self.navigationController.topViewController;
//        UINavigationController *topController = (UINavigationController *)(tabBar.selectedViewController);
//        UIViewController *topMostVC = _topMostController(topController);
//        if ([topMostVC isKindOfClass:[ChatViewController class]]) {
//            ChatViewController *chatController = (ChatViewController *)topMostVC;
//            [chatController hideImagePicker];
//
//            NSString *conversationChatter = userInfo[kConversationChatter];
//            if (![chatController.chatter isEqualToString:conversationChatter])
//            {
//                [chatController.navigationController popViewControllerAnimated:NO];
////                [self.navigationController popViewControllerAnimated:NO];
//            }
//        }
//        if (![topMostVC isKindOfClass:[ChatViewController class]])
//        {
//            [self.navigationController popToViewController:self animated:NO];
//            [self selectAnotherViewController:2];
//        }
//    }
//    else if (_chatVC)
//    {
//        [self.navigationController popToViewController:self animated:NO];
//        [self selectAnotherViewController:2];
//    }
//}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        UINavigationController *navController = (UINavigationController *)(self.selectedViewController);
        if ([navController.topViewController isKindOfClass:[ChatViewController class]]) {
            ChatViewController *chatController = (ChatViewController *)navController.topViewController;
            [chatController hideImagePicker];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mm_drawerController closeDrawerAnimated:NO completion:nil];
        });

        NSArray *viewControllers = navController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            [self closeViewController:((UIViewController *)obj).presentedViewController];
            if (obj != navController.viewControllers[0])
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
//                    if (self.mm_drawerController.openSide == MMDrawerSideNone) {
                        [navController popViewControllerAnimated:NO];
//                    }
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.chatter isEqualToString:conversationChatter])
                    {
                        [navController popViewControllerAnimated:NO];
                        EMMessageType messageType = [userInfo[kMessageType] intValue];
                        chatViewController = [[ChatViewController alloc] initWithChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        switch (messageType) {
                            case eMessageTypeGroupChat:
                            {
                                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                                for (EMGroup *group in groupArray) {
                                    if ([group.groupId isEqualToString:conversationChatter]) {
                                        chatViewController.title = group.groupSubject;
                                        break;
                                    }
                                }
                            }
                                break;
                            default:
                                chatViewController.title = conversationChatter;
                                break;
                        }
                        chatViewController.hidesBottomBarWhenPushed = YES;
                        chatViewController.delelgate = self;
//                        [navController pushViewController:chatViewController animated:NO];
                        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chatViewController];
                        nav.navigationBarHidden = NO;
                        [navController presentViewController:nav animated:NO completion:nil];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = (ChatViewController *)obj;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMMessageType messageType = [userInfo[kMessageType] intValue];
                chatViewController = [[ChatViewController alloc] initWithChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                switch (messageType) {
                    case eMessageTypeGroupChat:
                    {
                        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                        for (EMGroup *group in groupArray) {
                            if ([group.groupId isEqualToString:conversationChatter]) {
                                chatViewController.title = group.groupSubject;
                                break;
                            }
                        }
                    }
                        break;
                    default:
                        chatViewController.title = conversationChatter;
                        break;
                }
                chatViewController.hidesBottomBarWhenPushed = YES;
                chatViewController.delelgate = self;
//                [navController pushViewController:chatViewController animated:NO];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chatViewController];
                nav.navigationBarHidden = NO;
                [navController presentViewController:nav animated:NO completion:nil];
            }
        }];
    }
    else if (_chatVC)
    {
        NSArray *arr = [self.navigationController popToViewController:self animated:NO];
        if (arr.count == 0) {
            UINavigationController *navController = (UINavigationController *)(self.selectedViewController);
            [navController popToRootViewControllerAnimated:YES];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self selectAnotherViewController:2];
        });
    }
}

- (void)closeViewController:(UIViewController *)vc
{
    if (!vc) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *arr = [vc.navigationController popToRootViewControllerAnimated:NO];
        if (arr.count == 0) {
            [vc dismissViewControllerAnimated:NO completion:nil];
        }
    });
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)vc;
        [self closeViewController:navVC.topViewController];
    } else if (vc.presentedViewController) {
        [self closeViewController:vc.presentedViewController];
    }
}

#pragma mark - ChatViewControllerDelegate

// 根据环信id得到要显示头像路径，如果返回nil，则显示默认头像
- (NSString *)avatarWithChatter:(NSString *)chatter{
    //    return @"http://img0.bdstatic.com/img/image/shouye/jianbihua0525.jpg";
    id object = [[AppDelegate occupantsInfoDict] objectForKey:chatter];
    if ([object isKindOfClass:[LXGetChatGroupOccupantsResponseModel class]]) {
        LXGetChatGroupOccupantsResponseModel * model = (LXGetChatGroupOccupantsResponseModel *)object;
        if (![VertifyInputFormat isEmpty:model.icon_url]) {
            NSString * headUrl = [NSString stringWithFormat:@"%@%@", HEAD_PREFIX, model.icon_url];
            return headUrl;
        }
    }
    return nil;
}

// 根据环信id得到要显示用户名，如果返回nil，则默认显示环信id
- (NSString *)nickNameWithChatter:(NSString *)chatter{
    id object = [[AppDelegate occupantsInfoDict] objectForKey:chatter];
    if ([object isKindOfClass:[LXGetChatGroupOccupantsResponseModel class]]) {
        LXGetChatGroupOccupantsResponseModel * model = (LXGetChatGroupOccupantsResponseModel *)object;
        if (![VertifyInputFormat isEmpty:model.nickname]) {
            return model.nickname;
        }
    }
    NSString * tempNickname = chatter.length >= 4 ? [chatter substringFromIndex:chatter.length-4] : chatter;
    return tempNickname;
}

@end
