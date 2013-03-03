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

#define accessToken(url) [[[[NSString stringWithFormat:@"api_key=mobile&m=vcontent&url=%@532c28d5412dd75bf975fb951c740a30",url] stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"] stringByReplacingOccurrencesOfString:@":" withString:@"%3A"] md5]

#define videoUrl(accToken,url) [NSString stringWithFormat:@"http://interface.kankanews.com/kkapi/mobile/mobileapin.php?api_key=mobile&access_token=%@&m=vcontent&url=%@", accToken, url]

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
    _videoUrl = nil;
    [_lblTitle setText:[_metaData objectForKey:kXMLTitle]];
    [_lblIntro setText:[NSString stringWithFormat:@"简介：%@",[_metaData objectForKey:kXMLIntro]]];
    //reset label frame to prevent the size bug.
    [_lblIntro setFrame:CGRectMake(0, 0, 280, _secondView.bounds.size.height-20)];
    [_lblIntro sizeToFit];
    [_introScrollView setContentSize:_lblIntro.frame.size];
    _lblPubdate.text = [NSString stringWithFormat:@"日期:%@",[_metaData objectForKey:kXMLPubDate]];
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
                  _videoUrl = [[dict objectAtIndex:0] objectForKey:kXMLVideoUrl];
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
    
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 50)];
        [_lblTitle setFont:[UIFont boldSystemFontOfSize:15.0f]];
        [_lblTitle setTextAlignment:NSTextAlignmentCenter];
        [_lblTitle setLineBreakMode:NSLineBreakByWordWrapping];
        [_lblTitle setNumberOfLines:0];
        [_lblTitle setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:_lblTitle];
        [_lblTitle release];
    }
    
    if (!_firstView) {
        _firstView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 300, 140)];
        _firstView.layer.borderWidth = 1.0f;
        _firstView.layer.borderColor = [[UIColor grayColor] CGColor];
        _firstView.layer.masksToBounds = YES;
        _firstView.layer.cornerRadius = 10.0f;
        [self.view addSubview:_firstView];
        [_firstView release];
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 160, 120)];
        _iconImageView.layer.cornerRadius = 10.0f;
        _iconImageView.layer.masksToBounds = YES;
        [_firstView addSubview:_iconImageView];
        [_iconImageView release];
        
        _lblPubdate = [[UILabel alloc] initWithFrame:CGRectMake(180, 10, 110, 20)];
        _lblPubdate.font = [UIFont systemFontOfSize:11.0f];
        _lblPubdate.textAlignment = NSTextAlignmentLeft;
        [_lblPubdate setBackgroundColor:[UIColor clearColor]];
        [_firstView addSubview:_lblPubdate];
        [_lblPubdate release];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_playButton setTitle:@"播放" forState:UIControlStateNormal];
        [_playButton setFrame:CGRectMake(180, 90, 110, 30)];
        [_playButton setEnabled:NO];
        [_firstView addSubview:_playButton];
    }
    
    if (!_secondView) {
        _secondView = [[UIView alloc] initWithFrame:CGRectMake(10, 210, 300, 416+(iPhone5?88:0)-40-10-210)];
        _secondView.layer.borderWidth = 1.0f;
        _secondView.layer.borderColor = [[UIColor grayColor] CGColor];
        _secondView.layer.masksToBounds = YES;
        _secondView.layer.cornerRadius = 10.0f;
        [self.view addSubview:_secondView];
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
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 416+(iPhone5?88:0)-40, 320, 40)];
        _bottomView.layer.borderColor = [[UIColor grayColor] CGColor];
        _bottomView.layer.borderWidth = 1.0f;
        [self.view addSubview:_bottomView];
        [_bottomView release];
        
        UIButton *btnFavority = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnFavority.frame = CGRectMake(10, 5, 30, 30);
        [btnFavority setTitle:@"收藏" forState:UIControlStateNormal];
        [_bottomView addSubview:btnFavority];
        
        UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnShare.frame = CGRectMake(50, 5, 30, 30);
        [btnShare setTitle:@"分享" forState:UIControlStateNormal];
        [_bottomView addSubview:btnShare];
    }
    
}

- (void)selectBackAction:(UIEvent *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _videoUrl = nil;
    [_playButton setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
