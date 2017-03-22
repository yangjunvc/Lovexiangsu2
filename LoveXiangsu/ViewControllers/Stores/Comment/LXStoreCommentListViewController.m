//
//  LXStoreCommentListViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 16/3/2.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreCommentListViewController.h"
#import "LXStoreCommentNoReplyCell.h"
#import "LXStoreCommentHasReplyCell.h"
#import "LXCommentInfoResponseModel.h"
#import "LXCommentListByStoreIdRequest.h"
#import "LXStoreReplyCommentViewController.h"

#import "LXUserDefaultManager.h"
#import "VertifyInputFormat.h"
#import "LXNetManager.h"
#import "LXNotificationCenterString.h"

#import "LXUICommon.h"
#import "UIImageView+WebCache.h"
#import "NSString+Custom.h"
#import "Utils.h"
#import "UILabel+VerticalAlign.h"
#import "UITableView+FDTemplateLayoutCell.h"

static NSString *commentNoReplyCellIdentifier = @"CommentNoReplyCell";
static NSString *commentHasReplyCellIdentifier = @"CommentHasReplyCell";

@interface LXStoreCommentListViewController ()

@property (strong, nonatomic) UIView *emptyView;

@property (strong, nonatomic) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * tableArray;

@end

@implementation LXStoreCommentListViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self putNavigationBar];
    [self asyncConnectGetCommentList];
    
    [self registerNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

#pragma mark - Notification

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCommentList) name:k_Noti_refreshCommentList object:nil];
}

- (void)refreshCommentList
{
    [self removeAllSubviews];
    [self asyncConnectGetCommentList];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_Noti_refreshCommentList object:nil];
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxTitleLabel setTitle:@"评论列表" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];

    self.emptyView = [[UIView alloc]init];
    self.emptyView.frame = CGRectMake(0, 10, IconSize, IconSize);

    self.navigationController.navigationBar.translucent = NO;
    // 30 127 241
    self.navigationController.navigationBar.barTintColor = LX_PRIMARY_COLOR;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxLeftBtnImg];
    self.navigationItem.titleView = self.lxTitleLabel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.emptyView];
}

#pragma mark - Element of Page

- (void)putElements
{
    [self.view setBackgroundColor:LX_BACKGROUND_COLOR];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 收藏店铺列表
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    //    self.tableView.sectionFooterHeight = 0;//去掉tableView自己加的区尾
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = YES;
    self.tableView.scrollEnabled = YES;
    
    //    if (IOS8_OR_LATER) {
    //        CGFloat height = MARGIN * 2 + MARGIN * 2 + MARGIN * 2 + CommentImgHeight;
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

    [self.tableView registerClass:[LXStoreCommentNoReplyCell class] forCellReuseIdentifier:commentNoReplyCellIdentifier];
    [self.tableView registerClass:[LXStoreCommentHasReplyCell class] forCellReuseIdentifier:commentHasReplyCellIdentifier];

    [self.view addSubview:self.tableView];
}

- (void)refreshTableView
{
    if (self.tableView) {
        [self.tableView reloadData];
    }
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_refreshStoreDetail object:nil userInfo:nil];
    
    NSArray *arr = [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"arr = %@", arr);
    if (arr == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
    LXCommentInfoResponseModel *model = self.tableArray[indexPath.row];

    if (![VertifyInputFormat isEmpty:model.reply_at] && ![VertifyInputFormat isEmpty:model.owner_id]) {
        LXStoreCommentHasReplyCell * cell = [tableView dequeueReusableCellWithIdentifier:commentHasReplyCellIdentifier];
        
        [self setupModelOfHasReplyCell:cell atIndexPath:indexPath];
        
        return cell;
    } else {
        LXStoreCommentNoReplyCell * cell = [tableView dequeueReusableCellWithIdentifier:commentNoReplyCellIdentifier];
        
        [self setupModelOfNoReplyCell:cell atIndexPath:indexPath];
        
        return cell;
    }
}

