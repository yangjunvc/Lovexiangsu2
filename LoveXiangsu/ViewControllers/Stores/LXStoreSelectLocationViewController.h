//
//  LXStoreSelectLocationViewController.h
//  LoveXiangsu
//
//  Created by yangjun on 16/1/28.
//  Copyright (c) 2016年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseViewController.h"

@protocol LXStoreSelectLocationDelegate <NSObject>

@required

- (void)mapView:(MAMapView *)mapView didSelectLocation:(CLLocationCoordinate2D)coordinate;

@end

@interface LXStoreSelectLocationViewController : LXBaseViewController<MAMapViewDelegate>

@property (nonatomic, assign) CLLocationCoordinate2D storeCoordinate;

@property (nonatomic, weak) id<LXStoreSelectLocationDelegate> delegate;

@end
