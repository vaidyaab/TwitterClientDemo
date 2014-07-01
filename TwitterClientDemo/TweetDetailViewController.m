//
//  TweetDetailViewController.m
//  TwitterClientDemo
//
//  Created by Abhijeet Vaidya on 6/30/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import "TweetDetailViewController.h"
#import <UIImageView+AFNetworking.h>

@interface TweetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *topRetweetImageView;
@property (weak, nonatomic) IBOutlet UILabel *retweetedUserLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetedTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;

@end

@implementation TweetDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:[self.tweet profileImageURL]]];
    self.userNameLabel.text = [self.tweet name];
    self.userHandleLabel.text = [NSString stringWithFormat:@"@%@",[self.tweet handle]];
    self.tweetTextLabel.text = [self.tweet tweet];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate *createdDate = [formatter dateFromString:[self.tweet createdAt]];
    self.createdAtLabel.text = [NSString stringWithFormat:@"%@",createdDate];
    
    [self.topRetweetImageView setImage:[UIImage imageNamed:@"retweet.png"]];
    [self.replyImageView setImage:[UIImage imageNamed:@"reply.png"]];
    [self.retweetImageView setImage:[UIImage imageNamed:@"retweet.png"]];
    [self.favoriteImageView setImage:[UIImage imageNamed:@"favorite.png"]];
    self.retweetedCountLabel.text = [NSString stringWithFormat:@"%d",[self.tweet retweetCount]];
    self.retweetedTextLabel.text = @"RETWEETS";
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d",[self.tweet favoriteCount]];
    self.favoriteTextLabel.text = @"FAVORITES";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
