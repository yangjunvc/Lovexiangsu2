//
//  LXShowTopicDetailViewController.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/28.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXShowTopicDetailViewController.h"
#import "LXForumTopicDetailView.h"
#import "LXGetTopicDetailRequest.h"
#import "LXGetTopicDetailResponseModel.h"
#import "LXGetTopicImageResponseModel.h"
#import "LXForumTopicReplyCell.h"
#import "LXGetTopicReplyResponseModel.h"
#import "LXGetTopicReplyListRequest.h"
#import "LXTopicFavourToReplyRequest.h"
#import "LXTopicReplyToTopicRequest.h"
#import "LXForumModifyTopicViewController.h"
#import "LXSubmitReportViewController.h"

#import "LXNotificationCenterString.h"
#import "LXNetManager.h"
#import "VertifyInputFormat.h"
#import "LXUICommon.h"
#import "UIImageView+WebCache.h"
#import "Utils.h"
#import "UIImageView+WebCache.h"
#import "LXUserDefaultManager.h"
#import "PhotoBroswerVC.h"

#import "ConvertToCommonEmoticonsHelper.h"
#import "LXMessageToolBar.h"
#import "UITableView+FDTemplateLayoutCell.h"

static NSString *replyCellIdentifier = @"ReplyCell";

@interface LXShowTopicDetailViewController ()<LXMessageToolBarDelegate>
{
    CGPoint historyOffset;
}

@property (strong, nonatomic) LXForumTopicDetailView * detailView;

//@property (strong, nonatomic) UIView   * emptyView;

@property (strong, nonatomic) NSString * userId;
@property (strong, nonatomic) NSString * topicTitle;
@property (strong, nonatomic) NSString * headURL;
@property (strong, nonatomic) NSString * nickname;
@property (strong, nonatomic) NSString * updatetime;
@property (strong, nonatomic) NSString * topicContent;
@property (strong, nonatomic) NSArray  * imageArray;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) NSMutableArray  * tableArray;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger amountPerPage;

@end

@implementation LXShowTopicDetailViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    historyOffset = CGPointZero;
    [self putNavigationBar];
    [self initProperties];
    [self putScrollView];
//    [self putDetailView];
    [self putChatToolBar];
    [self asyncConnectGetTopicReplyList];

    [self registerNotification];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];

//    [self asyncConnectGetTopicDetail];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGSize size = [self.detailView.tableView sizeThatFits:CGSizeMake(ScreenWidth, 1000000)];
    NSLog(@"TableView高度：%f", size.height);
    if (size.height > 0.0) {
        [self.detailView.tableView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(size.height);
        }];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshContentSize];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.scrollView.delegate = nil;
    self.scrollView = nil;

    [self removeNotification];
}

- (void)refreshContentSize
{
    UIView * view = self.detailView.subviews[self.detailView.subviews.count - 1];
    CGFloat height = CGRectGetMaxY(view.frame);
    NSLog(@"视图最大高度：%f", height);
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, height + 64);
    self.detailView.frame = CGRectMake(0, 0, ScreenWidth, height);
}

#pragma mark - 初始化

- (void)initProperties
{
    self.pageNum = 0;
    self.amountPerPage = 20;
}

#pragma mark - Notification

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDetailView) name:k_Noti_refreshTopicDetail object:nil];
}

#pragma mark - Clean Work

- (void)removeAllSubviews:(UIView *)view
{
    for (UIView * subview in view.subviews) {
        [subview removeFromSuperview];
    }
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_Noti_refreshTopicDetail object:nil];
}

#pragma mark - 刷新页面

- (void)refreshDetailView
{
    historyOffset = self.scrollView.contentOffset;
    [self removeAllSubviews:self.scrollView];
    [self initProperties];
//    [self putDetailView];
    [self asyncConnectGetTopicReplyList];
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxTitleLabel setTitle:@"帖子详情" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];

