//
//  KKFileDownloadManager.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-30.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKFileDownloadManager.h"

@interface KKFileDownloadManager() {
    NSString            *_fileUrl;                     //下载文件url地址
    NSMutableData       *_fileData;                    //下载数据
    BOOL                _shouldExit;                   //线程关闭开关
    NSURLConnection     *_conn;                        //连接变量
    BOOL                _readCacheFlag;                //是否尝试读取cache
    BOOL                _saveCacheFlag;                //数据是否保存到cache
    //downloadDidFinished   _downloadDidFinishedBlock;
}

@end

@implementation KKFileDownloadManager
//@synthesize delegate = _delegate;
@synthesize downloadDidFinishedBlock = _downloadDidFinishedBlock;

- (void)dealloc {
//    NSLog(@"downloadManager_dealloc");
    [_fileUrl release];
    if (_fileData) {
        [_fileData release];
    }
    [super dealloc];
}

- (id)init {
    self = [super init];
    return  self;
}

- (void)downloadThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_fileUrl]];
    req.timeoutInterval = 30;
    NSURLConnection *conn = [[[NSURLConnection alloc] initWithRequest:req delegate:self] autorelease];
    [conn start];
    while (!_shouldExit) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    //[[NSRunLoop currentRunLoop] run];
    [pool drain];
}

#pragma NSConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (!_fileData) {
        _fileData = [[NSMutableData alloc] init];
    }
    [_fileData appendData:data];
}

- (void)callback {
    if (_downloadDidFinishedBlock) {
        _downloadDidFinishedBlock(_fileData);
    }
    [_downloadDidFinishedBlock release];
    _downloadDidFinishedBlock = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //[connection release];
    //connection = nil;
    _shouldExit = YES;
    //[_delegate fileDidDownloadSuccessfully:self withData:_fileData];
    if (_saveCacheFlag) {
        [KKFileManager writeToFile:kDownloadCachePath(_fileUrl) ofType:CachePath withData:_fileData];
    }
    [self callback];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //[connection release];
    //connection = nil;
    _shouldExit = YES;
    [self callback];
    //[_delegate fileDidFailed:self withError:error];
}

#pragma end

- (void)downloadFile {
    if (_readCacheFlag) {
        if ([KKFileManager fileExists:kDownloadCachePath(_fileUrl) ofType:CachePath]) {
            _fileData = [[NSMutableData alloc] initWithData:[KKFileManager fileDataWithPath:kDownloadCachePath(_fileUrl) ofType:CachePath]];
            return [self callback];
        }
    }
    if ([Reachability reachabilityForInternetConnection]) {
        [NSThread detachNewThreadSelector:@selector(downloadThread) toTarget:self withObject:nil];
    } else {
        //NSError *err = [NSError errorWithDomain:@"KKFileDownloadManager" code:404 userInfo:nil];
        [self callback];
        //[_delegate fileDidFailed:self withError:err];
    }
}

- (void)downloadFile:(NSString *)url
           readCache:(BOOL)readcache
           saveCache:(BOOL)savecache
          completion:(downloadDidFinished)completion {
    _fileUrl = [url retain];
    //NSLog(@"%@",_fileUrl);
    _readCacheFlag = readcache;
    _saveCacheFlag = savecache;
    self.downloadDidFinishedBlock = completion;
    [self downloadFile];
}

+ (NSString *)cacheFilePath:(NSString *)url {
    if ([KKFileManager fileExists:kDownloadCachePath(url) ofType:CachePath]) {
        return [KKFileManager filepathforFilename:kDownloadCachePath(url) forType:CachePath];
    } else {
        return nil;
    }
}

//- (void)stopDownload {
//    if (_downloadDidFinishedBlock) {
//        _downloadDidFinishedBlock = nil;
//    }
//    _shouldExit = YES;
//    if (_conn) {
//        [_conn cancel];
//        [_conn release];
//        _conn = nil;
//    }
//}

@end
