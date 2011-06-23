//
//  SONavigationBar.m
//  StatusOn
//
//  Created by Sergey Gavrilyuk on 5/19/11.
//  Copyright 2011 SoftTechnics. All rights reserved.
//

#import "SONavigationBar.h"
#import "SONavigationController.h"

@interface SONavigationBar ()
@end


#define TRANSITION_STEP 100

@implementation SONavigationBar
@synthesize delegate;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark construction && deconstruction
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) commonInit
{
	
	fItemsStack = [[NSMutableArray alloc] init];
	
	leftButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	//leftButton.backgroundColor = [UIColor blackColor];
	[leftButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];

	[leftButton addTarget:self action:@selector(leftButtonPressed:) 
		 forControlEvents:UIControlStateHighlighted];
	
	[self addSubview:leftButton];
	
	
	titleLabel = [[UILabel alloc] init];
	titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:34];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.adjustsFontSizeToFitWidth = YES;
	titleLabel.minimumFontSize = 12.0;
	[self addSubview:titleLabel];	
	
	//transition components
	transitionLeftButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	[transitionLeftButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
	transitionLeftButton.alpha = 0;
	[self addSubview:transitionLeftButton];
	
	transitionTitleLable = [[UILabel alloc] init];
	transitionTitleLable.font = [UIFont fontWithName:@"STHeitiSC-Light" size:34];
	transitionTitleLable.textAlignment = UITextAlignmentCenter;
	transitionTitleLable.backgroundColor = [UIColor clearColor];
	transitionTitleLable.adjustsFontSizeToFitWidth = YES;
	transitionTitleLable.minimumFontSize = 12.0;
	[self addSubview:transitionTitleLable];
	
	

	//self.backgroundColor = [UIColor whiteColor ];
	
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame 
{
    
    self = [super initWithFrame:frame];
    if (self) 
		[self commonInit];
	
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(id) initWithCoder:(NSCoder *)aDecoder
{
	if((self = [super initWithCoder:aDecoder]) != nil)
		[self commonInit];	
	
	return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc 
{
	[fItemsStack release];
	[leftButton release];
    [super dealloc];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark layour
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) layoutSubviews
{
	NSInteger buttHeight = 31;//self.bounds.size.height * .7;
	leftButton.frame = CGRectMake(0, (self.bounds.size.height- buttHeight)/2, 
								  25, buttHeight);
	
	titleLabel.frame = CGRectMake(leftButton.frame.origin.x + leftButton.frame.size.width + 8, 0, 
								  self.frame.size.width - 
								  (leftButton.frame.origin.x + leftButton.frame.size.width + 16), 
								  self.frame.size.height);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark uitilities
////////////////////////////////////////////////////////////////////////////////////////////////////

-(UINavigationItem*) currentItem
{
	return (UINavigationItem*)[fItemsStack lastObject];
}

-(UINavigationItem*) backItem
{
	if([fItemsStack count] >=2)
		return (UINavigationItem*)[fItemsStack objectAtIndex:[fItemsStack count]-2];
	else
		return nil;
}

-(BOOL) shouldShowBackButton
{
	return [fItemsStack count]>1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark navigation methods
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pushNavigationItem:(UINavigationItem *)item animated:(BOOL)animated
{
	if(animated)
	{
		transitionTitleLable.text = item.title;;
		transitionLeftButton.frame = CGRectOffset(leftButton.frame, TRANSITION_STEP, 0);
		transitionTitleLable.frame = CGRectOffset(titleLabel.frame, TRANSITION_STEP, 0);
		transitionTitleLable.alpha = 0;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop: finished: context:)];
		[UIView setAnimationDuration:.33];
		
		transitionLeftButton.frame = leftButton.frame;
		transitionLeftButton.alpha = 1 ;
		leftButton.frame = CGRectOffset(leftButton.frame, -TRANSITION_STEP, 0);
		leftButton.alpha = 0;
		
		transitionTitleLable.frame = titleLabel.frame;
		titleLabel.frame = CGRectOffset(titleLabel.frame, -TRANSITION_STEP, 0);
		transitionTitleLable.alpha = 1;
		titleLabel.alpha = 0;
		
		[UIView commitAnimations];
	}	

	[fItemsStack addObject:item];
	
	if(!animated)
	{
		titleLabel.text = item.title;
		leftButton.hidden = ![self shouldShowBackButton];
	}

}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(UINavigationItem *) popNavigationItemAnimated:(BOOL)animated
{
	id objToRemove = [[fItemsStack lastObject] retain];
	[fItemsStack removeLastObject];
	
	
	if(animated)
	{
		transitionTitleLable.text = ((UINavigationItem*)[fItemsStack lastObject]).title;;
		transitionLeftButton.frame = CGRectOffset(leftButton.frame, -TRANSITION_STEP, 0);
		transitionTitleLable.frame = CGRectOffset(titleLabel.frame, -TRANSITION_STEP, 0);
		transitionLeftButton.alpha = 0;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop: finished: context:)];
		[UIView setAnimationDuration:.33];
		
		transitionLeftButton.frame = leftButton.frame;
		transitionLeftButton.alpha = [self shouldShowBackButton];
		leftButton.frame = CGRectOffset(leftButton.frame, TRANSITION_STEP, 0);
		leftButton.alpha = 0;
		
		transitionTitleLable.frame = titleLabel.frame;
		titleLabel.frame = CGRectOffset(titleLabel.frame, TRANSITION_STEP, 0);
		transitionTitleLable.alpha = 1;
		titleLabel.alpha = 0;
		
		[UIView commitAnimations];
	}
	else
	{
		titleLabel.text = [self currentItem].title;
		leftButton.hidden = ![self shouldShowBackButton];
	}
	
	return [objToRemove autorelease];
}
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	leftButton.frame = transitionLeftButton.frame;
	titleLabel.frame = transitionTitleLable.frame;
	leftButton.alpha = 1;
	transitionLeftButton.alpha = 0;
	titleLabel.alpha = 1;
	transitionTitleLable.alpha = 0;
	titleLabel.text = transitionTitleLable.text;

	leftButton.hidden = ![self shouldShowBackButton];
}
////////////////////////////////////////////////////////////////////////////////////////////////////

/*-(UINavigationItem *) topItem
{
	return [fItemsStack lastObject];
}

-(UINavigationItem *) backItem
{
	return ([fItemsStack count] >=2)? [fItemsStack objectAtIndex:[fItemsStack count]-2] : 0;
}

-(NSArray *) items
{
	return fItemsStack;
}

-(void) setItems:(NSArray *) items
{
	[self setItems:items animated:NO];
}

*/
-(void) setItems:(NSArray *)items animated:(BOOL)animated
{
	[fItemsStack autorelease];
	fItemsStack = [items retain];
	
	if([fItemsStack count]<2)
		leftButton.hidden = YES;
	
	titleLabel.text = ((UINavigationItem*)[fItemsStack lastObject]).title;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) updateTopNavigationItem
{
	titleLabel.text = ((UINavigationItem*)[fItemsStack lastObject]).title;
}
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark button actions
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) leftButtonPressed:(id) sender
{
	if([self.delegate isKindOfClass:[SONavigationController class]])
	{
		[(UINavigationController*)self.delegate popViewControllerAnimated:YES];
	}
}
	

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UI customization
////////////////////////////////////////////////////////////////////////////////////////////////////

-(void) setTitleTextColor:(UIColor*) color
{
	titleLabel.textColor = color;
	transitionTitleLable.textColor = color;
}
////////////////////////////////////////////////////////////////////////////////////////////////////


@end
