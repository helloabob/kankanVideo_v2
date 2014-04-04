//
//  KKListViewController.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-30.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKListViewController.h"
#import "KKVideoDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

//#define NAV_VIEW_FRAME              CGRectMake(0, 0, 320, self.view.frame.size.height-44)

@interface KKListViewController () {
    NSUInteger                      _currentPageIndex;              //当前页码索引
    UITableView                     *_tblVideoList;                 //uitableview视图
    NSMutableArray                  *_arrVideoList;                 //uitableview对应数组
    UIView                          *_listContentView;              //uitableview所在uiview
    UIView                          *_scrollContentView;            //scrollview所在uiview
    WBRefreshTableHeaderView        *_headerTableView;              //下拉刷新视图
    WBRefreshTableHeaderView        *_footerTableView;              //上拉刷新视图
    BOOL                            _isloading;                     //是否在加载数据
    WBPullRefreshType               refreshType;                    //刷新类型  上拉/下拉
    UIBarButtonItem                 *_rightButton;                  //右上角按钮，切换视图模式
    UIBarButtonItem                 *_leftButton;
    KKVideoDetailViewController     *_videoDetailViewController;    //视频详细播放页视图
}

@end

@implementation KKListViewController
@synthesize channelId = _channelId;

- (void)setChannelId:(NSString *)channelId {
    if (_channelId != channelId) {
        [_channelId release];
        _channelId = [channelId retain];
        [self refreshVideoList];
    }
}

- (void)loadMore {
    _currentPageIndex ++;
    KKFileDownloadManager *dm = [[[KKFileDownloadManager alloc] init] autorelease];
    //NSLog(@"%@",kVideoListUrl(_channelId, _currentPageIndex));
    [dm downloadFile:kVideoListUrl(_channelId, _currentPageIndex)
           readCache:NO
           saveCache:NO
          completion:^(NSData *xmldata){
              [_arrVideoList addObjectsFromArray:[KKXMLParser parseXML:xmldata
                                                              withKeys:[NSArray arrayWithObjects:kXMLTitle
                                                                      ,kXMLTitleUrl
                                                                      ,kXMLTitlePic
                                                                    ,kXMLPubDate
                                                                    ,kXMLIntro, nil]]];
              if (_tblVideoList) {
                  [_tblVideoList reloadData];
                  _isloading = NO;
                  if (refreshType == WBPullRefreshRenew) {
                      [_headerTableView wbRefreshScrollViewDataSourceDidFinishedLoading:_tblVideoList];
                  } else {
                      [_footerTableView wbRefreshScrollViewDataSourceDidFinishedLoading:_tblVideoList];
                  }
              }
          }];
}

- (void)refreshVideoList {
    _currentPageIndex = 1;
    
    KKFileDownloadManager *dm = [[[KKFileDownloadManager alloc] init] autorelease];
    [dm downloadFile:kVideoListUrl(_channelId, _currentPageIndex)
           readCache:NO
           saveCache:NO
          completion:^(NSData *xmldata){
              if (_arrVideoList) {
                  [_arrVideoList release];
                  _arrVideoList = nil;
              }
              _arrVideoList = [[NSMutableArray alloc] initWithArray:[KKXMLParser parseXML:xmldata withKeys:[NSArray arrayWithObjects:kXMLTitle
                                                      ,kXMLTitleUrl
                                                      ,kXMLTitlePic
                                                      ,kXMLPubDate
                                                      ,kXMLIntro, nil]]];
              if (_tblVideoList) {
                  [_tblVideoList reloadData];
                  _isloading = NO;
                  if (refreshType == WBPullRefreshRenew) {
                      [_headerTableView wbRefreshScrollViewDataSourceDidFinishedLoading:_tblVideoList];
                  } else {
                      [_footerTableView wbRefreshScrollViewDataSourceDidFinishedLoading:_tblVideoList];
                  }
              }
    }];
}

