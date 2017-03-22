/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "AppDelegate+EaseMob.h"

#import "NSDate+Category.h"

#import "LXGetChatGroupOccupantsResponseModel.h"
#import "LXGetChatGroupOccupantsRequest.h"

#import "LXNetManager.h"
#import "LXUserDefaultManager.h"
#import "VertifyInputFormat.h"

static NSMutableDictionary * occupantsInfoDict = nil;

/**
 *  本类中做了EaseMob初始化和推送等操作
 */

@implementation AppDelegate (EaseMob)

#pragma mark - 群聊成员字典的Setter/Getter方法

+ (NSMutableDictionary *)occupantsInfoDict
{
    return occupantsInfoDict;
}

+ (void)setOccupantsInfoDict:(NSMutableDictionary *)infoDict
{
    occupantsInfoDict = infoDict;
}

#pragma mark - 生命周期

- (void)easemobApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    if (launchOptions) {
        NSDictionary *userInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        if(userInfo)
        {
            [self didReceiveRemoteNotification:userInfo];
        }
    }

    occupantsInfoDict = [NSMutableDictionary dictionary];

    _connectionState = eEMConnectionConnected;

    [self registerRemoteNotification];

#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = APNS_CERT_DEV;
#else
    apnsCertName = APNS_CERT_PRO;
#endif

    [[EaseMob sharedInstance] registerSDKWithAppKey:EASEMOB_APPKEY
                                       apnsCertName:apnsCertName
                                        otherConfig:@{kSDKConfigEnableConsoleLogger:@NO}];

    // 登录成功后，自动去取好友列表
    // SDK获取结束后，会回调
    // - (void)didFetchedBuddyList:(NSArray *)buddyList error:(EMError *)error方法。
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
    
    // 注册环信监听
    [self registerEaseMobNotification];
    [[EaseMob sharedInstance] application:application
            didFinishLaunchingWithOptions:launchOptions];
    
    [self setupNotifiers];
}


// 监听系统生命周期回调，以便将需要的事件传给SDK
- (void)setupNotifiers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveNotif:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActiveNotif:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminateNotif:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataWillBecomeUnavailableNotif:)
                                                 name:UIApplicationProtectedDataWillBecomeUnavailable
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataDidBecomeAvailableNotif:)
                                                 name:UIApplicationProtectedDataDidBecomeAvailable
                                               object:nil];
}

#pragma mark - notifiers
- (void)appDidEnterBackgroundNotif:(NSNotification*)notif{
    [[EaseMob sharedInstance] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:notif.object];
}

- (void)appDidFinishLaunching:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidFinishLaunching:notif.object];
}

- (void)appDidBecomeActiveNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidBecomeActive:notif.object];
}

- (void)appWillResignActiveNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillResignActive:notif.object];
}

- (void)appDidReceiveMemoryWarning:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidReceiveMemoryWarning:notif.object];
}

- (void)appWillTerminateNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillTerminate:notif.object];
}

- (void)appProtectedDataWillBecomeUnavailableNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationProtectedDataWillBecomeUnavailable:notif.object];
}

- (void)appProtectedDataDidBecomeAvailableNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationProtectedDataDidBecomeAvailable:notif.object];
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"deviceToken : %@", deviceToken);
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];

    // Required
    [JPUSHService registerDeviceToken:deviceToken];
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
}

// 注册推送
- (void)registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;

    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }

#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

#pragma mark - registerEaseMobNotification
- (void)registerEaseMobNotification{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}



