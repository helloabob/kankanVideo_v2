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

#define SCENE_FRAME                 CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)
#define RIGHT_SETTING_VIEW_FRAME    CGRectMake(250,0,70,self.view.frame.size.height)
#define ITEM_FRAME                  CGRectMake(0,0,100,100)

#define numPerPage                  (iPhone5?10:8)

@interface KKHomeViewController () {
    KKSceneView             *_sceneView;                   //封面界面
    KKListViewController    *_listViewController;          //列表界面
    NSMutableArray          *_itemArray;                   //itemView数组
    NSMutableArray          *_itemDataArray;               //item数据数组
    UIScrollView            *_contentScrollView;           //item所在滚动视图
    UIView                  *_rightSettingView;            //右侧控制按钮区域及返回normal状态热点
    KKFileDownloadManager   *_initDataDownloadManager;     //初始化数据加载器
}

@end

@implementation KKHomeViewController

//計算元素的坐標
- (CGRect)calculateRect:(u_int32_t)index {
    //const int numPerPage = iPhone5?10:8;
    u_int32_t x = 20;
    u_int32_t y = 10;
    int pages = index / numPerPage;
    x = x + (((index%2==1)?120:0) + pages * 320);
    y = y + (index - pages * numPerPage) / 2 * 110;
    return CGRectMake(x, y, 100, 100);
}

//整理界面上的item元素位置 并重新设置scrollview的尺寸
- (void)tidyItems {
    if (_itemArray.count == 0 && _itemDataArray.count > 0) {
        for (NSDictionary *dict in _itemDataArray) {
            KKHomeItemView *itemView = [[KKHomeItemView alloc] initWithFrame:ITEM_FRAME withParam:dict];
            [itemView setDelegate:self];
            [_contentScrollView addSubview:itemView];
            [_itemArray addObject:itemView];
            [itemView release];
        }
    }
    if (_itemArray.count > 0) {
        [UIView animateWithDuration:0.5f animations:^{
            for (u_int32_t i = 0; i < _itemArray.count; i ++) {
                KKHomeItemView *item = _itemArray[i];
                if (!item.pointIsHere) {
                    [item setFrame:[self calculateRect:item.index]];
                }
            }
        }];
        int pages;
        if (_itemArray.count == 0) {
            pages = 0;
        } else {
            pages = (_itemArray.count%numPerPage==0)?(_itemArray.count / numPerPage - 1):(_itemArray.count / numPerPage);
        }
        _contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width*(pages+1),self.view.frame.size.height);
        

    }
    //const int numPerPage = iPhone5?10:8;
        //NSLog(@"second_view_center_x:%f",((UIView *)_itemArray[1]).frame.origin.x);
}

- (void)dealloc {
    [_itemDataArray release];
    [_listViewController release];
    [_itemArray release];
    if (_initDataDownloadManager) {
        [_initDataDownloadManager release];
        _initDataDownloadManager = nil;
    }
    [super dealloc];
}

- (void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _sceneView = [[KKSceneView alloc] initWithFrame:SCENE_FRAME];
    [self.view addSubview:_sceneView];
    [_sceneView release];
    
    //[NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(timeout) userInfo:nil repeats:YES];
    
    
    //NSLog(@"%d",[_sceneView retainCount]);
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:SCENE_FRAME];
    [_contentScrollView setPagingEnabled:YES];
    [self.view addSubview:_contentScrollView];
    [_contentScrollView release];
    
    _rightSettingView = [[UIView alloc] initWithFrame:RIGHT_SETTING_VIEW_FRAME];
    [_rightSettingView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_rightSettingView];
    [_rightSettingView release];
    
    UIButton *btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRefresh setBackgroundImage:[UIImage imageNamed:@"home_button_refresh.png"] forState:UIControlStateNormal];
    [btnRefresh setFrame:CGRectMake(0, 0, 40, 40)];
    [btnRefresh setCenter:CGPointMake(_rightSettingView.frame.size.width/2, _rightSettingView.frame.size.height-4*50)];
    [_rightSettingView addSubview:btnRefresh];
    [btnRefresh release];
    
    UIButton *btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSetting setBackgroundImage:[UIImage imageNamed:@"home_button_setting"] forState:UIControlStateNormal];
    [btnSetting setFrame:CGRectMake(0, 0, 40, 40)];
    [btnSetting setCenter:CGPointMake(_rightSettingView.frame.size.width/2, _rightSettingView.frame.size.height-2*50)];
    [_rightSettingView addSubview:btnSetting];
    [btnSetting release];
    
    UIButton *btnSubScribe = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSubScribe setBackgroundImage:[UIImage imageNamed:@"home_button_subscribe"] forState:UIControlStateNormal];
    [btnSubScribe setFrame:CGRectMake(0, 0, 40, 40)];
    [btnSubScribe setCenter:CGPointMake(_rightSettingView.frame.size.width/2, _rightSettingView.frame.size.height-1*50)];
    [_rightSettingView addSubview:btnSubScribe];
    [btnSubScribe release];
    
    _itemDataArray = [[NSMutableArray alloc] initWithArray:[KKConfiguration getSubscriptionData]];
    _itemArray = [[NSMutableArray alloc] init];
    
    if (_itemDataArray.count == 0) {
        //try to init data from server
        _initDataDownloadManager = [[KKFileDownloadManager alloc] init];
        [_initDataDownloadManager downloadFile:kChannelListUrl
                                     readCache:YES
                                     saveCache:YES
                                    completion:^(NSData *xmldata){
                                        NSMutableArray *array = [KKXMLParser parseXML:xmldata withKeys:[NSArray arrayWithObjects:kXMLTitle,
                                                    kXMLBigPic,
                                                    kXMLSmallPic,
                                                    kXMLPubDate,
                                                    kXMLClassId,
                                                    kXMLPname,
                                                    kXMLIsGood,
                                                    kXMLFirstTitle,nil]];
                                        if (array.count > 0) {
                                            for (int i=0;i<array.count;i++) {
                                                NSMutableDictionary *dict = [array objectAtIndex:i];
                                                if ([[dict objectForKey:kXMLIsGood] intValue] > 0 || [[dict objectForKey:kXMLFirstTitle] intValue] > 0) {
                                                    [dict setObject:[NSNumber numberWithInt:i] forKey:kXMLIndex];
                                                    //[_itemArray addObject:dict];
                                                    [_itemDataArray addObject:dict];
                                                }
                                            }
                                            if (_itemArray.count > 0) {
                                                [self tidyItems];
                                            }
                                        }
        }];
    }
    
    