- (void) setupModelOfHasReplyCell:(LXStoreCommentHasReplyCell *) cell atIndexPath:(NSIndexPath *) indexPath {
    
    // 采用计算frame模式还是自动布局模式，默认为NO，自动布局模式
    //    cell.fd_enforceFrameLayout = NO;
    
    [cell setBackgroundColor:LX_BACKGROUND_COLOR];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@"ScreenWidth = %f", ScreenWidth);
    NSLog(@"CellHeight = %f", CGRectGetHeight(cell.frame));
    [cell.contentView setFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(cell.frame))];
    
    LXCommentInfoResponseModel *model = self.tableArray[indexPath.row];
    NSLog(@"评论内容：%@", model.comment);

    // 昵称
    cell.nicknameLabel.text = [NSString stringWithFormat:@"%@：", model.nickname];

    // 评论内容
//    cell.commentLabel.text = model.comment;
    __weak LXStoreCommentHasReplyCell * weakCell = cell;
    [cell.commentLabel setText:model.comment afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)weakCell.commentLabel.font.fontName,
                                                weakCell.commentLabel.font.pointSize,
                                                NULL);
        if (ctFont) {
            NSRange strRange = NSMakeRange(0, [mutableAttributedString length]);
            [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:strRange];
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)ctFont range:strRange];
            CFRelease(ctFont);
        }
        return mutableAttributedString;
    }];

    CGFloat nicknameWidth = [cell.nicknameLabel getFittingWidth];
    CGSize size = [Utils calcLabelHeight:cell.commentLabel.text withFont:cell.commentLabel.font withWidth:ScreenWidth - MARGIN * 2 - nicknameWidth];
    [cell.commentLabel updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(size.width);
        make.height.equalTo(size.height + 2);
    }];

    // 评论时间
    cell.createdatLabel.text = model.created_at;

    // 店主
    cell.ownerLabel.text = @"店主：";

    // 回复内容
//    cell.replyLabel.text = model.reply;
    [cell.replyLabel setText:model.reply afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)weakCell.replyLabel.font.fontName,
                                                weakCell.replyLabel.font.pointSize,
                                                NULL);
        if (ctFont) {
            NSRange strRange = NSMakeRange(0, [mutableAttributedString length]);
            [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:strRange];
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)ctFont range:strRange];
            CFRelease(ctFont);
        }
        return mutableAttributedString;
    }];

    CGFloat ownerWidth = [cell.ownerLabel getFittingWidth];
    size = [Utils calcLabelHeight:cell.replyLabel.text withFont:cell.replyLabel.font withWidth:ScreenWidth - MARGIN * 2 - ownerWidth];
    [cell.replyLabel updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(size.width);
        make.height.equalTo(size.height + 2);
    }];

    // 回复时间
    cell.replyTimeLabel.text = model.reply_at;

    // 评论ID
    cell.comment_id = model.id;
    
    //    if (indexPath.row == 0) {
    //        cell.cellSeparator.hidden = YES;
    //    } else {
    //        cell.cellSeparator.hidden = NO;
    //    }
}

- (void) setupModelOfNoReplyCell:(LXStoreCommentNoReplyCell *) cell atIndexPath:(NSIndexPath *) indexPath {
    
    // 采用计算frame模式还是自动布局模式，默认为NO，自动布局模式
    //    cell.fd_enforceFrameLayout = NO;
    
    [cell setBackgroundColor:LX_BACKGROUND_COLOR];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@"ScreenWidth = %f", ScreenWidth);
    NSLog(@"CellHeight = %f", CGRectGetHeight(cell.frame));
    [cell.contentView setFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(cell.frame))];
    
    LXCommentInfoResponseModel *model = self.tableArray[indexPath.row];
    NSLog(@"评论内容：%@", model.comment);
    
    // 昵称
    cell.nicknameLabel.text = [NSString stringWithFormat:@"%@：", model.nickname];
    
    // 评论内容
