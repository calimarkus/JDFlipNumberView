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

static NSString *const JDFlipNumerViewDefaultBundle = @"JDFlipNumberView";
static NSString *const kFlipAnimationKey = @"kFlipAnimationKey";
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

@property (nonatomic, readonly) NSArray *topImages;
@property (nonatomic, readonly) NSArray *bottomImages;
@property (nonatomic, readonly) CGSize imageSize;

@end


@implementation JDFlipNumberDigitView

- (id)initWithImageBundle:(NSString*)bundleName;
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // setup view
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = NO;
        
        // default values
        _value = 0;
        _animationState = JDFlipAnimationStateFirstHalf;
        _animationDuration = kFlipAnimationMaximumAnimationDuration;
        
        // images & frame
        self.bundleName = bundleName;
        [self initImagesAndFrames];
    }
    return self;
}

- (void)initImagesAndFrames;
{
	// setup image views
	self.topImageView	 = [[UIImageView alloc] initWithImage:self.topImages[0]];
	self.flipImageView	 = [[UIImageView alloc] initWithImage:self.topImages[0]];
	self.bottomImageView = [[UIImageView alloc] initWithImage:self.bottomImages[0]];
    self.flipImageView.hidden = YES;
    
    // set z positions
    self.topImageView.layer.zPosition = -1;
    self.bottomImageView.layer.zPosition = -1;
    self.flipImageView.layer.zPosition = 0;
	
	// add image views
	[self addSubview:self.topImageView];
	[self addSubview:self.bottomImageView];
	[self addSubview:self.flipImageView];
	
	// setup default 3d transform
	[self setZDistance: (self.imageSize.height*2)*3];
    
    // setup frames
    CGSize size = self.imageSize;
	self.bottomImageView.frame = CGRectMake(0, size.height, size.width, size.height);
    super.frame = CGRectMake(0, 0, size.width, size.height*2);
}

#pragma mark factory access

- (void)setBundleName:(NSString *)imageBundleName;
{
    if (imageBundleName == nil) imageBundleName = JDFlipNumerViewDefaultBundle;
    _imageBundleName = [imageBundleName copy];
    
    // update images
    self.topImageView.image	   = self.topImages[self.value];
    self.flipImageView.image   = self.topImages[self.value];
    self.bottomImageView.image = self.bottomImages[self.value];
}

- (NSArray*)topImages;
{
    JDFlipNumberViewImageFactory *factory = [JDFlipNumberViewImageFactory sharedInstance];
    return [factory topImagesForBundleNamed:self.imageBundleName];
}

- (NSArray*)bottomImages;
{
    JDFlipNumberViewImageFactory *factory = [JDFlipNumberViewImageFactory sharedInstance];
    return [factory bottomImagesForBundleNamed:self.imageBundleName];
}

- (CGSize)imageSize;
{
    JDFlipNumberViewImageFactory *factory = [JDFlipNumberViewImageFactory sharedInstance];
    return [factory imageSizeForBundleNamed:self.imageBundleName];
}

#pragma mark -
#pragma mark layout

- (CGSize)sizeThatFits:(CGSize)aSize;
{
    CGSize imageSize = self.imageSize;
    
    CGFloat ratioW     = aSize.width/aSize.height;
    CGFloat origRatioW = imageSize.width/(imageSize.height*2);
    CGFloat origRatioH = (imageSize.height*2)/imageSize.width;
    
    if (ratioW>origRatioW) {
        aSize.width = aSize.height*origRatioW;
    } else {
        aSize.height = aSize.width*origRatioH;
    }
    
    if (!self.upscalingAllowed) {
        aSize = [self sizeWithMaximumSize:aSize];
    }
    
    return aSize;
}

- (CGSize)sizeWithMaximumSize:(CGSize)size;
{
    size.width  = MIN(size.width, self.imageSize.width);
    size.height = MIN(size.height, self.imageSize.height*2);
    return size;
}

- (void)setFrame:(CGRect)rect;
{
    rect.size = [self sizeThatFits:rect.size];
	[super setFrame:rect];
    
    // update imageView frames
    rect.origin = CGPointMake(0, 0);
    rect.size.height /= 2.0;
    self.topImageView.frame = rect;
    rect.origin.y += rect.size.height;
    self.bottomImageView.frame = rect;

    // update flip imageView frame
    [self updateFlipViewFrame];
	
    // reset Z distance
	[self setZDistance: self.frame.size.height*3];
}

- (void)setZDistance:(NSUInteger)zDistance;
{
    _zDistance = zDistance;
    
	// setup 3d transform
	CATransform3D aTransform = CATransform3DIdentity;
	aTransform.m34 = -1.0 / zDistance;	
	self.layer.sublayerTransform = aTransform;
}

#pragma mark value setter

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
        self.topImageView.image	   = self.topImages[self.value];
        self.flipImageView.image   = self.topImages[self.value];
        self.bottomImageView.image = self.bottomImages[self.value];
        
        // reset state
        self.flipImageView.hidden = YES;
        
        // call completion immediatly
        if (self.completionBlock) {
            JDDigitAnimationCompletionBlock completion = self.completionBlock;
            self.completionBlock = nil;
            completion(YES);
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
        self.topImageView.image	   = self.topImages[isTopDown ? self.value : self.previousValue];
        self.flipImageView.image   = isTopDown ? self.topImages[self.previousValue] : self.bottomImages[self.previousValue];
        self.bottomImageView.image = self.bottomImages[isTopDown ? self.previousValue : self.value];
		
        animation.fromValue	= [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0, 1, 0, 0)];
        animation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(isTopDown ? -M_PI_2 : M_PI_2, 1, 0, 0)];
		animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	} else {
		// setup second animation half
        if (isTopDown) {
            self.flipImageView.image = self.bottomImages[self.value];
        } else {
            self.flipImageView.image = self.topImages[self.value];
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
            JDDigitAnimationCompletionBlock completion = self.completionBlock;
            self.completionBlock = nil;
            completion(NO);
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
            self.bottomImageView.image = self.bottomImages[self.value];
        } else {
            self.topImageView.image = self.topImages[self.value];
        }
		
		// remove old animation
		[self.flipImageView.layer removeAnimationForKey: kFlipAnimationKey];
        
        // hide animated view
        self.flipImageView.hidden = YES;
        
        // call completion block
        if (self.completionBlock) {
            JDDigitAnimationCompletionBlock completion = self.completionBlock;
            self.completionBlock = nil;
            completion(YES);
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
