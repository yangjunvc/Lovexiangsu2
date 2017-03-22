//
//  LXForumViewController.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/10/24.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXForumViewController.h"
#import "LXForumMenuViewController.h"
#import "LXShowTopicDetailViewController.h"
#import "LXForumGetAllTagsRequest.h"
#import "LXForumGetAllTagsResponseModel.h"
#import "LXForumListByForumIdRequest.h"
#import "LXForumInfoResponseModel.h"
#import "LXForumCell.h"
#import "LXForumNewTopicViewController.h"
#import "LXLoginViewController.h"

#import "LXUserDefaultManager.h"
#import "VertifyInputFormat.h"
#import "LXNetManager.h"
#import "LXMenuManager.h"
#import "LXNotificationCenterString.h"

#import "LXUICommon.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+MMDrawerController.h"
#import "NSString+Custom.h"
#import "Utils.h"
#import "UILabel+VerticalAlign.h"
#import "PhotoBroswerVC.h"
#import "MJRefresh.h"
#import "UITableView+FDTemplateLayoutCell.h"

static NSString *forumCellIdentifier = @"ForumCell";

@interface LXForumViewController ()

@end

@implementation LXForumViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self putNavigationBar];
    
    // 首先网络请求菜单，然后会再请求具体列表内容
    [self asyncConnectForumGetAllTags];
    
    [self registerNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mm_drawerController setLeftDrawerViewController:[LXMenuManager sharedInstance].forumMenuVC];
    [self.mm_drawerController setMaximumLeftDrawerWidth:ForumMenuWidth];
    [self.mm_drawerController setCenterInteractionEnable:YES];

    [self clearMemory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    
    [self removeNotification];
}

#pragma mark - Initialization

- (void)initProperties
{
    [super initProperties];
    
    self.id = @"1";
    self.tag = @"最新";
}

- (void)initPropertiesWithId:(NSString *)forum_id AndName:(NSString *)name
{
    [super initProperties];
    
    self.id = forum_id;
    self.tag = name;
}

#pragma mark - Notification

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshForumList) name:k_Noti_changeTabBarToForumList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forumMenuSelected:) name:k_Noti_ForumMenuSelected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comebackToForumList) name:k_Noti_comebackToForumList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshForumList) name:k_Noti_refreshForumList object:nil];
}

- (void)refreshForumList
{
    [((LXForumMenuViewController *)[LXMenuManager sharedInstance].forumMenuVC) setNeedsTableViewRefresh];
    [self removeAllSubviews];
    [self initProperties];
    // Tabbar切换需要重新获取菜单
    [self asyncConnectForumGetAllTags];
}

- (void)comebackToForumList
{
    [((LXForumMenuViewController *)[LXMenuManager sharedInstance].forumMenuVC) setDonotNeedScrollToTop];
}

- (void)forumMenuSelected:(NSNotification * )notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSLog(@"选择了论坛菜单，参数：forum_id:%@, name:%@", userInfo[@"forum_id"], userInfo[@"name"]);
    [self removeAllSubviews];
    [self initPropertiesWithId:userInfo[@"forum_id"] AndName:userInfo[@"name"]];
    [self asyncConnectGetForumList];
    // 改变导航条标题
    [self.lxLeftBtnTitle setTitle:self.tag forState:UIControlStateNormal];
}

#pragma mark - Clean Work

- (void)removeAllSubviews
{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_Noti_changeTabBarToForumList object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_Noti_ForumMenuSelected object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_Noti_comebackToForumList object:nil];
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{

    [self.lxLeftBtnTitle setTitle:@"最新" forState:UIControlStateNormal];
    [self.lxLeftBtnTitle setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.lxLeftBtnTitle.titleLabel.font = LX_TEXTSIZE_20;
//    self.lxLeftBtnTitle.layer.borderWidth = 1;
//    self.lxLeftBtnTitle.layer.borderColor = LX_DEBUG_COLOR;
    
    // [UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0]

    [self.lxRightBtn2Img setImage:[UIImage imageNamed:@"chat_group_add"] forState:UIControlStateNormal];
    [self.lxRightBtn2Img setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.lxRightBtn2Img addTarget:self action:@selector(newTopicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.lxRightBtn2Img.layer.borderWidth = 1;
//    self.lxRightBtn2Img.layer.borderColor = LX_DEBUG_COLOR;
    
    self.navigationController.navigationBar.translucent = NO;
    // 30 127 241
    self.navigationController.navigationBar.barTintColor = LX_PRIMARY_COLOR;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxLeftBtnTitle];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxRightBtn2Img];
}

#pragma mark - Element of Page

- (void)putElements
{
    [self.view setBackgroundColor:LX_BACKGROUND_COLOR];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 收藏店铺列表
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49) style:UITableViewStylePlain];
    //    self.tableView.sectionFooterHeight = 0;//去掉tableView自己加的区尾
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.bounces = YES;
    self.tableView.scrollEnabled = YES;

