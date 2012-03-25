//
//  GroupedFlipNumberView.h
//  OneTwoThree
//
//  Created by Markus Emrich on 27.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlipNumberView.h"

@protocol GroupedFlipNumberViewDelegate;

@interface GroupedFlipNumberView : UIView <FlipNumberViewDelegate>
{
	NSArray* mFlipNumberViews;
	
    NSUInteger mMaxValue;
    eFlipDirection mCurrentDirection;
	
	NSInteger mTargetValue;
	BOOL mTargetMode;
    
	id<GroupedFlipNumberViewDelegate> delegate;
}

@property (nonatomic, assign) id<GroupedFlipNumberViewDelegate> delegate;
@property (nonatomic, assign) NSUInteger intValue;
@property (nonatomic, assign) NSUInteger maximumValue;
@property (nonatomic, assign) eFlipDirection currentDirection;


- (id) initWithFlipNumberViewCount: (NSUInteger) viewCount;

- (void) setMaximumValue: (NSUInteger) maxValue;
- (void) setZDistance: (NSUInteger) zDistance;

// basic animation
- (void) animateToNextNumber;
- (void) animateToPreviousNumber;

// timed animation
- (void) animateUpWithTimeInterval: (NSTimeInterval) timeInterval;
- (void) animateDownWithTimeInterval: (NSTimeInterval) timeInterval;

// targeted animation
- (void) animateToValue: (NSInteger) value withDuration: (CGFloat) duration;

- (void) stopAnimation;

@end


#pragma mark -
#pragma mark delegate


@protocol GroupedFlipNumberViewDelegate <NSObject>
@optional
- (void) groupedFlipNumberView: (GroupedFlipNumberView*) groupedFlipNumberView willChangeToValue: (NSUInteger) newValue;
- (void) groupedFlipNumberView: (GroupedFlipNumberView*) groupedFlipNumberView didChangeValue: (NSUInteger) newValue animated: (BOOL) animated;
@end;