//
//  KKSceneView.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-29.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKSceneView.h"

#define BUTTON_FRAME CGRectMake(self.frame.size.width-40,self.frame.size.height-40,30,30)
#define LOGO_FRAME CGRectMake(10,10,60,78)

@interface KKSceneView() {
    UIButton *_btnArrow;
    UIImageView *_imageBack;
}

@end

@implementation KKSceneView


- (void)dealloc {
    NSLog(@"aaa");
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    [self setBackgroundColor:[UIColor blackColor]];
    
    _imageBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_bj.jpg"]];
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
