//
//  KKMoviePlayerViewController.h
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-3-6.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface KKMoviePlayerViewController : UIViewController {
    MPMoviePlayerController                     *_playerController;  //playerback
    UIView                                      *_backgroundView;    //backgroundView
    NSString                                    *_url;
}

- (id)initWithVideoUrl:(NSString *)theUrl;

@property(nonatomic,retain) NSString                *url;
@property(retain) MPMoviePlayerController           *playerController;
@property(nonatomic,retain) UIView                  *backgroundView;

@end
