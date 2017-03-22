//
//  LXStoreSelectLocationViewController.m
//  LoveXiangsu
//
//  Created by yangjun on 16/1/28.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXStoreSelectLocationViewController.h"

#import "LXUICommon.h"
#import "LXUserDefaultManager.h"

@interface LXStoreSelectLocationViewController ()

@property (nonatomic, strong) MAMapView * mapView;

@end

@implementation LXStoreSelectLocationViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self putNavigationBar];
    [self putMap];
    [self putLocationPoint];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.mapView setZoomLevel:16.5 animated:YES];
    if (CLLocationCoordinate2DIsValid(self.storeCoordinate)) {
        self.mapView.centerCoordinate = self.storeCoordinate;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.mapView.delegate = nil;
    self.mapView = nil;
}

#pragma mark - Navigation Bar

- (void)putNavigationBar
{
    [self.lxLeftBtnImg addTarget:self action:@selector(lxLeftBtnImgClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxLeftBtnImg.layer.borderWidth = 1;
    //    self.lxLeftBtnImg.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxTitleLabel setTitle:@"地图定位" forState:UIControlStateNormal];
    //    self.lxTitleLabel.layer.borderWidth = 1;
    //    self.lxTitleLabel.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    [self.lxRightBtnTitle setTitle:@"确定" forState:UIControlStateNormal];
    self.lxRightBtnTitle.titleLabel.font = LX_TEXTSIZE_20;
    [self.lxRightBtnTitle addTarget:self action:@selector(lxFinishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.lxRightBtn2Img.layer.borderWidth = 1;
    //    self.lxRightBtn2Img.layer.borderColor = [[UIColor colorWithRed:123.0/255.0 green:212.0/255.0 blue:254.0/255.0 alpha:1.0] CGColor];
    
    self.navigationController.navigationBar.translucent = NO;
    // 30 127 241
    self.navigationController.navigationBar.barTintColor = LX_PRIMARY_COLOR;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxLeftBtnImg];
    self.navigationItem.titleView = self.lxTitleLabel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.lxRightBtnTitle];
}

#pragma mark - MAMap

- (void)putMap
{
    self.mapView = [[MAMapView alloc]init];

    if (CLLocationCoordinate2DIsValid(self.storeCoordinate)) {
        self.mapView.centerCoordinate = self.storeCoordinate;
        self.mapView.userTrackingMode = MAUserTrackingModeNone;
        self.mapView.delegate = nil;
    } else {
        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
        self.mapView.delegate = self;
        self.mapView.hidden = YES;
    }

    [self.view addSubview:self.mapView];
    [self.mapView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(0);
    }];
}

- (void)putLocationPoint
{
    UIImageView * imgView = [[UIImageView alloc]init];
    imgView.layer.borderColor = LX_DEBUG_COLOR;
    imgView.layer.borderWidth = 1;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = [UIImage imageNamed:@"map_location"];
    [self.view addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.mapView.center);
        make.width.equalTo(MARGIN * 2 + PADDING);
    }];
}

#pragma mark - Button Event

- (void)lxLeftBtnImgClick:(id)sender{
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"vc = %@", vc);
    if (vc == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)lxFinishBtnClick:(id)sender{
    NSLog(@"确定按钮 Clicked");
    NSLog(@"longitude: %.6f, latitude: %.6f", self.mapView.centerCoordinate.longitude, self.mapView.centerCoordinate.latitude);
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didSelectLocation:)]) {
        [self.delegate mapView:self.mapView didSelectLocation:self.mapView.centerCoordinate];
    }
    [self lxLeftBtnImgClick:nil];
}

#pragma mark - MAMap Delegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    NSLog(@"高德地图定位信息更新啦~~~~");
    mapView.centerCoordinate = userLocation.location.coordinate;
    mapView.userTrackingMode = MAUserTrackingModeNone;
    mapView.showsUserLocation = NO;
    mapView.delegate = nil;
    mapView.hidden = NO;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
