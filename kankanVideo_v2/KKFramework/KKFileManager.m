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
//    NSArray *array = nil;
//    if (pathType == LibraryPath) {
//        array = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    } else if (pathType == DocumentPath) {
//        array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    } else if (pathType == CachePath) {
//        array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    }
//    NSString *filepath = [array objectAtIndex:0];
//    [filepath stringByAppendingPathComponent:filename];
    [filedata writeToFile:[KKFileManager filepathforFilename:filename forType:pathType] atomically:YES];
}

+ (BOOL)fileExists:(NSString *)filename ofType:(PathType)pathType {
//    NSArray *array = nil;
//    if (pathType == LibraryPath) {
//        array = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    } else if (pathType == DocumentPath) {
//        array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    } else if (pathType == CachePath) {
//        array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    }
//    NSString *filepath = [array objectAtIndex:0];
//    [filepath stringByAppendingPathComponent:filename];
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:[KKFileManager filepathforFilename:filename forType:pathType]];
}

+ (NSData *)fileDataWithPath:(NSString *)filename ofType:(PathType)pathType {
    
    //NSLog(@"%@----%@",filepath,filename);
    return [NSData dataWithContentsOfFile:[KKFileManager filepathforFilename:filename forType:pathType]];
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
    NSLog(@"%@",[filepath stringByAppendingPathComponent:filename]);
    return [filepath stringByAppendingPathComponent:filename];
}

@end
