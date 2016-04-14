//
//  DFCDropDownParameters.h
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-16.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef __GUI_DEBUG__
//#define __GUI_DEBUG__
#endif

typedef enum __DFCDropdownArrowOrientation__ {
    kDFCDropdownArrowOrientationNone,
    kDFCDropdownArrowOrientationLeft,
    kDFCDropdownArrowOrientationRight,
    kDFCDropdownArrowOrientationTop,
    kDFCDropdownArrowOrientationBottom
} DFCDropdownArrowOrientation;

typedef enum __DFCDecorationPosition__ {
    kDFCDecorationPositionTop,
    kDFCDecorationPositionBottom,
    kDFCDecorationPositionLeft,
    kDFCDecorationPositionRight
} DFCDecorationPosition;

typedef enum __DFCDecorationType__ {
    kDFCDecorationTypeNone,
    kDFCDecorationTypeImage,
    kDFCDecorationTypeColor,
    kDFCDecorationTypeGradient
} DFCDecorationType;

typedef struct __DFCTextParameters__ {
    NSColor* textColor;
    NSFont* textFont;
    CGFloat textGap;
    NSSize textMargin;
    NSLineBreakMode textLineBreakMode;
    NSTextAlignment textAlignment;
} DFCTextParameters;

@interface DFCDropdownParameters : NSObject
#pragma mark Basic Section
@property (nonatomic, retain) NSColor* fillColor;
@property (nonatomic, retain) NSColor* strokeColor;
@property (nonatomic, assign) CGFloat lineThickness;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) NSSize arrowSize;
@property (nonatomic, assign) DFCDropdownArrowOrientation arrowOrientation;
@property (nonatomic, assign) CGFloat openDuration;
@property (nonatomic, assign) NSSize popupSize;
#pragma mark Decoration Session
@property (nonatomic, assign) DFCDecorationPosition decorationPosition;
@property (nonatomic, assign) DFCDecorationType decorationType;
@property (nonatomic, retain) NSImage* decorationImage;
@property (nonatomic, retain) NSGradient* decorationGradient;
@property (nonatomic, assign) CGFloat decorationGradientAngle;
@property (nonatomic, retain) NSColor* decorationColor;
@property (nonatomic, assign) CGFloat decorationDimension;
@property (nonatomic, retain) NSColor* decorationTextColor;
@property (nonatomic, retain) NSFont* decorationFont;
@property (nonatomic, assign) NSLineBreakMode decorationLineBreakMode;
@property (nonatomic, assign) NSTextAlignment decorationTextAlignment;
@property (nonatomic, assign) NSSize decorationMargin;
@property (nonatomic, assign) CGFloat decorationGap;
#pragma mark Client Section
@property (nonatomic, retain) NSColor* clientBackgroundColor;
#pragma mark Item Section
@property (nonatomic, retain) NSGradient* itemGradient;
@property (nonatomic, retain) NSGradient* itemHighlightedGradient;
@property (nonatomic, assign) CGFloat itemGradientAngle;
@property (nonatomic, retain) NSColor* itemTextColor;
@property (nonatomic, retain) NSColor* itemTextHighlightedColor;
@property (nonatomic, assign) NSSize itemMargin;
@property (nonatomic, assign) CGFloat itemGap;
@property (nonatomic, retain) NSFont* itemFont;
@property (nonatomic, assign) NSLineBreakMode itemLineBreakMode;
@property (nonatomic, assign) NSTextAlignment itemTextAlignment;

@property (readonly, nonatomic) DFCTextParameters itemTextParameters;
@property (readonly, nonatomic) DFCTextParameters decorationTextParameters;
@end
