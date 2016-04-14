//
//  DFCDropDownParameters.m
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-16.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCDropDownParameters.h"

#define __LINE_THICKNESS__ 4.f
#define __CORNER_RADIUS__ 19.0f

#define __ARROW_WIDTH__ 12.0f
#define __ARROW_HEIGHT__ 8.0f

#define __POPUP_HEIGHT__ 220
#define __POPUP_WIDTH__ 310
#define __OPEN_DURATION__ .1

DFCTextParameters DFCTextParametersMake(NSColor* textColor,NSFont* textFont,CGFloat textGap,NSSize textMargin,NSLineBreakMode textLineBreakMode,NSTextAlignment textAlignment);
BOOL DFCEqualTextParameters(DFCTextParameters p1,DFCTextParameters p2);


@interface DFCDropdownParameters()
- (NSFont*) createDDFont;
- (NSFont*) createDCFont;
@end

@implementation DFCDropdownParameters
@synthesize fillColor;
@synthesize strokeColor;
@synthesize lineThickness;
@synthesize cornerRadius;
@synthesize arrowSize;
@synthesize arrowOrientation;
@synthesize openDuration;
@synthesize popupSize;

@synthesize decorationPosition;
@synthesize decorationImage;
@synthesize decorationGradient;
@synthesize decorationGradientAngle;
@synthesize decorationColor;
@synthesize decorationDimension;
@synthesize decorationTextColor;
@synthesize decorationFont;
@synthesize decorationTextAlignment;
@synthesize decorationLineBreakMode;
@synthesize decorationMargin;
@synthesize decorationGap;

@synthesize clientBackgroundColor;

@synthesize itemGradient;
@synthesize itemHighlightedGradient;
@synthesize itemGradientAngle;
@synthesize itemTextColor;
@synthesize itemTextHighlightedColor;
@synthesize itemMargin;
@synthesize itemGap;
@synthesize itemFont;
@synthesize itemLineBreakMode;
@synthesize itemTextAlignment;

@dynamic itemTextParameters;
@dynamic decorationTextParameters;

