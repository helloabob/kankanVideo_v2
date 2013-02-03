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
    KKFileDownloadManager *_downloadManager;
    KKFileDownloadManager *_imageDownloadManager;
}

@end

@implementation KKSceneView


- (void)dealloc {
    [_imageDownloadManager release];
    [_downloadManager release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    [self setBackgroundColor:[UIColor blackColor]];

    _imageBack = [[UIImageView alloc] initWithFrame:frame];
        _downloadManager = [[KKFileDownloadManager alloc] init];
        [_downloadManager downloadFile:kHomeBigImageUrl
                             readCache:YES
                             saveCache:YES
                            completion:^(NSData *xmlData){
                                if (xmlData) {
                                    NSMutableArray *array = [KKXMLParser parseXML:xmlData withKeys:[NSArray arrayWithObject:@"titlepic"]];
                                    _imageDownloadManager = [[KKFileDownloadManager alloc] init];
                                    [_imageDownloadManager downloadFile:[[array objectAtIndex:[KKConfiguration getHomeViewBackgroundIndex]] objectForKey:@"titlepic"]
                                           readCache:YES
                                           saveCache:YES
                                          completion:^(NSData *imageData){
                                              _imageBack.image = [UIImage imageWithData:imageData];
                                    }];
                                }
                            }];
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
    
    
    return self;
}

- (void)btnTapped:(UIControlEvents *)sender {
    [UIView animateWithDuration:1.0f animations:^{
        [self setAlpha:0];
    }completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

@end
