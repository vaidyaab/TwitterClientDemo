//
//  Tweet.m
//  TwitterClientDemo
//
//  Created by Abhijeet Vaidya on 6/29/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

-(id) initWithDictionary:(NSDictionary*) data {
    self = [super init];
    if(self){
        self.profileImageURL = data[@"user"][@"profile_image_url"];
        self.name = data[@"user"][@"name"];
        self.handle = data[@"user"][@"screen_name"];
        self.time = [self calculateElapsedTime:data[@"created_at"]];
        self.createdAt = data[@"created_at"];
        self.tweet = data[@"text"];
        self.retweetCount = [data[@"retweet_count"] integerValue];
        self.favoriteCount = [data[@"favorite_count"] integerValue];
        self.tweetId = data[@"id_str"];
        self.retweetedBy = data[@"retweeted_status"][@"user"][@"name"];

    }
    return self;
}

-(NSString*) calculateElapsedTime: (NSString*) createdAt {
    
    if(!self.time){
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
        NSDate *createdDate = [formatter dateFromString:createdAt];
        
        NSTimeInterval elapsedInterval = [createdDate timeIntervalSinceNow];
        
        int elapsedSeconds = (int) elapsedInterval * -1;
        
        if(elapsedSeconds < 60){
            self.time = [NSString stringWithFormat:@"now"];
        }else if (elapsedSeconds < 3600) {
			int minutes = elapsedSeconds / 60;
			self.time = [NSString stringWithFormat:@"%dm", minutes];
		}
		else if (elapsedSeconds < 86400) {
			int hours = elapsedSeconds / 3600;
			self.time = [NSString stringWithFormat:@"%dh", hours];
		}
		else if (elapsedSeconds < 31536000) {
			int days = elapsedSeconds / 86400;
			self.time = [NSString stringWithFormat:@"%dd", days];
		}
		else {
			int years = elapsedSeconds / 31536000;
			self.time = [NSString stringWithFormat:@"%dyr", years];
		}
        
    }
    
    return self.time;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.profileImageURL = [decoder decodeObjectForKey:@"profile_image_url"];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.handle = [decoder decodeObjectForKey:@"screen_name"];
    self.time = [decoder decodeObjectForKey:@"time"];
    self.tweet = [decoder decodeObjectForKey:@"text"];
    self.retweetCount = [decoder decodeIntegerForKey:@"retweet_count"];
    self.favoriteCount = [decoder decodeIntegerForKey:@"favorite_count"];
    self.createdAt = [decoder decodeObjectForKey:@"created_At"];
    self.tweetId = [decoder decodeObjectForKey:@"id_str"];
    self.retweetedBy = [decoder decodeObjectForKey:@"retweeted_by"];

    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.profileImageURL forKey:@"profile_image_url"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.handle forKey:@"screen_name"];
    [encoder encodeObject:self.time forKey:@"time"];
    [encoder encodeObject:self.tweet forKey:@"text"];
    [encoder encodeInteger:self.retweetCount forKey:@"retweet_count"];
    [encoder encodeInteger:self.favoriteCount forKey:@"favorite_count"];
    [encoder encodeObject:self.createdAt forKey:@"created_At"];
    [encoder encodeObject:self.tweetId forKey:@"id_str"];
    [encoder encodeObject:self.retweetedBy forKey:@"retweeted_by"];

}

@end
