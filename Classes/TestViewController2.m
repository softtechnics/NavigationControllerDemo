//
//  TestViewController2.m
//  NavigationControllerDemo
//
//  Created by Sergey Gavrilyuk on 6/23/11.
//  Copyright 2011 SoftTechnics. All rights reserved.
//

#import "TestViewController2.h"
#import "SONavigationController.h"
#import "SONavigationBar.h"

@implementation TestViewController2

- (void)viewDidUnload 
{
    [super viewDidUnload];
}

-(void) viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationItem.title = @"Second title";
	[self.soNavigationController.navigationBar updateTopNavigationItem];
}

- (void)dealloc 
{
    [super dealloc];
}


@end
