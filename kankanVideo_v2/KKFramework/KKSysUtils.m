//
//  KKSysUtils.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-2-21.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKSysUtils.h"

@implementation KKSysUtils

+ (CGFloat)systemVersion {
    UIDevice *device = [UIDevice currentDevice];
    return [[device systemVersion] floatValue];
}

+ (NSString *)dateToCountString:(id)date {
    NSDate *dt = nil;
    if ([date isKindOfClass:[NSString class]]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        dt = [dateFormatter dateFromString:date];
    } else {
        dt = date;
    }
    NSTimeInterval nowTimeInterval = [NSDate timeIntervalSinceReferenceDate];
    u_int64_t diff = nowTimeInterval - [dt timeIntervalSinceReferenceDate];
    NSString *result = nil;
    if (diff < 60) {
        result = [NSString stringWithFormat:@"%llu秒前",diff];
    } else if (diff < 3600) {
        result = [NSString stringWithFormat:@"%llu分钟前",diff/60];
    } else if (diff < 86400) {
        result = [NSString stringWithFormat:@"%llu小时前",diff/3600];
    } else if (diff < 604800) {
        result = [NSString stringWithFormat:@"%llu天前",diff/86400];
    } else {
        result = [NSString stringWithFormat:@"%@",dt];
    }
    return result;
}

@end
