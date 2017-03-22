//
//  NSFileManager+util.m
//  LoveXiangsu
//
//  Created by 张婷 on 15/10/24.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

#import "NSFileManager+util.h"
#include <sys/xattr.h>
#import "NSString+Custom.h"

@implementation NSFileManager (util)

/**
 * 获取文件大小
 */
+ (NSInteger)fileSize:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath isDirectory:nil]){
        
        NSDictionary * attributes = [fileManager attributesOfItemAtPath:filePath error:nil];
        
        // file size
        NSNumber *filesize = [attributes objectForKey:NSFileSize];
        return [filesize intValue];
    }
    return 0;
}

/**
 * 从指定路径删除指定的文件，没有指定文件时，删除路径下全部文件
 */
+ (NSInteger)removeFromPath:(NSString *)path ofFile:(NSString *)filename
{
    if ([NSString isBlankString:path]) {
        return 0;
    }
    int count = 0;
    if ([NSString isBlankString:filename]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
        NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
        for (NSString *file in fileList) {
            NSString *filePath = [path stringByAppendingPathComponent:file];
            if ([NSFileManager removeFileFromPath:filePath]) {
                count++;
            }
        }
    } else {
        NSString *filePath = [path stringByAppendingPathComponent:filename];
        if ([NSFileManager removeFileFromPath:filePath]) {
            count++;
        }
    }

    return count;
}

/**
 * 删除指定文件
 */
+ (BOOL)removeFileFromPath:(NSString *)filePath
{
    if ([NSString isBlankString:filePath]) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if ([fileManager fileExistsAtPath:filePath]) {
        if (![fileManager removeItemAtPath:filePath error:&error]) {
            // 删除失败
            NSLog(@"%@ When remove: %@", filePath, [error localizedDescription]);
            return NO;
        }
        return YES;
    } else {
        return NO;
    }
}

/**
 * 获取沙盒的Documents路径
 */
+ (NSString *)getDocumentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
}

/**
 * 根据文件路径创建文件，并根据delete决定是否删除旧有文件
 */
+ (BOOL)createFilePath:(NSString *)filePath deleteOldFile:(BOOL)deleteOld
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if ([fileManager fileExistsAtPath:filePath] && deleteOld) {
        if (![fileManager removeItemAtPath:filePath error:&error]) {
            // 删除失败
            NSLog(@"旧文件：%@ 删除失败: %@", filePath, [error localizedDescription]);
        } else {
            NSLog(@"旧文件：%@ 删除成功！", filePath);
        }
    }
    NSRange range = [filePath rangeOfString:@"/" options:NSBackwardsSearch];
    NSString * fileDirPath = nil;
    if (range.length > 0) {
        fileDirPath = [filePath substringToIndex:NSMaxRange(range)];
    }
    if (fileDirPath && ![fileManager fileExistsAtPath:fileDirPath]) {
        BOOL result = [fileManager createDirectoryAtPath:fileDirPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (result) {
            NSLog(@"目录：%@ 创建成功！", fileDirPath);
        } else {
            NSLog(@"目录：%@ 创建失败：%@", fileDirPath, [error localizedDescription]);
        }
    }

    BOOL result = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    if (result) {
        NSLog(@"文件：%@ 创建成功！", filePath);
    } else {
        NSLog(@"文件：%@ 创建失败：%@", filePath, [error localizedDescription]);
    }
    return result;
}

@end
