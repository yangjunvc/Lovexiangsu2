//
//  LXDictCommon.h
//  LoveXiangsu
//
//  Created by yangjun on 15/10/18.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#ifndef LoveXiangsu_LXDictCommon_h
#define LoveXiangsu_LXDictCommon_h

/**
 * 用户角色
 * 对应数据库的角色ID 0：普通用户
 */
typedef enum {
    LXUSER_ROLE_USER =2000,       // 普通用户
    LXUSER_ROLE_OTHERS
}LXUSER_ROLE;

/**
 * 用户角色状态
 */
typedef enum {
    
    LXUSER_STATUS_COMMON =3000,       // 正常
    LXUSER_STATUS_EXAMINE_DOING,   // 审核中
    LXUSER_ROLE_EXAMINE_FAIL,    // 审核失败
    LXUSER_ROLE_EXAMINE_SUCCESS   // 审核成功
}LXUSER_STATUS;

/**
 * 要申请成为的角色
 */
typedef enum {
    
    LXUSER_APPLYROLE_USER =4000,       // 普通用户
    LXUSER_APPLYROLE_OTHERS
}LXUSER_APPLYROLE;

/**
 * 弹窗类型
 */
typedef enum {
    
    LXPOPUPVIEW_TYPE_DIFFERENTPOSITIONLOGIN =5000,      // 异地登陆
    LXPOPUPVIEW_TYPE_MOBILEHASBEENREGISTED,             // 手机号已注册
    LXPOPUPVIEW_TYPE_ACCOUNTSTOP,                        //账户冻结弹窗
    
    LXPOPUPVIEW_TYPE_CAMERATOBEUSED,                    // 调用相机弹窗
    
    LXPOPUPVIEW_TYPE_USERHOMEPAGEMORE,                  //普通用户首页-更多功能快捷入口弹窗
}LXPOPUPVIEW_TYPE;

/**
 * 转子类型(不包括日期转子)
 */
typedef enum {
    
    LXPICKERVIEW_TYPE_AREA =6000,       // 省市县转子
}LXPICKERVIEW_TYPE;

#endif
