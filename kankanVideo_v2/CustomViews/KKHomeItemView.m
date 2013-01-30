//
//  KKHomeItemView.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-30.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKHomeItemView.h"
#define BOTTOM_TITLE_FRAME CGRectMake(0,self.frame.size.height-25,self.frame.size.width,25)

@interface KKHomeItemView() {
    UILabel *_lblTitle;     //item下方标题
    NSArray *_arr;          //item对应数据
}

@end

@implementation KKHomeItemView
@synthesize delegate;

- (void)dealloc {
    [_arr release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame withParam:(NSArray *)param
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    [self setBackgroundColor:[UIColor grayColor]];
    
    _arr = [param retain];
    _lblTitle = [[UILabel alloc] initWithFrame:BOTTOM_TITLE_FRAME];
    [_lblTitle setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5]];
    [_lblTitle setText:[_arr objectAtIndex:0]];
    [_lblTitle setTextColor:[UIColor whiteColor]];
    [_lblTitle setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_lblTitle];
    [_lblTitle release];
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self addGestureRecognizer:tapGest];
    [tapGest release];
    
    return self;
}

- (void)viewTapped:(UITapGestureRecognizer *)gest {
    [delegate itemTapped];
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
