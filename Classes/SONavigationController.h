//
//  SONavigationController.h
//  StatusOn
//
//  Created by Sergey Gavrilyuk on 5/19/11.
//  Copyright 2011 SoftTechnics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOViewController.h"

@class SONavigationBar;

@interface SONavigationController : /*UINavigationController */ SOViewController
{
@protected
	NSMutableArray* fViewControllers;

}


@property (nonatomic, retain) IBOutlet SONavigationBar* navigationBar;


// navigation
- (id)initWithRootViewController:(UIViewController *)rootViewController;
-(void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

-(UIViewController *) popViewControllerAnimated:(BOOL)animated;
-(UIViewController*) popToViewController:(UIViewController*) viewController animated:(BOOL) animated;

-(void) setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;
-(void) setViewControllers:(NSArray *)viewControllers;


@property(nonatomic, readonly) UIViewController *topViewController;
@property(nonatomic, readonly) UIViewController *rootViewController;

@end
