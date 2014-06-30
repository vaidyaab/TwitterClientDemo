//
//  TweetCell.m
//  TwitterClientDemo
//
//  Created by Abhijeet Vaidya on 6/29/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import "TweetCell.h"
#import <UIImageView+AFNetworking.h>
#import "Tweet.h"

@interface TweetCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImageView;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;


@end

@implementation TweetCell


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) initializeFromTweetData:(Tweet*) tweet{
 
    [self.profileImageView setImageWithURL:[NSURL URLWithString:[tweet profileImageURL]]];
    self.nameLabel.text = [tweet name];
    self.handleLabel.text = [NSString stringWithFormat:@"@%@",[tweet handle]];
    self.timeLabel.text = [tweet time];
    self.tweetLabel.text = [tweet tweet];
    [self.replyImageView setImage:[UIImage imageNamed:@"reply.png"]];
    [self.retweetImageView setImage:[UIImage imageNamed:@"retweet.png"]];
    [self.favoriteImageView setImage:[UIImage imageNamed:@"favorite.png"]];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d",[tweet retweetCount]];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d",[tweet favoriteCount]];
    
}

@end
