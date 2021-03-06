//
//  TwitterAPIClient.h
//  TwitterClientDemo
//
//  Created by Abhijeet Vaidya on 6/28/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterAPIClient : BDBOAuth1RequestOperationManager

+(TwitterAPIClient*) instance;

-(void) login;

-(void) logout;

-(void) handleCallbackWithURL:(NSURL*) url;

- (AFHTTPRequestOperation *)homeTimeLineWithSuccess:
                                (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:
                                (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


- (AFHTTPRequestOperation *)userDataWithSuccess:
                                (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:
                                (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)postTweetWithSuccess:
                                (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:
                                (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                            parameters:
                                (NSDictionary*) params;

- (AFHTTPRequestOperation *)postFavoriteStatusWithSuccess:
                                (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:
                                (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                            parameters:
                                (NSDictionary*) params;

- (AFHTTPRequestOperation *)postDestroyFavoriteWithSuccess:
                                (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:
                                (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                            parameters:
                                (NSDictionary*) params;

- (AFHTTPRequestOperation *)postRetweetWithSuccess:
                                (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:
                                (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                            parameters:
                                (NSDictionary*) params;

- (AFHTTPRequestOperation *)postDestroyTweetWithSuccess:
                                (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:
                                (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                            parameters:
                                (NSDictionary*) params;

- (AFHTTPRequestOperation *)getUserWithSuccess:
                                (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:
                                (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                            parameters:
                                (NSDictionary*) params;

@end
