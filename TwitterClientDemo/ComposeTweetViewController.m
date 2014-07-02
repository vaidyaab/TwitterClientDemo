//
//  ComposeTweetViewController.m
//  TwitterClientDemo
//
//  Created by Abhijeet Vaidya on 7/1/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "User.h"
#import <UIImageView+AFNetworking.h>

@interface ComposeTweetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorHandleLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;

@end

@implementation ComposeTweetViewController

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
    
    User *user = [User currentUser];
    
    self.authorHandleLabel.text = [user screenName];
    self.authorNameLabel.text = [user name];
    [self.authorImageView setImageWithURL:[NSURL URLWithString:[user profileImageUrl]]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
