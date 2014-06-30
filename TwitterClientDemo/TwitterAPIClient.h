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

-(void) handleCallbackWithURL:(NSURL*) url;

- (AFHTTPRequestOperation *)homeTimeLineWithSuccess:
                                (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:
                                (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


- (AFHTTPRequestOperation *)userDataWithSuccess:
                                (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:
                                (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
