//
//  HamBurgerMenuViewController.m
//  TwitterClientDemo
//
//  Created by Abhijeet Vaidya on 7/13/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import "HamBurgerMenuViewController.h"
#import "TimelineViewController.h"
#import "TwitterAPIClient.h"
#import "User.h"
#import <UIImageView+AFNetworking.h>


@interface HamBurgerMenuViewController ()
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) UINavigationController *contentView;
@property (nonatomic, assign) BOOL isMenuHidden;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userHandleLabel;
@end

@implementation HamBurgerMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        TimelineViewController *timelinevc = [[TimelineViewController alloc] init];
        self.contentView = [[UINavigationController alloc] initWithRootViewController:timelinevc];
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:126/255.0f green:208/255.0f blue:252/255.0f alpha:1.0f]];
        timelinevc.hbDelegate = self;
        
        self.contentView.view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        
        [self addChildViewController:self.contentView];
        [self.view addSubview:self.contentView.view];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.isMenuHidden = YES;
    
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    
    [self.menuView setBackgroundColor:[UIColor colorWithRed:0/255.0f green:16/255.0f blue:15/255.0f alpha:1.0f]];
    self.userNameLabel.text = [[User currentUser] name];
    self.userHandleLabel.text = [NSString stringWithFormat:@"@%@",[[User currentUser] screenName]];
    [self.userProfileImageView setImageWithURL:[NSURL URLWithString:[[User currentUser] profileImageUrl]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) onHBMenuTap{

    CGRect newFrame;
    
    if(!self.userNameLabel.text){
    
        self.userNameLabel.text = [[User currentUser] name];
        self.userHandleLabel.text = [NSString stringWithFormat:@"@%@",[[User currentUser] screenName]];
        [self.userProfileImageView setImageWithURL:[NSURL URLWithString:[[User currentUser] profileImageUrl]]];
    }
    

    if(self.isMenuHidden){
        newFrame = CGRectMake(180, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    }else{
        newFrame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.contentView.view.frame = newFrame;
    }];
    
    self.isMenuHidden = !self.isMenuHidden;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self onHBMenuTap];
            break;
        case 1:
            NSLog(@"Mentions clicked!");
            break;
        case 2:
        {
            NSLog(@"profile clicked!");
            
            NSNotification *notification = [NSNotification notificationWithName:ShowProfileNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [self onHBMenuTap];
        }
            break;
        case 3:
            [self onHBMenuTap];
            [[TwitterAPIClient instance] logout];
            break;
            
        default:
            break;
    }
    
}

-(BOOL) isMenuDisplayed {
    return !self.isMenuHidden;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Timeline";
            break;
        case 1:
            cell.textLabel.text = @"Mentions";
            break;
        case 2:
            cell.textLabel.text = @"Profile";
            break;
        case 3:
            cell.textLabel.text = @"Logout";
            break;
            
        default:
            break;
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor colorWithRed:0/255.0f green:16/255.0f blue:15/255.0f alpha:1.0f]];
    return cell;
}

@end
