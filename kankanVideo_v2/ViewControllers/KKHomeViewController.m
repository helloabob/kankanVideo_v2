//
//  KKHomeViewController.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-29.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKHomeViewController.h"
#import "KKSceneView.h"
#import "KKHomeItemView.h"

#define SCENE_FRAME CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)
#define HOME_ITEM_FRAME CGRectMake(0,0,30,30)

@interface KKHomeViewController () {
    KKSceneView *_sceneView;
}

@end

@implementation KKHomeViewController

- (void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:YES];
    
    _sceneView = [[KKSceneView alloc] initWithFrame:SCENE_FRAME];
    [self.view addSubview:_sceneView];
    [_sceneView release];
    
    KKHomeItemView *itemView = [[KKHomeItemView alloc] initWithFrame:HOME_ITEM_FRAME];
    [self.view addSubview:itemView];
    [itemView release];
    
    [self.view bringSubviewToFront:_sceneView];
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
