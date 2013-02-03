//
//  KKFileDownloadManager.h
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-30.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class KKFileDownloadManager;

/*@protocol KKFileDownloadManagerDelegate
@required
- (void)fileDidDownloadSuccessfully:(KKFileDownloadManager *)downloadManager withData:(NSData *)fileData;
- (void)fileDidFailed:(KKFileDownloadManager *)downloadManager withError:(NSError *)error;
@end*/

@interface KKFileDownloadManager : NSObject<NSURLConnectionDataDelegate>

typedef void (^downloadDidFinished)(NSData *fileData);

@property(nonatomic,copy) downloadDidFinished downloadDidFinishedBlock;

//@property(nonatomic,assign)id<KKFileDownloadManagerDelegate>delegate;
//- (void)downloadFile:(NSString *)url;
- (void)downloadFile:(NSString *)url
           readCache:(BOOL)readcache
           saveCache:(BOOL)savecache
          completion:(downloadDidFinished)completion;

//- (void)stopDownload;

@end
