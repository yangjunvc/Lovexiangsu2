//
//  LXStoreFixInfosViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 16/1/7.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreFixInfosViewController.h"
#import "LXNotificationCenterString.h"
#import "LXUICommon.h"
#import "LXUserDefaultManager.h"
#import "LXNetManager.h"
#import "LXStoreInfoFixView.h"
#import "LXStoreGetInfoRequest.h"
#import "LXStoreFixInfoRequest.h"
#import "LXStoreInfoResponseModel.h"
#import "LXStoreApplyRemoveViewController.h"

#import "VertifyInputFormat.h"
#import "NSString+Custom.h"

@interface LXStoreFixInfosViewController ()
{
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
    CGPoint _previousTextViewContentOffset;//上一次inputTextView的contentOffset
}

@property (nonatomic, strong) UILabel * tip;

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) LXStoreInfoFixView * infoView;

@end

@implementation LXStoreFixInfosViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self putNavigationBar];
    [self putScrollView];
    [self putElements];
    [self asyncConnectStoreGetInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.infoView.storeName becomeFirstResponder];

    // KVO 检查contentSize
    [self.infoView.storeDescription addObserver:self
                                          forKeyPath:@"contentSize"
                                             options:NSKeyValueObservingOptionNew
                                             context:nil];
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
    [self.infoView.storeDescription removeObserver:self forKeyPath:@"contentSize"];
}

