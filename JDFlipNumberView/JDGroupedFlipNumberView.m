//
//  GroupedFlipNumberView.m
//
//  Created by Markus Emrich on 27.02.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//

#import "JDGroupedFlipNumberView.h"


@implementation JDGroupedFlipNumberView

@synthesize delegate;
@dynamic	intValue;
@dynamic	maximumValue;
@synthesize	currentDirection = mCurrentDirection;

- (id) init
{
	return [self initWithFlipNumberViewCount: 2];
}

- (id) initWithFlipNumberViewCount: (NSUInteger) viewCount;
{
    self = [super initWithFrame: CGRectZero];
    if (self)
	{
		self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
		
        viewCount = MAX(2,viewCount);
		
        mMaxValue = 99;
        mCurrentDirection = eFlipDirectionUp;
		mTargetMode = NO;
        
		JDFlipNumberView* view = nil;
		NSMutableArray* allViews = [[NSMutableArray alloc] initWithCapacity: viewCount];
		for (int i = 0; i < viewCount; i++)
		{
			view = [[JDFlipNumberView alloc] init];
			view.delegate = self;
			view.frame = CGRectMake(i*view.frame.size.width, 0, view.frame.size.width, view.frame.size.height);
			[self addSubview: view];
			[allViews addObject: view];
			[view release];
		}
		
		mFlipNumberViews = [[NSArray alloc] initWithArray: allViews];
		[allViews release];
		
		super.frame = CGRectMake(0, 0, viewCount*view.frame.size.width, view.frame.size.height);
    }
    return self;
}

- (void)dealloc
{
	// NSLog(@"dealloc");
	
	[mFlipNumberViews release];
    [super dealloc];
}

#pragma mark -
#pragma mark external access


- (NSUInteger) intValue
{
	NSMutableString* stringValue = [NSMutableString stringWithCapacity: [mFlipNumberViews count]];
	for (JDFlipNumberView* view in mFlipNumberViews) {
		[stringValue appendFormat: @"%d", view.intValue];
	}
	
	return [stringValue intValue];
}

- (void) setIntValue: (NSUInteger) newValue
{
	for (JDFlipNumberView* view in mFlipNumberViews) {
        view.intValue = 0;
    }
    
	NSString* stringValue = [NSString stringWithFormat: @"%d", newValue];
	
	for (int i = 0; i < [stringValue length] && i < [mFlipNumberViews count]; i++)
	{
		JDFlipNumberView* view = (JDFlipNumberView*)[mFlipNumberViews objectAtIndex: [mFlipNumberViews count]-(1+i)];
		view.intValue = [[stringValue substringWithRange: NSMakeRange([stringValue length]-(1+i), 1)] intValue];
	}
	
	if ([delegate respondsToSelector: @selector(groupedFlipNumberView:didChangeValue:animated:)]) {
		[delegate groupedFlipNumberView: self didChangeValue: [self intValue] animated: NO];
	}
}

- (NSUInteger) maximumValue
{
	return mMaxValue;
}

- (void) setMaximumValue: (NSUInteger) maxValue
{
	for (JDFlipNumberView* view in mFlipNumberViews) {
        view.maxValue = 0;
    }
    
	NSString* stringValue = [NSString stringWithFormat: @"%d", maxValue];
	
	for (int i = 0; i < [stringValue length] && i < [mFlipNumberViews count]; i++)
	{
		JDFlipNumberView* view = (JDFlipNumberView*)[mFlipNumberViews objectAtIndex: [mFlipNumberViews count]-(1+i)];
		view.maxValue = [[stringValue substringWithRange: NSMakeRange([stringValue length]-(1+i), 1)] intValue];
	}
    
    mMaxValue = maxValue;
}

- (void) setZDistance: (NSUInteger) zDistance
{
	for (JDFlipNumberView* view in mFlipNumberViews) {
		[view setZDistance: zDistance];
	}
}

#pragma mark -
#pragma mark animation

- (void) animateToNextNumber
{
	[self stopAnimation];
    mCurrentDirection = eFlipDirectionUp;
    
	JDFlipNumberView* view = (JDFlipNumberView*)[mFlipNumberViews lastObject];
	[view animateToNextNumber];
}

- (void) animateToPreviousNumber
{
	[self stopAnimation];
    mCurrentDirection = eFlipDirectionDown;
    
	JDFlipNumberView* view = (JDFlipNumberView*)[mFlipNumberViews lastObject];
	[view animateToPreviousNumber];
}

#pragma mark -
#pragma mark timed animation

- (void) animateUpWithTimeInterval: (NSTimeInterval) timeInterval
{
	[self stopAnimation];
    mCurrentDirection = eFlipDirectionUp;
    
    JDFlipNumberView* view = (JDFlipNumberView*)[mFlipNumberViews lastObject];
	[view animateUpWithTimeInterval: timeInterval];
}

