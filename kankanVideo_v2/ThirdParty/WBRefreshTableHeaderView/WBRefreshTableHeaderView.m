//
//  EPGTableController.m
//  Test2122
//
//  Created by wangbo-ms on 13-2-5.
//  Copyright (c) 2013年 wangbo-ms. All rights reserved.
//

#import "WBRefreshTableHeaderView.h"

#define kWBRefreshTableHeaderViewHeight     60
#define kStatusLableFrame                   CGRectMake(0,self.frame.size.height-40,self.frame.size.width,20)
#define kLastTimeFrame                      CGRectMake(0,self.frame.size.height-20,self.frame.size.width,15)

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

#define kWBRefreshTableHeaderViewKey        @"kWBRefreshTableHeaderViewKey"

@interface WBRefreshTableHeaderView() {
    UIActivityIndicatorView             *_activityView;
    UILabel                             *_lblStatus;
    UILabel                             *_lblLastTime;
    WBPullRefreshState                  _state;
}

@end

@implementation WBRefreshTableHeaderView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
        _lblStatus = [[UILabel alloc] initWithFrame:kStatusLableFrame];
        [_lblStatus setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [_lblStatus setTextAlignment:NSTextAlignmentCenter];
        [_lblStatus setBackgroundColor:[UIColor clearColor]];
        [_lblStatus setTextColor:TEXT_COLOR];
        [self addSubview:_lblStatus];
        [_lblStatus release];
        
        _lblLastTime = [[UILabel alloc] initWithFrame:kLastTimeFrame];
        [_lblLastTime setFont:[UIFont boldSystemFontOfSize:11.0f]];
        [_lblLastTime setTextAlignment:NSTextAlignmentCenter];
        [_lblLastTime setBackgroundColor:[UIColor clearColor]];
        [_lblLastTime setTextColor:TEXT_COLOR];
        [self addSubview:_lblLastTime];
        [_lblLastTime release];
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:kWBRefreshTableHeaderViewKey]) {
            NSString *never = @"从未刷新";
            [_lblLastTime setText:never];
            [[NSUserDefaults standardUserDefaults] setObject:never forKey:kWBRefreshTableHeaderViewKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            [_lblLastTime setText:[[NSUserDefaults standardUserDefaults] objectForKey:kWBRefreshTableHeaderViewKey]];
        }
        
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityView setFrame:CGRectMake(50, frame.size.height-38, 20, 20)];
        [self addSubview:_activityView];
        [_activityView release];
        
        [self setState:WBPullRefreshNormal];
    }
    
    NSLog(@"state:%d",_state);
    return self;
}

- (void)setState:(WBPullRefreshState)state {
    switch (state) {
        case WBPullRefreshPulling:
            [_lblStatus setText:@"松开刷新"];
            break;
        case WBPullRefreshNormal:
            [_lblStatus setText:@"下拉可刷新"];
            [_activityView stopAnimating];
            break;
        case WBPullRefreshLoading:
            [_lblStatus setText:@"载入中..."];
            [_activityView startAnimating];
            break;
        default:
            break;
    }
    _state = state;
}

- (void)wbRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
    if (_state == WBPullRefreshLoading) {
        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, kWBRefreshTableHeaderViewHeight);
        scrollView.contentInset = UIEdgeInsetsMake(offset, 0, 0, 0);
    } else if (scrollView.isDragging) {
        BOOL _isloading = NO;
        if ([_delegate respondsToSelector:@selector(wbRefreshTableHeaderDataSourceIsLoading)]) {
            _isloading = [_delegate wbRefreshTableHeaderDataSourceIsLoading];
        }
        NSLog(@"%f and loading:%d and state:%d",scrollView.contentOffset.y,(0 - kWBRefreshTableHeaderViewHeight),_state);
        if (_isloading == NO
            && scrollView.contentOffset.y < (0 - kWBRefreshTableHeaderViewHeight)
            && _state == WBPullRefreshNormal) {
            [self setState:WBPullRefreshPulling];
        } else if (_isloading == NO
                   && _state == WBPullRefreshPulling
                   && scrollView.contentOffset.y > (0 - kWBRefreshTableHeaderViewHeight)
                   && scrollView.contentOffset.y < 0) {
            [self setState:WBPullRefreshNormal];
        }
    }
}

- (void)wbRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    BOOL _isloading = NO;
    if ([_delegate respondsToSelector:@selector(wbRefreshTableHeaderDataSourceIsLoading)]) {
        _isloading = [_delegate wbRefreshTableHeaderDataSourceIsLoading];
    }
    if (_isloading == NO && scrollView.contentOffset.y < (0 - kWBRefreshTableHeaderViewHeight)) {
        if ([_delegate respondsToSelector:@selector(wbRefreshTableHeaderDidTrigger)]) {
            [_delegate wbRefreshTableHeaderDidTrigger];
        }
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        scrollView.contentInset = UIEdgeInsetsMake(kWBRefreshTableHeaderViewHeight, 0, 0, 0);
        [UIView commitAnimations];
        [self setState:WBPullRefreshLoading];
    }
}

- (void)wbRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    scrollView.contentInset = UIEdgeInsetsZero;
    [UIView commitAnimations];
    [self setState:WBPullRefreshNormal];
    [self refreshLastTime];
}

- (void)refreshLastTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setAMSymbol:@"上午"];
    [formatter setPMSymbol:@"下午"];
    [formatter setDateFormat:@"yyyy-MM-dd a hh:mm"];
    _lblLastTime.text = [NSString stringWithFormat:@"最后更新: %@", [formatter stringFromDate:date]];
    [[NSUserDefaults standardUserDefaults] setObject:_lblLastTime.text forKey:kWBRefreshTableHeaderViewKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [formatter release];
}

@end
