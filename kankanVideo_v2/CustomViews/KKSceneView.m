//
//  KKSceneView.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-29.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKSceneView.h"

@interface KKSceneView() {
    UIButton *_btnArrow;
    UIImageView *_imageView;
}

@end

@implementation KKSceneView


- (void)dealloc {
    [_btnArrow release];
    [_imageView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    [self setBackgroundColor:[UIColor blackColor]];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
