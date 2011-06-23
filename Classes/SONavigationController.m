//
//  SONavigationController.m
//  StatusOn
//
//  Created by Sergey Gavrilyuk on 5/19/11.
//  Copyright 2011 SoftTechnics. All rights reserved.
//

#import "SONavigationController.h"
#import "SONavigationBar.h"
#import "SOViewController.h"

@interface SOViewController (Private)
@property (nonatomic, retain) SONavigationController* soNavigationController;

@end

@interface SONavigationController(Private)
-(CGRect) clientFrame:(UINavigationItem*) navigationItem;
@end


@implementation SONavigationController
@synthesize navigationBar;

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
	if((self = [super initWithNibName:@"SONavigationController" bundle:nil]) != nil)
	{
		fViewControllers = [[NSMutableArray alloc] init];
		[fViewControllers addObject:rootViewController];
		if([rootViewController isKindOfClass:[SOViewController class]])
			[(SOViewController*)rootViewController setSoNavigationController: self];
	}
	return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
	if((self = [super initWithCoder:aDecoder]) != nil)
	{
		fViewControllers = [[NSMutableArray alloc] init];
	}
	
	return self;
}

-(void) dealloc
{
	[fViewControllers release];
	self.navigationBar = nil;

	
	[super dealloc];
}


-(void) viewDidLoad
{
	[super viewDidLoad];
	
	NSMutableArray* navItemsArr = [[NSMutableArray alloc] init];
	for(UIViewController* c in fViewControllers)
		[navItemsArr addObject:c.navigationItem];
	
	[self.navigationBar setItems:navItemsArr animated:NO];
	[navItemsArr release];
	
	(void)self.topViewController.view;
	
	self.topViewController.view.frame = [self clientFrame:self.topViewController.navigationItem];
	
	[self.view addSubview: self.topViewController.view];
	
}