#pragma mark - IChatManagerDelegate
// 开始自动登录回调
-(void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    UIAlertView *alertView = nil;
    if (error) {
        NSLog(@"自动登录失败.");
        
        //发送自动登陆状态通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
    else{
        NSLog(@"自动登录开始...");
        
        // 旧数据转换 (如果您的sdk是由2.1.2版本升级过来的，需要家这句话)
        [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
        //获取数据库中的数据
        [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
    }
    
    [alertView show];
}

// 结束自动登录回调
-(void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    UIAlertView *alertView = nil;
    if (error) {
        NSLog(@"自动登录失败.");
        
        //发送自动登陆状态通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
    else{
        //获取群组列表
        [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];

        NSLog(@"自动登录结束...");
    }
    
    [alertView show];
}

// 离开群组回调
- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    NSString *tmpStr = group.groupSubject;
    NSString *str;
    if (!tmpStr || tmpStr.length == 0) {
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *obj in groupArray) {
            if ([obj.groupId isEqualToString:group.groupId]) {
                tmpStr = obj.groupSubject;
                break;
            }
        }
    }
    
    if (reason == eGroupLeaveReason_BeRemoved) {
        str = [NSString stringWithFormat:NSLocalizedString(@"group.beKicked", @"you have been kicked out from the group of \'%@\'"), tmpStr];
    }
    if (str.length > 0) {
        TTAlertNoTitle(str);
    }
}

// 申请加入群组被拒绝回调
- (void)didReceiveRejectApplyToJoinGroupFrom:(NSString *)fromId
                                   groupname:(NSString *)groupname
                                      reason:(NSString *)reason
                                       error:(EMError *)error{
    if (!reason || reason.length == 0) {
        reason = [NSString stringWithFormat:NSLocalizedString(@"group.beRefusedToJoin", @"be refused to join the group\'%@\'"), groupname];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:reason delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}

//接收到入群申请
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason
                             error:(EMError *)error
{
    if (!groupId || !username) {
        return;
    }
    
    if (!reason || reason.length == 0) {
        reason = [NSString stringWithFormat:NSLocalizedString(@"group.applyJoin", @"%@ apply to join groups\'%@\'"), username, groupname];
    }
    else{
        reason = [NSString stringWithFormat:NSLocalizedString(@"group.applyJoinWithName", @"%@ apply to join groups\'%@\'：%@"), username, groupname, reason];
    }
    
    if (error) {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.sendApplyFail", @"send application failure:%@\nreason：%@"), reason, error.description];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"Error") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        [alertView show];
    }
    else{
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":groupname, @"groupId":groupId, @"username":username, @"groupname":groupname, @"applyMessage":reason, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleJoinGroup]}];
//        [[ApplyViewController shareController] addNewApply:dic];
    }
}

// 已经同意并且加入群组后的回调
- (void)didAcceptInvitationFromGroup:(EMGroup *)group
                               error:(EMError *)error
{
    if(error)
    {
        return;
    }
    
    NSString *groupTag = group.groupSubject;
    if ([groupTag length] == 0) {
        groupTag = group.groupId;
    }
    
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.agreedAndJoined", @"agreed and joined the group of \'%@\'"), groupTag];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}


// 绑定deviceToken回调
- (void)didBindDeviceWithError:(EMError *)error
{
    if (error) {
        TTAlertNoTitle(NSLocalizedString(@"apns.failToBindDeviceToken", @"Fail to bind device token"));
    }
}

// 网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [self.tabbarDrawerViewController networkChanged:connectionState];
}

// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.content", @"Apns content")
//                                                    message:str
//                                                   delegate:nil
//                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
//                                          otherButtonTitles:nil];
//    [alert show];
    NSLog(@"接收到的推送内容JSON：%@", str);
}

-(void)didUpdateGroupList:(NSArray *)groupList error:(EMError *)error
{
    NSLog(@"didUpdateGroupList方法被调用......");
    for (EMGroup * group in groupList) {
        // 获取此群组的成员信息
        [[EaseMob sharedInstance].chatManager asyncFetchOccupantList:group.groupId completion:^(NSArray *occupantsList, EMError *error) {
            NSLog(@"群组ID：%@", group.groupId);
            NSLog(@"群组名称：%@", group.groupSubject);
            NSLog(@"群组成员数：%lu", (unsigned long)occupantsList.count);
            for (int i = 0; i < occupantsList.count; i++) {
                NSString * occupantPhone = occupantsList[i];
                NSLog(@"群组成员%d: %@", i, occupantPhone);
                [self asyncConnectChatGroupGetOccupants:occupantPhone];
            }
            NSLog(@"群组成员用户名（手机后4位）列表：%@", occupantsInfoDict);
        } onQueue:nil];
    }
}

#pragma mark - 环信登录注册登出

// 环信登录
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    //异步登陆账号
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         LXEaseMobLoginStatus loginStatus;
         if (loginInfo && !error) {
             //设置是否自动登录
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
             
             // 旧数据转换 (如果您的sdk是由2.1.2版本升级过来的，需要家这句话)
             [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             //获取数据库中数据
             [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             
             //获取群组列表
             [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
             
             //发送自动登陆状态通知
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
             
             //保存最近一次登录用户名
             [self saveLastLoginUsername];
             loginStatus = LXEaseMobLoginSuccess;
         }
         else
         {
             switch (error.errorCode)
             {
                 case EMErrorNotFound:
                     loginStatus = LXEaseMobErrorLoginNotExists;
                     break;
                 case EMErrorNetworkNotConnected:
                     loginStatus = LXEaseMobErrorLoginNetworkFail;
                     break;
                 case EMErrorServerNotReachable:
                     loginStatus = LXEaseMobErrorLoginServerFail;
                     break;
                 case EMErrorServerAuthenticationFailure:
                     loginStatus = LXEaseMobErrorLoginAuthenticationFail;
                     break;
                 case EMErrorServerTimeout:
                     loginStatus = LXEaseMobErrorLoginServerTimeout;
                     break;
                 default:
                     loginStatus = LXEaseMobErrorLoginLoginFailure;
                     break;
             }
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINFINISH object:@(loginStatus)];
     } onQueue:nil];
}

// 环信注册账号
- (void)registerWithUsername:(NSString *)username password:(NSString *)password
{
    //异步注册账号
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:username
                                                         password:password
                                                   withCompletion:
     ^(NSString *username, NSString *password, EMError *error) {
         LXEaseMobRegistStatus registStatus;
         if (!error) {
             registStatus = LXEaseMobRegistSuccess;
         } else {
             switch (error.errorCode) {
                 case EMErrorServerNotReachable:
                     registStatus = LXEaseMobErrorServerNotReachable;
                     break;
                 case EMErrorServerDuplicatedAccount:
                     registStatus = LXEaseMobErrorServerDuplicatedAccount;
                     break;
                 case EMErrorNetworkNotConnected:
                     registStatus = LXEaseMobErrorNetworkNotConnected;
                     break;
                 case EMErrorServerTimeout:
                     registStatus = LXEaseMobErrorServerTimeout;
                     break;
                 default:
                     registStatus = LXEaseMobErrorServerRegistFailed;
                     break;
             }
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_REGISTFINISH object:@(registStatus)];
     } onQueue:nil];
}

#pragma mark - 环信私有方法

- (void)saveLastLoginUsername
{
    NSString *username = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
        [ud synchronize];
    }
}

