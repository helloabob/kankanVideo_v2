//
//  KKListViewController.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-30.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKListViewController.h"

@interface KKListViewController () {
    NSUInteger              _currentPageIndex;
    UITableView             *_tblVideoList;
    
}

@end

@implementation KKListViewController
@synthesize channelId = _channelId;

- (void)setChannelId:(NSString *)channelId {
    if (_channelId != channelId) {
        [_channelId release];
        _channelId = nil;
        _channelId = [channelId retain];
        _currentPageIndex = 0;
        
    }
}

- (void)dealloc {
    [_channelId release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"viewWillAppear");
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"viewWillDisappear");
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
