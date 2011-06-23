//
//  SONavigationBar.h
//  StatusOn
//
//  Created by Sergey Gavrilyuk on 5/19/11.
//  Copyright 2011 SoftTechnics. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SONavigationBar : UIView 
{
	NSMutableArray* fItemsStack;
	
	UIButton* leftButton;
	UILabel* titleLabel;
	
	UIButton* transitionLeftButton;
	UILabel* transitionTitleLable;
	
	
	
	id delegate;
}

@property (nonatomic, assign) IBOutlet id delegate;



- (void) pushNavigationItem:(UINavigationItem *)item animated:(BOOL)animated;
-(UINavigationItem *) popNavigationItemAnimated:(BOOL)animated;
-(void) setItems:(NSArray *)items animated:(BOOL)animated;

-(void) updateTopNavigationItem;

-(void) setTitleTextColor:(UIColor*) color;

@end
