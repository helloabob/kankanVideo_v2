//
//  KKListTableViewCell.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-2-6.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKListTableViewCell.h"

#import <QuartzCore/QuartzCore.h>

@interface KKListTableViewCell() {
    BOOL                            _isDownloaded;
    UIImageView                     *_videoIconImageView;
    UILabel                         *_lblTitle;
}

@end

@implementation KKListTableViewCell
@synthesize cellData = _cellData;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.textLabel.font = [UIFont systemFontOfSize:12.0f];
//        [self.textLabel setFrame:CGRectMake(100, 5, 200, self.frame.size.height/2)];
//        self.textLabel.backgroundColor = [UIColor blackColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _videoIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 3, 92, 69)];
        _videoIconImageView.layer.cornerRadius = 10.0f;
        _videoIconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_videoIconImageView];
        [_videoIconImageView release];
        
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 210, 45)];
        [_lblTitle setLineBreakMode:NSLineBreakByWordWrapping];
        [_lblTitle setNumberOfLines:0];
        [_lblTitle setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [_lblTitle setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_lblTitle];
        [_lblTitle release];
    }
    return self;
}

- (void)setCellData:(NSDictionary *)cellData {
    if (_cellData != cellData) {
        [_cellData release];
        _cellData = [cellData retain];
        [self initData];
    }
}

- (void)initData {
//    self.textLabel.text = [_cellData objectForKey:kXMLTitle];
    [_lblTitle setText:[_cellData objectForKey:kXMLTitle]];
    NSString *strPic = [KKFileDownloadManager cacheFilePath:[_cellData objectForKey:kXMLTitlePic]];
    //NSLog(@"%@",strPic);
    if (strPic != nil) {
        _isDownloaded = YES;
        _videoIconImageView.image = [UIImage imageWithContentsOfFile:strPic];
        //[self resizeImageView];
    } else {
        _isDownloaded = NO;
        _videoIconImageView.image = [UIImage imageNamed:@"listback"];
        //[self resizeImageView];
    }
    
}

- (void)resizeImageView {
    float sw=60/self.imageView.image.size.width;
    float sh=45/self.imageView.image.size.height;
    self.imageView.transform=CGAffineTransformMakeScale(sw,sh);
}

- (void)startToDownload {
    if (_cellData && _isDownloaded == NO) {
        KKFileDownloadManager *dm = [[[KKFileDownloadManager alloc] init] autorelease];
        [dm downloadFile:[_cellData objectForKey:kXMLTitlePic]
               readCache:YES
               saveCache:YES
              completion:^(NSData *imageData){
                  _videoIconImageView.image = [UIImage imageWithData:imageData];
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
