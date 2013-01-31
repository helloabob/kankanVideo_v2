//
//  KKFileDownloadManager.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-30.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKFileDownloadManager.h"

static KKFileDownloadManager *_sharedInstance;

@interface KKFileDownloadManager() {
    BOOL _threadSwitch;
    NSString *_fileUrl;
    NSMutableData *_fileData;
    BOOL _shouldExit;
    //NSMutableArray *_downloadFileArray;
}

@end

@implementation KKFileDownloadManager
@synthesize delegate;

+ (KKFileDownloadManager *)sharedInstance {
    if (!_sharedInstance) {
        _sharedInstance = [[KKFileDownloadManager alloc] init];
        [NSThread detachNewThreadSelector:@selector(downloadThread) toTarget:_sharedInstance withObject:nil];
    }
    return _sharedInstance;
}

- (void)dealloc {
    delegate = nil;
    [super dealloc];
}

- (id)init {
    self = [super init];
    _threadSwitch = YES;
    
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

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_fileData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection release];
    connection = nil;
    _shouldExit = YES;
    [delegate fileDidDownloadSuccessfully:self withData:[_fileData autorelease]];
}

- (void)downloadFile:(NSString *)url {
    // TODO wangbo
    _fileUrl = url;
    _fileData = [[NSMutableData alloc] init];
    [NSThread detachNewThreadSelector:@selector(downloadThread) toTarget:self withObject:nil];
}

@end
