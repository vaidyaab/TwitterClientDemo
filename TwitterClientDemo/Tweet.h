//
//  Tweet.h
//  TwitterClientDemo
//
//  Created by Abhijeet Vaidya on 6/29/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject <NSCoding>

@property (nonatomic,strong) NSString* tweetId;
@property (nonatomic,strong) NSString* profileImageURL;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* handle;
@property (nonatomic,strong) NSString* time;
@property (nonatomic,strong) NSString* tweet;
@property (nonatomic,strong) NSString* createdAt;
@property int retweetCount;
@property int favoriteCount;
@property (nonatomic,strong) NSString* retweetedBy;

-(id) initWithDictionary:(NSDictionary*) data;

@end
