//
//  TweetCell.h
//  TwitterClientDemo
//
//  Created by Abhijeet Vaidya on 6/29/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetCell : UITableViewCell

-(void) initializeFromTweetData:(Tweet*) tweet currentParent:(UIViewController*) parent;

@end
