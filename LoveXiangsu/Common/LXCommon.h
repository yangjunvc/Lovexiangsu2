//
//  LXCommon.h
//  LoveXiangsu
//
//  Created by yangjun on 15/10/18.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#ifndef LoveXiangsu_LXCommon_h
#define LoveXiangsu_LXCommon_h

/**
 * 键盘高度
 */
#define KeyBoard_Height (iPhone6Plus?(252+30):((iPhone6?(252):((iPhone5_5C_5S?(252):(216))))))

/**
 * 判断是不是IOS7以后系统
 */
#define IOS7_OR_LATER  ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

/**
 * 判断是不是IOS8以后系统
 */
#define IOS8_OR_LATER  ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )


/**
 * 判断手机是否为iphone5 iphone5c iphone5s
 */
#define iPhone5_5C_5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 * 判断手机是否为iphone4 iphone4s
 */
#define iPhone4_4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 * 判断手机是否为iphone6
 */
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 * 判断手机是否为iphone6Plus
 */
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


/**
 *  userinfo parameters
 */
#define USERINFO_USERNONCE                    @"UserNonce"

#define USERINFO_USER_UID                     @"UserUID"
#define USERINFO_USER_NICKNAME                @"UserNickname"
#define USERINFO_USER_EMAIL                   @"UserEmail"
#define USERINFO_USER_SEX                     @"UserSex"
#define USERINFO_USER_CITY                    @"UserCity"
#define USERINFO_USER_PROFESSION              @"UserProfession"
#define USERINFO_USER_IP                      @"UserIP"
#define USERINFO_USER_NAME                    @"UserName"
#define USERINFO_USER_PHONE                   @"UserPhone"
#define USERINFO_USER_BIRTHDAY                @"UserBirthday"
#define USERINFO_USER_ONLINE                  @"UserOnline"
#define USERINFO_USER_ICONURL                 @"UserIconUrl"
#define USERINFO_USER_ICONFULLURL             @"UserIconFullUrl"

#define LOCATIONINFO_LATITUDE                 @"Latitude"
#define LOCATIONINFO_LONGITUDE                @"Longitude"

// 电话号码正则
#define PhoneRegex  @"\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{7}|1+[3578]+\\d{9}|\\d{8}|\\d{7}|\\d{5}"

/**
 * 各个小区信息
 */
#if defined(LXTARGET_VERSION_XIANGSU)

// 1:爱像素
// 小区ID
#define COMMUNITY_ID                 1
// 小区ICON
#define COMMUNITY_ICON               @"aixiangsu"
// 小区APP名称
#define COMMUNITY_APPNAME            @"爱像素"
// 小区名称
#define COMMUNITY_NAME               @"北京像素"

#elif defined(LXTARGET_VERSION_AIYUE)

// 2:爱爱乐
// 小区ID
#define COMMUNITY_ID                 2
// 小区ICON
#define COMMUNITY_ICON               @"aiaiyue"
// 小区APP名称
#define COMMUNITY_APPNAME            @"爱爱乐"
// 小区名称
#define COMMUNITY_NAME               @"柏林爱乐"

#elif defined(LXTARGET_VERSION_BAOLI)

// 3:爱保利（保利嘉园）
// 小区ID
#define COMMUNITY_ID                 3
// 小区ICON
#define COMMUNITY_ICON               @"aibaoli"
// 小区APP名称
#define COMMUNITY_APPNAME            @"爱保利"
// 小区名称
#define COMMUNITY_NAME               @"保利嘉园"

#elif defined(LXTARGET_VERSION_CHANGXIN)

// 4:爱畅心（畅心园）
// 小区ID
#define COMMUNITY_ID                 4
// 小区ICON
#define COMMUNITY_ICON               @"aichangxin"
// 小区APP名称
#define COMMUNITY_APPNAME            @"爱畅心"
// 小区名称
#define COMMUNITY_NAME               @"首开畅心园"

#elif defined(LXTARGET_VERSION_FUDI)

// 5:爱福第（北辰福第）
// 小区ID
#define COMMUNITY_ID                 5
// 小区ICON
#define COMMUNITY_ICON               @"aifudi"
// 小区APP名称
#define COMMUNITY_APPNAME            @"爱福第"
// 小区名称
#define COMMUNITY_NAME               @"北辰福第"

