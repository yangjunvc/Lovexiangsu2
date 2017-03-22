//
//  KMDatePickerDateModel.h
//  KMDatePicker
//
//  Created by KenmuHuang on 15/10/6.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMDatePickerDateModel : NSObject
@property (copy, nonatomic) NSString *year;
@property (copy, nonatomic) NSString *month;
@property (copy, nonatomic) NSString *day;
@property (copy, nonatomic) NSString *hour;
@property (copy, nonatomic) NSString *minute;
// new appended by Wolfgang
@property (copy, nonatomic) NSString *second;

@property (copy, nonatomic) NSString *weekdayName;

- (instancetype)initWithDate:(NSDate *)date;

@end
