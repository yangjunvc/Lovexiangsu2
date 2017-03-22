//
//  LXMyTopicViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 16/1/5.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXMyTopicViewController.h"
#import "LXForumCell.h"
#import "LXForumInfoResponseModel.h"
#import "LXShowTopicDetailViewController.h"
#import "LXMyTopicRequest.h"

#import "LXUserDefaultManager.h"
#import "VertifyInputFormat.h"
#import "LXNetManager.h"

#import "LXUICommon.h"
#import "UIImageView+WebCache.h"
#import "NSString+Custom.h"
#import "Utils.h"
#import "UILabel+VerticalAlign.h"
#import "PhotoBroswerVC.h"
#import "MJRefresh.h"
#import "UITableView+FDTemplateLayoutCell.h"

static NSString *topicCellIdentifier = @"MyTopicCell";

@interface LXMyTopicViewController ()

@property (strong, nonatomic) UIView *emptyView;

@end

@implementation LXMyTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self hiddenMenuViewController];
    [self putNavigationBar];
    [self asyncConnectGetMyTopicList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxTitleLabel setTitle:@"我的帖子" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    self.emptyView = [[UIView alloc]init];
    self.emptyView.frame = CGRectMake(14, 7, 30, 30);
    
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

    if (self.tableArray.count == 0) {
        return;
    }

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 列表
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    //    self.tableView.sectionFooterHeight = 0;//去掉tableView自己加的区尾
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.bounces = YES;
    self.tableView.scrollEnabled = YES;
    if (IOS8_OR_LATER) {
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
        self.tableView.tableHeaderView = headerView;
        UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
        self.tableView.tableFooterView = footerView;
    }
    
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

    [self.tableView registerClass:[LXForumCell class] forCellReuseIdentifier:topicCellIdentifier];

    [self.view addSubview:self.tableView];
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"vc = %@", vc);
    if (vc == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

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
    LXForumCell * cell = [tableView dequeueReusableCellWithIdentifier:topicCellIdentifier];
    
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
    [cell.contentLabel setText:model.content];
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
    
    typeof(self) weakSelf = self;
    // 帖子预览图
    cell.topicImg.userInteractionEnabled = YES;
    if (![VertifyInputFormat isEmpty:model.thumbnail]) {
        [cell.topicImg sd_setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:[UIImage imageNamed:@"default_image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.topicImg.tag = indexPath.row;
            if (cell.topicImg.gestureRecognizers == nil || cell.topicImg.gestureRecognizers.count == 0) {
                NSLog(@"给话题图片添加单击手势！");
                [cell.topicImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(topicImgClick:)]];
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
                [self asyncConnectGetMyTopicList];
            });
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tableView fd_heightForCellWithIdentifier:topicCellIdentifier cacheByIndexPath:indexPath configuration:^(LXForumCell *cell) {
        
        // 在这个block中，重新cell配置数据源
        [self setupModelOfCell:cell atIndexPath:indexPath];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
    return view;
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

-(void)asyncConnectGetMyTopicList{
    [self showHUD:@"正在加载..." anim:YES];
    LXMyTopicRequest * request = [[LXMyTopicRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识
    
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:@(self.pageNum * self.amountPerPage) forKey:@"offset"];
    [paraDic setObject:@(self.amountPerPage) forKey:@"num"];
    [request setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

@end
