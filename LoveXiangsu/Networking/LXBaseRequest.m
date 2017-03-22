//
//  LXBaseRequest.m
//  LoveXiangsu
//
//  Created by yangjun on 15/10/18.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXBaseRequest.h"
#import "LXNetManager.h"
#import "LXNotificationCenterString.h"
#import "NSString+Custom.h"

@implementation LXBaseRequest

-(id)init{
    self = [super init];
    if (self) {
        self.requestMethod = LXRequestMethodPost;//默认post请求
        self.baseUrl = HTTP_BASEURL;
//        self.requestParam = [self publicParametersForPost];
    }
    return self;
}

-(void)setCustomRequestParams:(NSDictionary *)requestCustomParam{
    NSMutableDictionary* parameterDic = [NSMutableDictionary dictionaryWithCapacity:1];
    if (requestCustomParam && [requestCustomParam count]>0) {
        [parameterDic addEntriesFromDictionary:requestCustomParam];
    }
    if (self.requestMethod == LXRequestMethodPost) {
//        [parameterDic addEntriesFromDictionary:[self publicParametersForPost]];
    }

    self.requestParam = parameterDic;
}

//-(NSDictionary*)publicParametersForPost{
//    /*
//     字段	描述	必填	备注
//     token	唯一标识	N
//     uid	User ID	N
//     appId	内部应用ID	Y
//     appBuildCode	软件版本	Y
//     */
//    NSMutableDictionary* publicDic= [NSMutableDictionary dictionaryWithCapacity:1];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    if ([userDefaults objectForKey:USERINFO_TOKEN]){//token
//        [publicDic setObject:[userDefaults objectForKey:USERINFO_TOKEN] forKey:USERINFO_TOKEN ];
//    }else{
//        [publicDic setObject:@"" forKey:USERINFO_TOKEN ];
//    }
//    if ([userDefaults objectForKey:USERINFO_UID]){//uid
//        [publicDic setObject:[userDefaults objectForKey:USERINFO_UID] forKey:USERINFO_UID ];
//    }else{
//        [publicDic setObject:@"" forKey:USERINFO_UID ];
//    }
//
//    [publicDic setObject:K_REQUESTPUBLICPARAMETER_APPID_VALUE forKey:K_REQUESTPUBLICPARAMETER_APPID ];//appId
//    //[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
//    [publicDic setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:K_REQUESTPUBLICPARAMETER_APPBUILDCODE];//appBuildCode
//
//    //appVersion
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    if (app_Version.length>0) {
//        [publicDic setObject:app_Version forKey:USERINFO_APPVERSION];
//    }
//
//    return publicDic;
//}

-(NSError*)handleResponseHeader:(LXBaseRequest*)request{
    NSError* responseError = nil;
    NSString* errorDes = nil;
    int errorCode = 100;
    NSString* errorDomain = nil;

    LXRequestMethod requestMethod = request.requestMethod;
    if ((requestMethod == LXRequestMethodGet) && ![NSString dictionaryWithJsonString:request.responseString])
    {
        NSLog(@"request.requestMethod=Get");
        NSLog(@"request.baseUrl=%@", request.baseUrl);
        NSLog(@"request.requestUrl=%@", request.requestUrl);
        NSLog(@"request.responseString=%@", request.responseString);
    }
    else
    {
        NSMutableDictionary* responseDictinoary = (NSMutableDictionary*)request.requestOperation.responseObject;
        /*
         status	响应结果标识
         0，成功
         1，DEBUG
         2，INFO
         3，WARNING
         4，ERROR
         */
        // 连接成功 请求失败 及相应处理
        if ([responseDictinoary.allKeys containsObject:K_RESPONSE_STATUS]) {
            NSLog(@"request.baseUrl=%@", request.baseUrl);
            NSLog(@"request.requestUrl=%@", request.requestUrl);
            NSLog(@"request.responseObject=%@", request.requestOperation.responseObject);
            NSLog(@"status:%@",[responseDictinoary objectForKeyedSubscript:K_RESPONSE_STATUS]);
            int statusCode = [[responseDictinoary valueForKey:K_RESPONSE_STATUS] intValue];
            if (statusCode != K_RESPONSE_STATUS_SUCCESS) {
                if (statusCode == K_RESPONSE_STATUS_DEBUG) {// 1
                    errorDomain = K_RESPONSE_STATUS_ERROR_DEBUG;
                    errorCode = E_RESULT_ERROR_DEBUG;
                    if ([responseDictinoary.allKeys containsObject:K_RESPONSE_MESSAGE]) {
                        errorDes = (NSString*)[responseDictinoary objectForKey:K_RESPONSE_MESSAGE];
                    }else{
                        errorDes = K_ERRORMSG_DEBUG;
                    }
                }else if (statusCode == K_RESPONSE_STATUS_INFO){// 2
                    
                    errorDomain = K_RESPONSE_STATUS_ERROR_INFO;
                    errorCode = E_RESULT_ERROR_INFO;
                    if ([responseDictinoary.allKeys containsObject:K_RESPONSE_MESSAGE]) {
                        errorDes = (NSString*)[responseDictinoary objectForKey:K_RESPONSE_MESSAGE];
                    }else{
                        errorDes = K_ERRORMSG_INFO;
                    }
                }else if (statusCode == K_RESPONSE_STATUS_WARNING){// 3
                    errorDomain = K_RESPONSE_STATUS_ERROR_WARNING;
                    errorCode = E_RESULT_ERROR_WARNING;
                    if ([responseDictinoary.allKeys containsObject:K_RESPONSE_MESSAGE]) {
                        errorDes = (NSString*)[responseDictinoary objectForKey:K_RESPONSE_MESSAGE];
                    }else{
                        errorDes = K_ERRORMSG_WARNING;
                    }
                }else if (statusCode == K_RESPONSE_STATUS_ERROR){// 4
                    errorDomain = K_RESPONSE_STATUS_ERROR_ERROR;
                    errorCode = E_RESULT_ERROR_ERROR;
                    if ([responseDictinoary.allKeys containsObject:K_RESPONSE_MESSAGE]) {
                        errorDes = (NSString*)[responseDictinoary objectForKey:K_RESPONSE_MESSAGE];
                    }else{
                        errorDes = K_ERRORMSG_ERROR;
                    }
                }else if (statusCode == K_RESPONSE_STATUS_ERROR_403){// 403
                    errorDomain = K_RESPONSE_STATUS_ERROR_ERROR;
                    errorCode = E_RESULT_ERROR_ERROR;
                    if ([responseDictinoary.allKeys containsObject:K_RESPONSE_MESSAGE]) {
                        errorDes = (NSString*)[responseDictinoary objectForKey:K_RESPONSE_MESSAGE];
                    }else{
                        errorDes = K_ERRORMSG_ERROR;
                    }
                }else{
                    errorDomain = K_RESPONSE_ERROR_STATUS;
                    errorCode = E_RESULT_ERROR_JSON;
                    errorDes = K_ERRORMSG_SERVER_ERROR;
                }
            }else{
                // status = 0
                if ([responseDictinoary.allKeys containsObject:K_RESPONSE_MESSAGE]) {
                    request.successMsg = (NSString*)[responseDictinoary objectForKey:K_RESPONSE_MESSAGE];
                }
                
                // Success return without error
                return nil;
            }
        }else{
            //no status
            errorDomain = K_RESPONSE_ERROR_CONTENT;
            errorCode = E_RESULT_ERROR_JSON;
            errorDes = K_ERRORMSG_SERVER_ERROR;
        }
        
        if (errorCode!=100 && errorDomain && errorDes) {
            responseError = [NSError errorWithDomain:errorDomain
                                                code:errorCode
                                            userInfo:[NSDictionary dictionaryWithObject:errorDes forKey:NSLocalizedDescriptionKey]];
        }
    }

    return responseError;
}

-(void)handleResponse:(LXBaseRequest*)request{
    
}

-(void)handleResponseError:(LXBaseRequest*)request{
    NSString *errorDes = nil;
    NSError* responseError = request.requestOperation.error;
    if (responseError) {
        if (responseError.code == kCFURLErrorTimedOut) {
            errorDes = K_ERRORMSG_REQUSETTIMEOUT;
        }else if (responseError.code == kCFURLErrorCannotConnectToHost){
            errorDes = K_ERRORMSG_CONNECTHOST;
        }
        else if (responseError.code == kCFURLErrorBadServerResponse){
            errorDes = K_ERRORMSG_SERVER_ERROR;
        }
        else if (responseError.code == kCFURLErrorNotConnectedToInternet){
            errorDes = K_ERRORMSG_CONNECTION_OFFLINE;
        }
        else if (responseError.code == kCFURLErrorCannotFindHost){
            errorDes = K_ERRORMSG_CONNECTION_OFFLINE;
        }
        else{
            errorDes = K_ERRORMSG_SERVER_ERROR;
        }
        NSError* netError = [NSError errorWithDomain:responseError.domain code:responseError.code userInfo:[NSDictionary dictionaryWithObject:errorDes forKey:NSLocalizedDescriptionKey]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestResult:withData:responseData:)]) {
            [self.delegate requestResult:netError withData:nil responseData:request];
        }
    }
}

- (NSString *)responseString
{
    return self.requestOperation.responseString;
}

- (NSInteger)responseStatusCode
{
    return self.requestOperation.response.statusCode;
}

- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    if (statusCode >= 200 && statusCode <= 299) {
        return YES;
    }else {
        return NO;
    }
}

- (void)stop {
    [[LXNetManager sharedInstance] cancelRequest:self.tag];
}

@end
