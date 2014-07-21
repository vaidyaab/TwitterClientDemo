//
//  TweetCell.m
//  TwitterClientDemo
//
//  Created by Abhijeet Vaidya on 6/29/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"
#import "ComposeTweetViewController.h"
#import "TwitterAPIClient.h"
#import "TimelineViewController.h"
#import "ProfileViewController.h"

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
@property (strong,nonatomic) UIViewController* parent;
@property (strong,nonatomic) Tweet* origTweet;
@property (strong,nonatomic) NSString *retweetId;
@property (weak, nonatomic) IBOutlet UILabel *retweetedBy;
@property (weak, nonatomic) IBOutlet UIImageView *retweetedByImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetedLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileImageMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handleMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeMargin;

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

-(void) initializeFromTweetData:(Tweet*) tweet currentParent: (UIViewController*) parent {
 
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
    [self.favoriteImageView setTag:0];
    self.origTweet = tweet;
    self.parent = parent;
    
    UITapGestureRecognizer *profileImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postProfileImageTapped:)];
    profileImageTap.numberOfTapsRequired = 1;
    profileImageTap.numberOfTouchesRequired = 1;
    [self.profileImageView addGestureRecognizer:profileImageTap];
    [self.profileImageView setUserInteractionEnabled:YES];
    
    
    UITapGestureRecognizer *replyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postReplyImageTapped:)];
    replyTap.numberOfTapsRequired = 1;
    replyTap.numberOfTouchesRequired = 1;
    [self.replyImageView addGestureRecognizer:replyTap];
    [self.replyImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *favoriteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postFavoriteImageTapped:)];
    favoriteTap.numberOfTapsRequired = 1;
    favoriteTap.numberOfTouchesRequired = 1;
    [self.favoriteImageView addGestureRecognizer:favoriteTap];
    [self.favoriteImageView setUserInteractionEnabled:YES];
    
    
    UITapGestureRecognizer *retweetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postRetweetImageTapped:)];
    retweetTap.numberOfTapsRequired = 1;
    retweetTap.numberOfTouchesRequired = 1;
    [self.retweetImageView addGestureRecognizer:retweetTap];
    [self.retweetImageView setUserInteractionEnabled:YES];
    [self.retweetImageView setTag:0];
    
    if([tweet retweetedBy]){
        [self.retweetedByImageView setImage:[UIImage imageNamed:@"retweet.png"]];
        self.retweetedBy.text = [NSString stringWithFormat:@"%@ retweeted",[tweet retweetedBy]];
    }
    else{
        self.retweetedBy.text = @"";
        [self.retweetedByImageView setImage:nil];
    }
}

-(void) postProfileImageTapped :(UIGestureRecognizer *)gestureRecognizer {

    NSMutableDictionary *tweetParams = [[NSMutableDictionary alloc] init];
    [tweetParams setObject:[self.origTweet handle] forKey:@"screenName"];
    
    [[TwitterAPIClient instance] getUserWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ProfileViewController *pvc = [[ProfileViewController alloc]init];
        User *user = [[User alloc] initWithDictionary:responseObject];
        [pvc setUser:user];
        [self.parent.navigationController pushViewController:pvc animated:YES];
                            
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to get user data for profile view");
    } parameters:tweetParams];
    
}

- (void) postReplyImageTapped :(UIGestureRecognizer *)gestureRecognizer {
    
    NSLog(@"reply image tapped.");
    ComposeTweetViewController *composeTweetvc = [[ComposeTweetViewController alloc] init];
    [composeTweetvc setOriginalTweet:self.origTweet];
    [gestureRecognizer setCancelsTouchesInView:NO];
    
    if([((TimelineViewController*)self.parent).hbDelegate isMenuDisplayed]){
        [((TimelineViewController*)self.parent).hbDelegate onHBMenuTap];
    }
    [self.parent.navigationController pushViewController:composeTweetvc animated:YES];
}

- (void) postFavoriteImageTapped :(UIGestureRecognizer *)gestureRecognizer {
    
    NSLog(@"favorite image tapped.");
    
    NSMutableDictionary *tweetParams = [[NSMutableDictionary alloc] init];
    [tweetParams setObject:[self.origTweet tweetId] forKey:@"id"];
    
    if(self.favoriteImageView.tag == 0){
        
        [[TwitterAPIClient instance] postFavoriteStatusWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [self.favoriteImageView setImage:[UIImage imageNamed:@"favorite_f.png"]];
            self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d",[self.favoriteCountLabel.text intValue] + 1 ];
            self.favoriteImageView.tag = 1;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"unable to mark a tweet as favorite");
            
        } parameters:[[NSDictionary alloc] initWithDictionary:tweetParams]];
        
    }else{
        
        [[TwitterAPIClient instance] postDestroyFavoriteWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [self.favoriteImageView setImage:[UIImage imageNamed:@"favorite.png"]];
            self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d",[self.favoriteCountLabel.text intValue] - 1 ];
            self.favoriteImageView.tag = 0;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"unable to undo a favorite");
            
        } parameters:[[NSDictionary alloc] initWithDictionary:tweetParams]];
    }
    
}

- (void) postRetweetImageTapped :(UIGestureRecognizer *)gestureRecognizer {
    
    NSLog(@"retweet image tapped.");
    
    NSMutableDictionary *tweetParams = [[NSMutableDictionary alloc] init];
    [tweetParams setObject:[self.origTweet tweetId] forKey:@"id"];
    
    if(self.retweetImageView.tag == 0){
        
        [[TwitterAPIClient instance] postRetweetWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            self.retweetCountLabel.text = [NSString stringWithFormat:@"%d",[self.retweetCountLabel.text intValue] + 1 ];
            self.retweetImageView.tag = 1;
            self.retweetId = responseObject[@"id"];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"unable to retweet");
            
        } parameters:[[NSDictionary alloc] initWithDictionary:tweetParams]];
        
    }else{
        
        if(self.retweetId){
            
            [tweetParams setObject:self.retweetId forKey:@"id"];
            
            [[TwitterAPIClient instance] postDestroyTweetWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                self.retweetCountLabel.text = [NSString stringWithFormat:@"%d",[self.retweetCountLabel.text intValue] - 1 ];
                self.retweetImageView.tag = 0;
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"unable to destroy a retweet");
                
            } parameters:[[NSDictionary alloc] initWithDictionary:tweetParams]];
        
        }
        
    }
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if([self.origTweet retweetedBy]){
        self.nameMargin.constant = 31.0f;
        self.profileImageMargin.constant = 31.0f;
        self.handleMargin.constant = 31.0f;
        self.timeMargin.constant = 31.0f;
    }else{
        
        self.nameMargin.constant = 10.0f;
        self.profileImageMargin.constant = 10.0f;
        self.handleMargin.constant = 10.0f;
        self.timeMargin.constant = 10.0f;
        
    }
    [self layoutIfNeeded];
    
   
}

@end
