//
//  SOViewController.m
//  StatusOn
//
//  Created by Sergey Gavrilyuk on 5/24/11.
//  Copyright 2011 SoftTechnics. All rights reserved.
//

#import "SOViewController.h"

@interface SOViewController (Private)
@property (nonatomic, retain) SONavigationController* soNavigationController;


@end



@implementation SOViewController
@synthesize soNavigationController = fNavigationController;
@synthesize tabBarImage;

-(void) setSoNavigationController:(SONavigationController*) navigationController
{
	[fNavigationController autorelease];
	fNavigationController = [navigationController retain];
}


-(void) dealloc
{
	[fNavigationController release];
	[fPendingRequests makeObjectsPerformSelector:@selector(clearDelegatesAndCancel)];
	[fPendingRequests release];
	
	[super dealloc];
}

@end