//    if (IOS8_OR_LATER) {
//        CGFloat height = MARGIN * 2 + MARGIN * 2 + MARGIN * 2 + TopicImgHeight;
//        self.tableView.estimatedRowHeight = height;
//        self.tableView.rowHeight = UITableViewAutomaticDimension;
//    }

    //设置系统默认分割线从边线开始(1)
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    [self.tableView setBackgroundColor:LX_BACKGROUND_COLOR];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    // 添加MJRefreshView
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.tableView.headerRefreshingText = @"努力刷新中...";

    [self.tableView registerClass:[LXForumCell class] forCellReuseIdentifier:forumCellIdentifier];

    [self.view addSubview:self.tableView];
}

- (void)refreshTableView
{
    if (self.tableView) {
        [self.tableView reloadData];
    }
}

- (void)headerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [super initProperties];
        [self asyncConnectRefreshForumList];
    });
}

#pragma mark - Button Event

- (void)newTopicBtnClick:(id)sender{
    NSLog(@"发新帖子按钮 Clicked");
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            LXForumNewTopicViewController * vc = [[LXForumNewTopicViewController alloc]init];
            vc.id = self.id;
            vc.tag = self.tag;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            nav.navigationBarHidden = NO;
            [self presentViewController:nav animated:YES completion:nil];
        });
        return;
    }

    LXLoginViewController *loginVC = [[LXLoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    nav.navigationBarHidden = NO;
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

//- (void)imageViewClick:(id)sender{
//    NSLog(@"帖子预览图 Clicked");
//    if ([sender isKindOfClass:[UIButton class]]) {
//        UIButton *btn = (UIButton *)sender;
//        id superView = [btn superview];
//        int loopCnt = 0;
//        while (![superView isKindOfClass:[LXForumCell class]] && loopCnt < 4) {
//            superView = [superView superview];
//            loopCnt ++;
//        }
//        if ([superView isKindOfClass:[LXForumCell class]]) {
//            LXForumCell *cell = (LXForumCell *)superView;
//            NSLog(@"帖子图片地址：%@", cell.topicImgPath);
//            // TODO:显示图片，并可以保存
//        }
//    }
//}

- (void)topicImgClick:(UITapGestureRecognizer *)tap{
    NSLog(@"话题图片被点击！");
    NSUInteger index = tap.view.tag;
    NSLog(@"话题图片所在Cell的index = %lu", (unsigned long)index);
    LXForumInfoResponseModel *model = self.tableArray[index];
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeModal index:0 photoModelBlock:^NSArray *{
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:1];
        for (NSUInteger i = 0; i < 1; i++) {
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.image_HD_U = model.original;
            
            //源frame
            pbModel.sourceImageView = (UIImageView *)tap.view;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LXForumCell * cell = [tableView dequeueReusableCellWithIdentifier:forumCellIdentifier];

    [self setupModelOfCell:cell atIndexPath:indexPath];

    return cell;
}

- (void) setupModelOfCell:(LXForumCell *) cell atIndexPath:(NSIndexPath *) indexPath {
    
    // 采用计算frame模式还是自动布局模式，默认为NO，自动布局模式
    //    cell.fd_enforceFrameLayout = NO;

    [cell setBackgroundColor:LX_BACKGROUND_COLOR];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@"ScreenWidth = %f", ScreenWidth);
    NSLog(@"CellHeight = %f", CGRectGetHeight(cell.frame));
    [cell.contentView setFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(cell.frame))];

    LXForumInfoResponseModel *model = self.tableArray[indexPath.row];
    NSLog(@"帖子标题：%@", model.title);
    
    // 置顶
    [cell.topImg setImage:[UIImage imageNamed:@"forum_top"]];
    if ([model.top isEqualToString:@"1"]) {
        cell.topImg.hidden = NO;
    } else {
        cell.topImg.hidden = YES;
    }
    
    // 帖子标题
    [cell.titleLabel setText:model.title];
    
    // 帖子内容
//    [cell.contentLabel setText:model.content];
    __weak LXForumCell * weakCell = cell;
    [cell.contentLabel setText:model.content afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)weakCell.contentLabel.font.fontName,
                                                weakCell.contentLabel.font.pointSize,
                                                NULL);
        if (ctFont) {
            NSRange strRange = NSMakeRange(0, [mutableAttributedString length]);
            [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:strRange];
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)ctFont range:strRange];
            CFRelease(ctFont);
        }
        return mutableAttributedString;
    }];

    if ([VertifyInputFormat isEmpty:model.thumbnail]) {
        int numberOfLines = [Utils calcLabelRowNum:model.content withFont:cell.contentLabel.font withWidth:ScreenWidth - MARGIN * 2 numberOfLines:4];
        cell.contentLabel.numberOfLines = numberOfLines;
        [cell.contentLabel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(numberOfLines * cell.contentLabel.font.leading + 2);
        }];
    } else {
        cell.contentLabel.numberOfLines = 5;
//        double finalWidth = ScreenWidth - MARGIN * 2 - TopicImgWidth - MARGIN;
//        [cell.contentLabel alignTop:finalWidth];
        [cell.contentLabel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(4 * cell.contentLabel.font.leading + 2);
        }];
    }
    
    __weak typeof(self) weakSelf = self;
