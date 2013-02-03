//
//  KKHomeItemView.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-30.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKHomeItemView.h"
#import <QuartzCore/QuartzCore.h>

#define BOTTOM_TITLE_FRAME          CGRectMake(0,_contentView.frame.size.height-25,_contentView.frame.size.width,25)
#define CLOSE_BUTTON_FRAME          CGRectMake(-10,-10,24,24)

@interface KKHomeItemView() {
    UIView  *_contentView;                      //item内容view，除关闭按钮
    UILabel *_lblTitle;                         //item下方标题
    NSArray *_arr;                              //item对应数据
    UIButton *_btnClose;                        //item左上角关闭按钮
    UITapGestureRecognizer *_tapGest;           //点击事件
    UILongPressGestureRecognizer *_longGest;    //长按事件
    ItemStatus _currentItemStatus;              //当前item状态
    BOOL _pointIsHere;                          //当前长按手势在此对象
    CGAffineTransform oldTransform;
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
    //[self setBackgroundColor:[UIColor grayColor]];
    //self.layer.cornerRadius = 10.0f;
    //self.layer.masksToBounds = YES;
    
    _contentView = [[UIView alloc] initWithFrame:frame];
    [self addSubview:_contentView];
    [_contentView release];
    [_contentView setBackgroundColor:[UIColor grayColor]];
    _contentView.layer.cornerRadius = 10.0f;
    _contentView.layer.masksToBounds = YES;
    
    _currentItemStatus = ItemNormalStatus;
    
    _arr = [param retain];
    _lblTitle = [[UILabel alloc] initWithFrame:BOTTOM_TITLE_FRAME];
    [_lblTitle setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5]];
    [_lblTitle setText:[_arr objectAtIndex:0]];
    [_lblTitle setTextColor:[UIColor whiteColor]];
    [_lblTitle setTextAlignment:NSTextAlignmentCenter];
    [_contentView addSubview:_lblTitle];
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
    if (_currentItemStatus == ItemNormalStatus) {
        return YES;
    } else {
        if ([gestureRecognizer locationInView:self].x<_btnClose.frame.size.width && [gestureRecognizer locationInView:self].y<_btnClose.frame.size.height) {
            return NO;
        } else {
            return YES;
        }
    }
}

- (void)closeButtonTapped {
    [self removeFromSuperview];
    [delegate itemViewDidRemoved:self];
}

- (void)changeItemStatus:(NSNumber *)itemStatus {
    if (!_pointIsHere) {
        _currentItemStatus = [itemStatus intValue];
        if (_currentItemStatus == ItemDeletableStatus) {
            [_btnClose setHidden:NO];
            [self removeGestureRecognizer:_tapGest];
            //[self removeGestureRecognizer:_longGest];
        } else if (_currentItemStatus == ItemNormalStatus){
            [_btnClose setHidden:YES];
            [self addGestureRecognizer:_tapGest];
            //[self addGestureRecognizer:_longGest];
        }
    }
    [self shakeStatus];
}

- (void)shakeStatus {
    if (_currentItemStatus == ItemNormalStatus || _currentItemStatus == ItemRemovableStatus) {
        [self.layer removeAnimationForKey:@"shakeAnimation"];
    } else {
        if (![self.layer animationForKey:@"shakeAnimation"]) {
            CGFloat rotation = 0.03;
            
            CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
            shake.duration = 0.1f;
            shake.autoreverses = YES;
            shake.repeatCount  = MAXFLOAT;
            shake.removedOnCompletion = NO;
            shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform,-rotation, 0.0 ,0.0 ,1.0)];
            shake.toValue   = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, rotation, 0.0 ,0.0 ,1.0)];
            
            [self.layer addAnimation:shake forKey:@"shakeAnimation"];
        }
    }
}

- (void)viewLongPressed:(UILongPressGestureRecognizer *)gest {
    if (gest.state == UIGestureRecognizerStateBegan) {
        _currentItemStatus = ItemRemovableStatus;
        _pointIsHere = YES;
        oldTransform = self.transform;
        [_btnClose setHidden:NO];
        [self shakeStatus];
        [UIView animateWithDuration:0.3f animations:^{
            self.alpha = 0.8f;
            CGAffineTransform newTransform = CGAffineTransformScale(self.transform, 1.1f, 1.1f);
            [self setTransform:newTransform];
        }];
        [delegate itemLongPressed];
    } else if (gest.state ==UIGestureRecognizerStateEnded) {
        _currentItemStatus = ItemDeletableStatus;
        _pointIsHere = NO;
        [UIView animateWithDuration:0.3f animations:^{
            self.alpha = 1.0f;
            [self setTransform:oldTransform];
        } completion:^(BOOL finished){
            [self shakeStatus];
        }];
    }
}

- (void)viewTapped:(UITapGestureRecognizer *)gest {
    [delegate itemTapped];
}

@end
