//
//  SampleHomeViewController.m
//  DYFloatingHeaderView
//
//  Created by Derek Yang on 09/11/12.
//  Copyright (c) 2012 iappexperience.com. All rights reserved.
//

#import "SampleHomeViewController.h"
#import "DYFloatingHeaderView.h"
#import "SampleListViewController.h"

@interface SampleHomeViewController ()

@property(nonatomic, strong) SampleListViewController *listViewController;

@end

@implementation SampleHomeViewController

@synthesize listViewController = _listViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Floating header
    DYFloatingHeaderView *floatingHeader = [[DYFloatingHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [DYFloatingHeaderView height])];
    [self.view addSubview:floatingHeader];

    // Table view
    self.listViewController = [[SampleListViewController alloc] init];
    self.listViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.listViewController.headerView = floatingHeader;
    [self.view insertSubview:self.listViewController.view belowSubview:floatingHeader];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