- (NSString*)lastLoginUsername
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
    if (username && username.length > 0) {
        return username;
    }
    return nil;
}

#pragma mark - 网络请求及相应的回调方法

-(void)asyncConnectChatGroupGetOccupants:(NSString *)phone{
    if (!phone) {
        return;
    }
    if (![occupantsInfoDict objectForKey:phone]) {
        NSLog(@"成员%@不存在，新创建一个字典项", phone);
        NSString * tempNickname = phone.length >= 4 ? [phone substringFromIndex:phone.length-4] : phone;
        LXGetChatGroupOccupantsResponseModel * model = [[LXGetChatGroupOccupantsResponseModel alloc]init];
        model.phone = phone;
        model.nickname = tempNickname;
        model.updatetime = [[NSDate date] timeIntervalSince1970InMilliSecond];
        [occupantsInfoDict setObject:model forKey:phone];
    } else {
        id object = [occupantsInfoDict objectForKey:phone];
        if ([object isKindOfClass:[LXGetChatGroupOccupantsResponseModel class]]) {
            LXGetChatGroupOccupantsResponseModel * model = (LXGetChatGroupOccupantsResponseModel *)object;
            NSDate * nowDate = [NSDate date];
            NSTimeInterval diffTime = [nowDate timeIntervalSince1970InMilliSecond] - model.updatetime;
            // 30秒内不再重新请求成员信息
            if (diffTime < EASEMOB_INTERVAL * 1000) {
                NSLog(@"成员手机号：%@，%d秒内不再重新请求该成员信息", model.phone, EASEMOB_INTERVAL);
                return;
            }
        }
    }
    
    LXGetChatGroupOccupantsRequest * request = [[LXGetChatGroupOccupantsRequest alloc]init];//初始化网络请求
    
    request.requestMethod = LXRequestMethodGet;
    request.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    request.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:phone forKey:@"phone"];
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
            return;
        }
        
        // 将返回的数据进行model转换（注意：要加上对model类型的校验）
        LXGetChatGroupOccupantsResponseModel *responseModel = nil;
        if ([responseObject isKindOfClass:[LXGetChatGroupOccupantsResponseModel class]]) {
            responseModel = (LXGetChatGroupOccupantsResponseModel *)responseObject;
            
            NSString *phone = requestData.requestParam[@"phone"];
            if (phone) {
                responseModel.phone = phone;
                responseModel.updatetime = [[NSDate date] timeIntervalSince1970InMilliSecond];
            }
            
            [occupantsInfoDict setObject:responseModel forKey:phone];
            
            return;
        }
    }
    
    return;
}

@end
