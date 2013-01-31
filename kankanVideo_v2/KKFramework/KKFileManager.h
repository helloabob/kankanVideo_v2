//
//  KKFileManager.h
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-30.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    DocumentPath = 1,
    LibraryPath,
    CachePath,
};

typedef NSInteger PathType;

@interface KKFileManager : NSObject

+ (void)writeToFile:(NSString *)filename ofType:(PathType)pathType withData:(NSData *)filedata;
+ (BOOL)fileExists:(NSString *)filepath ofType:(PathType)pathType;
+ (NSData *)fileDataWithPath:(NSString *)filename ofType:(PathType)pathType;
+ (NSString *)filepathforFilename:(NSString *)filename forType:(PathType)pathType;

@end