#elif defined(LXTARGET_VERSION_GONGYUAN)

// 6:爱公元（常楹公元）
// 小区ID
#define COMMUNITY_ID                 6
// 小区ICON
#define COMMUNITY_ICON               @"aigongyuan"
// 小区APP名称
#define COMMUNITY_APPNAME            @"爱公元"
// 小区名称
#define COMMUNITY_NAME               @"常楹公元"

#elif defined(LXTARGET_VERSION_LIJING)

// 7:爱丽景（丽景园）
// 小区ID
#define COMMUNITY_ID                 7
// 小区ICON
#define COMMUNITY_ICON               @"ailijing"
// 小区APP名称
#define COMMUNITY_APPNAME            @"爱丽景"
// 小区名称
#define COMMUNITY_NAME               @"金隅丽景园"

#elif defined(LXTARGET_VERSION_LIANXIN)

// 8:爱连心（连心园）
// 小区ID
#define COMMUNITY_ID                 8
// 小区ICON
#define COMMUNITY_ICON               @"ailianxin"
// 小区APP名称
#define COMMUNITY_APPNAME            @"爱连心"
// 小区名称
#define COMMUNITY_NAME               @"连心园"

#elif defined(LXTARGET_VERSION_MINZU)

// 9:爱民族（民族家园）
// 小区ID
#define COMMUNITY_ID                 9
// 小区ICON
#define COMMUNITY_ICON               @"aiminzu"
// 小区APP名称
#define COMMUNITY_APPNAME            @"爱民族"
// 小区名称
#define COMMUNITY_NAME               @"常营民族家园"

#elif defined(LXTARGET_VERSION_PINGGUOPAI)

// 10:爱苹果派（苹果派）
// 小区ID
#define COMMUNITY_ID                 10
// 小区ICON
#define COMMUNITY_ICON               @"aipingguopai"
// 小区APP名称
#define COMMUNITY_APPNAME            @"爱苹果派"
// 小区名称
#define COMMUNITY_NAME               @"苹果派"

#elif defined(LXTARGET_VERSION_TIANJIE)

// 11:爱天街（长楹天街）
// 小区ID
#define COMMUNITY_ID                 11
// 小区ICON
#define COMMUNITY_ICON               @"aitianjie"
// 小区APP名称
#define COMMUNITY_APPNAME            @"爱天街"
// 小区名称
#define COMMUNITY_NAME               @"龙湖长楹天街"

#elif defined(LXTARGET_VERSION_WANXIANG)

// 12:爱万象（万象新天）
// 小区ID
#define COMMUNITY_ID                 12
// 小区ICON
#define COMMUNITY_ICON               @"aiwanxiang"
// 小区APP名称
#define COMMUNITY_APPNAME            @"爱万象"
// 小区名称
#define COMMUNITY_NAME               @"万象新天"

#elif defined(LXTARGET_VERSION_YANGGUANG)

// 13:爱阳光（阳光美园）
// 小区ID
#define COMMUNITY_ID                 13
// 小区ICON
#define COMMUNITY_ICON               @"aiyangguang"
// 小区APP名称
#define COMMUNITY_APPNAME            @"爱阳光"
// 小区名称
#define COMMUNITY_NAME               @"富力阳光美园"

#elif defined(LXTARGET_VERSION_ZHUXIN)

// 14:爱住欣（住欣家园）
// 小区ID
#define COMMUNITY_ID                 14
// 小区ICON
#define COMMUNITY_ICON               @"aizhuxin"
// 小区APP名称
#define COMMUNITY_APPNAME            @"爱住欣"
// 小区名称
#define COMMUNITY_NAME               @"住欣家园"

#endif

#define CAMERA_TIP_MSG               [NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”选项中，允许i%@访问你的相机", COMMUNITY_APPNAME]
#define ALBUM_TIP_MSG                [NSString stringWithFormat:@"请在iPhone的“设置-隐私-照片”选项中，允许i%@访问你的手机相册", COMMUNITY_APPNAME]

#endif
