//
//  KKFileDownloadManager.h
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-30.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KKFileDownloadManager;


@protocol KKFileDownloadManagerDelegate
@required
- (void)fileDidDownloadSuccessfully:(KKFileDownloadManager *)downloadManager withData:(NSData *)fileData;

@end

@interface KKFileDownloadManager : NSObject<NSURLConnectionDataDelegate>

@property(nonatomic,assign)id<KKFileDownloadManagerDelegate>delegate;
+ (KKFileDownloadManager *)sharedInstance;
- (void)downloadFile:(NSString *)url;

@end
