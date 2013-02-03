//
//  KKConfig.h
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-29.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#ifndef kankanVideo_v2_KKConfig_h
#define kankanVideo_v2_KKConfig_h

#define iPhone5                 ([UIScreen mainScreen].bounds.size.height == 568)
#define kHomeBigImageUrl         @"http://interface.kankanews.com/kkapi/mobile/mobileapi.php?m=index"
#define kChannelListUrl          @"http://interface.kankanews.com/kkapi/mobile/mobileapi.php?m=clistphone"
#define kVideoListUrl            @"http://interface.kankanews.com/kkapi/mobile/mobileapi.php?m=vlist&cid=%@&pagesize=20&page=%d"
#define kVideoPlayUrl            @"http://interface.kankanews.com/kkapi/mobile/mobileapi.php?m=vcontent&url=%@"

#define sinaAppKey              @"4281330846"
#define sinaAppSecret           @"aadc4acbe227004e391803af30fa6224"

#define qqAppKey                @""
#define qqAppSecret             @""

#define kDownloadCacheDirectory         @"tmp"
#define kDownloadCachePath(url)         [NSString stringWithFormat:@"%@/%@",kDownloadCacheDirectory,[url md5]]

#define kSceneViewBackgroundIndex       @"sceneViewBackgroundIndex"

#define kSubscriptionKey                @"subscriptionKey"

#import "Reachability.h"
#import "KKFileDownloadManager.h"
#import "KKFileManager.h"
#import "KKXMLParser.h"
#import "NSString+MD5.h"
#import "KKConfiguration.h"






#endif
