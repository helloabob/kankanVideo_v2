//
//  KKSceneView.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-29.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKSceneView.h"

#define BUTTON_FRAME                CGRectMake(self.frame.size.width-40,self.frame.size.height-40,30,30)
#define LOGO_FRAME                  CGRectMake(10,10,60,78)

#define DEFAULT_HOME_IMAGE_NAME     @"home_bj.jpg"
#define HOME_IMAGE_PATH             @"home_bj.jpg"

@interface KKSceneView() {
    UIButton *_btnArrow;        //右箭头按钮
    UIImageView *_imageBack;    //背景图片
}

@end

@implementation KKSceneView


- (void)dealloc {
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    [self setBackgroundColor:[UIColor blackColor]];
    
    if ([KKFileManager fileExists:HOME_IMAGE_PATH ofType:LibraryPath] == YES) {
        NSLog(@"aa");
        _imageBack = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[KKFileManager fileDataWithPath:HOME_IMAGE_PATH ofType:LibraryPath]]];
    } else {
        _imageBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:DEFAULT_HOME_IMAGE_NAME]];
        KKFileDownloadManager *downloadManager = [[KKFileDownloadManager alloc] init];
        [downloadManager setDelegate:self];
        [downloadManager downloadFile:@"http://static.statickksmg.com/image/2013/01/28/d68b73f99f409de897a62d21f31a6d66.jpg"];
    }
    
    [self addSubview:_imageBack];
    [_imageBack release];
    
    _btnArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnArrow setBackgroundImage:[UIImage imageNamed:@"kk_enter"] forState:UIControlStateNormal];
    [_btnArrow setFrame:BUTTON_FRAME];
    [_btnArrow addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnArrow];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kk_logo"]];
    [imageView setFrame:LOGO_FRAME];
    [self addSubview:imageView];
    [imageView release];
    
    //[[KKFileDownloadManager sharedInstance] downloadFile:@"http://static.statickksmg.com/image/2013/01/28/d68b73f99f409de897a62d21f31a6d66.jpg"];
    //[[KKFileDownloadManager sharedInstance] setDelegate:self];
    return self;
}

- (void)fileDidDownloadSuccessfully:(KKFileDownloadManager *)downloadManager withData:(NSData *)fileData {
    NSLog(@"fileDidDownloadSuccessfully");
    [KKFileManager writeToFile:HOME_IMAGE_PATH ofType:LibraryPath withData:fileData];
    [downloadManager release];
}

- (void)btnTapped:(UIControlEvents *)sender {
    [UIView animateWithDuration:1.0f animations:^{
        [self setAlpha:0];
    }completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

@end
