//
//  FlipNumberView.m
//
//  Created by Markus Emrich on 26.02.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//
//
//  based on
//  www.voyce.com/index.php/2010/04/10/creating-an-ipad-flip-clock-with-core-animation/
//

#import <QuartzCore/QuartzCore.h>
#import "JDFlipNumberViewImageFactory.h"

#import "JDFlipNumberView.h"

static NSString* kFlipAnimationKey = @"kFlipAnimationKey";

typedef NS_OPTIONS(NSUInteger, JDFlipAnimationState) {
	JDFlipAnimationStateFirstHalf,
	JDFlipAnimationStateSecondHalf
};


@interface JDFlipNumberView ()
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *flipImageView;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, assign) JDFlipAnimationState animationState;
- (void)commonInit;
- (void)initImagesAndFrames;
- (void)updateFlipViewFrame;
@end


@implementation JDFlipNumberView

- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib;
{
    [self commonInit];
}

- (void)commonInit;
{
    // setup view
    self.backgroundColor = [UIColor clearColor];
    self.autoresizesSubviews = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    
    // default values
    _intValue = 0;
    _animationState = JDFlipAnimationStateFirstHalf;
    _animationDuration = 0.25;
    
    // images & frame
    [self initImagesAndFrames];
}

- (void)initImagesAndFrames;
{
	// setup image views
	self.topImageView	 = [[UIImageView alloc] initWithImage: JD_IMG_FACTORY.topImages[0]];
	self.flipImageView	 = [[UIImageView alloc] initWithImage: JD_IMG_FACTORY.topImages[0]];
	self.bottomImageView = [[UIImageView alloc] initWithImage: JD_IMG_FACTORY.bottomImages[0]];
    self.flipImageView.hidden = YES;
	
	self.bottomImageView.frame = CGRectMake(0, JD_IMG_FACTORY.imageSize.height,
                                            JD_IMG_FACTORY.imageSize.width,
                                            JD_IMG_FACTORY.imageSize.height);
	
	// add image views
	[self addSubview:self.topImageView];
	[self addSubview:self.bottomImageView];
	[self addSubview:self.flipImageView];
	
	// setup default 3d transform
	[self setZDistance: (JD_IMG_FACTORY.imageSize.height*2)*3];
    
    // setup frame
    super.frame = CGRectMake(0, 0, JD_IMG_FACTORY.imageSize.width, JD_IMG_FACTORY.imageSize.height*2);
}

- (CGSize) sizeThatFits: (CGSize) aSize
{
    CGSize imageSize = JD_IMG_FACTORY.imageSize;
    
    CGFloat ratioW     = aSize.width/aSize.height;
    CGFloat origRatioW = imageSize.width/(imageSize.height*2);
    CGFloat origRatioH = (imageSize.height*2)/imageSize.width;
    
    if (ratioW>origRatioW) {
        aSize.width = aSize.height*origRatioW;
    } else {
        aSize.height = aSize.width*origRatioH;
    }
    
    return aSize;
}


#pragma mark -
#pragma mark external access

- (void) setFrame: (CGRect)rect
{
    [self setFrame:rect allowUpscaling:NO];
}

- (void) setFrame: (CGRect)rect allowUpscaling:(BOOL)upscalingAllowed
{
    if (!upscalingAllowed) {
        rect.size.width  = MIN(rect.size.width, JD_IMG_FACTORY.imageSize.width);
        rect.size.height = MIN(rect.size.height, JD_IMG_FACTORY.imageSize.height*2);
    }
    
    rect.size = [self sizeThatFits: rect.size];
	[super setFrame: rect];
    
    // update imageView frames
    rect.origin = CGPointMake(0, 0);
    rect.size.height /= 2.0;
    self.topImageView.frame = rect;
    rect.origin.y += rect.size.height;
    self.bottomImageView.frame = rect;

    // update flip imageView frame
    BOOL isFirstHalf = (self.animationState == JDFlipAnimationStateFirstHalf);
    self.flipImageView.frame = (isFirstHalf) ? self.topImageView.frame : self.bottomImageView.frame;
	
    // reset Z distance
	[self setZDistance: self.frame.size.height*3];
}

- (void)setZDistance:(NSUInteger)zDistance;
{
	// setup 3d transform
	CATransform3D aTransform = CATransform3DIdentity;
	aTransform.m34 = -1.0 / zDistance;	
	self.layer.sublayerTransform = aTransform;
}

- (void)setIntValue:(NSUInteger)intValue;
{
    [self setIntValue:intValue animated:NO];
}

