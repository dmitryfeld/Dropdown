//
//  DFCAnimatedImageView.m
//  Dropdown
//
//  Created by Dmitry Feld on 2013-10-05.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCAnimatedImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface DFCAnimatedImageView() {
    BOOL _isPerformingAnimation;
}
- (void) onDelegateComplete;
@end

@implementation DFCAnimatedImageView
@synthesize parameters;
@synthesize delegate;
@synthesize isPerformingAnimation = _isPerformingAnimation;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isPerformingAnimation = NO;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}


- (void) startAnimation {
    if (kDFCItemIconAnimationTypeSpin & self.parameters.type) {
        [self startRotation];
        return;
    }
    if (kDFCItemIconAnimationTypeReplace & self.parameters.type) {
        [self startCrossFading];
        return;
    }
    if (kDFCItemIconAnimationTypeAlphaFade & self.parameters.type) {
        [self startFading];
    }
}
- (void) stopAnimation {
    CALayer *myLayer = [self layer];
    [myLayer removeAllAnimations];
}

-(void) startRotation {    
    CALayer *myLayer = [self layer];
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: (4* M_PI) * 1];
    rotationAnimation.duration = self.parameters.duration;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatDuration = self.parameters.continuous?DBL_MAX:self.parameters.duration;
    rotationAnimation.delegate = self;
    rotationAnimation.removedOnCompletion = YES;
    [myLayer addAnimation:rotationAnimation forKey:@"transform.rotation"];
}
-(void) startFading {
    CALayer *myLayer = [self layer];
    CABasicAnimation* fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOut.toValue = [NSNumber numberWithFloat: .0f];
    fadeOut.duration = self.parameters.duration;
    fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fadeOut.removedOnCompletion = YES;
    fadeOut.autoreverses = YES;
    fadeOut.repeatCount = self.parameters.continuous?HUGE_VAL:1;
    fadeOut.delegate = self;
    [myLayer addAnimation:fadeOut forKey:@"opacity"];
}

- (void) startCrossFading {
    CALayer *myLayer = [self layer];
    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"contents"];
    fadeOut.duration = self.parameters.duration;
    fadeOut.toValue = self.parameters.imageReplacement;
    fadeOut.removedOnCompletion = YES;
    fadeOut.autoreverses = YES;
    fadeOut.repeatCount = self.parameters.continuous?HUGE_VAL:1;
    fadeOut.delegate = self;
    [myLayer addAnimation:fadeOut forKey:@"contents"];
}

- (void) animationDidStart:(CAAnimation *)anim {
    _isPerformingAnimation = YES;
}
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    _isPerformingAnimation = NO;
    [self performSelectorOnMainThread:@selector(onDelegateComplete) withObject:nil waitUntilDone:YES];
}
- (void) onDelegateComplete {
    if ([self.delegate respondsToSelector:@selector(animated:hasCompletedAnimationWithParameters:)]) {
        [self.delegate animated:self hasCompletedAnimationWithParameters:self.parameters];
    }
}
- (void) setFrame:(NSRect)frameRect {
    [super setFrame:frameRect];
    if (self.image) {
        // Prepare layer for animation
        CALayer* layer = self.layer;
        NSPoint position = layer.position;
        NSSize size = self.image.size;
        layer.anchorPoint = NSMakePoint(.5f, .5f);
        position.x += .5*size.width;
        position.y += .5*size.height;
        layer.position = position;
    }
}
@end
