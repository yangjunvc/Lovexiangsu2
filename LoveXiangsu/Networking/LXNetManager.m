//
//  LXNetManager.m
//  LoveXiangsu
//
//  Created by yangjun on 15/10/18.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXNetManager.h"
#import "LXUserDefaultManager.h"

@implementation LXNetManager
{
    AFHTTPRequestOperationManager *_manager;
    NSMutableDictionary * _requestsRecord;
}

+(LXNetManager *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPRequestOperationManager manager];
        //_manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//Code = -1016
        _requestsRecord = [NSMutableDictionary dictionary];
        _manager.operationQueue.maxConcurrentOperationCount = 2;
        _requestTimeInterval = 30;
    }

    return self;
}

- (BOOL)checkResult:(LXBaseRequest *)request
{
    BOOL result = [request statusCodeValidator];
    return result;
}

- (void)handleRequestResult:(AFHTTPRequestOperation *)operation {
    NSString * key = [self requestHashKey:operation];
    LXBaseRequest *request = _requestsRecord[key];
    if (request) {
        BOOL succeed = [self checkResult:request];
        if (succeed) {
            [request handleResponse:request];
        }else {
            [request handleResponseError:request];
        }
    }
    [self removeOperation:operation];
}

- (void)addOperation:(LXBaseRequest *)request {
    if (request.requestOperation != nil) {
        NSString * key = [self requestHashKey:request.requestOperation];
        _requestsRecord[key] = request;
    }
}

- (void)addRequest:(LXBaseRequest *)request{
    
    LXRequestMethod method = request.requestMethod;
    NSString * url = [NSString stringWithFormat:@"%@%@",request.baseUrl,request.requestUrl];

    NSDictionary * param = request.requestParam;
    _manager.requestSerializer.timeoutInterval = _requestTimeInterval;
    if (request.headerParam) {
        for (NSString *key in request.headerParam.allKeys) {
            [_manager.requestSerializer setValue:[request.headerParam objectForKey:key] forHTTPHeaderField:key];
        }
    }

    // _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    if (method == LXRequestMethodGet) {
        // 应对非JSON的返回值（只有Get下设置）
        if (request.responseSerializer) {
            _manager.responseSerializer = request.responseSerializer;
        }
        NSLog(@"GET request: Url=%@", url);
        request.requestOperation = [_manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self handleRequestResult:operation];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleRequestResult:operation];
        }];
    }else if (method == LXRequestMethodPost) {
        NSLog(@"POST request: Url=%@", url);
        request.requestOperation = [_manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self handleRequestResult:operation];
        }  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleRequestResult:operation];
        }];
    }
    [self addOperation:request];
}

- (NSString *)requestHashKey:(AFHTTPRequestOperation *)operation
{
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[operation hash]];
    return key;
}

- (void)removeOperation:(AFHTTPRequestOperation *)operation {
    NSString * key = [self requestHashKey:operation];
    [_requestsRecord removeObjectForKey:key];
}

/**
 *  cancelRequest by tag
 *
 *  @param tag  request tag
 */
- (void)cancelRequest:(NSInteger)tag{
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        LXBaseRequest *request = copyRecord[key];
        if (request.tag == tag) {
            [request.requestOperation cancel];
            [self removeOperation:request.requestOperation];
        }
    }
}

/**
 *  cnacelAllRequests
 */
- (void)cancelAllRequests;
{
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        LXBaseRequest *request = copyRecord[key];
        [request stop];
    }
}

//上传data图片       fileType: 1、头像 2、图片 3、语音
- (void)addUploadRequest:(LXBaseRequest *)request{
    NSString * url = [NSString stringWithFormat:@"%@%@",request.baseUrl,request.requestUrl];
    NSDictionary * param = request.requestParam;
    _manager.requestSerializer.timeoutInterval = _requestTimeInterval;
    //_manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    request.requestOperation = [_manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:[param objectForKey:K_UPLOAD_FILEDATA] name:K_UPLOAD_FILEPATHNAME fileName:K_UPLOAD_FILEPATHNAME mimeType:[param objectForKey:K_UPLOAD_FILEMIMETYPE]];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self handleRequestResult:operation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleRequestResult:operation];
    }];
    
    [self addOperation:request];
}

- (NSString*) createPath:(NSString*) rootDirectory subDirectory:(NSString*)path
{
    NSString *cachesPath = [NSHomeDirectory() stringByAppendingPathComponent:rootDirectory];
    NSString *folderPath = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", path]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return folderPath;
}

-(void)addDownloadRequest:(LXBaseRequest*)request{
    NSString* pathRoot = nil;
    NSString* savePath = nil;
    NSDictionary* param = request.requestParam;
    NSString* fileTypeStr = [param objectForKey:K_UPLOAD_FILETYPE];
    NSString* fileName = [param objectForKey:K_DOWNLOADFILE_FILENAME];
    if ([fileTypeStr isEqualToString:K_DOWNLOADFILE_IMAGE]) {
        pathRoot = [self createPath:@"Library/Caches" subDirectory:@"image"];
        savePath = [pathRoot stringByAppendingFormat:@"/%@",fileName];
    }else if ([fileTypeStr isEqualToString:K_DOWNLOADFILE_AUDIO]){
        pathRoot = [self createPath:@"Library/Caches" subDirectory:@"audio"];
        NSArray *fileNameArray = [fileName componentsSeparatedByString:@"."];
        savePath = [pathRoot stringByAppendingFormat:@"/%@.amr",fileNameArray[0]];
    }else{
        pathRoot = [self createPath:@"Library/Caches" subDirectory:@"file"];
        savePath = [pathRoot stringByAppendingFormat:@"/%@",fileName];
    }
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:savePath]) {//检车本地是否有此文件
        return;
    }
    
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",request.baseUrl,request.requestUrl,fileName]];
    
    //NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:requestUrl];
    NSMutableURLRequest *urlRequest = [_manager.requestSerializer requestWithMethod:@"POST" URLString:[requestUrl absoluteString] parameters:nil error:nil];
    AFHTTPRequestOperation *operationDownload = [[AFHTTPRequestOperation alloc]initWithRequest:urlRequest];
    
    [operationDownload setOutputStream:[NSOutputStream outputStreamToFileAtPath:savePath append:NO]];
    [operationDownload setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //下载进度
        //NSLog(@"is download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
        
    }];
    
    
    [operationDownload setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self handleRequestResult:operation];
        
        //        NSMutableDictionary* responseDic = [[NSMutableDictionary alloc] initWithCapacity:2];
        //        [responseDic setObject:savePath forKey:K_RESPONSE_FILEPATH];
        //        [self checkResponseCallback:nil responseDic:responseDic requestParam:requestParam delegate:netDelegate];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //        [self checkResponseCallback:error responseDic:nil requestParam:requestParam delegate:netDelegate];
        [self handleRequestResult:operation];
    }];
    request.requestOperation = operationDownload;
    [self addOperation:request];
    [_manager.operationQueue addOperation:operationDownload];
    //[operationDownload start];
}

@end
