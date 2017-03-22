//
//  LXBasePageViewController.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/11/15.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXBasePageViewController.h"
#import "VertifyInputFormat.h"

#import "MJRefresh.h"

@interface LXBasePageViewController ()

@end

@implementation LXBasePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initProperties];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化

- (void)initProperties
{
    self.pageNum = 0;
    self.amountPerPage = 20;
}

#pragma mark - 放置页面元素

- (void)putElements
{
}

- (void)refreshTableView
{
    
}

#pragma mark - 网络请求及相应的回调方法

// 网络请求回调
-(void)requestResult:(NSError*) error withData:(id)responseObject responseData:(LXBaseRequest*)requestData
{
    if (requestData.tag == 1000) {
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

                [self putElements];
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
                        [self.tableView beginUpdates];
                        // 后续数据插入显示
                        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                        [self.tableView endUpdates];
                        [UIView setAnimationsEnabled:YES];
                    });
                }
            }

            [self hideHUD:YES];

            return;
        } else {
            [self showError:@"获取列表内容失败" delay:2 anim:YES];
        }
    } else if (requestData.tag == 9999) {
        if (error) {
            //对error进行相应的处理
            NSLog(@"%@",[[error userInfo] objectForKey:@"NSLocalizedDescription"]);
            
            if (self.pageNum > 0) {
                self.pageNum --;
            }
            
            if ([self.tableView isHeaderRefreshing]) {
                [self.tableView headerEndRefreshing];
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
                
                [self refreshTableView];
                
                if ([self.tableView isHeaderRefreshing]) {
                    [self.tableView headerEndRefreshing];
                }
            }
            
            [self hideHUD:YES];
            
            return;
        } else {
            if ([self.tableView isHeaderRefreshing]) {
                [self.tableView headerEndRefreshing];
            }
            
            [self showError:@"获取列表内容失败" delay:2 anim:YES];
        }
    }

    return;
}

@end
