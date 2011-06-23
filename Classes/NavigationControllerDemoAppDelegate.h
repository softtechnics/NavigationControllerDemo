//
//  NavigationControllerDemoAppDelegate.h
//  NavigationControllerDemo
//
//  Created by Sergey Gavrilyuk on 6/23/11.
//  Copyright 2011 SoftTechnics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SONavigationController.h"

@interface NavigationControllerDemoAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SONavigationController* navigationController;

@end

