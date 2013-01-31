//
//  KKHomeItemView.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-30.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKHomeItemView.h"

#define BOTTOM_TITLE_FRAME          CGRectMake(0,self.frame.size.height-25,self.frame.size.width,25)
#define CLOSE_BUTTON_FRAME          CGRectMake(-10,-10,24,24)

@interface KKHomeItemView() {
    UILabel *_lblTitle;                         //item下方标题
    NSArray *_arr;                              //item对应数据
    UIButton *_btnClose;                        //item左上角关闭按钮
    UITapGestureRecognizer *_tapGest;           //点击事件
    UILongPressGestureRecognizer *_longGest;    //长按事件
}

@end

@implementation KKHomeItemView
@synthesize delegate;

- (void)dealloc {
    [_longGest release];
    [_tapGest release];
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
    
    _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnClose setBackgroundImage:[UIImage imageNamed:@"itemclose"] forState:UIControlStateNormal];
    [_btnClose setFrame:CLOSE_BUTTON_FRAME];
    [_btnClose setHidden:YES];
    [_btnClose addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnClose];
    
    _tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [_tapGest setDelegate:self];
    [_tapGest setCancelsTouchesInView:NO];
    [self addGestureRecognizer:_tapGest];
    
    _longGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(viewLongPressed:)];
    [_longGest setDelegate:self];
    [self addGestureRecognizer:_longGest];
    
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //if ([gestureRecognizer.view isKindOfClass:[UIButton class]]) {
    NSLog(@"%@",[gestureRecognizer locationInView:self]);
    if ([gestureRecognizer locationInView:self].x<_btnClose.frame.size.width && [gestureRecognizer locationInView:self].y<_btnClose.frame.size.height) {
        NSLog(@"no");
        return NO;
    } else {
        NSLog(@"yes");
        return YES;
    }
}

- (void)closeButtonTapped {
    [self removeFromSuperview];
    [delegate itemViewDidRemoved:self];
}

- (void)changeItemStatus:(NSNumber *)itemStatus {
    ItemStatus _tmpStatus = [itemStatus intValue];
    if (_tmpStatus == ItemRemovableStatus) {
        [_btnClose setHidden:NO];
        //[self removeGestureRecognizer:_tapGest];
        //[self removeGestureRecognizer:_longGest];
    } else {
        [_btnClose setHidden:YES];
        //[self addGestureRecognizer:_tapGest];
        //[self addGestureRecognizer:_longGest];
    }
}

- (void)viewLongPressed:(UILongPressGestureRecognizer *)gest {
    [delegate itemLongPressed];
}

- (void)viewTapped:(UITapGestureRecognizer *)gest {
    [delegate itemTapped];
}

@end
