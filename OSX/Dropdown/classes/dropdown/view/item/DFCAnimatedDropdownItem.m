//
//  DFCAnimatedDropdownItem.m
//  Dropdown
//
//  Created by Dmitry Feld on 2013-10-05.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCAnimatedDropdownItem.h"
#import "DFCAnimatedImageView.h"
#import "DFCItem+Private.h"

@interface DFCAnimatedDropdownItem() {
    DFCItemAnimationParameters* _animationParameters;
}
- (NSImageView*) newImageView;
@end


@implementation DFCAnimatedDropdownItem
@dynamic isPerformingAnimation;
@dynamic animationParameters;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _animationParameters = [DFCItemAnimationParameters new];
        [self  setWantsLayer:YES];
    }
    return self;
}
- (void) dealloc {
    [_animationParameters dealloc];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];
}


- (NSImageView*) newImageView {
    DFCAnimatedImageView* result = [DFCAnimatedImageView new];
    result.parameters = _animationParameters;
    return result;
}


- (DFCItemAnimationParameters*) animationParameters {
    return _animationParameters;
}
- (void) setAnimationParameters:(DFCItemAnimationParameters *)animationParameters {
    if ([_animationParameters isEqualTo:animationParameters]) {
        NSImageView* image = [self getImageView];
        [_animationParameters release],_animationParameters = [animationParameters retain];
        if ([image isKindOfClass:[DFCAnimatedImageView class]]) {
            ((DFCAnimatedImageView*)image).parameters = _animationParameters;
        }
    }
}
- (BOOL) isPerformingAnimation {
    BOOL result = NO;
    NSImageView* image = [self getImageView];
    if ([image isKindOfClass:[DFCAnimatedImageView class]]) {
        result = ((DFCAnimatedImageView*)image).isPerformingAnimation;
    }
    return result;
}
- (void) startAnimation {
    NSImageView* image = [self getImageView];
    if ([image isKindOfClass:[DFCAnimatedImageView class]]) {
        [((DFCAnimatedImageView*)image) startAnimation];
    }
}
- (void) stopAnimation {
    NSImageView* image = [self getImageView];
    if ([image isKindOfClass:[DFCAnimatedImageView class]]) {
        [((DFCAnimatedImageView*)image) stopAnimation];
    }
}

@end
