//
//  LXMainMenuViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 15/10/18.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXMainMenuViewController.h"
#import "LXLoginViewController.h"
#import "LXMainMenuCell.h"
#import "LXNavigationController.h"
#import "LXMyCollectStoresViewController.h"
#import "LXSettingViewController.h"
#import "LXLoginResponseModel.h"
#import "LXMyTopicViewController.h"
#import "LXMyCommentedTopicViewController.h"
#import "LXMyCalledStoresViewController.h"
#import "LXUserGetProfileRequest.h"
#import "LXUserEditProfileViewController.h"
#import "LXUserEditProfileRequest.h"
#import "LXMyStoresViewController.h"

#import "LXNetManager.h"
#import "LXBaseRequest.h"
#import "LXUICommon.h"
#import "VertifyInputFormat.h"
#import "LXUserDefaultManager.h"
#import "LXNotificationCenterString.h"
#import "LXUploadManager.h"

#import "UIButton+WebCache.h"
#import "UIImage+Resize.h"
#import "NSFileManager+util.h"

@interface LXMainMenuViewController ()<UITableViewDataSource,UITableViewDelegate,LXRequestDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
}

@property (nonatomic , strong) NSMutableArray * tableArray;

@end

@implementation LXMainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createTableArray];
    [self putTableView];

    // 每次重启需重新获取个人信息
    [self asyncConnectUserGetProfile];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_Noti_userLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_Noti_userLogoutSuccess object:nil];

    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView初始化

-(void)putTableView{
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.sectionFooterHeight = 0;//去掉tableView自己加的区尾
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    self.tableView.scrollEnabled = YES;

    //设置系统默认分割线从边线开始(1)
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        
//        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//        
//    }
//    
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        
//        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
//        
//    }
    //
    [self.tableView setBackgroundColor:LX_BACKGROUND_COLOR];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //headerView
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    self.headerView = [[LXMainMenuHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MenuHeaderHeight + rectStatus.size.height)];

    // 头像
    LXLoginResponseModel *userModel = [LXUserDefaultManager getUserInfo];
    if (![VertifyInputFormat isEmpty:userModel.icon_url] && ![VertifyInputFormat isEmpty:userModel.icon_full_url]) {
        [self.headerView.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:userModel.icon_full_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"main_menu_home_head"]];
    } else {
        [self.headerView.headBtn setBackgroundImage:[UIImage imageNamed:@"main_menu_home_head"] forState:UIControlStateNormal];
    }
    [self.headerView.headBtn setAdjustsImageWhenHighlighted:NO];
    [self.headerView.headBtn addTarget:self action:@selector(loginOrPhotoClick:) forControlEvents:UIControlEventTouchUpInside];

    // 昵称
    if (![VertifyInputFormat isEmpty:userModel.nickname]) {
        [self.headerView.nickNameBtn setTitle:userModel.nickname forState:UIControlStateNormal];
    } else {
        [self.headerView.nickNameBtn setTitle:@"登陆" forState:UIControlStateNormal];
    }
    [self.headerView.nickNameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.headerView.nickNameBtn addTarget:self action:@selector(loginOrPhotoClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.headerView.nickNameBtn.layer.borderWidth = 1;
//    self.headerView.nickNameBtn.layer.borderColor = [[UIColor yellowColor] CGColor];

//    [self.headerView.headBtn addTarget:self action:@selector(headBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    self.headerView.backgroundColor = LX_PRIMARY_COLOR;
    self.tableView.tableHeaderView = self.headerView;

//    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
//    [footerView setBackgroundColor:LX_BACKGROUND_COLOR];
//    UIImageView * shedowLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 2)];
//    [shedowLine setImage:[UIImage imageNamed:@"Login_shedowLine"]];
//    [footerView addSubview:shedowLine];
//    self.tableView.tableFooterView = footerView;//使下面多余的边线不再显示

    [self.view addSubview:self.tableView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginStatusChangeNoti) name:k_Noti_userLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginStatusChangeNoti) name:k_Noti_userLogoutSuccess object:nil];
}

