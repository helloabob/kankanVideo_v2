//
//  KKHomeItemView.h
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-30.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKHomeItemViewDelegate
@required
- (void) itemTapped;

@end

@interface KKHomeItemView : UIView

@property(nonatomic, assign)id<KKHomeItemViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame withParam:(NSArray *)param;


@end