//    cell.commentLabel.text = model.comment;
    __weak LXStoreCommentNoReplyCell * weakCell = cell;
    [cell.commentLabel setText:model.comment afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)weakCell.commentLabel.font.fontName,
                                                weakCell.commentLabel.font.pointSize,
                                                NULL);
        if (ctFont) {
            NSRange strRange = NSMakeRange(0, [mutableAttributedString length]);
            [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:strRange];
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)ctFont range:strRange];
            CFRelease(ctFont);
        }
        return mutableAttributedString;
    }];

    CGFloat nicknameWidth = [cell.nicknameLabel getFittingWidth];
    CGSize size = [Utils calcLabelHeight:cell.commentLabel.text withFont:cell.commentLabel.font withWidth:ScreenWidth - MARGIN * 2 - nicknameWidth];
    [cell.commentLabel updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(size.width);
        make.height.equalTo(size.height + 2);
    }];

    // 点击答复
    cell.tipLabel.text = @"点击答复";

    // 评论时间
    cell.createdatLabel.text = model.created_at;

    // 评论ID
    cell.comment_id = model.id;
    
    //    if (indexPath.row == 0) {
    //        cell.cellSeparator.hidden = YES;
    //    } else {
    //        cell.cellSeparator.hidden = NO;
    //    }
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // 帖子Cell区高度
//    CGFloat height = MARGIN * 2 + MARGIN * 2 + MARGIN * 2 + TopicImgHeight;
//    return height;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LXCommentInfoResponseModel *model = self.tableArray[indexPath.row];
    
    if (![VertifyInputFormat isEmpty:model.reply_at] && ![VertifyInputFormat isEmpty:model.owner_id]) {
        return [self.tableView fd_heightForCellWithIdentifier:commentHasReplyCellIdentifier cacheByIndexPath:indexPath configuration:^(LXStoreCommentHasReplyCell *cell) {
            
            // 在这个block中，重新cell配置数据源
            [self setupModelOfHasReplyCell:cell atIndexPath:indexPath];
        }];
    } else {
        return [self.tableView fd_heightForCellWithIdentifier:commentNoReplyCellIdentifier cacheByIndexPath:indexPath configuration:^(LXStoreCommentNoReplyCell *cell) {
            
            // 在这个block中，重新cell配置数据源
            [self setupModelOfNoReplyCell:cell atIndexPath:indexPath];
        }];
    }
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
    LXCommentInfoResponseModel *model = self.tableArray[indexPath.row];
    
    if ([VertifyInputFormat isEmpty:model.reply]
        && [VertifyInputFormat isEmpty:model.reply_at]
        && [VertifyInputFormat isEmpty:model.owner_id]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            LXStoreCommentNoReplyCell * cell = (LXStoreCommentNoReplyCell *)[tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"评论ID：%@ 被选择", cell.comment_id);
            LXStoreReplyCommentViewController * vc = [[LXStoreReplyCommentViewController alloc]init];
            vc.comment_id = model.id;
            vc.nickname   = model.nickname;
            vc.comment    = model.comment;
            vc.createdat  = model.created_at;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            nav.navigationBarHidden = NO;
            [self presentViewController:nav animated:YES completion:nil];
        });
    } else {
        NSLog(@"已回复过的评论，不再处理！");
    }
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

-(void)asyncConnectGetCommentList{
    [self showHUD:@"正在加载..." anim:YES];
    LXCommentListByStoreIdRequest * request = [[LXCommentListByStoreIdRequest alloc]init];//初始化网络请求
    
    request.requestMethod = LXRequestMethodGet;
    request.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    request.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.storeId forKey:@"store_id"];
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
        
        // 将返回的数据进行model转换（注意：要加上对model类型的校验）
        if ([responseObject isKindOfClass:[NSArray class]]) {
            self.tableArray = responseObject;
            
            [self putElements];
            
            [self hideHUD:YES];
            
            return;
        } else {
            [self showError:@"获取店铺评论列表失败" delay:2 anim:YES];
        }
    }
    
    return;
}

@end