- (void)userLoginStatusChangeNoti
{
    // 头像
    LXLoginResponseModel *userModel = [LXUserDefaultManager getUserInfo];
    if (![VertifyInputFormat isEmpty:userModel.icon_url] && ![VertifyInputFormat isEmpty:userModel.icon_full_url]) {
        [self.headerView.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:userModel.icon_full_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"main_menu_home_head"]];
    } else {
        [self.headerView.headBtn setBackgroundImage:[UIImage imageNamed:@"main_menu_home_head"] forState:UIControlStateNormal];
    }

    // 昵称
    if (![VertifyInputFormat isEmpty:userModel.nickname]) {
        [self.headerView.nickNameBtn setTitle:userModel.nickname forState:UIControlStateNormal];
    } else {
        [self.headerView.nickNameBtn setTitle:@"登陆" forState:UIControlStateNormal];
    }
}

-(void)createTableArray{
    NSArray * sec = @[
                       @{@"img":@"main_menu_home_mystore",@"content":@"我的店铺"},
                       @{@"img":@"main_menu_home_star"   ,@"content":@"我收藏的店铺"},
                       @{@"img":@"main_menu_home_phone"  ,@"content":@"我拨打过的店铺"},
                       @{@"img":@"main_menu_home_forum"  ,@"content":@"我的帖子"},
                       @{@"img":@"main_menu_home_comment",@"content":@"我的评论"},
                       @{@"img":@"main_menu_home_config" ,@"content":@"设置"},
                      ];

    self.tableArray = [NSMutableArray array];
    [self.tableArray addObject:sec];
}

#pragma mark - Button Event