//    self.emptyView = [[UIView alloc]init];
//    self.emptyView.frame = CGRectMake(14, 7, 30, 30);

    [self.lxRightBtnTitle setTitle:@"举报" forState:UIControlStateNormal];
    self.lxRightBtnTitle.titleLabel.font = LX_TEXTSIZE_16;
    [self.lxRightBtnTitle addTarget:self action:@selector(lxReportBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationController.navigationBar.translucent = NO;
    // 30 127 241
    self.navigationController.navigationBar.barTintColor = LX_PRIMARY_COLOR;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxLeftBtnImg];
    self.navigationItem.titleView = self.lxTitleLabel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxRightBtnTitle];
}

- (void)putNavBarRightButton
{
    [self.lxRightBtn2Img setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [self.lxRightBtn2Img setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.lxRightBtn2Img addTarget:self action:@selector(modifyTopicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxRightBtn2Img.layer.borderWidth = 1;
    //    self.lxRightBtn2Img.layer.borderColor = LX_DEBUG_COLOR;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxRightBtn2Img];
}

#pragma mark - UIScrollView

- (void)putScrollView
{
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - (kVerticalPadding * 2 + kInputTextViewMinHeight))];
    } else {
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    }
    self.scrollView.backgroundColor = LX_BACKGROUND_COLOR;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"视图开始滚动！！！");
    [self refreshContentSize];
}

#pragma mark - Element of Page

//- (void)putDetailView
//{
//    self.detailView = [[LXForumTopicDetailView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
//    self.detailView.tableView.delegate = self;
//    self.detailView.tableView.dataSource = self;
//    self.detailView.layer.borderColor = LX_DEBUG_COLOR;
//    self.detailView.layer.borderWidth = 1;
//}

- (void)putElements
{
    [self.view setBackgroundColor:LX_BACKGROUND_COLOR];

    typeof(self) selfVC = self;

    self.detailView = [[LXForumTopicDetailView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) andImageNumber:self.imageArray.count];
    self.detailView.tableView.delegate = self;
    self.detailView.tableView.dataSource = self;
    self.detailView.layer.borderColor = LX_DEBUG_COLOR;
    self.detailView.layer.borderWidth = 1;

    // 帖子标题
    [self.detailView.titleLabel setText:self.topicTitle];

    // 发帖人头像
    [self.detailView.headBtn sd_setImageWithURL:[NSURL URLWithString:self.headURL] placeholderImage:[UIImage imageNamed:@"main_menu_home_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"发帖人头像下载完成，并添加单击手势！");
        [self.detailView.headBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:selfVC action:@selector(ownerHeadClick:)]];
        self.detailView.headBtn.userInteractionEnabled = YES;
    }];

    // 发帖人昵称
    [self.detailView.nicknameLabel setText:self.nickname];

    // 发帖时间
    [self.detailView.updatetimeLabel setText:self.updatetime];

    // 帖子内容
    [self.detailView.contentLabel setText:self.topicContent];
    int numberOfLines = [Utils calcLabelRowNum:self.topicContent withFont:self.detailView.contentLabel.font withWidth:ScreenWidth - MARGIN * 2 numberOfLines:10000];
    self.detailView.contentLabel.numberOfLines = numberOfLines;

//    NSArray *imgViewArr = @[self.detailView.image1, self.detailView.image2,
//                            self.detailView.image3, self.detailView.image4,
//                            self.detailView.image5, self.detailView.image6,
//                            self.detailView.image7, self.detailView.image8,
//                            self.detailView.image9,
//                           ];
    NSArray *imgViewArr = self.detailView.imageviewArray;

    for (int i = 0; i < self.imageArray.count && i < imgViewArr.count; i++) {
        LXGetTopicImageResponseModel * imgModel = self.imageArray[i];
        UIView * superView = self.detailView;
        UIImageView * imgView = (UIImageView *)imgViewArr[i];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgModel.url] placeholderImage:[UIImage imageNamed:@"default_image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"第%d张图片下载完成~", (i+1));
            [imgView updateConstraints:^(MASConstraintMaker *make) {
                NSLog(@"图片%d大小：%f, %f", (i+1), imgView.image.size.width, imgView.image.size.height);
                CGFloat height = (ScreenWidth - MARGIN * 2) / (imgView.image.size.width / imgView.image.size.height);
                NSLog(@"计算后高度：%f", height);
                make.height.equalTo(height);
            }];
            [self.view setNeedsLayout];
            [superView setNeedsLayout];
            [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:selfVC action:@selector(touchImage:)]];
            imgView.userInteractionEnabled = YES;
        }];
    }

    [self.scrollView addSubview:self.detailView];
    [self.view setNeedsLayout];

    [self.scrollView setContentOffset:historyOffset animated:NO];

    // 如果是发帖的用户本人，则显示编辑帖子按钮
    if ([[LXUserDefaultManager getUserID] isEqualToString:self.userId]) {
        [self putNavBarRightButton];
    }
}

