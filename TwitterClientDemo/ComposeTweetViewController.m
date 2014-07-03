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
#import "TwitterAPIClient.h"

@interface ComposeTweetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorHandleLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;

@property (strong,nonatomic) UILabel *charCount;

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
    
    self.tweetText.delegate = self;
    
    self.charCount = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 30, 12)];
    
    if(self.originalTweet && [self.originalTweet handle]){
        self.charCount.text = [NSString stringWithFormat:@"%d",140 - [[NSString stringWithFormat:@"@%d",[[self.originalTweet handle] length]] intValue]];
        
    }else{
    
        self.charCount.text = @"140";
    }
    self.charCount.textColor = [UIColor grayColor];
    
    
    UIBarButtonItem *charCounterButton = [[UIBarButtonItem alloc] initWithCustomView:self.charCount];
    
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweet:)];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:tweetButton, charCounterButton, nil];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    if(self.originalTweet && [self.originalTweet handle]){
    
        self.tweetText.text = [NSString stringWithFormat:@"@%@ ",[self.originalTweet handle] ];
    }
    

}

-(IBAction)onCancel:(id)sender {
    NSLog(@"cancel clicked.");
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onTweet:(id)sender {
    NSLog(@"Tweet clicked.");
    
    if(self.tweetText.text){
        
        NSMutableDictionary *tweetParams = [[NSMutableDictionary alloc] init];
        [tweetParams setObject:self.tweetText.text forKey:@"status"];
        
        if(self.originalTweet && [self.originalTweet tweetId]){
            
            [tweetParams setObject:self.originalTweet.tweetId forKey:@"in_reply_to_status_id"];
        }
        
        [[TwitterAPIClient instance] postTweetWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"successfully tweeted");
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Failed to reply. ");
            
        } parameters:[[NSDictionary alloc] initWithDictionary:tweetParams]];
    }
}

- (void)textViewWillChange:(UITextView *)textView {
    
    
    self.charCount.text = [NSString stringWithFormat:@"%d",140 - [[NSString stringWithFormat:@"%d",[textView.text length]] intValue]];
}

- (void)textViewDidChange:(UITextView *)textView {
    
    
    self.charCount.text = [NSString stringWithFormat:@"%d",140 - [[NSString stringWithFormat:@"%d",[textView.text length]] intValue]];
}
         
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
             
             
    if([text isEqualToString:@"\b"]){
        
        return YES;
        
    }else if([[textView text] length] - range.length + text.length > 140){
        
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
