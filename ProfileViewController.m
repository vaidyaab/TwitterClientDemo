//
//  ProfileViewController.m
//  TwitterClientDemo
//
//  Created by Abhijeet Vaidya on 7/20/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import "ProfileViewController.h"
#import <UIImageView+AFNetworking.h>
#import "UIImage+ImageEffects.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;

@end

@implementation ProfileViewController

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
//    [self.backgroundImageView setImageWithURL:[NSURL URLWithString:self.user.backgroundImageURL]];
    
    __weak ProfileViewController *weakSelf = self;
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.user.backgroundImageURL]];
    
    [self.backgroundImageView setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        weakSelf.backgroundImageView.image = image;
        [self blurredSnapshot];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"failed to load image");
    }];
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    self.userNameLabel.text = self.user.name;
    self.userHandleLabel.text = [NSString stringWithFormat:@"@%@",self.user.screenName];
    self.tweetsCountLabel.text = [NSString stringWithFormat:@"%d",self.user.tweetsCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%d",self.user.followingCount];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%d",self.user.followersCount];
    self.navigationItem.title = @"Me";
    

}

-(void) blurredSnapshot
{

    UIGraphicsBeginImageContextWithOptions(self.backgroundImageView.bounds.size, NO, 0);
     BOOL result = [self.backgroundImageView drawViewHierarchyInRect:self.backgroundImageView.bounds afterScreenUpdates:YES];

    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(result){
        self.backgroundImageView.image = [snapshotImage applyDarkEffect];
    }else{
        NSLog(@"failed");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