- (void)putChatToolBar
{
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        [self.view addSubview:self.chatToolBar];
    }
}

- (LXMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
        _chatToolBar = [[LXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [LXMessageToolBar defaultHeight], self.view.frame.size.width, [LXMessageToolBar defaultHeight])];
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
    }
    
    return _chatToolBar;
}

#pragma mark - LXMessageToolBarDelegate

- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
    NSLog(@"inputTextViewWillBeginEditing被调用！");
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    NSLog(@"didChangeFrameToHeight被调用！");
}

- (void)didSendText:(NSString *)text
{
    NSLog(@"didSendText被调用！发送内容：%@", text);
    if ([VertifyInputFormat isEmpty:text]) {
        [self showError:@"空内容不能发送" delay:2 anim:YES];
    } else {
        NSString * sendText = [ConvertToCommonEmoticonsHelper convertToCommonEmoticons:text];
        [self asyncConnectReplyToTopicId:sendText];
    }
}

#pragma mark - UITableView

- (void)putTableView
{
    if (self.detailView && self.detailView.tableView) {
        [self.detailView.tableView reloadData];
    }
}

#pragma mark - Button Event

// 点击背景隐藏
- (void)keyBoardHidden
{
    [self.chatToolBar endEditing:YES];
}

- (void)lxLeftBtnImgClick:(id)sender{
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_comebackToForumList object:nil];

    NSArray *arr = [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"arr = %@", arr);
    if (arr == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)favourBtnClick:(id)sender{
    NSLog(@"对回复点赞！");
    UIButton *favourBtn = (UIButton *)sender;
    NSUInteger index = favourBtn.tag;
    NSLog(@"回复人头像所在Cell的index = %lu", (unsigned long)index);
    LXGetTopicReplyResponseModel *model = self.tableArray[index];
    NSString *replyId = model.id;
    LXForumTopicReplyCell * cell = (LXForumTopicReplyCell *)[self.detailView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if ([model.my_favour isEqualToString:@"0"]) {
        [favourBtn setImage:[UIImage imageNamed:@"yes_on"] forState:UIControlStateNormal];
        [self asyncConnectFavourToReplyId:replyId op:@"true"];
        model.favour = [@([model.favour intValue] + 1) stringValue];
        cell.favourCountLabel.text = [NSString stringWithFormat:@"%@次", model.favour];
        model.my_favour = @"1";
    } else if ([model.my_favour isEqualToString:@"1"]) {
        [favourBtn setImage:[UIImage imageNamed:@"yes_off"] forState:UIControlStateNormal];
        [self asyncConnectFavourToReplyId:replyId op:@"false"];
        model.favour = [@([model.favour intValue] - 1) stringValue];
        cell.favourCountLabel.text = [NSString stringWithFormat:@"%@次", model.favour];
        model.my_favour = @"0";
    }
}

-(void)touchImage:(UITapGestureRecognizer *)tap{
    NSUInteger index = tap.view.tag;

    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeModal index:index photoModelBlock:^NSArray *{
//        NSArray *imgViewArr = @[self.detailView.image1, self.detailView.image2,
//                                self.detailView.image3, self.detailView.image4,
//                                self.detailView.image5, self.detailView.image6,
//                                self.detailView.image7, self.detailView.image8,
//                                self.detailView.image9,
//                                ];
        NSArray *imgViewArr = self.detailView.imageviewArray;

        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:self.imageArray.count];
        for (NSUInteger i = 0; i < self.imageArray.count; i++) {
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            LXGetTopicImageResponseModel * imgModel = self.imageArray[i];
            pbModel.image_HD_U = imgModel.url;

            //源frame
            UIImageView *imageV =(UIImageView *) imgViewArr[i];
            pbModel.sourceImageView = imageV;

            [modelsM addObject:pbModel];
        }

        return modelsM;
    }];
}

