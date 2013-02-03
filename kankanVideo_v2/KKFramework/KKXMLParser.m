//
//  KKXMLParser.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-2-2.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKXMLParser.h"
#import "DDXMLDocument.h"

@implementation KKXMLParser

+ (NSMutableArray *)parseXML:(NSData *)xmldata withKeys:(NSArray *)array{
    NSMutableArray *mutableArray = [NSMutableArray array];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:xmldata options:0 error:nil];
    DDXMLElement *root = [doc rootElement];
    for (DDXMLElement *node in root.children) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (DDXMLElement *element in node.children) {
            for (NSString *key in array) {
                if ([key isEqualToString:element.name]) {
                    [dict setObject:[element.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:key];
                }
            }
        }
        [mutableArray addObject:dict];
    }
    [doc release];
    doc = nil;
    return mutableArray;
}

@end
