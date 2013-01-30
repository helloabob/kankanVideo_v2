//
//  KKHomeViewController.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-29.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKHomeViewController.h"
#import "KKSceneView.h"
#import "KKListViewController.h"

#define SCENE_FRAME         CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)
#define HOME_ITEM_FRAME     CGRectMake(10,30,120,90)
#define HOME_ITEM2_FRAME    CGRectMake(140,30,120,90)

@interface KKHomeViewController () {
    KKSceneView *_sceneView;
    KKListViewController *_listViewController;
    UILabel *_str;
}

@end

@implementation KKHomeViewController

- (CGRect)calculateRect:(u_int32_t)index {
    const int numPerPage = iPhone5?10:8;
    u_int32_t x = 10;
    u_int32_t y = 20;
    int pages = index / numPerPage;
    x = x + ((index%2==1)?130:0 + pages * 320);
    y = y + (index - pages * numPerPage) / 2 * 100;
    return CGRectMake(x, y, 120, 90);
}

- (void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _sceneView = [[KKSceneView alloc] initWithFrame:SCENE_FRAME];
    [self.view addSubview:_sceneView];
    [_sceneView release];
    
    NSArray *arr = [NSArray arrayWithObject:@"测试"];
    
    for (u_int32_t i = 0; i < 10; i ++) {
        KKHomeItemView *itemView = [[KKHomeItemView alloc] initWithFrame:[self calculateRect:i] withParam:arr];
        [self.view addSubview:itemView];
        [itemView setDelegate:self];
        [itemView release];
    }
    [self.view setClipsToBounds:YES];
    
    [self.view bringSubviewToFront:_sceneView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)itemTapped {
    if (!_listViewController) {
        _listViewController = [[KKListViewController alloc] init]; 
    }
    [self.navigationController pushViewController:_listViewController animated:YES];
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
