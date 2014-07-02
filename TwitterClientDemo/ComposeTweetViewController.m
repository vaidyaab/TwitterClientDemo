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
    self.charCount.text = @"140";
    self.charCount.textColor = [UIColor grayColor];
    
    
    UIBarButtonItem *charCounterButton = [[UIBarButtonItem alloc] initWithCustomView:self.charCount];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel:)];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:cancelButton, charCounterButton, nil];

}

-(IBAction)onCancel:(id)sender {
    NSLog(@"cancel clicked.");
    [self.navigationController popViewControllerAnimated:YES];
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
