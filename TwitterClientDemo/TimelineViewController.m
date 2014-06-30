//
//  TimelineViewController.m
//  TwitterClientDemo
//
//  Created by Abhijeet Vaidya on 6/29/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import "TimelineViewController.h"
#import "User.h"
#import "TwitterAPIClient.h"
#import "TweetCell.h"
#import "Tweet.h"
#import <ODRefreshControl/ODRefreshControl.h>

@interface TimelineViewController ()

@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;
@property (strong, nonatomic) NSMutableArray *tweetsArray;

@end

@implementation TimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentView) name:UserLoggedInNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentView) name:UserLoggedOutNotification object:nil];
    }
    return self;
}
- (void) updateCurrentView {
    
    NSLog(@"inside updateCurrentView");
    if([User currentUser]){
        NSLog(@"user found");
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 10, 50, 30);
        [button setTitle:@"Logout" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName: @"HelveticaNeue" size:15.0]];
        [button addTarget:self action:@selector(onLogoutButton:) forControlEvents: UIControlEventTouchUpInside];
        UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = logoutButton;
        
        UIButton *tButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        tButton.frame = CGRectMake(0, 10, 50, 30);
        [tButton setTitle:@"Tweet" forState:UIControlStateNormal];
        [tButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tButton.titleLabel setFont:[UIFont fontWithName: @"HelveticaNeue" size:15.0]];
        [tButton addTarget:self action:@selector(onTweetButton:) forControlEvents: UIControlEventTouchUpInside];
        UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithCustomView:tButton];
        self.navigationItem.rightBarButtonItem = tweetButton;
        
        self.navigationItem.title = @"Home";

        
    }else{
        NSLog(@"no user found");
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 10, 50, 30);
        [button setTitle:@"Login" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName: @"HelveticaNeue" size:15.0]];
        
        [button addTarget:self action:@selector(onLoginButton:) forControlEvents: UIControlEventTouchUpInside];
        UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = loginButton;
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    [self updateCurrentView];
    self.timelineTableView.delegate = self;
    self.timelineTableView.dataSource = self;
    [self.timelineTableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    
    [self loadHomeTimeline];
    
    [self addRefreshControlToTimeline];
    
}

-(void) addRefreshControlToTimeline {
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.timelineTableView];
    refreshControl.tintColor = [UIColor grayColor];
    
    [refreshControl addTarget:self action:@selector(refreshTableViewHandler:) forControlEvents:UIControlEventValueChanged];
}

- (void) refreshTableViewHandler:(ODRefreshControl*) refreshControl {
    
    [self loadHomeTimeline];
    [refreshControl endRefreshing];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {

    return [self.tweetsArray count];
}

-(void) loadHomeTimeline {
    
        [[TwitterAPIClient instance] homeTimeLineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    
            //NSLog(@"Got home timeline response: ");
                        
            self.tweetsArray = [[NSMutableArray alloc] initWithCapacity:20];
            Tweet *tempTweet;
            
            for(int cnt = 0; cnt < [responseObject count]; cnt++){
                            
                tempTweet = [[Tweet alloc] initWithDictionary:responseObject[cnt]];
                [self.tweetsArray addObject:tempTweet];

            }
                        
            [self.timelineTableView reloadData];
    
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
            NSLog(@"oops! error while fetching timeline tweets.");
        }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TweetCell";
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell initializeFromTweetData:[self.tweetsArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButton:(id)sender {
    
    [[TwitterAPIClient instance] login];
}

- (IBAction)onLogoutButton:(id)sender {
    
    NSLog(@"logout clicked!");
    self.navigationItem.title = @"";
    self.navigationItem.rightBarButtonItem = nil;
}

- (IBAction)onTweetButton:(id)sender {
    
    NSLog(@"New tweet clicked!");
    
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UserLoggedInNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UserLoggedOutNotification object:nil];
}

@end