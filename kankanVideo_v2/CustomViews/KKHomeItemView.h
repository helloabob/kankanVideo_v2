//
//  KKHomeItemView.h
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-30.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKHomeItemView;

typedef enum {
    ItemNormalStatus = 0,
    ItemDeletableStatus,
    ItemRemovableStatus,
} ItemStatus;

@protocol KKHomeItemViewDelegate
@required
- (void) itemTapped;
- (void) itemLongPressed;
- (void) itemViewDidRemoved:(KKHomeItemView *)homeItemView;

@end

@interface KKHomeItemView : UIView<UIGestureRecognizerDelegate>

@property(nonatomic, assign)id<KKHomeItemViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame withParam:(NSArray *)param;


@end
