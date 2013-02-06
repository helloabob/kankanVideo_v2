//
//  KKListViewController.h
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-1-30.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBRefreshTableHeaderView.h"
#import "KKListTableViewCell.h"

@interface KKListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,WBRefreshTableHeaderViewDelegate>

@property(nonatomic,retain) NSString *channelId;

@end
