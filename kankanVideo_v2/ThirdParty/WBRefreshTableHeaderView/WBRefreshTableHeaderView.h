//
//  EPGTableController.h
//  Test2122
//
//  Created by wangbo-ms on 13-2-5.
//  Copyright (c) 2013年 wangbo-ms. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WBPullRefreshPulling = 0,
    WBPullRefreshNormal,
    WBPullRefreshLoading,
}WBPullRefreshState;

typedef enum {
    WBPullRefreshRenew = 0,
    WBPullRefreshMore,
}WBPullRefreshType;

@protocol WBRefreshTableHeaderViewDelegate
@required
- (void)wbRefreshTableHeaderDidTrigger:(WBPullRefreshType)type;
- (BOOL)wbRefreshTableHeaderDataSourceIsLoading;
@optional
- (CGFloat)wbRefreshTableViewContentHeight;
@end

@interface WBRefreshTableHeaderView : UIView {
    id            _delegate;
}

@property(nonatomic,assign)id<WBRefreshTableHeaderViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withRefreshType:(WBPullRefreshType)type;

- (void)wbRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)wbRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)wbRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
