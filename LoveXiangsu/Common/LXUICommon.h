//
//  LXUICommon.h
//  LoveXiangsu
//
//  Created by yangjun on 15/10/18.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#ifndef LoveXiangsu_LXUICommon_h
#define LoveXiangsu_LXUICommon_h

/**
 * 颜色值
 */
// 色调
// primaryColor           蓝色
#define LX_PRIMARY_COLOR           COLOR_RGB_HEX(0x2196F3)              // 主色调
// primaryColorDark       蓝色（加深）
#define LX_PRIMARY_COLOR_DARK      COLOR_RGB_HEX(0x1976D2)              // 主色调加深
// accentColor            红色
#define LX_ACCENT_COLOR            COLOR_RGB_HEX(0xF44336)              // 标示重点用的反色调
// background             白色
#define LX_BACKGROUND_COLOR        COLOR_RGB_HEX(0xffffff)              // 背景色

// 文字颜色
// accentText             白色
#define LX_ACCENT_TEXT_COLOR       COLOR_RGBA_HEX(0xFFFFFFDE)           // 反色调上的文字颜色
// PrimaryText            白色
#define LX_PRIMARY_TEXT_COLOR      COLOR_RGBA_HEX(0xFFFFFFDE)           // 主色调上的文字颜色
// mainText               黑色
#define LX_MAIN_TEXT_COLOR         COLOR_RGBA_HEX(0x000000DE)           // 黑字1
// secondText             黑色
#define LX_SECOND_TEXT_COLOR       COLOR_RGBA_HEX(0x00000092)           // 黑字2
// thirdText              黑色
#define LX_THIRD_TEXT_COLOR        COLOR_RGBA_HEX(0x00000072)           // 黑字3

// 调试颜色
#define LX_DEBUG_COLOR             [[UIColor clearColor] CGColor]         // 调试:红色；非调试：透明色

/**
 * 字体大小
 */
#define LX_TEXTSIZE_12             FONT_SYSTEM(12)                      // 12号字体
#define LX_TEXTSIZE_14             FONT_SYSTEM(14)                      // 14号字体
#define LX_TEXTSIZE_16             FONT_SYSTEM(16)                      // 16号字体
#define LX_TEXTSIZE_20             FONT_SYSTEM(20)                      // 20号字体

#define LX_TEXTSIZE_BOLD_12        FONT_SYSTEM_BOLD(12)                 // 12号粗体
#define LX_TEXTSIZE_BOLD_14        FONT_SYSTEM_BOLD(14)                 // 14号粗体
#define LX_TEXTSIZE_BOLD_16        FONT_SYSTEM_BOLD(16)                 // 16号粗体
#define LX_TEXTSIZE_BOLD_20        FONT_SYSTEM_BOLD(20)                 // 20号粗体

/**
 * 排版边距
 */
#define MARGIN                     16                                   // 外边距16dp
#define LINESPACE                   8                                   // 行间距8dp
#define PADDING                     8                                   // 内边距8dp

/**
 * 全屏高度/宽度，ios7之后
 */
#define ScreenFrame  ([UIScreen mainScreen].bounds)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define ScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define MenuWidth    (ScreenWidth / 1.38)
#define MenuHeaderHeight (MenuWidth / 16 * 9)

/**
 * 菜单栏宽度
 */
#define StoreMenuWidth      (MARGIN * 2 + IconSize)
#define ForumMenuWidth      (MARGIN * 2 + IconSize + PADDING)
#define PhoneMenuWidth      (MARGIN * 2 + IconSize)

/**
 * 系统字体获取
 */
#define FONT_SYSTEM(_size_) [UIFont systemFontOfSize:(_size_)]
#define FONT_SYSTEM_BOLD(_size_) [UIFont boldSystemFontOfSize:(_size_)]

/**
 * 自定义字体获取
 */
#define FONT_NAME(_name_, _size_) [UIFont fontWithName:(_name_) size:(_size_)]

/**
 * 根据RGBA各自的值来获取颜色对象
 */
#define COLOR_RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define COLOR_RGB(r, g, b) COLOR_RGBA((r), (g), (b), 1)

/**
 * 根据RGBA的值来获取颜色对象
 * usage:
 *      COLOR_RGB_HEX(0xa1a1a1)
 *      COLOR_RGB_HEX(0xa1a1a1FF)
 */
#define COLOR_RGB_HEX(rgbValue) COLOR_RGB((((rgbValue) & 0xFF0000) >> 16), (((rgbValue) & 0xFF00) >> 8), (((rgbValue) & 0xFF)))
#define COLOR_RGBA_HEX(rgbValue) COLOR_RGBA((((rgbValue) & 0xFF000000) >> 24), (((rgbValue) & 0xFF0000) >> 16), (((rgbValue) & 0xFF00) >> 8), (((rgbValue) & 0xFF)/255.0f))


#define COLOR_CLEAR [UIColor clearColor]

/**
 * 定义UIImage对象  ，节约运行内存
 */
#define IMAGE(A,B) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:B]]

/**
 * TabBar
 */
#define TabBarHeight        54
#define TabBarIconSize      29
#define TabBarIconTopMargin 2.5
#define TabBarTitleHeight   15
#define TabBarBtnHeight     49

/**
 * 图标大小
 */
// 店铺区
#define IconSize            25
#define StoreImgWidth       59
#define StoreImgHeight      45
#define StoreRowGap          8
#define StoreStarHeight     10.4
#define CallingImgSize      35
//#define CallTimesWidth      40
#define CallTimesHeight     15

// 店铺活动区
#define ActivityImgWidth    67
#define ActivityImgHeight   50

// HeaderView
// 小喇叭
#define TrumpetImgSize      20
// 更多新闻
#define MoreNewsBtnWidth    49
// 更多店铺
#define MoreStoresBtnWidth  56
// 功能区
#define NoticeImgSize       (37 + 5)
#define NoticeTxtWidth      80
#define PhoneImgSize        (37 + 5)
#define PhoneTxtWidth       80
// 论坛区
#define HeadBtnSize         30
#define HeadBigBtnSize      50
#define FavourBtnSize       23

// 论坛区
// 置顶图标
#define TopImgWidth         31
#define TopImgHeight        15

// 帖子图像大小
#define TopicImgWidth       49
#define TopicImgHeight      72

// 回复数泡泡
#define ReplyImgWidth       16
#define ReplyImgHeight      16

// 店铺评论
// 星级图像大小
#define StoreStarImgSize    50
// 评论内容高
#define StoreCommentHeight  170

/**
 * 线条宽度
 */
#define BorderWidth05       0.5
#define BorderWidth10       1.0
#define SeparatorHeight     1.0

/**
 * 登陆类按钮高度
 */
#define LoginClassBtnHeight 45

/**
 * 论坛菜单定义
 */
// 新帖子论坛选择列表排除项
#define FORUM_TYPE_EXCLUDE  @"最新"

#endif
