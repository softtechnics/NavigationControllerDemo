//
//  SOViewController.h
//  StatusOn
//
//  Created by Sergey Gavrilyuk on 5/24/11.
//  Copyright 2011 SoftTechnics. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SONavigationController;

@interface SOViewController : UIViewController 
{
@private 
	SONavigationController* fNavigationController;
	
@public	
	NSMutableArray* fPendingRequests;		

}

@property (nonatomic, readonly) SONavigationController* soNavigationController;
@property (nonatomic, retain) UIImage* tabBarImage;


@end
