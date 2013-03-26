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
    UILabel                     *_lblPubdate;           //发布时间
    UILabel                     *_lblPubtime;           //发布时间
    UIButton                    *_playButton;           //播放按钮
    UIScrollView                *_introScrollView;      //简介scroll视图
    UILabel                     *_lblIntro;             //简介
    
    NSString                    *_videoUrl;             //视频地址
    
}


@property(nonatomic,retain)NSString     *videoUrl;
@property(nonatomic,retain)NSDictionary *metaData;

@end
