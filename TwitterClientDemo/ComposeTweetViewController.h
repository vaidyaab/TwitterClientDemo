//
//  ComposeTweetViewController.h
//  TwitterClientDemo
//
//  Created by Abhijeet Vaidya on 7/1/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface ComposeTweetViewController : UIViewController<UITextViewDelegate>

@property (strong,nonatomic) Tweet *originalTweet;

@end
