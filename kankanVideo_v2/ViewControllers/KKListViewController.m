//
//  KKListViewController.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-30.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKListViewController.h"

#define NAV_VIEW_FRAME              CGRectMake(0, 0, 320, self.view.frame.size.height-44)

@interface KKListViewController () {
    NSUInteger                      _currentPageIndex;
    UITableView                     *_tblVideoList;
    NSMutableArray                  *_arrVideoList;
    UIView                          *_listContentView;
    UIView                          *_scrollContentView;
    WBRefreshTableHeaderView        *_headerTableView;
    WBRefreshTableHeaderView        *_footerTableView;
    BOOL                            _isloading;
    WBPullRefreshType               refreshType;
}

@end

@implementation KKListViewController
@synthesize channelId = _channelId;

- (void)setChannelId:(NSString *)channelId {
    if (_channelId != channelId) {
        [_channelId release];
        _channelId = nil;
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
                                                                    ,kXMLPubDate, nil]]];
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
    if (_arrVideoList) {
        [_arrVideoList release];
        _arrVideoList = nil;
    }
    KKFileDownloadManager *dm = [[[KKFileDownloadManager alloc] init] autorelease];
    [dm downloadFile:kVideoListUrl(_channelId, _currentPageIndex)
           readCache:NO
           saveCache:NO
          completion:^(NSData *xmldata){
              _arrVideoList = [KKXMLParser parseXML:xmldata withKeys:[NSArray arrayWithObjects:kXMLTitle
                                                      ,kXMLTitleUrl
                                                      ,kXMLTitlePic
                                                      ,kXMLPubDate, nil]];
              [_arrVideoList retain];
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
    [_channelId release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //NSLog(@"listcontroller_viewdidload");
    //_arrVideoList = [[NSMutableArray alloc] init];
    
    _listContentView = [[UIView alloc] initWithFrame:NAV_VIEW_FRAME];
    [self.view addSubview:_listContentView];
    [_listContentView release];
    
    _tblVideoList = [[UITableView alloc] initWithFrame:_listContentView.frame];
    _tblVideoList.delegate = self;
    _tblVideoList.dataSource = self;
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

    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    //UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(selectRightAction:)];
    //UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Posterous"] style:UIBarButtonItemStyleBordered target:self action:@selector(selectRightAction:)];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"Posterous"] forState:UIControlStateNormal];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)selectRightAction:(UIEvent *)sender {
    NSLog(@"aa");
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_arrVideoList) {
        return _arrVideoList.count;
    }
    return 0;
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
