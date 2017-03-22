//
//  LXNetCommon.h
//  LoveXiangsu
//
//  Created by yangjun on 15/10/18.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#ifndef LoveXiangsu_LXNetCommon_h
#define LoveXiangsu_LXNetCommon_h

// 基本URL
#define HTTP_BASEURL                          @"http://api.21xiaoqu.com"

//二维码可识别前缀
#define QRCODE_PREFIX                         @"http://download.21xiaoqu.com/store/detail?id="

//用户头像URL前缀
#define HEAD_PREFIX                           @"http://image.21xiaoqu.com/face/"

/**
 request url
 */
#define REQUESTURL_SENTVALIDCODE              @"/user/sendvalidate"    //注册—>获取验证码
#define REQUESTURL_REGISTER_USER              @"/user/register"        //用户注册
#define REQUESTURL_GETNONCE                   @"/user/getnonce"        //获取用户nonce
#define REQUESTURL_LOGIN                      @"/user/login"           //登录
#define REQUESTURL_LOGOUT                     @"/user/logout"          //登出
#define REQUESTURL_RESETPSW                   @"/user/resetpassword"   //重置密码
#define REQUESTURL_RESETPSW_VALIDCODE         @"/user/resetpasswordsendsms"    //重置密码—>获取验证码
#define REQUESTURL_USEREDITPROFILE            @"/user/editprofile"     //修改个人信息
#define REQUESTURL_USERPROFILE                @"/user/profile"         //获取个人信息

#define REQUESTURL_MAIN                       @"/main"                 //主页

#define REQUESTURL_MYSTORES                   @"/store/mystore"        //我的店铺
#define REQUESTURL_MYCOLLECTSTORES            @"/store/mycollect"      //我收藏的店铺
#define REQUESTURL_STORELISTBYTAG             @"/store/storelist"      //店铺列表
#define REQUESTURL_STOREGETALLTAGS            @"/store/gettags"        //全部店铺标签
#define REQUESTURL_STOREGETTAGS               @"/store/tags"           //店铺分类列表(不包含全部、优惠)
#define REQUESTURL_MYCALLEDSTORES             @"/store/mycalllist"     //我拨打过的店铺
#define REQUESTURL_STOREADDCOMMENT            @"/store/comment"        //店铺评论
#define REQUESTURL_STOREGETINFO               @"/store/storeinfo"      //店铺详情
#define REQUESTURL_STOREFIXINFO               @"/store/fix"            //店铺信息纠错（需审核）
#define REQUESTURL_STOREREMOVE                @"/store/remove"         //店铺申请下线（需审核）
#define REQUESTURL_STOREMODIFYINFO            @"/store/edit"           //修改店铺信息（直接修改）
#define REQUESTURL_STOREONLINE                @"/store/online"         //商户上线下线
#define REQUESTURL_SEARCHRECORD               @"/store/searchrecord"   //获取历史搜索记录
#define REQUESTURL_STORECHECKCOLLECT          @"/store/checkcollect"   //获取店铺是否收藏
#define REQUESTURL_STOREADDCOLLECT            @"/store/addcollect"     //店铺添加到收藏
#define REQUESTURL_STOREREMOVECOLLECT         @"/store/removecollect"  //店铺从收藏中移除
#define REQUESTURL_STORENEWSTORE              @"/store/new"            //申请新店铺

#define REQUESTURL_ACTIVITYLISTBYID           @"/store/activitylist"   //店铺活动列表
#define REQUESTURL_STOREADDACTIVITY           @"/store/addactivity"    //添加活动
#define REQUESTURL_STOREEDITACTIVITY          @"/store/activityedit"   //修改店铺活动
#define REQUESTURL_ACTIVITYGETINFO            @"/store/activityinfo"   //活动详情
#define REQUESTURL_STOREDELETEACTIVITY        @"/store/activityremove" //删除店铺活动

#define REQUESTURL_GOODSLISTBYID              @"/store/goodslist"      //店铺商品列表
#define REQUESTURL_STOREADDGOODS              @"/store/addgoods"       //添加商品
#define REQUESTURL_GOODSGETINFO               @"/store/goodsinfo"      //店铺商品详情
#define REQUESTURL_STOREEDITGOODS             @"/store/goodsedit"      //修改商品信息
#define REQUESTURL_STOREDELETEGOODS           @"/store/goodsremove"    //删除店铺商品

#define REQUESTURL_SERVICELISTBYID            @"/store/servicelist"    //店铺服务列表
#define REQUESTURL_STOREADDSERVICE            @"/store/addservice"     //添加服务项目
#define REQUESTURL_SERVICEGETINFO             @"/store/serviceinfo"    //店铺服务详情
#define REQUESTURL_STOREEDITSERVICE           @"/store/serviceedit"    //修改店铺服务
#define REQUESTURL_STOREDELETESERVICE         @"/store/serviceremove"  //删除店铺服务

#define REQUESTURL_COMMENTLISTBYID            @"/store/commentlist"    //店铺评论列表
#define REQUESTURL_STOREREPLYCOMMENT          @"/store/commentreply"   //为评论添加答复

#define REQUESTURL_FORUMGETALLTAGS            @"/forum/list"           //全部论坛标签
#define REQUESTURL_FORUMLISTBYID              @"/forum/topiclist"      //帖子列表
#define REQUESTURL_GETTOPICDETAIL             @"/forum/topic"          //帖子详情
#define REQUESTURL_GETTOPICREPLY              @"/forum/replylist"      //帖子回复列表
#define REQUESTURL_FAVOURTOREPLY              @"/forum/favour"         //对回复点赞
#define REQUESTURL_REPLYTOTOPIC               @"/forum/reply"          //回复帖子
#define REQUESTURL_FORUMNEWTOPIC              @"/forum/createtopic"    //发新帖子
#define REQUESTURL_FORUMMODIFYTOPIC           @"/forum/edittopic"      //修改帖子
#define REQUESTURL_MYTOPIC                    @"/forum/mytopic"        //我的帖子
#define REQUESTURL_MYCOMMENTEDTOPIC           @"/forum/myreply"        //我回复过的帖子
#define REQUESTURL_FORUMREPORT                @"/forum/report"         //举报接口