//    __weak LXForumCell * weakCell = cell;
    // 帖子预览图
    cell.topicImg.userInteractionEnabled = YES;
    if (![VertifyInputFormat isEmpty:model.thumbnail]) {
        [cell.topicImg sd_setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:[UIImage imageNamed:@"default_image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            weakCell.topicImg.tag = indexPath.row;
            if (weakCell.topicImg.gestureRecognizers == nil || weakCell.topicImg.gestureRecognizers.count == 0) {
                NSLog(@"给话题图片添加单击手势！");
                [weakCell.topicImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(topicImgClick:)]];
            } else {
                NSLog(@"话题图片已有单击手势！无需再次添加！");
            }
        }];
        cell.topicImg.hidden = NO;
        //        [cell.topicImgView addTarget:self action:@selector(imageViewClick:) forControlEvents:UIControlEventTouchUpInside];
        //        cell.topicImgView.hidden = NO;
    } else {
        cell.topicImg.hidden = YES;
        //        cell.topicImgView.hidden = YES;
    }
    
    // 回复小图标
    [cell.replyImg setImage:[UIImage imageNamed:@"main_forum_reply"]];
    
    // 回复数量标签
    //    NSString *tempStr = [NSString stringWithFormat:@"%@  %ld", model.reply, (long)indexPath.row + 1];
    //    [cell.replyCountLabel setText:tempStr];
    [cell.replyCountLabel setText:model.reply];
    
    // 版块（没有则不显示）
    if (![VertifyInputFormat isEmpty:model.forum_name]) {
        NSString * forumname = [NSString stringWithFormat:@"版块：%@", model.forum_name];
        [cell.forumNameLabel setText:forumname];
        cell.forumNameLabel.hidden = NO;
    } else {
        cell.forumNameLabel.hidden = YES;
    }
    
    // 最后更新时间标签
    [cell.updateTimeLabel setText:model.update];
    
    // 话题ID
    cell.topicId = model.id;
    // 版块ID
    cell.forumId = model.forum_id;
    // 话题预览图（原图）路径
    cell.topicImgPath = model.original;
    
    //    if (indexPath.row == 0) {
    //        cell.cellSeparator.hidden = YES;
    //    } else {
    //        cell.cellSeparator.hidden = NO;
    //    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"TableView滚动结束！");
    UITableView *tableview = (UITableView *) scrollView;
    NSArray *visibleRows = [tableview indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visibleRows) {
        if ((indexPath.row + 1 == self.tableArray.count) &&
            (self.tableArray.count == (self.pageNum + 1) * self.amountPerPage)) {
            self.pageNum ++;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self asyncConnectGetForumList];
            });
        }
    }
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // 帖子Cell区高度
//    CGFloat height = MARGIN * 2 + MARGIN * 2 + MARGIN * 2 + TopicImgHeight;
//    return height;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (IOS8_OR_LATER) {
//        return UITableViewAutomaticDimension;
//    }
//    
//    // 帖子Cell区高度
//    CGFloat height = MARGIN * 2 + MARGIN * 2 + MARGIN * 2 + TopicImgHeight;
//    return height;
    return [self.tableView fd_heightForCellWithIdentifier:forumCellIdentifier cacheByIndexPath:indexPath configuration:^(LXForumCell *cell) {
        
        // 在这个block中，重新cell配置数据源
        [self setupModelOfCell:cell atIndexPath:indexPath];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LXForumCell * cell = (LXForumCell *)[tableView cellForRowAtIndexPath:indexPath];

    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"帖子ID：%@ 被选择", cell.topicId);
        LXShowTopicDetailViewController * topicVC = [[LXShowTopicDetailViewController alloc]init];
        topicVC.topicId = cell.topicId;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:topicVC];
        nav.navigationBarHidden = NO;
        [self presentViewController:nav animated:YES completion:nil];
    });
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //* 设置系统默认分割线从边线开始(2)
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
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

