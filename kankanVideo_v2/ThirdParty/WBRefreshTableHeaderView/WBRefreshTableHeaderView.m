//
//  EPGTableController.m
//  Test2122
//
//  Created by wangbo-ms on 13-2-5.
//  Copyright (c) 2013年 wangbo-ms. All rights reserved.
//

#import "WBRefreshTableHeaderView.h"

#define kWBRefreshTableHeaderViewHeight             60

#define kStatusLabelRenewFrame                      CGRectMake(0,self.frame.size.height-40,self.frame.size.width,20)
#define kStatusLabelMoreFrame                       CGRectMake(0,5,self.frame.size.width,20)

#define kActivityViewRenewFrame                     CGRectMake(50,frame.size.height-38, 20, 20)
#define kActivityViewMoreFrame                      CGRectMake(50,5,20,20)

#define kLastTimeFrame                              CGRectMake(0,self.frame.size.height-20,self.frame.size.width,15)

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

#define kWBRefreshTableHeaderViewKey        @"kWBRefreshTableHeaderViewKey"

@interface WBRefreshTableHeaderView() {
    UIActivityIndicatorView             *_activityView;
    UILabel                             *_lblStatus;
    UILabel                             *_lblLastTime;
    WBPullRefreshState                  _state;
    WBPullRefreshType                   _type;
}

@end

@implementation WBRefreshTableHeaderView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame withRefreshType:(WBPullRefreshType)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
        _type = type;
        
        _lblStatus = [[UILabel alloc] init];
        [_lblStatus setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [_lblStatus setTextAlignment:NSTextAlignmentCenter];
        [_lblStatus setBackgroundColor:[UIColor clearColor]];
        [_lblStatus setTextColor:TEXT_COLOR];
        [self addSubview:_lblStatus];
        [_lblStatus release];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityView];
        [_activityView release];
        
        if (_type == WBPullRefreshRenew) {
            [_lblStatus setFrame:kStatusLabelRenewFrame];
            [_activityView setFrame:kActivityViewRenewFrame];
            
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
        } else {
            [_lblStatus setFrame:kStatusLabelMoreFrame];
            [_activityView setFrame:kActivityViewMoreFrame];
        }
        [self setState:WBPullRefreshNormal];
    }
    return self;
}

- (void)setState:(WBPullRefreshState)state {
    switch (state) {
        case WBPullRefreshPulling:
            [_lblStatus setText:(_type==WBPullRefreshRenew)?@"松开刷新":@"松开加载更多"];
            break;
        case WBPullRefreshNormal:
            [_lblStatus setText:(_type==WBPullRefreshRenew)?@"下拉刷新":@"下拉加载更多"];
            [_activityView stopAnimating];
            break;
        case WBPullRefreshLoading:
            [_lblStatus setText:@"加载中.."];
            [_activityView startAnimating];
            break;
        default:
            break;
    }
    _state = state;
}

- (void)wbRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
    if (_type == WBPullRefreshRenew) {
        if (_state == WBPullRefreshLoading) {
            CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
            offset = MIN(offset, kWBRefreshTableHeaderViewHeight);
            scrollView.contentInset = UIEdgeInsetsMake(offset, 0, 0, 0);
        } else if (scrollView.isDragging) {
            BOOL _isloading = NO;
            if ([_delegate respondsToSelector:@selector(wbRefreshTableHeaderDataSourceIsLoading)]) {
                _isloading = [_delegate wbRefreshTableHeaderDataSourceIsLoading];
            }
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
    } else if (_type == WBPullRefreshMore && [_delegate respondsToSelector:@selector(wbRefreshTableViewContentHeight)]){
        CGFloat contentHeight = [_delegate wbRefreshTableViewContentHeight];
        [self setFrame:CGRectMake(0, contentHeight, 320, scrollView.frame.size.height)];
        if (_state == WBPullRefreshLoading) {
            //scrollView.contentOffset = CGPointMake(0,contentHeight + kWBRefreshTableHeaderViewHeight - scrollView.frame.size.height);
        } else if (scrollView.isDragging) {
            BOOL _isloading = NO;
            if ([_delegate respondsToSelector:@selector(wbRefreshTableHeaderDataSourceIsLoading)]) {
                _isloading = [_delegate wbRefreshTableHeaderDataSourceIsLoading];
            }
            //NSLog(@"%f and loading:%f and state:%d",scrollView.contentOffset.y,[_delegate wbRefreshTableViewContentHeight]-scrollView.frame.size.height,_state);
            //NSLog(@"%f now:%f",contentHeight+kWBRefreshTableHeaderViewHeight-scrollView.frame.size.height,scrollView.contentOffset.y);
            if (_isloading == NO
                && scrollView.contentOffset.y > (contentHeight + kWBRefreshTableHeaderViewHeight - scrollView.frame.size.height)
                && _state == WBPullRefreshNormal) {
                [self setState:WBPullRefreshPulling];
            } else if (_isloading == NO
                       && _state == WBPullRefreshPulling
                       && scrollView.contentOffset.y < (contentHeight + kWBRefreshTableHeaderViewHeight - scrollView.frame.size.height)
                       && scrollView.contentOffset.y > 0) {
                [self setState:WBPullRefreshNormal];
            }
        }
    }
    if (_type == WBPullRefreshMore) {
    }
}

- (void)wbRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    if (_type == WBPullRefreshRenew) {
        BOOL _isloading = NO;
        if ([_delegate respondsToSelector:@selector(wbRefreshTableHeaderDataSourceIsLoading)]) {
            _isloading = [_delegate wbRefreshTableHeaderDataSourceIsLoading];
        }
        if (_isloading == NO && scrollView.contentOffset.y < (0 - kWBRefreshTableHeaderViewHeight)) {
            if ([_delegate respondsToSelector:@selector(wbRefreshTableHeaderDidTrigger:)]) {
                [_delegate wbRefreshTableHeaderDidTrigger:_type];
            }
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3f];
            scrollView.contentInset = UIEdgeInsetsMake(kWBRefreshTableHeaderViewHeight, 0, 0, 0);
            [UIView commitAnimations];
            [self setState:WBPullRefreshLoading];
        }
    } else {
        BOOL _isloading = NO;
        if ([_delegate respondsToSelector:@selector(wbRefreshTableHeaderDataSourceIsLoading)]) {
            _isloading = [_delegate wbRefreshTableHeaderDataSourceIsLoading];
        }
        
        CGFloat contentHeight = [_delegate wbRefreshTableViewContentHeight];
        if (_isloading == NO && scrollView.contentOffset.y > (contentHeight + kWBRefreshTableHeaderViewHeight - scrollView.frame.size.height)) {
            if ([_delegate respondsToSelector:@selector(wbRefreshTableHeaderDidTrigger:)]) {
                [_delegate wbRefreshTableHeaderDidTrigger:_type];
            }
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3f];
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, kWBRefreshTableHeaderViewHeight, 0);
            [UIView commitAnimations];
            [self setState:WBPullRefreshLoading];
        }
    }
}

- (void)wbRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    scrollView.contentInset = UIEdgeInsetsZero;
    [UIView commitAnimations];
    [self setState:WBPullRefreshNormal];
    if (_type == WBPullRefreshRenew) {
        [self refreshLastTime];
    } else {
        CGFloat contentHeight = [_delegate wbRefreshTableViewContentHeight];
        [self setFrame:CGRectMake(0, contentHeight, 320, scrollView.frame.size.height)];
    }
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