-(void)loginOrPhotoClick:(id)sender{
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSLog(@"已经是登录状态");
        UIActionSheet *imageActionSheet = [[UIActionSheet alloc] initWithTitle:@"设置" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择本地图片", @"拍照", @"修改个人信息", nil];
        imageActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        imageActionSheet.destructiveButtonIndex = 4;
        [imageActionSheet showInView:self.mm_drawerController.view];
        return;
    }
    LXLoginViewController *loginVC = [[LXLoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    nav.navigationBarHidden = NO;

//    CATransition *animation = [CATransition animation];
//    [animation setDuration:0.4];
//    [animation setType:kCATransitionPush];
//    [animation setSubtype:kCATransitionFromRight];
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//    [[nav.view layer] addAnimation:animation forKey:@"SwitchToView"];

    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    switch (buttonIndex) {
        case 0: // 选择本地图片
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            } else {
//                NSString * msg = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-照片”选项中，允许i%@访问你的手机相册", COMMUNITY_APPNAME];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:ALBUM_TIP_MSG delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                
                return;
            }
        }
            break;
        case 1: // 拍照
        {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
            {
//                NSString * msg = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”选项中，允许i%@访问你的相机", COMMUNITY_APPNAME];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:CAMERA_TIP_MSG delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alert show];
                
                return;
            }
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
            break;
        case 2:
        {
            // 修改个人信息
            if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    LXUserEditProfileViewController * vc = [[LXUserEditProfileViewController alloc]init];
                    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
                    nav.navigationBarHidden = NO;
                    [self presentViewController:nav animated:YES completion:nil];
                });
            }
        }
            return;
        case 3:
            return;
    }
    
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    if (self.mm_drawerController) {
        [self.mm_drawerController presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = nil;
    if ([picker allowsEditing]){
        selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    NSData *imageData = [self compressImage:selectedImage];
    NSLog(@"质量压缩后分辨率:%f  %f",[UIImage imageWithData:imageData].size.width, [UIImage imageWithData:imageData].size.height);

    [picker dismissViewControllerAnimated:YES completion:^{
        [self chooseImageDidGetImageData:imageData];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //用户取消操作
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 图片压缩处理

- (NSData *)compressImage:(UIImage *)sourceImg
{
    //解决图片其他平台显示旋转的问题
    UIImage * selectedImage = [sourceImg fixOrientation];
    
    
    //压缩图片，默认压缩比为万分之一
    //    if (selectedImage.) {//判断是否小于500k 是则不压缩
    //        <#statements#>
    //    }
    NSLog(@"压缩前分辨率:%f  %f",selectedImage.size.width, selectedImage.size.height);
    
    CGFloat width = selectedImage.size.width;
    CGFloat height = selectedImage.size.height;
    
    // 图片的长边不能超过1440
    if (width >= height && width > (CGFloat)MAX_IMAGE_SIZE) {
        CGFloat radio = width / (CGFloat)MAX_IMAGE_SIZE;
        width = (CGFloat)MAX_IMAGE_SIZE;
        height = height / radio;
    } else if (height > (CGFloat)MAX_IMAGE_SIZE) {
        CGFloat radio = height / (CGFloat)MAX_IMAGE_SIZE;
        height = (CGFloat)MAX_IMAGE_SIZE;
        width = width / radio;
    }
    selectedImage = [selectedImage resizedImage:CGSizeMake(width, height) interpolationQuality:kCGInterpolationMedium];
    
    NSLog(@"压缩后分辨率:%f  %f",selectedImage.size.width, selectedImage.size.height);

    // 生成PNG文件
    NSData *imageData = UIImagePNGRepresentation(selectedImage);
    return imageData;
}

- (void)chooseImageDidGetImageData:(NSData *)imageData
{
    if (!imageData) {
        NSLog(@"错误：所选择的图片数据为空！");
        return;
    }

    [self showHUD:@"正在上传头像..." anim:YES];

    NSString * docDir = [NSFileManager getDocumentsPath];
    
    NSString * objectKey = [[LXUploadManager sharedInstance] makeObjectKey:LXUPLOAD_FACE];
    
    NSString * filePath = [docDir stringByAppendingFormat:@"/%@/%@", SANDBOX_IMAGE_PATH, objectKey];
    NSLog(@"图片文件路径： %@", filePath);
    
    [NSFileManager createFilePath:filePath deleteOldFile:YES];
    
    [imageData writeToFile:filePath atomically:YES];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // 上传到OSS
        if ([[LXUploadManager sharedInstance] uploadObjectSync:objectKey source:filePath]) {
            NSString * icon_url = [objectKey stringByReplacingOccurrencesOfString:UPLOAD_FACE_PATH withString:@""];
            [self asyncConnectUserEditProfile:icon_url];
        } else {
            [self showError:@"头像上传失败" delay:2 anim:YES];
        }
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.tableArray[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MainMenuCell";

    LXMainMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LXMainMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setBackgroundColor:LX_BACKGROUND_COLOR];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView setFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(cell.frame))];
    }
    [cell.contentImg setImage:[UIImage imageNamed:self.tableArray[indexPath.section][indexPath.row][@"img"]]];
    [cell.contentLabel setText:self.tableArray[indexPath.section][indexPath.row][@"content"]];
//    [cell.contentLabel setBackgroundColor:[UIColor greenColor]];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MARGIN * 2 + IconSize;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return MARGIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MARGIN)];
    view.backgroundColor = LX_BACKGROUND_COLOR;
//    view.layer.borderColor = LX_DEBUG_COLOR;
//    view.layer.borderWidth = 1;
    return view;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == LXMainMenuMyStore) {//我的店铺
            NSLog(@"点击进入我的店铺");
            if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    LXMyStoresViewController * vc = [[LXMyStoresViewController alloc]init];
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                    nav.navigationBarHidden = NO;
                    [self presentViewController:nav animated:YES completion:nil];
                });
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                LXLoginViewController *loginVC = [[LXLoginViewController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
                nav.navigationBarHidden = NO;
                
                [self.navigationController presentViewController:nav animated:YES completion:nil];
            });
        }
        if (indexPath.row == LXMainMenuMyFavorStore) {
            NSLog(@"点击进入我收藏的店铺");
            // 检查用户Nonce
            if ([VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
                [self showTips:@"请先登录" delay:2 anim:YES];
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                LXMyCollectStoresViewController * collectVC = [[LXMyCollectStoresViewController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:collectVC];
                nav.navigationBarHidden = NO;
                [self presentViewController:nav animated:YES completion:nil];
            });
        }
        if (indexPath.row == LXMainMenuMyCalledStore) {
            NSLog(@"点击进入我拨打过的店铺");
            if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    LXMyCalledStoresViewController * vc = [[LXMyCalledStoresViewController alloc]init];
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                    nav.navigationBarHidden = NO;
                    [self presentViewController:nav animated:YES completion:nil];
                });
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                LXLoginViewController *loginVC = [[LXLoginViewController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
                nav.navigationBarHidden = NO;
                
                [self.navigationController presentViewController:nav animated:YES completion:nil];
            });
        }
        if (indexPath.row == LXMainMenuMyTopic) {
            NSLog(@"点击进入我的帖子");
            if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    LXMyTopicViewController * vc = [[LXMyTopicViewController alloc]init];
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                    nav.navigationBarHidden = NO;
                    [self presentViewController:nav animated:YES completion:nil];
                });
                return;
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                LXLoginViewController *loginVC = [[LXLoginViewController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
                nav.navigationBarHidden = NO;
                
                [self.navigationController presentViewController:nav animated:YES completion:nil];
            });
        }
        if (indexPath.row == LXMainMenuMyComment) {
            NSLog(@"点击进入我的评论");
            if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    LXMyCommentedTopicViewController * vc = [[LXMyCommentedTopicViewController alloc]init];
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                    nav.navigationBarHidden = NO;
                    [self presentViewController:nav animated:YES completion:nil];
                });
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                LXLoginViewController *loginVC = [[LXLoginViewController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
                nav.navigationBarHidden = NO;
                
                [self.navigationController presentViewController:nav animated:YES completion:nil];
            });
        }
        if (indexPath.row == LXMainMenuSetting) {
            NSLog(@"点击进入设置");
            dispatch_async(dispatch_get_main_queue(), ^{
                LXSettingViewController *setting = [[LXSettingViewController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:setting];
                nav.navigationBarHidden = NO;
                [self presentViewController:nav animated:YES completion:nil];
            });
        }
    }

