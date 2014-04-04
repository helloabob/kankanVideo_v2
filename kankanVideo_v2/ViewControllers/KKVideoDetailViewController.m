//
//  KKVideoDetailViewController.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-2-11.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKVideoDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KKFileDownloadManager.h"
#import "KKMoviePlayerViewController.h"

#define accessToken(url) [[[[NSString stringWithFormat:@"api_key=mobile&m=vcontent&url=%@532c28d5412dd75bf975fb951c740a30",url] stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"] stringByReplacingOccurrencesOfString:@":" withString:@"%3A"] md5]

#define videoUrl(accToken,url) [NSString stringWithFormat:@"http://interface.kankanews.com/kkapi/mobile/mobileapin.php?api_key=mobile&access_token=%@&m=vcontent&url=%@", accToken, url]

#define detailBorderColor [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]

@interface KKVideoDetailViewController (){
    UIBarButtonItem                 *_leftButton;
}

@end

@implementation KKVideoDetailViewController
@synthesize metaData = _metaData;

- (void)dealloc {
    [_metaData release];
    [super dealloc];
}

- (void)setMetaData:(NSDictionary *)metaData {
    if (_metaData != metaData) {
        [_metaData release];
        _metaData = [metaData retain];
        [self updateData];
    }
}

- (void)updateData {
    self.videoUrl = nil;
    _playButton.enabled = NO;
    if (_lblTitle == nil) {
        [self performSelector:@selector(updateData) withObject:nil afterDelay:0.3f];
        return;
    }
    [_lblTitle setText:[_metaData objectForKey:kXMLTitle]];
    [_lblIntro setText:[NSString stringWithFormat:@"简介：%@",[_metaData objectForKey:kXMLIntro]]];
    //reset label frame to prevent the size bug.
    [_lblIntro setFrame:CGRectMake(0, 0, 280, _secondView.bounds.size.height-20)];
    [_lblIntro sizeToFit];
    [_introScrollView setContentSize:_lblIntro.frame.size];
    
    //get date and convert to the yyyy-MM-dd format.
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    df.timeZone = [NSTimeZone localTimeZone];
    NSDate *dt = [df dateFromString:[_metaData objectForKey:kXMLPubDate]];
    
    df.dateFormat = @"yyyy-MM-dd";
    _lblPubdate.text = [NSString stringWithFormat:@"日期: %@",[df stringFromDate:dt]];
    
    df.dateFormat = @"HH:mm:ss";
    _lblPubtime.text = [NSString stringWithFormat:@"时间: %@",[df stringFromDate:dt]];
    KKFileDownloadManager *dm = [[[KKFileDownloadManager alloc] init] autorelease];
    [dm downloadFile:[_metaData objectForKey:kXMLTitlePic]
           readCache:YES
           saveCache:YES
          completion:^(NSData *imageData){
              _iconImageView.image = [UIImage imageWithData:imageData];
    }];
    //[self performSelector:@selector(getVideoM3U8Url) withObject:nil afterDelay:1.0f];
    [self getVideoM3U8Url];
}

- (void)getVideoM3U8Url {
    NSString *url = videoUrl(accessToken([_metaData objectForKey:kXMLTitleUrl]), [_metaData objectForKey:kXMLTitleUrl]);
    KKFileDownloadManager *dm = [[[KKFileDownloadManager alloc] init] autorelease];
    [dm downloadFile:url
           readCache:YES
           saveCache:YES
          completion:^(NSData *xmlData){
              NSMutableArray *dict = [KKXMLParser parseXML:xmlData withKeys:[NSArray arrayWithObjects:kXMLVideoUrl, nil]];
              if (dict.count > 0 && [[dict objectAtIndex:0] objectForKey:kXMLVideoUrl]) {
                  self.videoUrl = [[dict objectAtIndex:0] objectForKey:kXMLVideoUrl];
                  [_playButton setEnabled:YES];
              }
          }];
}

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
    NSLog(@"videodetail_viewdidload");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    
    if (!_leftButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 20, 25);
        [btn addTarget:self action:@selector(selectBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"left_button_icon"] forState:UIControlStateNormal];
        _leftButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    self.navigationItem.leftBarButtonItem = _leftButton;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, [KKSysUtils systemVersion]>=7.0?(self.view.bounds.size.height-64):(self.view.bounds.size.height-44))];
    [self.view addSubview:scrollView];
