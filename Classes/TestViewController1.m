//
//  TestViewController1.m
//  NavigationControllerDemo
//
//  Created by Sergey Gavrilyuk on 6/23/11.
//  Copyright 2011 SoftTechnics. All rights reserved.
//

#import "TestViewController1.h"
#import "TestViewController2.h"
#import "SONavigationBar.h"
#import "SONavigationController.h"

@implementation TestViewController1

- (void)viewDidUnload 
{
    [super viewDidUnload];
}


- (void)dealloc 
{
    [super dealloc];
}


-(void) viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationItem.title = @"First title";
	[self.soNavigationController.navigationBar updateTopNavigationItem];
}



-(IBAction) pushButtonPressed
{
	TestViewController2* viewCtrl = [[TestViewController2 alloc] initWithNibName:nil bundle:nil];
	[self.soNavigationController pushViewController:viewCtrl animated:YES];
	[viewCtrl release];
}

@end
