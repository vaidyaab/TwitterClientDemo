//
//  User.m
//  TwitterClientDemo
//
//  Created by Abhijeet Vaidya on 6/28/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import "User.h"
#import "TwitterAPIClient.h"
NSString * const UserLoggedInNotification = @"UserLoggedInNotification";
NSString * const UserLoggedOutNotification = @"UserLoggedOutNotification";
NSString * const currentUserKey = @"currentUserKey";

@implementation User

static User* _currentUser = nil;

+(User*) currentUser {
    
    if(_currentUser == nil){
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:currentUserKey];
        
        if(data){
        
            _currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
        }
    }
    return _currentUser;
}
+(void) setCurrentUser {
    
    [[TwitterAPIClient instance] userDataWithSuccess:
                                    ^(AFHTTPRequestOperation *operation, id responseObject) {
                                        _currentUser = [[User alloc] initWithDictionary: responseObject];
                                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_currentUser];
                                        [[NSUserDefaults standardUserDefaults] setObject:data forKey:currentUserKey];
                                        
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                        NSLog(@"Got the user. sending notification to update view");
                                        NSNotification *notification = [NSNotification notificationWithName:UserLoggedInNotification object:nil];
                                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                                    }
                                 failure:
                                    ^(AFHTTPRequestOperation *operation, NSError *error) {
                                        NSLog(@"unable to set user properties");
                                 }
     ];
    
}

-(id) initWithDictionary:(NSDictionary*) data{
    self = [super init];
    if(self){
        self.description = data[@"description"];
        self.userId = (int)data[@"id"];
        self.name = data[@"name"];
        self.screenName = data[@"screen_name"];
        self.profileImageUrl = data[@"profile_image_url"];
    }
    return self;
}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.description = [decoder decodeObjectForKey:@"description"];
    self.userId = [decoder decodeIntegerForKey:@"id"];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.screenName = [decoder decodeObjectForKey:@"screen_name"];
    self.profileImageUrl = [decoder decodeObjectForKey:@"profile_image_url"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.description forKey:@"description"];
    [encoder encodeInteger:self.userId forKey:@"id"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.screenName forKey:@"screen_name"];
    [encoder encodeObject:self.profileImageUrl forKey:@"profile_image_url"];
}


@end