- (void) animateDownWithTimeInterval: (NSTimeInterval) timeInterval
{
	[self stopAnimation];
    mCurrentDirection = eFlipDirectionDown;
    
    JDFlipNumberView* view = (JDFlipNumberView*)[mFlipNumberViews lastObject];
	[view animateDownWithTimeInterval: timeInterval];
}

#pragma mark -
#pragma mark targeted animation

- (void) animateToValue: (NSInteger) value withDuration: (CGFloat) duration
{
	// get value in valid range
	NSString* strvalue = [NSString stringWithFormat: @"%30d", value];
	strvalue = [strvalue substringWithRange: NSMakeRange([strvalue length]-[mFlipNumberViews count], [mFlipNumberViews count])];
	value = [strvalue intValue];
	
	// determine direction
	eFlipDirection direction = eFlipDirectionDown;
	if (value >= [self intValue]) {
		direction = eFlipDirectionUp;
	}
	
	// determine speed per digit
	NSInteger difference = ABS(value-self.intValue);
	CGFloat speed = ABS(duration/difference);
	
	if (direction == eFlipDirectionUp) {
		[self animateUpWithTimeInterval: speed];
	} else {
		[self animateDownWithTimeInterval: speed];
	}
	
	// enable target mode and save target value (this has do be done after animation start)
	mTargetMode = YES;
	mTargetValue = value;
    
    // inform programmer about time difference
    if (speed < 0.001) {
        NSString *message = [NSString stringWithFormat:@"Actual animation duration will be: %.02f seconds", ABS(0.001*difference)];
        NSLog(@"%@", message);
        [NSException raise:NSInvalidArgumentException format:@"%@", message];
    }
}

#pragma mark -
#pragma mark cancel animation

- (void) stopAnimation
{
	mTargetMode = NO;
	
	JDFlipNumberView* view = (JDFlipNumberView*)[mFlipNumberViews lastObject];
	[view stopAnimation];
}

#pragma mark -
#pragma mark resizing

- (void) setFrame: (CGRect) rect
{
    JDFlipNumberView* view = nil;
	if (mFlipNumberViews && [mFlipNumberViews count] > 0)
	{
		NSUInteger i, count = [mFlipNumberViews count], xWidth = rect.size.width/count;
		for (i = 0; i < count; i++)
		{
			view = [mFlipNumberViews objectAtIndex:i];
			view.frame = CGRectMake(i*xWidth, 0, xWidth, rect.size.height);
		}
	}
    
    if (view) {
		// take bottom right of last view for new size, to match size of subviews
		rect.size.width  = ceil(view.frame.size.width  + view.frame.origin.x);
		rect.size.height = ceil(view.frame.size.height + view.frame.origin.y);
    }
    
    [super setFrame: rect];
}

#pragma mark -
#pragma mark delegate


- (void) flipNumberView: (JDFlipNumberView*) flipNumberView willChangeToValue: (NSUInteger) newValue
{
    BOOL upwardsEnded   = newValue == 0 && flipNumberView.currentDirection == eFlipDirectionUp;
    BOOL downwardsEnded = newValue == flipNumberView.maxValue && flipNumberView.currentDirection == eFlipDirectionDown;
    
//    LOG(@"newValue: %d", newValue);
    
	if (upwardsEnded || downwardsEnded)
	{
		NSUInteger index = [mFlipNumberViews indexOfObject: flipNumberView];
		if (index > 0)
		{
			JDFlipNumberView* view = (JDFlipNumberView*)[mFlipNumberViews objectAtIndex: index-1];
            if (upwardsEnded) {
                [view animateToNextNumberWithDuration: flipNumberView.currentAnimationDuration*9.0];
            } else {
                [view animateToPreviousNumberWithDuration: flipNumberView.currentAnimationDuration*9.0];
            }
		}
	}
	
	if (flipNumberView == [mFlipNumberViews lastObject]) {
		if ([delegate respondsToSelector: @selector(groupedFlipNumberView:willChangeToValue:)])
        {
            NSInteger newValue = [self intValue];
            if (flipNumberView.currentDirection == eFlipDirectionDown) {
                newValue -= 1;
            } else {
                newValue += 1;
            }
            newValue = (mMaxValue+1+newValue) % (mMaxValue+1);
            
			[delegate groupedFlipNumberView: self willChangeToValue: newValue];
		}
	}
}

- (void) flipNumberView:(JDFlipNumberView *)flipNumberView didChangeValue:(NSUInteger)newValue animated:(BOOL)animated
{
	if(mTargetMode == YES && flipNumberView == [mFlipNumberViews lastObject])
	{
		BOOL upEnd   = (mCurrentDirection == eFlipDirectionUp && [self intValue] >= mTargetValue);
		BOOL downEnd = (mCurrentDirection == eFlipDirectionDown && [self intValue] <= mTargetValue);
		
		if(upEnd || downEnd)  {
			[self stopAnimation];
			self.intValue = mTargetValue;
		}
	}
	
	if ([delegate respondsToSelector: @selector(groupedFlipNumberView:didChangeValue:animated:)]) {
		[delegate groupedFlipNumberView: self didChangeValue: [self intValue] animated: animated];
	}
}


@end