- (void)refreshContentSize
{
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 64 + 1);
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxTitleLabel setTitle:@"商家信息纠错" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxRightBtnTitle setTitle:@"申请修改" forState:UIControlStateNormal];
    self.lxRightBtnTitle.frame = CGRectMake(0, 7, 80, 30);
    self.lxRightBtnTitle.titleLabel.font = LX_TEXTSIZE_16;
    [self.lxRightBtnTitle addTarget:self action:@selector(lxFixInfosBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.lxRightBtnTitle.layer.borderWidth = 1;
    self.lxRightBtnTitle.layer.borderColor = LX_DEBUG_COLOR;
    
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

    self.infoView = [[LXStoreInfoFixView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];

    self.infoView.storeName.delegate = self;
    [self.infoView.storeName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.infoView.storeName.returnKeyType = UIReturnKeyNext;

    self.infoView.storeAddress.delegate = self;
    [self.infoView.storeAddress addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.infoView.storeAddress.returnKeyType = UIReturnKeyNext;

    self.infoView.storePhone1.delegate = self;
    [self.infoView.storePhone1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.infoView.storePhone1.returnKeyType = UIReturnKeyNext;

    self.infoView.storePhone2.delegate = self;
    [self.infoView.storePhone2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.infoView.storePhone2.returnKeyType = UIReturnKeyNext;

    self.infoView.storeDescription.delegate = self;
    _previousTextViewContentHeight = [self getTextViewContentH:self.infoView.storeDescription];

    [self.infoView.closeStore addTarget:self action:@selector(closeStoreClick:) forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleClick:)];
    [self.infoView addGestureRecognizer:tap];

    self.infoView.layer.borderColor = LX_DEBUG_COLOR;
    self.infoView.layer.borderWidth = 1;
    [self.scrollView addSubview:self.infoView];
}

#pragma mark - UITextField Delegate

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 32) {
        textField.text = [textField.text substringToIndex:32];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.infoView.storeName) {
        [self.infoView.storeAddress becomeFirstResponder];
    } else if (textField == self.infoView.storeAddress)
    {
        [self.infoView.storePhone1 becomeFirstResponder];
    } else if (textField == self.infoView.storePhone1)
    {
        [self.infoView.storePhone2 becomeFirstResponder];
    } else if (textField == self.infoView.storePhone2)
    {
        [self.infoView.storeDescription becomeFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - UITextView Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 32 && textView.markedTextRange == nil) {
        textView.text = [textView.text substringToIndex:32];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (!_previousTextViewContentHeight) {
        _previousTextViewContentHeight = [self getTextViewContentH:textView];
    }

    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.scrollView.contentOffset = CGPointMake(0, CGRectGetMaxY(self.infoView.storePhone2.frame));
                     }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.scrollView.contentOffset = CGPointMake(0, 0);
                     }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length > 32 && text.length > range.length) {
        return NO;
    }
    
    return YES;
}

- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    if (IOS7_OR_LATER)
    {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - Message input view

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight {
    // 动态改变自身的高度和输入框的高度
    CGRect prevFrame = self.infoView.storeDescription.frame;
    
    NSUInteger nolText = [self.infoView.storeDescription numberOfLinesOfText];
    NSInteger nol = [self.infoView.storeDescription.text numberOfLines];
    NSUInteger numLines = MAX(nolText, nol);
    
    self.infoView.storeDescription.frame = CGRectMake(prevFrame.origin.x,
                                          prevFrame.origin.y,
                                          prevFrame.size.width,
                                          prevFrame.size.height + changeInHeight);

    CGRect btnFrame = self.infoView.closeStore.frame;
    self.infoView.closeStore.frame = CGRectMake(btnFrame.origin.x,
                                                btnFrame.origin.y + changeInHeight,
                                                btnFrame.size.width,
                                                btnFrame.size.height);

    CGRect tipFrame = self.infoView.tipLabel.frame;
    self.infoView.tipLabel.frame = CGRectMake(tipFrame.origin.x,
                                                tipFrame.origin.y + changeInHeight,
                                                tipFrame.size.width,
                                                tipFrame.size.height);

//    self.infoView.storeDescription.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f : 0.0f),
//                                                       0.0f,
//                                                       (numLines >= 6 ? 4.0f : 0.0f),
//                                                       0.0f);
    self.infoView.storeDescription.contentInset = UIEdgeInsetsZero;
    
    // from iOS 7, the content size will be accurate only if the scrolling is enabled.
    self.infoView.storeDescription.scrollEnabled = YES;

    if (numLines >= 8) {
//        NSLog(@"contentSize.height: %f", self.infoView.storeDescription.contentSize.height);
//        NSLog(@"bounds.size.height: %f", self.infoView.storeDescription.bounds.size.height);
        CGPoint bottomOffset = CGPointMake(0.0f, (self.infoView.storeDescription.contentSize.height - self.infoView.storeDescription.bounds.size.height));
        [self.infoView.storeDescription setContentOffset:bottomOffset animated:YES];
        [self.infoView.storeDescription scrollRangeToVisible:NSMakeRange(self.infoView.storeDescription.text.length - 2, 1)];
    } else {
        [self.infoView.storeDescription setContentOffset:CGPointZero animated:YES];
    }
}

+ (CGFloat)textViewLineHeight {
    return 38.0f; // for fontSize 17.0f
}

+ (CGFloat)maxLines {
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 3.0f : 8.0f;
}

+ (CGFloat)maxHeight {
    return ([[self class] maxLines] + 1.0f) * [[self class] textViewLineHeight];
}

#pragma mark - Layout Message Input View Helper Method

- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView {
    CGFloat maxHeight = [[self class] maxHeight];
    
    CGFloat contentH = [self getTextViewContentH:textView];
    
    BOOL isShrinking = contentH < _previousTextViewContentHeight;
    CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
    
    if (!isShrinking && (_previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - _previousTextViewContentHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             if (isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     _previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self adjustTextViewHeightBy:changeInHeight];
                             }

                             if (!isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     _previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];

        _previousTextViewContentHeight = MIN(contentH, maxHeight);
        _previousTextViewContentOffset = self.infoView.storeDescription.contentOffset;
    } else {
        [self.infoView.storeDescription setContentOffset:_previousTextViewContentOffset animated:NO];
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (_previousTextViewContentHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

#pragma mark - Key-value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.infoView.storeDescription && [keyPath isEqualToString:@"contentSize"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self layoutAndAnimateMessageInputTextView:object];
        });
    }
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    NSArray *arr = [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"arr = %@", arr);
    if (arr == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)lxFixInfosBtnClick:(id)sender{
    NSLog(@"申请修改按钮 Clicked");

    [self asyncConnectStoreFixInfo];
}

- (void)singleClick:(UITapGestureRecognizer * )recognizer
{
    [self.view endEditing:YES];
}

- (void)closeStoreClick:(id)sender
{
    NSLog(@"申请下线按钮 Clicked");
    LXStoreApplyRemoveViewController * vc = [[LXStoreApplyRemoveViewController alloc]init];
    vc.store_id = self.store_id;
    [self.navigationController pushViewController:vc animated:YES];
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

-(void)asyncConnectStoreGetInfo{
    [self showHUD:@"正在加载..." anim:YES];
    LXStoreGetInfoRequest * request = [[LXStoreGetInfoRequest alloc]init];//初始化网络请求
    
    request.requestMethod = LXRequestMethodGet;
    request.requestSerializerType = LXRequestSerializerTypeHTTP;// 这里必须是HTTP类型请求
    request.responseSerializer = [AFJSONResponseSerializer serializer];// 这里必须是JSON类型响应
    request.delegate = self;//代理设置
    request.tag = 1001;//类型标识
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.store_id forKey:@"store_id"];
    [request setCustomRequestParams:paraDic];//设置入参
    
    [[LXNetManager sharedInstance] addRequest:request];//发送网络请求
}

-(void)asyncConnectStoreFixInfo{
    [self showHUD:@"正在提交..." anim:YES];
    LXStoreFixInfoRequest * request = [[LXStoreFixInfoRequest alloc]init];//初始化网络请求
    
    request.delegate = self;//代理设置
    request.tag = 1000;//类型标识
    
    if (![VertifyInputFormat isEmpty:[LXUserDefaultManager getUserNonce]]) {
        NSMutableDictionary * headDic = [NSMutableDictionary dictionary];//入参字典
        [headDic setObject:[LXUserDefaultManager getUserNonce] forKey:@"nonce"];
        [request setHeaderParam:headDic];//设置Header入参
    }
    
    NSMutableDictionary * paraDic = [NSMutableDictionary dictionary];//入参字典
    [paraDic setObject:self.store_id forKey:@"store_id"];
    [paraDic setObject:self.infoView.storeName.text forKey:@"name"];
    [paraDic setObject:self.infoView.storeDescription.text forKey:@"description"];
    [paraDic setObject:self.infoView.storeAddress.text forKey:@"address"];
    [paraDic setObject:self.infoView.storePhone1.text forKey:@"phone1"];
    [paraDic setObject:self.infoView.storePhone2.text forKey:@"phone2"];

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

        [self lxLeftBtnImgClick:nil];
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
        }
        
        // 将返回的数据进行model转换（注意：要加上对model类型的校验）
        LXStoreInfoResponseModel * model = nil;
        if ([responseObject isKindOfClass:[LXStoreInfoResponseModel class]]) {
            model = (LXStoreInfoResponseModel *)responseObject;
            self.infoView.storeName.text = model.name;
            self.infoView.storeAddress.text = model.address;
            self.infoView.storePhone1.text = model.phone1;
            self.infoView.storePhone2.text = model.phone2;
            NSString * desc = nil;
            if (model.description.length > 32) {
                desc = [model.description substringToIndex:32];
            } else {
                desc = model.description;
            }
            self.infoView.storeDescription.text = desc;

            [self hideHUD:YES];

            return;
        } else {
            [self showError:@"获取商家信息失败" delay:2 anim:YES];
        }
    }

    return;
}

@end
