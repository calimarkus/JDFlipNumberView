//
//  JDGroupedFlipNumberView.h
//
//  Created by Markus Emrich on 27.02.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//

#import "JDFlipNumberView.h"

@protocol JDGroupedFlipNumberViewDelegate;

@interface JDGroupedFlipNumberView : UIView <JDFlipNumberViewDelegate>
{
	NSArray* mFlipNumberViews;
	
    NSUInteger mMaxValue;
    eFlipDirection mCurrentDirection;
	
	NSInteger mTargetValue;
	BOOL mTargetMode;
    
	id<JDGroupedFlipNumberViewDelegate> delegate;
}

@property (nonatomic, assign) id<JDGroupedFlipNumberViewDelegate> delegate;
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


@protocol JDGroupedFlipNumberViewDelegate <NSObject>
@optional
- (void) groupedFlipNumberView: (JDGroupedFlipNumberView*) groupedFlipNumberView willChangeToValue: (NSUInteger) newValue;
- (void) groupedFlipNumberView: (JDGroupedFlipNumberView*) groupedFlipNumberView didChangeValue: (NSUInteger) newValue animated: (BOOL) animated;
@end;