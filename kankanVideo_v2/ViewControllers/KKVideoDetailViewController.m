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
    [_lblTitle setText:[_metaData objectForKey:kXMLTitle]];
    [_lblIntro setText:[NSString stringWithFormat:@"简介：%@",[_metaData objectForKey:kXMLIntro]]];
    [_lblIntro sizeToFit];
    KKFileDownloadManager *dm = [[[KKFileDownloadManager alloc] init] autorelease];
    [dm downloadFile:[_metaData objectForKey:kXMLTitlePic]
           readCache:YES
           saveCache:YES
          completion:^(NSData *imageData){
              _iconImageView.image = [UIImage imageWithData:imageData];
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
    }
    
    if (!_secondView) {
        _secondView = [[UIView alloc] initWithFrame:CGRectMake(10, 210, 300, 416+(iPhone5?88:0)-40-10-210)];
        _secondView.layer.borderWidth = 1.0f;
        _secondView.layer.borderColor = [[UIColor grayColor] CGColor];
        _secondView.layer.masksToBounds = YES;
        _secondView.layer.cornerRadius = 10.0f;
        [self.view addSubview:_secondView];
        [_secondView release];
        
        _lblIntro = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, _secondView.bounds.size.height-20)];
        [_lblIntro setFont:[UIFont systemFontOfSize:12.0f]];
        [_lblIntro setTextAlignment:NSTextAlignmentLeft];
        [_lblIntro setLineBreakMode:NSLineBreakByWordWrapping];
        [_lblIntro setNumberOfLines:0];
        //[_lblIntro sizeToFit];
        [_secondView addSubview:_lblIntro];
        [_lblIntro release];
    }
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 416+(iPhone5?88:0)-40, 320, 40)];
        _bottomView.layer.borderColor = [[UIColor grayColor] CGColor];
        _bottomView.layer.borderWidth = 1.0f;
        [self.view addSubview:_bottomView];
        [_bottomView release];
    }
    
}

- (void)selectBackAction:(UIEvent *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
