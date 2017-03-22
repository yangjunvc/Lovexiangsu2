//
//  NSFileManager+util.h
//  LoveXiangsu
//
//  Created by 张婷 on 15/10/24.
//  Copyright (c) 2015年 MingRui Info Tech. All rights reserved.
//

@interface NSFileManager (util)

/**
 * 获取文件大小
 */
+ (NSInteger)fileSize:(NSString *)file;

/**
 * 从指定路径删除指定的文件，没有指定文件时，删除路径下全部文件
 */
+ (NSInteger)removeFromPath:(NSString *)path ofFile:(NSString *)filename;

/**
 * 删除指定文件
 */
+ (BOOL)removeFileFromPath:(NSString *)filePath;

/**
 * 获取沙盒的Documents路径
 */
+ (NSString *)getDocumentsPath;

/**
 * 根据文件路径创建文件，并根据delete决定是否删除旧有文件
 */
+ (BOOL)createFilePath:(NSString *)filePath deleteOldFile:(BOOL)deleteOld;

@end
