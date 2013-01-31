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
    KKSceneView             *_sceneView;                   //封面界面
    KKListViewController    *_listViewController;          //列表界面
    NSMutableArray          *_itemArray;                   //item数组
    UIScrollView            *_contentScrollView;           //item所在滚动视图
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

//整理界面上的item元素位置 并重新设置scrollview的尺寸
- (void)tidyItems {
    [UIView animateWithDuration:0.5f animations:^{
        for (u_int32_t i = 0; i < _itemArray.count; i ++) {
            UIView *item = _itemArray[i];
            [item setFrame:[self calculateRect:i]];
        }
    }];
    const int numPerPage = iPhone5?10:8;
    int pages = _itemArray.count / numPerPage;
    _contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width*(pages+1),self.view.frame.size.height);
}

- (void)dealloc {
    [_listViewController release];
    [_itemArray release];
    [super dealloc];
}

- (void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _sceneView = [[KKSceneView alloc] initWithFrame:SCENE_FRAME];
    [self.view addSubview:_sceneView];
    [_sceneView release];
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:SCENE_FRAME];
    [_contentScrollView setPagingEnabled:YES];
    [self.view addSubview:_contentScrollView];
    [_contentScrollView release];
    
    _itemArray = [[NSMutableArray alloc] init];
    
    NSArray *arr = [NSArray arrayWithObject:@"测试"];
    
    for (u_int32_t i = 0; i < 10; i ++) {
        KKHomeItemView *itemView = [[KKHomeItemView alloc] initWithFrame:[self calculateRect:i] withParam:arr];
        [_contentScrollView addSubview:itemView];
        [itemView setDelegate:self];
        [itemView release];
        
        [_itemArray addObject:itemView];
    }
    [self.view setClipsToBounds:YES];
    [self.view bringSubviewToFront:_sceneView];
    
    [self tidyItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma KKHomeItemViewDelegate

- (void)itemTapped {
    if (!_listViewController) {
        _listViewController = [[KKListViewController alloc] init]; 
    }
    [self.navigationController pushViewController:_listViewController animated:YES];
}

- (void)itemLongPressed {
    [_itemArray makeObjectsPerformSelector:@selector(changeItemStatus:) withObject:[NSNumber numberWithInt:ItemRemovableStatus]];
}

- (void)itemViewDidRemoved:(KKHomeItemView *)homeItemView {
    [_itemArray removeObject:homeItemView];
    [self tidyItems];
}

#pragma end

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
