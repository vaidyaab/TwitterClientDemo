//
//  User.h
//  TwitterClientDemo
//
//  Created by Abhijeet Vaidya on 6/28/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserLoggedInNotification;
extern NSString * const UserLoggedOutNotification;
extern NSString * const currentUserKey;

@interface User : NSObject <NSCoding>

@property (strong, nonatomic) NSString *description;
@property int userId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *profileImageUrl;
@property (strong, nonatomic) NSString *screenName;

+(User*) currentUser;
+(void) setCurrentUser;
+(void) resetCurrentUser;

-(id) initWithDictionary:(NSDictionary*) data;

@end
