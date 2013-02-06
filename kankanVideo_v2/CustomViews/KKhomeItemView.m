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
    //NSArray *_arr;                              //item对应数据
    UIButton *_btnClose;                        //item左上角关闭按钮
    UITapGestureRecognizer *_tapGest;           //点击事件
    UILongPressGestureRecognizer *_longGest;    //长按事件
    UIPanGestureRecognizer *_panGest;           //移动事件
    ItemStatus _currentItemStatus;              //当前item状态
    //BOOL _pointIsHere;                          //当前长按手势在此对象
    CGAffineTransform oldTransform;             //item初始transform
    UIImageView *_itemBackImage;                 //item背景图片
    BOOL _moveBegan;                            //是否可以移动item标志
    KKFileDownloadManager *_imageDownloader;    //加载图片加载器
    UIImageView *_imageViewLoading;             //加载时loading效果
}

@end

@implementation KKHomeItemView
@synthesize delegate = _delegate;
@synthesize index = _index;
@synthesize pointIsHere = _pointIsHere;
@synthesize currentItemStatus = _currentItemStatus;
@synthesize itemData = _itemData;

- (void)dealloc {
    [_imageDownloader release];
    [_longGest release];
    [_tapGest release];
    [_panGest release];
    //[_arr release];
    [_itemData release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame withParam:(NSDictionary *)param
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    //[self setBackgroundColor:[UIColor grayColor]];
    //self.layer.cornerRadius = 10.0f;
    //self.layer.masksToBounds = YES;
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _imageViewLoading = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-48, frame.size.height-48, 48, 48)];
    [_imageViewLoading setAnimationImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"l1"],
                                          [UIImage imageNamed:@"l2"],
                                          [UIImage imageNamed:@"l3"],
                                          [UIImage imageNamed:@"l4"],
                                          [UIImage imageNamed:@"l5"],
                                          [UIImage imageNamed:@"l6"],
                                          [UIImage imageNamed:@"l7"],
                                           [UIImage imageNamed:@"l8"],nil]];
    [_imageViewLoading setAnimationRepeatCount:0];
    [_imageViewLoading setAnimationDuration:0.8f];
    [_imageViewLoading startAnimating];
    [self addSubview:_imageViewLoading];
    [_imageViewLoading release];
    
    
    _contentView = [[UIView alloc] initWithFrame:frame];
    [self addSubview:_contentView];
    [_contentView release];
    [_contentView setBackgroundColor:[UIColor whiteColor]];
    //_contentView.layer.cornerRadius = 10.0f;
    //_contentView.layer.masksToBounds = YES;
    _contentView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _contentView.layer.borderWidth = 1.0f;
    
    _currentItemStatus = ItemNormalStatus;
    
    self.itemData = param;
    
    _itemBackImage = [[UIImageView alloc] initWithFrame:frame];
    //_itemBackImage.image = [UIImage imageNamed:@"bigitemimage.jpg"];
    
    _imageDownloader = [[KKFileDownloadManager alloc] init];
    [_imageDownloader downloadFile:[_itemData objectForKey:kXMLBigPic]
                         readCache:YES
                         saveCache:YES
                        completion:^(NSData *imageData){
                            _itemBackImage.image = [UIImage imageWithData:imageData];
                            [_imageViewLoading stopAnimating];
                            [_imageViewLoading removeFromSuperview];
        
    }];
    [_contentView addSubview:_itemBackImage];
    
    _lblTitle = [[UILabel alloc] initWithFrame:BOTTOM_TITLE_FRAME];
    [_lblTitle setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5]];
    [_lblTitle setText:[_itemData objectForKey:kXMLTitle]];
    [_lblTitle setFont:[UIFont systemFontOfSize:11.0f]];
    [_lblTitle setTextColor:[UIColor whiteColor]];
    [_lblTitle setTextAlignment:NSTextAlignmentCenter];
    [_contentView addSubview:_lblTitle];
    [_lblTitle release];
    
    _index = [[_itemData objectForKey:kXMLIndex] intValue];
    
    _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnClose setBackgroundImage:[UIImage imageNamed:@"itemclose"] forState:UIControlStateNormal];
    [_btnClose setFrame:CLOSE_BUTTON_FRAME];
    [_btnClose setHidden:YES];
    [_btnClose addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnClose];
    
    _tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [_tapGest setDelegate:self];
    //[_tapGest setCancelsTouchesInView:NO];
    [_contentView addGestureRecognizer:_tapGest];
    
    _longGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(viewLongPressed:)];
    [_longGest setDelegate:self];
    [self addGestureRecognizer:_longGest];
    
    _panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewPan:)];
    [_panGest setDelegate:self];
    [self addGestureRecognizer:_panGest];
    
    oldTransform = self.transform;
    
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ((gestureRecognizer == _panGest && otherGestureRecognizer == _longGest) || (gestureRecognizer == _longGest && otherGestureRecognizer == _panGest)) {
        return YES;
    } /*else if((gestureRecognizer == _panGest && otherGestureRecognizer == _tapGest) || (gestureRecognizer == _tapGest && otherGestureRecognizer == _panGest)) {
        return YES;
    }*/
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == _panGest) {
        return _pointIsHere;
    }
    return YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    
