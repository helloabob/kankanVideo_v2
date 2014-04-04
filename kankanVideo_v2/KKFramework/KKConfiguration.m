//
//  KKConfiguration.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-2-1.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKConfiguration.h"

@implementation KKConfiguration

+ (void)defaultConfiguration {
    
    //初始化下载模块缓冲文件夹
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![KKFileManager fileExists:kDownloadCacheDirectory ofType:CachePath]) {
        NSString *path = [KKFileManager filepathforFilename:kDownloadCacheDirectory forType:CachePath];
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //初始化SceneView的背景图片索引
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:kSceneViewBackgroundIndex]) {
//        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:kSceneViewBackgroundIndex];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
    //初始化订阅数据
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:kSubscriptionKey]) {
//        [[NSUserDefaults standardUserDefaults] setObject:[NSArray array] forKey:kSubscriptionKey];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
    //use registerDefaults function to replace the old function.
    //初始化SceneView的背景图片索引
    //初始化订阅数据
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [NSNumber numberWithInt:0],
                                                             kSceneViewBackgroundIndex,
                                                             [NSArray array],
                                                             kSubscriptionKey, nil]];
}

+ (void)setSubscriptionData:(NSArray *)array {
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:kSubscriptionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)getSubscriptionData {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSubscriptionKey];
}

+ (int)getHomeViewBackgroundIndex {
    int index = [[[NSUserDefaults standardUserDefaults] objectForKey:kSceneViewBackgroundIndex] intValue];
    int newIndex = index + 1;
    if (newIndex >= 4) {
        newIndex = 0;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:newIndex] forKey:kSceneViewBackgroundIndex];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return index;
}

@end