//    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 网络请求及相应的回调方法

-(void)asyncConnectUserGetProfile{
    if ([VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        return;
    }
    //    [self showHUD:@"正在加载..." anim:YES];
    LXUserGetProfileRequest * request = [[LXUserGetProfileRequest alloc]init];//初始化网络请求
    
    request.requestMethod = LXRequestMethodGet;
    request.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    request.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识
    
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }
    
    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

-(void)asyncConnectUserEditProfile:(NSString *)icon_url
{
    [self showHUD:@"请稍候..." anim:YES];
    LXUserEditProfileRequest * request = [[LXUserEditProfileRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1001;//类型标识
    
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }

    LXLoginResponseModel *userModel = [LXUserDefaultManager getUserInfo];

    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:userModel.name       forKey:@"name"];
    [paraDic setObject:userModel.city       forKey:@"city"];
    [paraDic setObject:userModel.birthday   forKey:@"birthday"];
    [paraDic setObject:userModel.nickname   forKey:@"nickname"];// 用新值
    [paraDic setObject:userModel.sex        forKey:@"sex"];// 用新值
    [paraDic setObject:userModel.profession forKey:@"profession"];//用新值
    [paraDic setObject:userModel.email      forKey:@"email"];//用新值

    [paraDic setObject:icon_url             forKey:@"icon_url"];
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
            
//            [self showError:[[error userInfo] objectForKey:@"NSLocalizedDescription"] delay:2 anim:YES];
            return;
        }
        
        // 成功时有时也会有成功Message
        if (![VertifyInputFormat isEmpty:requestData.successMsg]) {
            [self showSuccess:requestData.successMsg delay:2 anim:YES];
        }
        
        // 将返回的数据进行model转换（注意：要加上对model类型的校验）
        LXLoginResponseModel * responseModel = nil;
        if ([responseObject isKindOfClass:[LXLoginResponseModel class]]) {
            responseModel = (LXLoginResponseModel *)responseObject;
            NSLog(@"nickName = %@", responseModel.nickname);
            // 保存用户信息
            [LXUserDefaultManager saveUserInfo:responseModel];
            
            // 获取个人信息成功后，通知菜单页面更新头像及昵称
            [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_userLoginSuccess object:nil userInfo:nil];
        } else {
            [self showError:@"获取个人信息失败" delay:2 anim:YES];
        }
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
        } else {
            [self hideHUD:YES];
        }
        
        [self asyncConnectUserGetProfile];
    }

    return;
}

@end
