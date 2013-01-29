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
    KKSceneView *sceneView;
}

@end

@implementation KKHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
