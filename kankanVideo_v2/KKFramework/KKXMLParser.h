//
//  KKXMLParser.h
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-2-2.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKXMLParser : NSObject

+ (NSMutableArray *)parseXML:(NSData *)xmldata withKeys:(NSArray *)array;

@end
