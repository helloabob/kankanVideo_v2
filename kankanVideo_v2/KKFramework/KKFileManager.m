//
//  KKFileManager.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-30.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKFileManager.h"

@implementation KKFileManager

+ (void)writeToFile:(NSString *)filename ofType:(PathType)pathType withData:(NSData *)filedata {
    [filedata writeToFile:[self filepathforFilename:filename forType:pathType] atomically:YES];
}

+ (BOOL)fileExists:(NSString *)filename ofType:(PathType)pathType {
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:[self filepathforFilename:filename forType:pathType]];
}

+ (NSData *)fileDataWithPath:(NSString *)filename ofType:(PathType)pathType {
    return [NSData dataWithContentsOfFile:[self filepathforFilename:filename forType:pathType]];
}

+ (NSString *)filepathforFilename:(NSString *)filename forType:(PathType)pathType {
    NSArray *array = nil;
    if (pathType == LibraryPath) {
        array = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    } else if (pathType == DocumentPath) {
        array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    } else if (pathType == CachePath) {
        array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    }
    NSString *filepath = [array objectAtIndex:0];
    //NSLog(@"%@",filepath);
    return [filepath stringByAppendingPathComponent:filename];
}

@end