//    if (gestureRecognizer == _tapGest) {
//        if (_currentItemStatus == ItemNormalStatus) {
//            return YES;
//        } else {
//            if ([gestureRecognizer locationInView:self].x<_btnClose.frame.size.width && [gestureRecognizer locationInView:self].y<_btnClose.frame.size.height) {
//                return NO;
//            } else {
//                return YES;
//            }
//        }
//    }
//    return YES;
//}

- (void)closeButtonTapped {
    [self removeFromSuperview];
    [_delegate itemViewDidRemoved:self];
}

- (void)changeItemStatus:(NSNumber *)itemStatus {
    if (!_pointIsHere) {
        _currentItemStatus = [itemStatus intValue];
        if (_currentItemStatus == ItemDeletableStatus) {
            [_btnClose setHidden:NO];
            //[self removeGestureRecognizer:_tapGest];
            //[self removeGestureRecognizer:_longGest];
        } else if (_currentItemStatus == ItemNormalStatus){
            [_btnClose setHidden:YES];
            //[self addGestureRecognizer:_tapGest];
            //[self addGestureRecognizer:_longGest];
            
        }
    }
}

//- (void)shakeStatus {
//    if (_currentItemStatus == ItemNormalStatus || _currentItemStatus == ItemRemovableStatus) {
//        [self.layer removeAnimationForKey:@"shakeAnimation"];
//    } else {
//        if (![self.layer animationForKey:@"shakeAnimation"]) {
//            CGFloat rotation = 0.03;
//            
//            CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
//            shake.duration = 0.1f;
//            shake.autoreverses = YES;
//            shake.repeatCount  = MAXFLOAT;
//            shake.removedOnCompletion = NO;
//            shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform,-rotation, 0.0 ,0.0 ,1.0)];
//            shake.toValue   = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, rotation, 0.0 ,0.0 ,1.0)];
//            
//            [self.layer addAnimation:shake forKey:@"shakeAnimation"];
//        }
//    }
//}

- (void)viewPan:(UIPanGestureRecognizer *)gest {
    //NSLog(@"pan:%d",gest.state);
    if (_pointIsHere) {
        //[_delegate itemViewMovingWithIndex:_index andPoint:[gest locationInView:self.superview]];
        [_delegate itemViewMovingWithGesture:gest];
    }
}

- (void)viewLongPressed:(UILongPressGestureRecognizer *)gest {
    //NSLog(@"longPress:%d",gest.state);
    if (gest.state == UIGestureRecognizerStateBegan) {
        _currentItemStatus = ItemRemovableStatus;
        _pointIsHere = YES;
        [_btnClose setHidden:NO];
        [_delegate itemLongPressed:self];
        [UIView animateWithDuration:0.1f animations:^{
            self.alpha = 0.8f;
            CGAffineTransform newTransform = CGAffineTransformScale(self.transform, 1.1f, 1.1f);
            [self setTransform:newTransform];
        } completion:^(BOOL finished){
            //[self addGestureRecognizer:_panGest];
            //[_longGest setValue:UIGestureRecognizerStateBegan forKeyPath:@"_state"];
        }];
    } else if(gest.state == UIGestureRecognizerStateChanged) {
    } else if (gest.state == UIGestureRecognizerStateEnded) {
        //if (_moveBegan) return;
        _currentItemStatus = ItemDeletableStatus;
        _pointIsHere = NO;
        [UIView animateWithDuration:0.1f animations:^{
            self.alpha = 1.0f;
            [self setTransform:oldTransform];
        }completion:^(BOOL finished){
            //[self removeGestureRecognizer:_panGest];
            [_delegate itemViewDidMoved];
        }];
    }
}

- (void)viewTapped:(UITapGestureRecognizer *)gest {
    [_delegate itemTapped:self];
}

@end
