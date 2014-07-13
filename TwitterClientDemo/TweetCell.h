//
//  TweetCell.h
//  TwitterClientDemo
//
//  Created by Abhijeet Vaidya on 6/29/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

//---- A way of handling UITableViewCell clicks
//@class TweetCell;
//
//@protocol TweetCellDelegate <NSObject>
//
//-(void) onTapRetweetForTweetCell :(TweetCell*) cell;
//
//@end

@interface TweetCell : UITableViewCell

//@property (nonatomic, weak) id<TweetCellDelegate> delegate;

-(void) initializeFromTweetData:(Tweet*) tweet currentParent:(UIViewController*) parent;

@end
