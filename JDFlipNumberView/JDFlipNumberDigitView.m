//
//  JDFlipNumberDigitView.m
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

#import "JDFlipNumberDigitView.h"

static NSString* kFlipAnimationKey = @"kFlipAnimationKey";
static CGFloat kFlipAnimationMinimumAnimationDuration = 0.05;
static CGFloat kFlipAnimationMaximumAnimationDuration = 0.70;

typedef NS_OPTIONS(NSUInteger, JDFlipAnimationState) {
	JDFlipAnimationStateFirstHalf,
	JDFlipAnimationStateSecondHalf
};


@interface JDFlipNumberDigitView ()
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *flipImageView;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, assign) JDFlipAnimationState animationState;
@property (nonatomic, assign) JDFlipAnimationType animationType;
@property (nonatomic, assign) NSUInteger previousValue;
@property (nonatomic, copy) JDDigitAnimationCompletionBlock completionBlock;
- (void)commonInit;
- (void)initImagesAndFrames;
- (void)updateFlipViewFrame;
- (void)updateImagesAnimated:(BOOL)animated;
- (void)runAnimation;
@end


@implementation JDFlipNumberDigitView

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
    _value = 0;
    _animationState = JDFlipAnimationStateFirstHalf;
    _animationDuration = kFlipAnimationMaximumAnimationDuration;
    
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

- (CGSize)sizeThatFits:(CGSize)aSize;
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

- (void)setFrame:(CGRect)rect;
{
    [self setFrame:rect allowUpscaling:NO];
}

- (void)setFrame:(CGRect)rect allowUpscaling:(BOOL)upscalingAllowed;
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

- (void)setValue:(NSUInteger)value
{
    [self setValue:value withAnimationType:JDFlipAnimationTypeNone completion:nil];
}

- (void)setValue:(NSUInteger)value withAnimationType:(JDFlipAnimationType)animationType
      completion:(JDDigitAnimationCompletionBlock)completionBlock;
{
    // copy completion block
    self.completionBlock = completionBlock;
    
	// save previous value
    self.previousValue = self.value;
	NSInteger newValue = value % 10;

    // update animation type
    self.animationType = animationType;
	BOOL animated = (animationType != JDFlipAnimationTypeNone);
    
    // save new value
    _value = newValue;
	
    [self updateImagesAnimated:animated];
}

#pragma mark -
#pragma mark animation

- (void)updateImagesAnimated:(BOOL)animated
{
    if (!animated || self.animationDuration < kFlipAnimationMinimumAnimationDuration) {
        // show new value
        self.topImageView.image	   = JD_IMG_FACTORY.topImages[self.value];
        self.flipImageView.image   = JD_IMG_FACTORY.topImages[self.value];
        self.bottomImageView.image = JD_IMG_FACTORY.bottomImages[self.value];
        
        // reset state
        self.flipImageView.hidden = YES;
        
        // call completion immediatly
        if (self.completionBlock) {
            self.completionBlock(YES);
            self.completionBlock = nil;
        }
    } else {
        self.animationState = JDFlipAnimationStateFirstHalf;
        [self runAnimation];
    }
}

- (void)runAnimation;
{
	[self updateFlipViewFrame];
    
    BOOL isTopDown = self.animationType == JDFlipAnimationTypeTopDown;
	
	// setup animation
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
	animation.duration	= MIN(kFlipAnimationMaximumAnimationDuration/2.0,self.animationDuration/2.0);
	animation.delegate	= self;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeForwards;
    
	// exchange images & setup animation
	if (self.animationState == JDFlipAnimationStateFirstHalf) {
        // remove any old animations
        [self.flipImageView.layer removeAllAnimations];
        
		// setup first animation half
        self.topImageView.image	   = JD_IMG_FACTORY.topImages[isTopDown ? self.value : self.previousValue];
        self.flipImageView.image   = isTopDown ? JD_IMG_FACTORY.topImages[self.previousValue] : JD_IMG_FACTORY.bottomImages[self.previousValue];
        self.bottomImageView.image = JD_IMG_FACTORY.bottomImages[isTopDown ? self.previousValue : self.value];
		
        animation.fromValue	= [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0, 1, 0, 0)];
        animation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(isTopDown ? -M_PI_2 : M_PI_2, 1, 0, 0)];
		animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	} else {
		// setup second animation half
        if (isTopDown) {
            self.flipImageView.image = JD_IMG_FACTORY.bottomImages[self.value];
        } else {
            self.flipImageView.image = JD_IMG_FACTORY.topImages[self.value];
        }
        
		animation.fromValue	= [NSValue valueWithCATransform3D:CATransform3DMakeRotation(isTopDown ? M_PI_2 : -M_PI_2, 1, 0, 0)];
		animation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0, 1, 0, 0)];
		animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	}
	
	// add/start animation
	[self.flipImageView.layer addAnimation: animation forKey: kFlipAnimationKey];
    
	// show animated view
	self.flipImageView.hidden = NO;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
	if (!finished) {
        if (self.completionBlock) {
            self.completionBlock(NO);
            self.completionBlock = nil;
        }
		return;
	}
	
	if (self.animationState == JDFlipAnimationStateFirstHalf) {
		// do second animation step
		self.animationState = JDFlipAnimationStateSecondHalf;
		[self runAnimation];
	} else {
		// reset state
		self.animationState = JDFlipAnimationStateFirstHalf;
		
		// update images
        if(self.animationType == JDFlipAnimationTypeTopDown) {
            self.bottomImageView.image = JD_IMG_FACTORY.bottomImages[self.value];
        } else {
            self.topImageView.image = JD_IMG_FACTORY.topImages[self.value];
        }
        self.flipImageView.hidden  = YES;
		
		// remove old animation
		[self.flipImageView.layer removeAnimationForKey: kFlipAnimationKey];
        
        // call completion block
        if (self.completionBlock) {
            self.completionBlock(YES);
            self.completionBlock = nil;
        }
	}
}

- (void)updateFlipViewFrame;
{
    if ((self.animationType == JDFlipAnimationTypeTopDown && self.animationState == JDFlipAnimationStateFirstHalf) ||
        (self.animationType == JDFlipAnimationTypeBottomUp && self.animationState == JDFlipAnimationStateSecondHalf)) {
		self.flipImageView.layer.anchorPoint = CGPointMake(0.5, 1.0);
		self.flipImageView.frame = self.topImageView.frame;
	} else {
		self.flipImageView.layer.anchorPoint = CGPointMake(0.5, 0.0);
		self.flipImageView.frame = self.bottomImageView.frame;
	}
}

@end
