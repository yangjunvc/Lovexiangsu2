//
//  LXStoreReplyCommentViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 16/3/4.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreReplyCommentViewController.h"
#import "LXStoreReplyCommentView.h"
#import "LXStoreReplyCommentRequest.h"

#import "LXUICommon.h"
#import "LXNetManager.h"
#import "VertifyInputFormat.h"
#import "LXUserDefaultManager.h"
#import "LXNotificationCenterString.h"

#import "NSString+Custom.h"
#import "SZTextView.h"
#import "Utils.h"
#import "UILabel+VerticalAlign.h"

@interface LXStoreReplyCommentViewController ()

@property (nonatomic, strong) UIScrollView            * scrollView;
@property (nonatomic, strong) LXStoreReplyCommentView * replyView;

@property (nonatomic)         CGPoint                   oldContentOffset;

@end

@implementation LXStoreReplyCommentViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self putNavigationBar];
    [self putScrollView];
    [self putElements];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
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
}

- (void)refreshContentSize
{
    self.replyView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(self.replyView.replyContent.frame) + MARGIN);
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(self.replyView.frame));
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxTitleLabel setTitle:@"答复评论" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];

    [self.lxRightBtnTitle setTitle:@"答复" forState:UIControlStateNormal];
    self.lxRightBtnTitle.titleLabel.font = LX_TEXTSIZE_20;
    [self.lxRightBtnTitle addTarget:self action:@selector(lxReplyCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxRightBtn2Img.layer.borderWidth = 1;
    //    self.lxRightBtn2Img.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    self.navigationController.navigationBar.translucent = NO;
    // 30 127 241
    self.navigationController.navigationBar.barTintColor = LX_PRIMARY_COLOR;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxLeftBtnImg];
    self.navigationItem.titleView = self.lxTitleLabel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxRightBtnTitle];
}

- (void)putScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    self.scrollView.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    [self.view addSubview:self.scrollView];
}

#pragma mark - Element of Page

- (void)putElements
{
    [self.view setBackgroundColor:[UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0]];
    self.replyView = [[LXStoreReplyCommentView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];

    self.replyView.nicknameLabel.text = [NSString stringWithFormat:@"%@：", self.nickname];
    CGFloat nicknameWidth = [self.replyView.nicknameLabel getFittingWidth];
    [self.replyView.nicknameLabel updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(nicknameWidth);
    }];

//    self.replyView.commentLabel.text = self.comment;
    __weak typeof(self) weakSelf = self;
    [self.replyView.commentLabel setText:self.comment afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)weakSelf.replyView.commentLabel.font.fontName,
                                                weakSelf.replyView.commentLabel.font.pointSize,
                                                NULL);
        if (ctFont) {
            NSRange strRange = NSMakeRange(0, [mutableAttributedString length]);
            [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:strRange];
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)ctFont range:strRange];
            CFRelease(ctFont);
        }
        return mutableAttributedString;
    }];

    CGSize size = [Utils calcLabelHeight:self.replyView.commentLabel.text withFont:self.replyView.commentLabel.font withWidth:ScreenWidth - MARGIN * 2 - nicknameWidth];
    [self.replyView.commentLabel updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(size.width);
        make.height.equalTo(size.height + 2);
    }];

    self.replyView.createdatLabel.text = self.createdat;

    self.replyView.replyContent.delegate = self;

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleClick:)];
    [self.replyView addGestureRecognizer:tap];
    [self.scrollView addGestureRecognizer:tap];
    
    self.replyView.layer.borderColor = LX_DEBUG_COLOR;
    self.replyView.layer.borderWidth = 1;
    [self.scrollView addSubview:self.replyView];
}

#pragma mark - UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.oldContentOffset = self.scrollView.contentOffset;

    CGFloat maxY = CGRectGetMaxY(self.replyView.replyContent.frame);
    CGFloat halfHeight = (ScreenHeight / 2) + 50;
    if (maxY > halfHeight) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             self.scrollView.contentOffset = CGPointMake(0, CGRectGetMaxY(self.replyView.createdatLabel.frame));
                         }];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.scrollView.contentOffset = self.oldContentOffset;
                     }];
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    [self.view endEditing:YES];

    NSArray *arr = [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"arr = %@", arr);
    if (arr == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)lxReplyCommentBtnClick:(id)sender{
    NSLog(@"答复按钮 Clicked");
    [self asyncConnectStoreReplyComment];
}

- (void)singleClick:(UITapGestureRecognizer * )recognizer
{
    [self.view endEditing:YES];
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

-(void)asyncConnectStoreReplyComment{
    [self showHUD:@"正在提交..." anim:YES];
    LXStoreReplyCommentRequest * request = [[LXStoreReplyCommentRequest alloc]init];//初始化网络请求

    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识

    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }

    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.comment_id forKey:@"comment_id"];
    [paraDic setObject:self.replyView.replyContent.text forKey:@"reply"];
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

        [self performSelector:@selector(sendNotification) withObject:nil afterDelay:2.0];
    }
    
    return;
}

- (void)sendNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:k_Noti_refreshCommentList object:nil userInfo:nil];
    [self lxLeftBtnImgClick:nil];
}

@end
