//
//  LXBaseRequest.h
//  LoveXiangsu
//
//  Created by yangjun on 15/10/18.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "LXNetCommon.h"
#import "LXCommon.h"

@class LXBaseRequest;

typedef NS_ENUM(NSInteger, LXRequestMethod) {
    LXRequestMethodGet = 0,
    LXRequestMethodPost,
};
typedef NS_ENUM(NSInteger, LXRequestSerializerType) {
    LXRequestSerializerTypeJSON = 0,
    LXRequestSerializerTypeHTTP,
};

@protocol LXRequestDelegate <NSObject>

@required
-(void)requestResult:(NSError*) error withData:(id)responseObject responseData:(LXBaseRequest*)requestData;

@end

@interface LXBaseRequest : NSObject

@property (nonatomic, strong) AFHTTPRequestOperation * requestOperation;

@property (nonatomic, strong) AFHTTPResponseSerializer <AFURLResponseSerialization> * responseSerializer;

//HTTP请求的方法..
@property (nonatomic) LXRequestMethod requestMethod;

//请求的参数
@property (nonatomic, strong) NSDictionary * requestParam;

//请求的Header参数
@property (nonatomic, strong) NSDictionary * headerParam;

//成功的Message
@property (nonatomic, strong) NSString * successMsg;

//服务器地址BaseUrl
@property (nonatomic, strong) NSString * baseUrl;

//请求的URL
@property (nonatomic, strong) NSString * requestUrl;

//返回的数据
@property (nonatomic, strong, readonly) NSString * responseString;

//请求的数据类型
@property (nonatomic) LXRequestSerializerType requestSerializerType;

@property (nonatomic, strong) id<LXRequestDelegate> delegate;

@property (nonatomic) NSInteger tag;

//@property (nonatomic) NSInteger fileType;//上传用
//
//@property (nonatomic, strong) NSString* fileExtName;//上传用
//
//@property (nonatomic, strong) NSData* fileData;//上传用
//
//@property (nonatomic, strong) NSString* fileMimeType;//上传用

-(void)handleResponse:(LXBaseRequest*)request;
-(void)handleResponseError:(LXBaseRequest*)request;
-(NSError*)handleResponseHeader:(LXBaseRequest*)request;

-(void)setCustomRequestParams:(NSDictionary *)requestParam;
//-(NSDictionary*)publicParametersForPost;

//状态码校验
- (BOOL)statusCodeValidator;

- (void)stop;

@end