//    scrollView.backgroundColor = [UIColor grayColor];
    [scrollView release];
    
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 50)];
        [_lblTitle setFont:[UIFont boldSystemFontOfSize:15.0f]];
        [_lblTitle setTextAlignment:NSTextAlignmentCenter];
        [_lblTitle setLineBreakMode:NSLineBreakByWordWrapping];
        [_lblTitle setNumberOfLines:0];
        [_lblTitle setBackgroundColor:[UIColor clearColor]];
        [scrollView addSubview:_lblTitle];
        [_lblTitle release];
    }
    
    if (!_firstView) {
        _firstView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 300, 140)];
        _firstView.layer.borderWidth = 1.0f;
        _firstView.layer.borderColor = detailBorderColor;
        _firstView.layer.masksToBounds = YES;
        _firstView.layer.cornerRadius = 10.0f;
        [scrollView addSubview:_firstView];
        [_firstView release];
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 160, 120)];
        _iconImageView.layer.cornerRadius = 10.0f;
        _iconImageView.layer.masksToBounds = YES;
        [_firstView addSubview:_iconImageView];
        [_iconImageView release];
        
        _lblPubdate = [[UILabel alloc] initWithFrame:CGRectMake(180, 10, 110, 20)];
        _lblPubdate.font = [UIFont systemFontOfSize:12.0f];
        _lblPubdate.textAlignment = NSTextAlignmentLeft;
        [_lblPubdate setBackgroundColor:[UIColor clearColor]];
        [_firstView addSubview:_lblPubdate];
        [_lblPubdate release];
        
        _lblPubtime = [[UILabel alloc] initWithFrame:CGRectMake(180, 35, 110, 20)];
        _lblPubtime.font = [UIFont systemFontOfSize:12.0f];
        _lblPubtime.textAlignment = NSTextAlignmentLeft;
        [_lblPubtime setBackgroundColor:[UIColor clearColor]];
        [_firstView addSubview:_lblPubtime];
        [_lblPubtime release];
        
        _playButton = [[[UIButton alloc] init] autorelease];
        [_playButton setTitle:@"播放" forState:UIControlStateNormal];
        [_playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_playButton setBackgroundColor:[UIColor grayColor]];
        [_playButton setFrame:CGRectMake(180, 90, 110, 30)];
        _playButton.layer.cornerRadius = 7.0f;
        [_playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        [_firstView addSubview:_playButton];
    }
    
    if (!_secondView) {
        _secondView = [[UIView alloc] initWithFrame:CGRectMake(10, 210, 300, scrollView.bounds.size.height-40-10-210)];
        _secondView.layer.borderWidth = 1.0f;
        _secondView.layer.borderColor = detailBorderColor;
        _secondView.layer.masksToBounds = YES;
        _secondView.layer.cornerRadius = 10.0f;
        [scrollView addSubview:_secondView];
        [_secondView release];
        
        _introScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, 280, _secondView.bounds.size.height-20)];
        [_secondView addSubview:_introScrollView];
        
        _lblIntro = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, _secondView.bounds.size.height-20)];
        [_lblIntro setFont:[UIFont systemFontOfSize:12.0f]];
        [_lblIntro setTextAlignment:NSTextAlignmentLeft];
        [_lblIntro setLineBreakMode:NSLineBreakByWordWrapping];
        [_lblIntro setNumberOfLines:0];
        [_lblIntro setBackgroundColor:[UIColor clearColor]];
        //[_lblIntro sizeToFit];
        [_introScrollView addSubview:_lblIntro];
        [_lblIntro release];
    }
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, scrollView.bounds.size.height-40, 320, 40)];
        _bottomView.layer.borderColor = detailBorderColor;
        _bottomView.layer.borderWidth = 1.0f;
        [scrollView addSubview:_bottomView];
        [_bottomView release];
        
//        UIButton *btnFavority = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        btnFavority.frame = CGRectMake(10, 5, 30, 30);
//        [btnFavority setTitle:@"收藏" forState:UIControlStateNormal];
//        [_bottomView addSubview:btnFavority];
//        
//        UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        btnShare.frame = CGRectMake(50, 5, 30, 30);
//        [btnShare setTitle:@"分享" forState:UIControlStateNormal];
//        [_bottomView addSubview:btnShare];
    }
    
}

- (void)playVideo {
    KKMoviePlayerViewController *pvc = [[KKMoviePlayerViewController alloc] initWithVideoUrl:self.videoUrl];
    NSLog(@"%@",self.videoUrl);
    [self presentModalViewController:pvc animated:YES];
    [pvc release];
}

- (void)selectBackAction:(UIEvent *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    [_playButton setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
