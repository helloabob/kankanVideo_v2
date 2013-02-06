//
//  KKFileManager.h
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-30.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DocumentPath = 1,
    LibraryPath,
    CachePath,
}PathType;

@interface KKFileManager : NSObject

//写数据   filename=相对路径
+ (void)writeToFile:(NSString *)filename ofType:(PathType)pathType withData:(NSData *)filedata;

//判断文件是否存在  filepath＝相对路径
+ (BOOL)fileExists:(NSString *)filepath ofType:(PathType)pathType;

//指定路径下的二进制数据
+ (NSData *)fileDataWithPath:(NSString *)filename ofType:(PathType)pathType;
+ (NSString *)filepathforFilename:(NSString *)filename forType:(PathType)pathType;

+ (void)deleteAllCacheData;

@end