- (void)setIntValue:(NSUInteger)intValue animated:(BOOL)animated;
{
	// save new value
	_intValue = intValue%10;
	
	// inform delegate
	if ([self.delegate respondsToSelector:@selector(flipNumberView:willChangeToValue:animated:)]) {
		[self.delegate flipNumberView:self willChangeToValue:self.intValue animated:animated];
	}
	
	// show new value
	self.topImageView.image	   = JD_IMG_FACTORY.topImages[self.intValue];
    self.flipImageView.image   = JD_IMG_FACTORY.topImages[self.intValue];
	self.bottomImageView.image = JD_IMG_FACTORY.bottomImages[self.intValue];
    
	// inform delegate
	if ([self.delegate respondsToSelector:@selector(flipNumberView:didChangeValueAnimated:)]) {
		[self.delegate flipNumberView:self didChangeValueAnimated:animated];
	}
    
    // @TODO: animated updates
}

#pragma mark -
#pragma mark animation

- (void) animateIntoCurrentDirectionWithDuration: (CGFloat) duration
{
//	mCurrentAnimationDuration = duration;
//	
//	// get next value
//    NSUInteger nextIndex = [self nextValue];
//    if (mCurrentDirection == JDFlipDirectionDown) {
//        nextIndex = [self previousValue];
//    }
//	
//	// if duration is less than 0.05, don't animate
//	if (duration < 0.05) {
//		// inform delegate
//		if ([delegate respondsToSelector: @selector(flipNumberView:willChangeToValue:)]) {
//			[delegate flipNumberView: self willChangeToValue: nextIndex];
//		}
//		[NSTimer scheduledTimerWithTimeInterval: duration
//										 target: self
//									   selector: @selector(nextValueWithoutAnimation:)
//									   userInfo: nil
//										repeats: NO];
//		return;
//	}
//	
//	[self updateFlipViewFrame];
//	
//	// setup animation
//	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
//	animation.duration	= MIN(0.35,mCurrentAnimationDuration);
//	animation.delegate	= self;
//	animation.removedOnCompletion = NO;
//	animation.fillMode = kCAFillModeForwards;
//    
//	// exchange images & setup animation
//	if (mCurrentState == JDFlipAnimationStateFirstHalf)
//	{
//		// setup first animation half
//		self.flipImageView.frame   = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2.0);
//		self.flipImageView.image   = [mTopImages	objectAtIndex: mCurrentValue];
//		self.bottomImageView.image = [mBottomImages objectAtIndex: mCurrentValue];
//		self.topImageView.image	   = [mTopImages    objectAtIndex: nextIndex];
//        
//		// inform delegate
//		if ([delegate respondsToSelector: @selector(flipNumberView:willChangeToValue:)]) {
//			[delegate flipNumberView: self willChangeToValue: nextIndex];
//		}
//		
//		animation.fromValue	= [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0, 1, 0, 0)];
//		animation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI_2, 1, 0, 0)];
//		animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
//	}
//	else
//	{
//		// setup second animation half
//		self.flipImageView.image = [mBottomImages objectAtIndex: nextIndex];
//        
//		animation.fromValue	= [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 1, 0, 0)];
//		animation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0, 1, 0, 0)];
//		animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
//	}
//	
//	// add/start animation
//	[self.flipImageView.layer addAnimation: animation forKey: kFlipAnimationKey];
//	 
//	// show animated view
//	self.flipImageView.hidden = NO;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
//	if (!flag) {
//		return;
//	}
//	
//	if (mCurrentState == JDFlipAnimationStateFirstHalf)
//	{		
//		// do second animation step
//		mCurrentState = JDFlipAnimationStateSecondHalf;
//		[self animateIntoCurrentDirectionWithDuration: mCurrentAnimationDuration];
//	}
//	else
//	{
//		// reset state
//		mCurrentState = JDFlipAnimationStateFirstHalf;
//		
//		// set new value
//		NSUInteger nextIndex = [self nextValue];
//		if (mCurrentDirection == JDFlipDirectionDown) {
//			nextIndex = [self previousValue];
//		}
//		mCurrentValue = nextIndex;
//		
//		// update images
//		self.bottomImageView.image = [mBottomImages objectAtIndex: mCurrentValue];
//        self.flipImageView.hidden  = YES;
//		
//		// remove old animation
//		[self.flipImageView.layer removeAnimationForKey: kFlipAnimationKey];
//		
//		// inform delegate
//		if ([delegate respondsToSelector: @selector(flipNumberView:didChangeValue:animated:)]) {
//			[delegate flipNumberView: self didChangeValue: mCurrentValue animated: YES];
//		}
//	}
}

- (void) updateFlipViewFrame
{	
	if (self.animationState == JDFlipAnimationStateFirstHalf) {
		self.flipImageView.layer.anchorPoint = CGPointMake(0.5, 1.0);
		self.flipImageView.frame = self.topImageView.frame;
	} else {
		self.flipImageView.layer.anchorPoint = CGPointMake(0.5, 0.0);
		self.flipImageView.frame = self.bottomImageView.frame;
	}
}

@end