-(void)asyncConnectForumGetAllTags{
    [self showHUD:@"请稍候..." anim:YES];
    LXForumGetAllTagsRequest * getAllTags = [[LXForumGetAllTagsRequest alloc]init];//初始化网络请求
    
    getAllTags.requestMethod = LXRequestMethodGet;
    getAllTags.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    getAllTags.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    getAllTags.delegate = self;//代理设置
    getAllTags.tag = 1001;//类型标识
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:@(COMMUNITY_ID) forKey:@"community_id"];
    [getAllTags setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:getAllTags];//发送网络请求
}

-(void)asyncConnectGetForumList{
    [self showHUD:@"正在加载..." anim:YES];
    LXForumListByForumIdRequest * forumList = [[LXForumListByForumIdRequest alloc]init];//初始化网络请求
    
    forumList.requestMethod = LXRequestMethodGet;
    forumList.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    forumList.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    forumList.delegate = self;//代理设置
    forumList.tag = 1000;//类型标识

    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:@(self.pageNum * self.amountPerPage) forKey:@"offset"];
    [paraDic setObject:@(self.amountPerPage) forKey:@"num"];
    [paraDic setObject:self.id forKey:@"forum_id"];
    [paraDic setObject:@(COMMUNITY_ID) forKey:@"community_id"];
    [forumList setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:forumList];//发送网络请求
}

-(void)asyncConnectRefreshForumList{
    LXForumListByForumIdRequest * forumList = [[LXForumListByForumIdRequest alloc]init];//初始化网络请求
    
    forumList.requestMethod = LXRequestMethodGet;
    forumList.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    forumList.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    forumList.delegate = self;//代理设置
    forumList.tag = 9999;//类型标识
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:@(self.pageNum * self.amountPerPage) forKey:@"offset"];
    [paraDic setObject:@(self.amountPerPage) forKey:@"num"];
    [paraDic setObject:self.id forKey:@"forum_id"];
    [paraDic setObject:@(COMMUNITY_ID) forKey:@"community_id"];
    [forumList setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:forumList];//发送网络请求
}

// 网络请求回调
-(void)requestResult:(NSError*) error withData:(id)responseObject responseData:(LXBaseRequest*)requestData
{
    if (requestData.tag == 1001) {
        if (error) {
            //对error进行相应的处理
            NSLog(@"%@",[[error userInfo] objectForKey:@"NSLocalizedDescription"]);
            
            //            [self showError:[[error userInfo] objectForKey:@"NSLocalizedDescription"] delay:2 anim:YES];
            [self asyncConnectGetForumList];
            return;
        }
        
        // 成功时有时也会有成功Message
        if (![VertifyInputFormat isEmpty:requestData.successMsg]) {
            [self showSuccess:requestData.successMsg delay:2 anim:YES];
        }
        
        // 将返回的数据进行model转换（注意：要加上对model类型的校验）
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (((NSArray *)responseObject).count > 0) {
                LXForumGetAllTagsResponseModel * model = ((NSArray *)responseObject)[0];
//                self.id = model.id;
                NSDictionary *param = @{@"forum_id":model.id,
                                        @"name":model.name,
                                        };
                [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_ForumMenuSelected object:nil userInfo:param];
            }
        }
//        [self asyncConnectGetForumList];
        
        return;
    }
    
    return [super requestResult:error withData:responseObject responseData:requestData];
}

@end
