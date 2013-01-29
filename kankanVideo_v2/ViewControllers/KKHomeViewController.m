//
//  KKHomeViewController.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-29.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKHomeViewController.h"
#import "KKSceneView.h"

@interface KKHomeViewController () {
    KKSceneView *_sceneView;
}

@end

@implementation KKHomeViewController

- (void)loadView {
    [super loadView];
    [self.navigationController setNavigationBarHidden:YES];
    _sceneView = [[KKSceneView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_sceneView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
