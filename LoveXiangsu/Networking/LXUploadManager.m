//
//  LXUploadManager.m
//  LoveXiangsu
//
//  Created by yangjun on 15/12/20.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "LXUploadManager.h"
#import "LXNetCommon.h"
#import "LXUserDefaultManager.h"

#import "Utils.h"
#import "FCUUID.h"

#import <AliyunOSSiOS/OSSService.h>

@interface LXUploadManager()
{
    OSSClient * client;
}

@end

@implementation LXUploadManager

+(LXUploadManager *)sharedInstance
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
        [OSSLog enableLog];

        [self initOSSClient];
    }
    
    return self;
}

- (void)initOSSClient {
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:OSS_AccessKey
                                                                                                            secretKey:OSS_SecretKey];

    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 2;
    conf.timeoutIntervalForRequest = 30;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    
    client = [[OSSClient alloc] initWithEndpoint:OSS_EndPoint credentialProvider:credential clientConfiguration:conf];
}

/**
 * 同步上传文件到ObjectKey指定的路径
 */
- (BOOL)uploadObjectSync:(NSString *)objectKey source:(NSString *)sourcePath {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    // required fields
    put.bucketName = OSS_BucketName;
    put.objectKey = objectKey;
    put.uploadingFileURL = [NSURL fileURLWithPath:sourcePath];
    
    // optional fields
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"上传进度：%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    put.contentType = @"";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    
    OSSTask * putTask = [client putObject:put];

    [putTask waitUntilFinished]; // 阻塞直到上传完成

    NSLog(@"objectKey: %@", put.objectKey);
    if (!putTask.error) {
        NSLog(@"upload object success!");
        return YES;
    } else {
        NSLog(@"upload object failed, error: %@" , putTask.error);
        return NO;
    }
}

/**
 * 创建ObjectKey
 */
- (NSString *)makeObjectKey:(LXUPLOAD_TYPE)uploadType
{
    NSString * objectKey = nil;
    switch (uploadType) {
        case LXUPLOAD_FACE:
        {
            // 获取当前时间（年月日时分秒）
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *dateStr = [formatter stringFromDate:[NSDate date]];

            // 获取用户手机号
            NSString * phone = [LXUserDefaultManager getUserPhone];

            // 拼接头像上传ObjectKey
            objectKey = [NSString stringWithFormat:@"%@%@%@%@", UPLOAD_FACE_PATH, phone, dateStr, UPLOAD_FACE_TYPE];
        }
            break;
        case LXUPLOAD_FORUM:
        {
            // 获取用户ID
            NSString * uid = [LXUserDefaultManager getUserID];

            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *dateStr = [formatter stringFromDate:[NSDate date]];

            // 获取当前年
            NSString * year = [dateStr substringWithRange:NSMakeRange(0, 4)];
            // 获取当前月
            NSString * month = [dateStr substringWithRange:NSMakeRange(4, 2)];

            // 生成7位随机数
            int randomValue = [Utils getRandomNumber:1000000 to:9999999];
            
            // 拼接头像上传ObjectKey
            objectKey = [NSString stringWithFormat:@"%@%@/%@/%@/%d%@", UPLOAD_FORUM_PATH, uid, year, month, randomValue, UPLOAD_FORUM_TYPE];
        }
            break;
        case LXUPLOAD_OTHER:
        {
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *dateStr = [formatter stringFromDate:[NSDate date]];
            
            // 获取当前年
            NSString * year = [dateStr substringWithRange:NSMakeRange(0, 4)];
            // 获取当前月
            NSString * month = [dateStr substringWithRange:NSMakeRange(4, 2)];
            
            // 生成UUID
            NSString * randomValue = [FCUUID uuid];
            
            // 拼接头像上传ObjectKey
            objectKey = [NSString stringWithFormat:@"%@/%@/%@%@", year, month, randomValue, UPLOAD_OTHER_TYPE];
        }
            break;
            
        default:
            break;
    }

    return objectKey;
}

@end