#define REQUESTURL_GETNEWSLIST                @"/news/list"            //新闻列表
#define REQUESTURL_GETNEWSDETAIL              @"/news/detail"          //新闻详情

#define REQUESTURL_PHONELISTBYTAG             @"/phone/list"           //电话列表
#define REQUESTURL_PHONEGETALLTAGS            @"/phone/gettags"        //全部电话标签
#define REQUESTURL_PHONESAVERECORD            @"/phone/savecallrecord" //电话拨打记录接口

#define REQUESTURL_GETHEADBYPHONE             @"/chat/getheadbyphone"  //根据手机号获取头像昵称



/**
 public repuset parameter
 */
#define K_REQUESTPUBLICPARAMETER_APPID        @"appId"
#define K_REQUESTPUBLICPARAMETER_APPID_VALUE  @"1"//1:IOS 2:Android
#define K_REQUESTPUBLICPARAMETER_APPBUILDCODE @"appBuildCode"

/**
 *  response message for net error
 */
#define K_ERRORMSG_REQUSETTIMEOUT             @"网络请求超时，请稍后重试"  //The connection timed out.
#define K_ERRORMSG_CONNECTHOST                @"服务器连接失败，请稍后重试"  //The connection failed because a connection cannot be made to the host.
#define K_ERRORMSG_SERVER_ERROR               @"服务器内部错误，请稍后重试"  //The connection received an invalid server response.&& default error message
#define K_ERRORMSG_CONNECTION_OFFLINE         @"网络不给力，请稍后重试"  //The connection failed because the device is not connected to the internet.

/**
 *  json content
 */
#define K_RESPONSE_STATUS                     @"status"
#define K_RESPONSE_MESSAGE                    @"message"
#define K_RESPONSE_DATA                       @"data"

/**
 *  code for status
 */
/*
 status	响应结果标识
 0，成功
 1，DEBUG
 2，INFO
 3，WARNING
 4，ERROR
 */
#define K_RESPONSE_STATUS_SUCCESS             0   // SUCCESS
#define K_RESPONSE_STATUS_DEBUG               1   // DEBUG
#define K_RESPONSE_STATUS_INFO                2   // INFO
#define K_RESPONSE_STATUS_WARNING             3   // WARNING
#define K_RESPONSE_STATUS_ERROR               4   // ERROR
#define K_RESPONSE_STATUS_ERROR_403           403 // ERROR 403

//status->error
#define K_RESPONSE_STATUS_ERROR_DEBUG         @"error_status_debug"    //status:1
#define K_RESPONSE_STATUS_ERROR_INFO          @"error_status_info" //status:2
#define K_RESPONSE_STATUS_ERROR_WARNING       @"error_status_warning"  //status:3
#define K_RESPONSE_STATUS_ERROR_ERROR         @"error_status_error" //status:4
#define K_RESPONSE_ERROR_STATUS               @"error_status" //status error
#define K_RESPONSE_ERROR_CONTENT              @"error_content" //content error

#define K_ERRORMSG_DEBUG                      @"DEBUG信息"
#define K_ERRORMSG_INFO                       @"INFO信息"
#define K_ERRORMSG_WARNING                    @"WARNING信息"
#define K_ERRORMSG_ERROR                      @"ERROR信息"


typedef enum {
    E_RESULT_ERROR_DEBUG=20000,        // DEBUG
    E_RESULT_ERROR_INFO,               // INFO
    E_RESULT_ERROR_WARNING,            // WARNING
    E_RESULT_ERROR_ERROR,              // ERROR
    E_RESULT_ERROR_JSON,               // JSON错误
}EResultCode;

/********上传文件**********/
#define K_UPLOAD_FILETYPE                     @"fileType"
#define K_UPLOAD_FILEEXTNAME                  @"fileExtName"
#define K_UPLOAD_FILEDATA                     @"fileData"
#define K_UPLOAD_FILEMIMETYPE                 @"fileMimeType"
#define K_UPLOAD_FILEPATHNAME                 @"file"

/********下载文件**********/
#define K_DOWNLOADFILE_IMAGE                  @"1" //image
#define K_DOWNLOADFILE_AUDIO                  @"2" //audio
#define K_DOWNLOADFILE_FILE                   @"3" //file
#define K_DOWNLOADFILE_FILENAME               @"fileName" //download fileName
#define K_DOWNLOADFILE_FILEURL                @"fileUrl"
#define K_DOWNLOADFILE_FILETYPE               @"fileType"

// 文件上传类型
typedef enum {
    LXUPLOAD_FACE = 0,       // 头像上传
    LXUPLOAD_FORUM,          // 论坛上传
    LXUPLOAD_OTHER,          // 其它上传
} LXUPLOAD_TYPE;

#define UPLOAD_FACE_PATH                      @"face/"
#define UPLOAD_FORUM_PATH                     @"forum/"
#define OSS_ROOT_PATH                         @"http://image.21xiaoqu.com/"

#define UPLOAD_FACE_TYPE                      @".png"
#define UPLOAD_FORUM_TYPE                     @".jpg"
#define UPLOAD_OTHER_TYPE                     @".jpg"

#endif

