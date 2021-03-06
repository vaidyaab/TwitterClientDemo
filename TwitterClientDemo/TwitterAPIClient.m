//
//  TwitterAPIClient.m
//  TwitterClientDemo
//
//  Created by Abhijeet Vaidya on 6/28/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import <AFNetworking.h>
#import "TwitterAPIClient.h"
#import "NSURL+dictionaryFromQueryString.h"
#import "User.h"

@implementation TwitterAPIClient

+(TwitterAPIClient*) instance{
    
    static TwitterAPIClient* instance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        instance = [[TwitterAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"] consumerKey:@"12PZVNuZf2RFJZiSztJeuQojI" consumerSecret:@"Mi7qgCgtsnx1iuMlxzeAxpwcHFaLsdjfgnPZGZUdUv24Q2CDet"];
    });
    
    return instance;
}

-(void) login {
    
    [self.requestSerializer removeAccessToken];
    
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"avtwitter://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        
        NSLog(@"Got the request token!");
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    
    } failure:^(NSError *error) {
        NSLog(@"failure while getting the request token!");
    }];
}

-(void) logout {
    
    [self.requestSerializer removeAccessToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:currentUserKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [User resetCurrentUser];
    NSNotification *notification = [NSNotification notificationWithName:UserLoggedOutNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(void) handleCallbackWithURL:(NSURL*) url{
    
    if ([url.host isEqualToString:@"oauth"])
    {
        NSDictionary *parameters = [url dictionaryFromQueryString];
        if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]){
            
            [self fetchAccessTokenWithPath:@"/oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
                
                NSLog(@"Got the access token!");
                [self.requestSerializer saveAccessToken:accessToken];
                
                [User setCurrentUser];
                
                
            } failure:^(NSError *error) {
                NSLog(@"Got the access token error!");
                
            }];
        }
    }
    
}

- (AFHTTPRequestOperation *)homeTimeLineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    return [self GET:@"1.1/statuses/home_timeline.json"
          parameters:nil
             success: success
             failure: failure];
}

- (AFHTTPRequestOperation *)userDataWithSuccess:
                                (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:
                                (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    return [self GET:@"1.1/account/verify_credentials.json"
          parameters:nil
             success: success
             failure: failure];
}

- (AFHTTPRequestOperation *)postTweetWithSuccess:
                                (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:
                                (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                            parameters:
                                (NSDictionary*) params {
    
    return [self POST:@"1.1/statuses/update.json"
          parameters:params
             success: success
             failure: failure];
}

- (AFHTTPRequestOperation *)postFavoriteStatusWithSuccess:
                                (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:
                                (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                            parameters:
                                (NSDictionary*) params {
    
    return [self POST:@"1.1/favorites/create.json"
           parameters:params
              success: success
              failure: failure];
}

- (AFHTTPRequestOperation *)postDestroyFavoriteWithSuccess:
                                (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:
                                (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                            parameters:
                                (NSDictionary*) params {
    
    return [self POST:@"1.1/favorites/destroy.json"
           parameters:params
              success: success
              failure: failure];
}

- (AFHTTPRequestOperation *)postRetweetWithSuccess:
                                (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:
                                (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                            parameters:
                                (NSDictionary*) params {
    
    NSString *postString = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json",[params objectForKey:@"id"]];
    
    return [self POST:postString
           parameters:nil
              success: success
              failure: failure];
}

- (AFHTTPRequestOperation *)postDestroyTweetWithSuccess:
                                (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:
                                (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                            parameters:
                                (NSDictionary*) params {
    
    NSString *postString = [NSString stringWithFormat:@"1.1/statuses/destroy/%@.json",[params objectForKey:@"id"]];
    
    return [self POST:postString
           parameters:nil
              success: success
              failure: failure];
}

- (AFHTTPRequestOperation *)getUserWithSuccess:
                                (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:
                                (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                            parameters:
                                (NSDictionary*) params {
    
    NSString *getString = [NSString stringWithFormat:@"1.1/users/show.json?screen_name=%@",[params objectForKey:@"screenName"]];
    
    return [self GET:getString
           parameters:nil
              success: success
              failure: failure];
}

@end
