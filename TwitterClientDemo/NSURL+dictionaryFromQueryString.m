//
//  NSURL+NSURL_dictionaryFromQueryString.m
//  TwitterClientDemo
//
//  Created by Abhijeet Vaidya on 6/28/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import "NSURL+dictionaryFromQueryString.h"

@implementation NSURL (dictionaryFromQueryString)

-(NSDictionary *) dictionaryFromQueryString{
    
    NSString *query = [self query];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

@end
