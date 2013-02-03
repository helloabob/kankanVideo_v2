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
- (void) itemTapped:(KKHomeItemView *)itemView;
- (void) itemLongPressed:(KKHomeItemView *)itemView;
- (void) itemViewDidRemoved:(KKHomeItemView *)homeItemView;
- (void) itemViewMovingWithGesture:(UIPanGestureRecognizer *)gest;
- (void) itemViewDidMoved;

@end

@interface KKHomeItemView : UIView<UIGestureRecognizerDelegate>

@property(nonatomic, retain)NSDictionary *itemData;
@property(nonatomic, assign)id<KKHomeItemViewDelegate>delegate;
@property(nonatomic, assign)NSInteger index;                        //item的排列索引
@property(nonatomic, assign)BOOL pointIsHere;
@property(nonatomic, assign)ItemStatus currentItemStatus;

- (id)initWithFrame:(CGRect)frame withParam:(NSDictionary *)param;


@end