- (id) init {
    if (self = [super init]) {
        self.fillColor = [NSColor colorWithDeviceRed:1.0 green:1.0 blue:1.0 alpha:.9];
        self.strokeColor = [NSColor colorWithDeviceRed:.65 green:.09 blue:.16 alpha:.9];
        self.lineThickness = __LINE_THICKNESS__;
        self.cornerRadius = __CORNER_RADIUS__;
        self.arrowSize = NSMakeSize(__ARROW_WIDTH__,__ARROW_HEIGHT__);
        self.popupSize = NSMakeSize(__POPUP_WIDTH__,__POPUP_HEIGHT__);
        self.openDuration = __OPEN_DURATION__;
        self.arrowOrientation = kDFCDropdownArrowOrientationTop;
        
        self.decorationPosition = kDFCDecorationPositionRight;
        self.decorationType = kDFCDecorationTypeGradient;
        self.decorationImage = [NSImage imageNamed:@"insignia128v"];
        self.decorationColor = self.strokeColor;
        self.decorationGradient = [[NSGradient alloc] initWithStartingColor:self.strokeColor endingColor:[NSColor whiteColor]];
        self.decorationGradientAngle = 180.f;
        self.decorationDimension = 32.f;
        self.decorationTextColor = [NSColor whiteColor];
        self.decorationFont = [self createDCFont];
        self.decorationLineBreakMode = NSLineBreakByTruncatingTail;
        self.decorationTextAlignment = NSLeftTextAlignment;
        self.decorationGap = 10.0f;
        self.decorationMargin = NSMakeSize(10.0f,0.0f);
       
        //self.clientOverlapsDecoration = NO;
        self.clientBackgroundColor = [NSColor clearColor];
        
        self.itemGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.99 alpha:1.0] endingColor:[NSColor colorWithCalibratedWhite:0.94 alpha:1.0]];
        self.itemHighlightedGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.77 alpha:1.0] endingColor:[NSColor colorWithCalibratedWhite:0.50 alpha:1.0]];
        self.itemGradientAngle = 270.0f;
        self.itemTextColor = [NSColor colorWithDeviceRed:.6 green:.2 blue:.2 alpha:1];
        self.itemTextHighlightedColor = [NSColor colorWithDeviceRed:.4 green:.0 blue:.0 alpha:1];
        self.itemMargin = NSMakeSize(10.0f,10.0f);
        self.itemGap = 20.0f;
        self.itemFont = [self createDDFont];
        self.itemLineBreakMode = NSLineBreakByTruncatingTail;
        self.itemTextAlignment = NSLeftTextAlignment;
    }
    return self;
}
- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[DFCDropdownParameters class]]) {
        return NO;
    }
    DFCDropdownParameters* params = (DFCDropdownParameters*)object;
    if (![params.fillColor isEqual:self.fillColor]) {
        return NO;
    }
    if (![params.strokeColor isEqual:self.strokeColor]) {
        return NO;
    }
    if (params.lineThickness != self.lineThickness) {
        return NO;
    }
    if (params.cornerRadius != self.cornerRadius) {
        return NO;
    }
    if (!NSEqualSizes(params.arrowSize, self.arrowSize)) {
        return NO;
    }
    if (!NSEqualSizes(params.popupSize, self.popupSize)) {
        return NO;
    }
    if (params.openDuration != self.openDuration) {
        return NO;
    }
    if (params.arrowOrientation != self.arrowOrientation) {
        return NO;
    }
    if (params.decorationPosition != self.decorationPosition) {
        return NO;
    }
    if (params.decorationType != self.decorationType) {
        return NO;
    }
    if (params.decorationGradientAngle != self.decorationGradientAngle) {
        return NO;
    }
    if (params.decorationDimension != self.decorationDimension) {
        return NO;
    }
    if (params.decorationGradientAngle != self.decorationGradientAngle) {
        return NO;
    }
    if (![params.decorationColor isEqualTo:self.decorationColor]) {
        return NO;
    }
    if (![params.decorationGradient isEqualTo:self.decorationGradient]) {
        return NO;
    }
    if (![params.clientBackgroundColor isEqualTo:self.clientBackgroundColor]) {
        return NO;
    }
    if (![params.decorationImage isEqualTo:self.decorationImage]) {
        return NO;
    }
    if (![params.decorationTextColor isEqualTo:self.decorationTextColor]) {
        return NO;
    }
    if (![params.decorationFont isEqualTo:self.decorationFont]) {
        return NO;
    }
    if (params.decorationTextAlignment != self.decorationTextAlignment) {
        return NO;
    }
    if (params.decorationLineBreakMode != self.decorationLineBreakMode) {
        return NO;
    }
    if (params.decorationGap != self.decorationGap) {
        return NO;
    }
    if (!NSEqualSizes(params.decorationMargin,self.decorationMargin)) {
        return NO;
    }
    if (![params.itemGradient isEqualTo:self.itemGradient]) {
        return NO;
    }
    if (![params.itemHighlightedGradient isEqualTo:self.itemHighlightedGradient]) {
        return NO;
    }
    if (![params.itemTextColor isEqualTo:self.itemTextColor]) {
        return NO;
    }
    if (![params.itemTextHighlightedColor isEqualTo:self.itemTextHighlightedColor]) {
        return NO;
    }
    if (![params.itemFont isEqualTo:self.itemFont]) {
        return NO;
    }
    if (params.itemGradientAngle != self.itemGradientAngle) {
        return NO;
    }
    if (params.itemGap != self.itemGap) {
        return NO;
    }
    if (!NSEqualSizes(params.itemMargin,self.itemMargin)) {
        return NO;
    }
    if (params.itemLineBreakMode != self.itemLineBreakMode) {
        return NO;
    }
    if (params.itemTextAlignment != self.itemTextAlignment) {
        return NO;
    }
    
    return YES;
}
- (NSFont*) createDDFont {
    NSFont* result = nil;
    
    if(!(result = [NSFont fontWithName:@"Lucida Grabde" size:18.])) {
        result = [NSFont systemFontOfSize:18.];
    }
    
    return result;
}
- (NSFont*) createDCFont {
    NSFont* result = nil;
    
    if(!(result = [NSFont fontWithName:@"Lucida Grande" size:15.])) {
        result = [NSFont systemFontOfSize:15.];
    }
    
    return result;
}

- (DFCTextParameters) itemTextParameters {
    return DFCTextParametersMake(self.itemTextColor, self.itemFont, self.itemGap, self.itemMargin, self.itemLineBreakMode, self.itemTextAlignment);
}
- (DFCTextParameters) decorationTextParameters {
    return DFCTextParametersMake(self.decorationTextColor, self.decorationFont, self.decorationGap, self.decorationMargin, self.decorationLineBreakMode, self.decorationTextAlignment);
}
@end


DFCTextParameters DFCTextParametersMake(NSColor* textColor,NSFont* textFont,CGFloat textGap,NSSize textMargin,NSLineBreakMode textLineBreakMode,NSTextAlignment textAlignment) {
    DFCTextParameters result;
    result.textColor = textColor;
    result.textFont = textFont;
    result.textGap = textGap;
    result.textMargin = textMargin;
    result.textLineBreakMode = textLineBreakMode;
    result.textAlignment = textAlignment;
    return result;
}
BOOL DFCEqualTextParameters(DFCTextParameters p1,DFCTextParameters p2) {
    if (![p1.textColor isEqualTo:p2.textColor]) {
        return NO;
    }
    if (![p1.textFont isEqualTo:p2.textFont]) {
        return NO;
    }
    if (p1.textGap != p2.textGap) {
        return NO;
    }
    if (!NSEqualSizes(p1.textMargin, p2.textMargin)) {
        return NO;
    }
    if (p1.textAlignment != p2.textAlignment) {
        return NO;
    }
    if (p1.textLineBreakMode != p2.textLineBreakMode) {
        return NO;
    }
    return YES;
}