- (void)dealloc {
    [_leftButton release];
    [_rightButton release];
    [_channelId release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //NSLog(@"listcontroller_viewdidload");
    //_arrVideoList = [[NSMutableArray alloc] init];
    
    _scrollContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, [KKSysUtils systemVersion]>=7.0?self.view.bounds.size.height-64:self.view.bounds.size.height-44)];
    _scrollContentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollContentView];
    
    CGRect rect = CGRectMake(0, [KKSysUtils systemVersion]>=7.0?64:0, 320, [KKSysUtils systemVersion] >= 7.0?self.view.bounds.size.height-64:self.view.bounds.size.height-44);
    _listContentView = [[UIView alloc] initWithFrame:rect];
    [self.view addSubview:_listContentView];
    [_listContentView release];
    
    _tblVideoList = [[UITableView alloc] initWithFrame:_listContentView.bounds];
    _tblVideoList.delegate = self;
    _tblVideoList.dataSource = self;
    _tblVideoList.backgroundView = nil;
    _tblVideoList.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    [_listContentView addSubview:_tblVideoList];
    [_tblVideoList release];
    
    _headerTableView = [[WBRefreshTableHeaderView alloc]
                  initWithFrame:CGRectMake(0, 0-self.view.frame.size.height, 320, self.view.frame.size.height)
                  withRefreshType:WBPullRefreshRenew];
    [_tblVideoList addSubview:_headerTableView];
    _headerTableView.delegate = self;
    
    _footerTableView = [[WBRefreshTableHeaderView alloc]
                  initWithFrame:CGRectMake(0, -100, 320, 100)
                  withRefreshType:WBPullRefreshMore];
    [_tblVideoList addSubview:_footerTableView];
    [_footerTableView setDelegate:self];
    [_footerTableView release];

    
    if (!_rightButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 25, 25);
        [btn addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"right_button_scroll"] forState:UIControlStateNormal];
        _rightButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    self.navigationItem.rightBarButtonItem = _rightButton;
    
    if (!_leftButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 20, 25);
        [btn addTarget:self action:@selector(selectBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"left_button_icon"] forState:UIControlStateNormal];
        _leftButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    self.navigationItem.leftBarButtonItem = _leftButton;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)selectBackAction:(UIEvent *)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = @"rippleEffect";
    transition.type = @"oglFlip";
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectRightAction:(UIEvent *)sender {
    CATransition *animation=[CATransition animation];
    animation.delegate=self;
    animation.duration=0.5f;
    animation.timingFunction=UIViewAnimationCurveEaseInOut;
    animation.type=@"oglFlip";
    animation.subtype=kCATransitionFromLeft;
    [self.view.layer addAnimation:animation forKey:@"move in"];
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
}

- (void)viewWillDisappear:(BOOL)animated {
    //NSLog(@"viewWillDisappear");
    [super viewWillDisappear:animated];
}

#pragma WBPullRefreshHeaderView

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_headerTableView wbRefreshScrollViewDidEndDragging:scrollView];
    [_footerTableView wbRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_headerTableView wbRefreshScrollViewDidScroll:scrollView];
    [_footerTableView wbRefreshScrollViewDidScroll:scrollView];
}

- (void)wbRefreshTableHeaderDidTrigger:(WBPullRefreshType)type {
    if (type == WBPullRefreshMore) {
        refreshType = WBPullRefreshMore;
        [self loadMore];
    } else {
        refreshType = WBPullRefreshRenew;
        [self refreshVideoList];
    }
    _isloading = YES;
}

- (BOOL)wbRefreshTableHeaderDataSourceIsLoading {
    return _isloading;
}

- (CGFloat)wbRefreshTableViewContentHeight {
    return 75.0f * _arrVideoList.count;
}

#pragma end

#pragma UITableViewDelegate and UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"select:%d",indexPath.row);
    if (!_videoDetailViewController) {
        _videoDetailViewController = [[KKVideoDetailViewController alloc] init];
    }
    [self.navigationController pushViewController:_videoDetailViewController animated:YES];
    _videoDetailViewController.title = self.title;
    _videoDetailViewController.metaData = [_arrVideoList objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if (_arrVideoList) {
        rows = _arrVideoList.count;
    }
    if (rows == 0) {
        _footerTableView.hidden = YES;
    } else {
        _footerTableView.hidden = NO;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"kkListTableViewCell";
    KKListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[KKListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.cellData = [_arrVideoList objectAtIndex:indexPath.row];
    if (!tableView.isDragging) {
        [cell performSelector:@selector(startToDownload)];
    }
    return cell;
}

#pragma end

#pragma UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSArray *array = [_tblVideoList visibleCells];
    [array makeObjectsPerformSelector:@selector(startToDownload) withObject:nil];
}

#pragma end

@end
