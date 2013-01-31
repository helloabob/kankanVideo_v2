//
//  KKFileDownloadManager.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-30.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKFileDownloadManager.h"

@interface KKFileDownloadManager() {
    NSString *_fileUrl;
    NSMutableData *_fileData;
    BOOL _shouldExit;
    NSURLConnection *_conn;
}

@end

@implementation KKFileDownloadManager
@synthesize delegate;

- (void)dealloc {
    [_fileData release];
    delegate = nil;
    [super dealloc];
}

- (id)init {
    self = [super init];
    _fileData = [[NSMutableData alloc] init];
    return  self;
}

- (void)downloadThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:_fileUrl]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [conn start];
    while (!_shouldExit) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [pool drain];
}

#pragma NSConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_fileData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection release];
    connection = nil;
    _shouldExit = YES;
    [delegate fileDidDownloadSuccessfully:self withData:_fileData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [connection release];
    connection = nil;
    _shouldExit = YES;
    [delegate fileDidFailed:self withError:error];
}

#pragma end

- (void)downloadFile:(NSString *)url {
    if ([Reachability reachabilityForInternetConnection]) {
        _fileUrl = url;
        [NSThread detachNewThreadSelector:@selector(downloadThread) toTarget:self withObject:nil];
    } else {
        NSError *err = [NSError errorWithDomain:@"KKFileDownloadManager" code:404 userInfo:nil];
        [delegate fileDidFailed:self withError:err];
    }
}

- (void)stopDownload {
    _shouldExit = YES;
    if (_conn) {
        [_conn release];
        _conn = nil;
    }
}

@end
