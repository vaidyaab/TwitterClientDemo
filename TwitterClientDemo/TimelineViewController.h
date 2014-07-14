//
//  TimelineViewController.h
//  TwitterClientDemo
//
//  Created by Abhijeet Vaidya on 6/29/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HamBurgerMenuDelegate <NSObject>

-(void) onHBMenuTap;

@end


@interface TimelineViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id hbDelegate;

@end