- (void)replierHeadClick:(UITapGestureRecognizer *)tap{
    NSLog(@"回复人头像被点击！");
    NSUInteger index = tap.view.tag;
    NSLog(@"回复人头像所在Cell的index = %lu", (unsigned long)index);
    LXGetTopicReplyResponseModel *model = self.tableArray[index];
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeModal index:0 photoModelBlock:^NSArray *{
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:1];
        for (NSUInteger i = 0; i < 1; i++) {
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.image_HD_U = model.icon_url;
            
            //源frame
            pbModel.sourceImageView = (UIImageView *)tap.view;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
}

- (void)ownerHeadClick:(UITapGestureRecognizer *)tap{
    NSLog(@"发帖人头像被点击！");
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeModal index:0 photoModelBlock:^NSArray *{
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:1];
        for (NSUInteger i = 0; i < 1; i++) {
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.image_HD_U = self.headURL;
            
            //源frame
            pbModel.sourceImageView = self.detailView.headBtn;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
}

- (void)modifyTopicBtnClick:(id)sender{
    NSLog(@"修改帖子按钮 Clicked");
    dispatch_async(dispatch_get_main_queue(), ^{
        LXForumModifyTopicViewController * vc = [[LXForumModifyTopicViewController alloc]init];
        vc.topicId = self.topicId;
        vc.topicTitleStr = self.topicTitle;
        vc.topicContentStr = self.topicContent;
        vc.imageArray = self.imageArray;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        nav.navigationBarHidden = NO;
        [self presentViewController:nav animated:YES completion:nil];
    });
}

- (void)lxReportBtnClick:(id)sender{
    NSLog(@"举报帖子按钮 Clicked");
    dispatch_async(dispatch_get_main_queue(), ^{
        LXSubmitReportViewController * vc = [[LXSubmitReportViewController alloc]init];
        vc.topicId = self.topicId;
        [self.navigationController pushViewController:vc animated:YES];
    });
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
    LXForumTopicReplyCell * cell = [tableView dequeueReusableCellWithIdentifier:replyCellIdentifier];

    [self setupModelOfCell:cell atIndexPath:indexPath];

    return cell;
}

- (void) setupModelOfCell:(LXForumTopicReplyCell *) cell atIndexPath:(NSIndexPath *) indexPath {
    
    // 采用计算frame模式还是自动布局模式，默认为NO，自动布局模式
    //    cell.fd_enforceFrameLayout = NO;

    [cell setBackgroundColor:LX_BACKGROUND_COLOR];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@"ScreenWidth = %f", ScreenWidth);
    NSLog(@"CellHeight = %f", CGRectGetHeight(cell.frame));
    [cell.contentView setFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(cell.frame))];

    LXGetTopicReplyResponseModel *model = self.tableArray[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    __weak LXForumTopicReplyCell * weakCell = cell;
    // 回复人头像
    cell.headBtn.userInteractionEnabled = YES;
    [cell.headBtn sd_setImageWithURL:[NSURL URLWithString:model.icon_url] placeholderImage:[UIImage imageNamed:@"main_menu_home_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakCell.headBtn.layer.cornerRadius = CGRectGetWidth(weakCell.headBtn.frame)/2.0;
            weakCell.headBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            weakCell.headBtn.layer.borderWidth = 1;
            weakCell.headBtn.clipsToBounds = YES;
        });
        weakCell.headBtn.tag = indexPath.row;
        if (weakCell.headBtn.gestureRecognizers == nil || weakCell.headBtn.gestureRecognizers.count == 0) {
            NSLog(@"给回复人头像添加单击手势！");
            [weakCell.headBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(replierHeadClick:)]];
        } else {
            NSLog(@"回复人头像已有单击手势！无需再次添加！");
        }
    }];
    
    cell.nicknameLabel.text = model.nickname;
    
    cell.floortimeLabel.text = [NSString stringWithFormat:@"%@楼  %@", model.order_id, model.created_at];
    
    cell.favourBtn.tag = indexPath.row;
    if ([model.my_favour isEqualToString:@"0"]) {
        [cell.favourBtn setImage:[UIImage imageNamed:@"yes_off"] forState:UIControlStateNormal];
        [cell.favourBtn addTarget:self action:@selector(favourBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    } else if ([model.my_favour isEqualToString:@"1"]) {
        [cell.favourBtn setImage:[UIImage imageNamed:@"yes_on"] forState:UIControlStateNormal];
        [cell.favourBtn addTarget:self action:@selector(favourBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.favourCountLabel.text = [NSString stringWithFormat:@"%@次", model.favour];
    
    // 表情映射。
    NSString *didReceiveText = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:model.content];
    cell.contentLabel.text = didReceiveText;
    int numberOfLines = [Utils calcLabelRowNum:model.content withFont:cell.contentLabel.font withWidth:ScreenWidth - MARGIN * 2 numberOfLines:10000];
    cell.contentLabel.numberOfLines = numberOfLines;
    
    cell.reply_id = model.id;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"ScrollView滚动结束！");
    UITableView *tableview = self.detailView.tableView;
    CGRect target = [tableview convertRect:self.view.bounds fromView:self.view];
    NSArray *visibleRows = [tableview indexPathsForRowsInRect:target];
    for (NSIndexPath *indexPath in visibleRows) {
        if ((indexPath.row + 1 == self.tableArray.count) &&
            (self.tableArray.count == (self.pageNum + 1) * self.amountPerPage)) {
            self.pageNum ++;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self asyncConnectGetTopicReplyList];
            });
        }
    }
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // 回复Cell区高度
//    CGFloat height = MARGIN * 2 + HeadBigBtnSize + MARGIN * 5 + PADDING * 2;
//    return height;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (IOS8_OR_LATER) {
//        return UITableViewAutomaticDimension;
//    }
//    
//    // 回复Cell区高度
//    CGFloat height = MARGIN * 2 + HeadBigBtnSize + MARGIN * 5 + PADDING * 2;
//    return height;
    return [tableView fd_heightForCellWithIdentifier:replyCellIdentifier cacheByIndexPath:indexPath configuration:^(LXForumTopicReplyCell *cell) {
        
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
    NSLog(@"点击了一个回复Cell");
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

-(void)asyncConnectGetTopicDetail{
    LXGetTopicDetailRequest * request = [[LXGetTopicDetailRequest alloc]init];//初始化网络请求
    
    request.requestMethod = LXRequestMethodGet;
    request.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    request.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是HTTP类型响应
    request.delegate = self;//代理设置
    request.tag = 1002;//类型标识
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.topicId forKey:@"topic_id"];
    [request setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

-(void)asyncConnectGetTopicReplyList{
    [self showHUD:@"正在加载..." anim:YES];
    LXGetTopicReplyListRequest * request = [[LXGetTopicReplyListRequest alloc]init];//初始化网络请求

    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识

    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }

    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.topicId forKey:@"topic_id"];
    [paraDic setObject:@(self.pageNum * self.amountPerPage) forKey:@"offset"];
    [paraDic setObject:@(self.amountPerPage) forKey:@"num"];
    [paraDic setObject:@(0) forKey:@"order_type"];
    [request setCustomRequestParams:paraDic];//设置入参

    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

-(void)asyncConnectFavourToReplyId:(NSString *)replyId op:(NSString *)op{
    if ([VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        [self showTips:@"请先登录" delay:2 anim:YES];
        return;
    }
    LXTopicFavourToReplyRequest * request = [[LXTopicFavourToReplyRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1001;//类型标识
    
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:replyId forKey:@"reply_id"];
    [paraDic setObject:op forKey:@"op"];
    [request setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

-(void)asyncConnectReplyToTopicId:(NSString *)content{
    LXTopicReplyToTopicRequest * request = [[LXTopicReplyToTopicRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1003;//类型标识
    
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.topicId forKey:@"topic_id"];
    [paraDic setObject:content forKey:@"content"];
    [request setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

// 网络请求回调
-(void)requestResult:(NSError*) error withData:(id)responseObject responseData:(LXBaseRequest*)requestData
{
    if (requestData.tag == 1002) {
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
        LXGetTopicDetailResponseModel * model = nil;
        if ([responseObject isKindOfClass:[LXGetTopicDetailResponseModel class]]) {
            model = (LXGetTopicDetailResponseModel *)responseObject;
            self.userId = model.user_id;
            self.topicTitle = model.title;
            self.headURL = model.icon_url;
            self.nickname = model.nickname;
            self.updatetime = model.created_at;
            self.topicContent = model.content;
            self.imageArray = model.images;

//            [self asyncConnectGetTopicReplyList];
            [self putElements];

            [self hideHUD:YES];
            
            return;
        } else {
            [self showError:@"获取帖子详情失败" delay:2 anim:YES];
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
            [self showError:@"糟糕~对回复（取消）点赞失败啦" delay:2 anim:YES];
        }
    } else if (requestData.tag == 1003) {
        if (error) {
            //对error进行相应的处理
            NSLog(@"%@",[[error userInfo] objectForKey:@"NSLocalizedDescription"]);
            
            [self showError:[[error userInfo] objectForKey:@"NSLocalizedDescription"] delay:2 anim:YES];
            return;
        }
        
        // 成功时有时也会有成功Message
        if (![VertifyInputFormat isEmpty:requestData.successMsg]) {
            NSString * tip = @"回复成功~";
            [self showSuccess:tip delay:2 anim:YES];
        } else {
            [self showError:@"糟糕~对帖子的回复失败啦" delay:2 anim:YES];
        }

        // 刷新详情
        [self performSelector:@selector(refreshDetailView) withObject:nil afterDelay:2.0];
    } else if (requestData.tag == 1000) {
        if (error) {
            //对error进行相应的处理
            NSLog(@"%@",[[error userInfo] objectForKey:@"NSLocalizedDescription"]);
            
            if (self.pageNum > 0) {
                self.pageNum --;
            }
            
            [self showError:[[error userInfo] objectForKey:@"NSLocalizedDescription"] delay:2 anim:YES];
            return;
        }
        
        // 成功时有时也会有成功Message
        if (![VertifyInputFormat isEmpty:requestData.successMsg]) {
            [self showSuccess:requestData.successMsg delay:2 anim:YES];
        }
        
        // 将返回的数据进行model转换（注意：要加上对model类型的校验）
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (self.pageNum == 0) {
                // 第一页，则直接替换原来数组，重新刷新TableView显示最新数据
                self.tableArray = responseObject;
                
                [self putTableView];
                [self asyncConnectGetTopicDetail];

                return;
            } else if (self.pageNum > 0) {
                // 第二页往后
                // 后续数据
                NSArray *newArray = (NSArray *)responseObject;
                if (newArray.count == 0) {
                    if (self.pageNum > 0) self.pageNum --;
                    // 没有后续数据，则不做任何处理
                    return;
                } else {
                    // 有后续数据，则后续数据需要追加到原来数组的尾部，然后追加显示后续数据
                    NSUInteger oldCount = self.tableArray.count;
                    [self.tableArray addObjectsFromArray:newArray];
                    
                    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:newArray.count];
                    [newArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(oldCount + idx) inSection:0];
                        [indexPaths addObject:indexPath];
                    }];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView setAnimationsEnabled:NO];
                        [self.detailView.tableView beginUpdates];
                        // 后续数据插入显示
                        [self.detailView.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                        [self.detailView.tableView endUpdates];
                        [UIView setAnimationsEnabled:YES];

                        [self.view setNeedsLayout];
                    });
                }
            }
            
            [self hideHUD:YES];
            
            return;
        } else {
            [self showError:@"获取列表内容失败" delay:2 anim:YES];
        }
    }

    return;
}

@end