//    for (u_int32_t i = 0; i < 10; i ++) {
//        NSArray *arr = [NSArray arrayWithObject:[NSString stringWithFormat:@"达人秀%d",i]];
//        KKHomeItemView *itemView = [[KKHomeItemView alloc] initWithFrame:ITEM_FRAME withParam:arr];
//        [_contentScrollView addSubview:itemView];
//        [itemView setDelegate:self];
//        [itemView setIndex:i];
//        [itemView release];
//        
//        [_itemArray addObject:itemView];
//    }
    
    [self.view setClipsToBounds:YES];
    [self.view bringSubviewToFront:_sceneView];
    
    [self tidyItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma KKHomeItemViewDelegate

- (void)itemTapped:(KKHomeItemView *)itemView {
    if (!_listViewController) {
        _listViewController = [[KKListViewController alloc] init]; 
    }
    //if (itemView.currentItemStatus == ItemNormalStatus) {
        [self.navigationController pushViewController:_listViewController animated:YES];
    //} else {
    //    [_itemArray makeObjectsPerformSelector:@selector(changeItemStatus:) withObject:[NSNumber numberWithInt:ItemNormalStatus]];
    //}
}

- (void)itemLongPressed:(KKHomeItemView *)itemView {
    [_itemArray makeObjectsPerformSelector:@selector(changeItemStatus:) withObject:[NSNumber numberWithInt:ItemDeletableStatus]];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reviseItemNormal:)];
    [_rightSettingView addGestureRecognizer:tapGest];
    [tapGest release];
    [_contentScrollView bringSubviewToFront:itemView];
}

- (void)itemViewDidRemoved:(KKHomeItemView *)homeItemView {
    [_itemArray removeObject:homeItemView];
    int removedItemIndex = homeItemView.index;
    for (KKHomeItemView *item in _itemArray) {
        if (item.index > removedItemIndex) {
            item.index --;
        }
    }
    [self tidyItems];
}

- (void)itemViewMovingWithGesture:(UIPanGestureRecognizer *)gest {
    KKHomeItemView *currentItemView = (KKHomeItemView *)gest.view;
    CGPoint point = [gest locationInView:_contentScrollView];
    [currentItemView setCenter:point];
    
//    _contentScrollView.contentOffset
    
//    if (point.x >= 270) {
//        [UIView animateWithDuration:0.5f animations:^{
//            _contentScrollView.contentOffset = CGPointMake(320, 0);
//        }];
//        
//    } else {
    
        for (KKHomeItemView *each in _itemArray) {
            if (each != currentItemView) {
                //check the pengzhuang
                if ((point.x >= each.center.x - 20) && (point.x <= each.center.x + 20) && (point.y >= each.center.y - 20) && (point.y <= each.center.y + 20)) {
                    [self exchangeIndex:each.index withIndex:currentItemView.index];
                    break;
                }
            }
        }
    //}
}

- (void)itemViewDidMoved {
    [self tidyItems];
}

#pragma end

- (void)exchangeIndex:(NSInteger)oldIndex withIndex:(NSInteger)newIndex {
    if (oldIndex < newIndex) {
        for (KKHomeItemView *item in _itemArray) {
            if (item.index >= oldIndex && item.index < newIndex) {
                item.index ++;
            } else if (item.index == newIndex) {
                item.index = oldIndex;
            }
        }
    } else if (oldIndex > newIndex) {
        for (KKHomeItemView *item in _itemArray) {
            if (item.index <= oldIndex && item.index > newIndex) {
                item.index --;
            } else if (item.index == newIndex) {
                item.index = oldIndex;
            }
        }
    }
    [self tidyItems];
}

- (void)reviseItemNormal:(UITapGestureRecognizer *)gest {
    [_itemArray makeObjectsPerformSelector:@selector(changeItemStatus:) withObject:[NSNumber numberWithInt:ItemNormalStatus]];
    [_rightSettingView removeGestureRecognizer:gest];
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
