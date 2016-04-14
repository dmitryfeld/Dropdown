//
//  DFCHorizontalDecoration.m
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-30.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCHorizontalDecoration.h"
#import "DFCItem+Private.h"

@implementation DFCHorizontalDecoration
- (DFCTextParameters) getTextParameters {
    return [self getParameters].decorationTextParameters;
}

@end

/*
 @implementation VerticalTextCell
 
 - (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
 
 NSMutableDictionary *atr = [NSMutableDictionary dictionary];
 NSFont *font = [NSFont fontWithName:@"Lucida Grande" size:12];
 [atr setObject:font forKey:NSFontAttributeName];
 
 [[[self backgroundColor] colorWithAlphaComponent:0.7] set];
 NSRectFillUsingOperation(cellFrame, NSCompositeSourceOver);
 
 NSGraphicsContext *currentContext = [NSGraphicsContext currentContext];
 [currentContext saveGraphicsState];
 
 NSAffineTransform *transform = [NSAffineTransform transform];
 [transform translateXBy:NSMinX(cellFrame) yBy:NSMinY(cellFrame)];
 [transform rotateByDegrees:-90];
 [transform concat];
 
 // vertical inset 5 pixels
 [[self stringValue] drawInRect:NSMakeRect(-NSHeight(cellFrame),5,NSHeight(cellFrame),NSWidth(cellFrame)) withAttributes:atr];
 
 [currentContext restoreGraphicsState];
 
 }
 
 
 @end
 */
