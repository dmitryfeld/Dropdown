//
//  DFCDropdownItem.m
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-26.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCDropdownItem.h"
#import "DFCItem+Private.h"

@interface DFCDropdownItem() {
    NSTrackingArea* _trackingArea;
}
@property (assign, nonatomic) id messagingCallback;
@end

@implementation DFCDropdownItem
@synthesize delegate;
@synthesize messagingCallback;
@dynamic isHighlighted;
@synthesize tag;
- (void) dealloc {
    [self removeTrackingArea:_trackingArea];
    [_trackingArea release], _trackingArea = nil;
    [super dealloc];
}
- (BOOL) isHighlighted {
    return [[super getParameters].itemTextHighlightedColor isEqualTo:[super getTitleView].textColor];
}
- (void) setIsHighlighted:(BOOL)isHighlighted {
    if (isHighlighted) {
        [super getTitleView].textColor = [super getParameters].itemTextHighlightedColor;
    } else {
        [super getTitleView].textColor = [super getParameters].itemTextColor;
    }
    [self setNeedsDisplay:YES];
}


- (void)drawRect:(NSRect)dirtyRect {
    if (self.isHighlighted) {
        [[super getParameters].itemHighlightedGradient drawInRect:[self bounds] angle:[super getParameters].itemGradientAngle];
    } else {
        [[super getParameters].itemGradient drawInRect:[self bounds] angle:[super getParameters].itemGradientAngle];
    }
    [super drawRect:dirtyRect];
}
- (void) mouseEntered:(NSEvent *)theEvent {
    self.isHighlighted = YES;
    [self performSelector:@selector(onMouseEntered:) onThread:[NSThread mainThread] withObject:theEvent waitUntilDone:YES];
}
- (void) mouseExited:(NSEvent *)theEvent {
    self.isHighlighted = NO;
    [self performSelector:@selector(onMouseExited:) onThread:[NSThread mainThread] withObject:theEvent waitUntilDone:YES];
}

- (void) mouseDown:(NSEvent *)theEvent {
    [self performSelector:@selector(onMouseDown:) onThread:[NSThread mainThread] withObject:theEvent waitUntilDone:YES];
}

- (void) mouseUp:(NSEvent *)theEvent {
    [self performSelector:@selector(onMouseUp:) onThread:[NSThread mainThread] withObject:theEvent waitUntilDone:YES];
}

- (void) updateTrackingAreas {
    if(_trackingArea != nil) {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
    }
    
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
    _trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                  options:opts
                                                    owner:self
                                                 userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void) onMouseUp:(NSEvent*)event {
    if ([self.delegate respondsToSelector:@selector(itemViewReleased:)]) {
        [self.delegate performSelector:@selector(itemViewReleased:) withObject:self];
    }
}

- (void) onMouseDown:(NSEvent*)event {
    if ([self.delegate respondsToSelector:@selector(itemViewPressed:)]) {
        [self.delegate performSelector:@selector(itemViewPressed:) withObject:self];
    }
}

- (void) onMouseEntered:(NSEvent*)event {
    if ([self.delegate respondsToSelector:@selector(itemViewEntered:)]) {
        [self.delegate performSelector:@selector(itemViewEntered:) withObject:self];
    }
}

- (void) onMouseExited:(NSEvent*)event {
    if ([self.delegate respondsToSelector:@selector(itemViewExited:)]) {
        [self.delegate performSelector:@selector(itemViewExited:) withObject:self];
    }
}

- (DFCTextParameters) getTextParameters {
    return [self getParameters].itemTextParameters;
}

@end
