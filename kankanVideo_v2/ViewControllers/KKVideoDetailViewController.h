//
//  KKVideoDetailViewController.h
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-2-11.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKVideoDetailViewController : UIViewController {
    NSDictionary                *_metaData;             //元数据
    UILabel                     *_lblTitle;             //标题
    UIView                      *_firstView;            //第一个圆形框
    UIView                      *_secondView;           //第二个圆形框
    UIView                      *_bottomView;           //底层视图
    UIImageView                 *_iconImageView;        //缩略图视图
    UILabel                     *_lblIntro;             //简介
    
}

@property(nonatomic,retain)NSDictionary *metaData;

@end