-(void) viewDidUnload
{
	[super viewDidLoad];
	
	self.navigationBar = nil;

}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController staff
////////////////////////////////////////////////////////////////////////////////////////////////////

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.topViewController viewWillAppear:animated];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self.topViewController viewDidAppear:animated];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self.topViewController viewWillDisappear:animated];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[self.topViewController viewDidDisappear:animated];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Navigation staff

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if([animationID isEqualToString:@"Push"])
	{
		UIViewController* viewController = (UIViewController*)context;
		
		[self.topViewController.view removeFromSuperview];
		[self.topViewController viewDidDisappear:YES];
		[viewController viewDidAppear:YES];	
		
		[fViewControllers addObject:viewController];
		
		[viewController release];
	}
	else if( [animationID isEqualToString:@"Pop"])
	{
		UIViewController* viewController = (UIViewController*)context;
		
		[viewController.view removeFromSuperview];
		[viewController viewDidDisappear:YES];
		[self.topViewController viewDidAppear:YES];		
		
		[viewController release];		
	}
	else if( [animationID isEqualToString:@"Set"])
	{
		UIViewController* lastTopViewCtrl = (UIViewController*)context;
		
		[lastTopViewCtrl.view removeFromSuperview];
		[lastTopViewCtrl viewDidDisappear:YES];
		[self.topViewController viewDidAppear:YES];
		
		[lastTopViewCtrl release];
		
	}
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	(void)viewController.view;
	
	viewController.view.frame = [self clientFrame:viewController.navigationItem];
	[viewController viewWillAppear:animated];
	[self.topViewController viewWillDisappear:animated];
	
	[self.view addSubview: viewController.view];
	if(animated)
	{
		if(![self.topViewController.navigationItem.title length])
			self.navigationBar.frame = CGRectMake(self.view.frame.size.width, 0, self.navigationBar.frame.size.width,
												  self.navigationBar.frame.size.height);
		
		viewController.view.frame = CGRectOffset(viewController.view.frame, self.view.frame.size.width, 0);
		
		[UIView beginAnimations:@"Push" context: [viewController retain]];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop: finished: context:)];
		[UIView setAnimationDuration:.33];
		
		self.topViewController.view.frame = CGRectOffset(self.topViewController.view.frame, -self.view.frame.size.width, 0);
		viewController.view.frame = CGRectOffset(viewController.view.frame, -self.view.frame.size.width, 0);

		if(![viewController.navigationItem.title length] || ![self.topViewController.navigationItem.title length])
			self.navigationBar.frame = CGRectOffset(self.navigationBar.frame, -self.view.frame.size.width, 0);

		[UIView commitAnimations];
	}
	else
	{
		[self.topViewController.view removeFromSuperview];
		[self.topViewController viewDidDisappear:animated];
		[viewController viewDidAppear:animated];	
		
		[fViewControllers addObject:viewController];
	}
		
	if([viewController  isKindOfClass:[SOViewController class]])
		[(SOViewController*)viewController setSoNavigationController:self];
	
	
	[self.navigationBar pushNavigationItem:viewController.navigationItem animated:
	 [viewController.navigationItem.title length]];
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(UIViewController *) popViewControllerAnimated:(BOOL)animated
{
	if([fViewControllers count] >1)
		return [self popToViewController:[fViewControllers objectAtIndex:[fViewControllers count]-2] 
					 animated:animated];
	else
		return nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(UIViewController*) popToViewController:(UIViewController*) viewController animated:(BOOL) animated
{
	if(![fViewControllers containsObject:viewController])
		return nil;
	
	UIViewController* popCtrl = [[fViewControllers lastObject] retain];
	
	while([self topViewController] != viewController)
		[fViewControllers removeLastObject];
	
	[popCtrl viewWillDisappear:animated];
	
	(void)self.topViewController.view;
	
	self.topViewController.view.frame = [self clientFrame:self.topViewController.navigationItem];
	
	[self.topViewController viewWillAppear:animated];
	
	[self.view addSubview: ((UIViewController*)[fViewControllers lastObject]).view];
	
	if(animated)
	{
		if(![self.topViewController.navigationItem.title length])
			self.navigationBar.frame = CGRectMake(-self.view.frame.size.width, 0, self.navigationBar.frame.size.width,
												  self.navigationBar.frame.size.height);
		
		self.topViewController.view.frame = 
		CGRectOffset(self.topViewController.view.frame, -self.view.frame.size.width, 0);
		
		[UIView beginAnimations:@"Pop" context: [popCtrl retain]];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop: finished: context:)];
		[UIView setAnimationDuration:.33];
		
		self.topViewController.view.frame = CGRectOffset(self.topViewController.view.frame, self.view.frame.size.width, 0);
		popCtrl.view.frame = CGRectOffset(popCtrl.view.frame, self.view.frame.size.width, 0);
		
		if(![self.topViewController.navigationItem.title length] ||![popCtrl.navigationItem.title length] )
			self.navigationBar.frame = CGRectOffset(self.navigationBar.frame, self.view.frame.size.width, 0);
		
		[UIView commitAnimations];
	}
	else
	{
		[popCtrl.view removeFromSuperview];
		[popCtrl viewDidDisappear:animated];
		[self.topViewController viewDidAppear:animated];		
	}
	
	[self.navigationBar popNavigationItemAnimated:
	 [self.topViewController.navigationItem.title length]];
	
	if([popCtrl  isKindOfClass:[SOViewController class]])
		[(SOViewController*)popCtrl setSoNavigationController:self];
	
	return [popCtrl autorelease];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
	UIViewController* lastTopViewCtrl = [self.topViewController retain];
	[lastTopViewCtrl viewWillDisappear:animated];
	
	[fViewControllers setArray:viewControllers];
	
	NSMutableArray* navItemsArr = [[NSMutableArray alloc] init];
	for(UIViewController* c in viewControllers)
	{
		if([c isKindOfClass:[SOViewController class]])
			[(SOViewController*)c setSoNavigationController:self];
		
		[navItemsArr addObject:c.navigationItem];
	}
	
	[self.navigationBar setItems:navItemsArr animated:animated];
	[navItemsArr release];
	

	if([self isViewLoaded])
	{
		(void)self.topViewController.view;
		
		self.topViewController.view.frame = [self clientFrame:self.topViewController.navigationItem];
		
		[self.topViewController viewWillAppear:animated];
		[self.view addSubview: self.topViewController.view];		
		
		if(animated && lastTopViewCtrl)
		{
			if([self.topViewController.navigationItem.title length])
				self.navigationBar.frame = CGRectMake(self.view.frame.size.width, 0, self.navigationBar.frame.size.width, 
													  self.navigationBar.frame.size.height);

			self.topViewController.view.frame = CGRectOffset(self.topViewController.view.frame, self.view.frame.size.width, 0);
			
			[UIView beginAnimations:@"Set" context:[lastTopViewCtrl retain]];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(animationDidStop: finished: context:)];
			[UIView setAnimationDuration:.33];
			
			lastTopViewCtrl.view.frame = CGRectOffset(lastTopViewCtrl.view.frame, -self.view.frame.size.width, 0);
			self.topViewController.view.frame = CGRectOffset(self.topViewController.view.frame, -self.view.frame.size.width, 0);

			if([self.topViewController.navigationItem.title length])
				self.navigationBar.frame = CGRectOffset(self.navigationBar.frame, -self.view.frame.size.width, 0);

			[UIView commitAnimations];
		}
		else
		{
			[lastTopViewCtrl.view removeFromSuperview];
			[lastTopViewCtrl viewDidDisappear:animated];

			[self.topViewController viewDidAppear:animated];
			
		}
		
		
	}
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) setViewControllers:(NSArray *)viewControllers
{
	[self setViewControllers: viewControllers animated:NO];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(UIViewController *) topViewController
{
	return [fViewControllers lastObject];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(UIViewController *) rootViewController
{
	return [fViewControllers objectAtIndex:0];
}

#pragma mark -
#pragma mark utilities

-(CGRect) clientFrame:(UINavigationItem*) navigationItem
{
	return CGRectMake(0, 
					  [navigationItem.title length] ? self.navigationBar.frame.size.height : 0, 
					  self.view.frame.size.width, 
					  [navigationItem.title length] ? self.view.frame.size.height - self.navigationBar.frame.size.height : 
					  self.view.frame.size.height);
}

@end
