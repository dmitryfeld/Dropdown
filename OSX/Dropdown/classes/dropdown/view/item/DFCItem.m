//
//  DFCDropdownItem.m
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-26.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCItem.h"
#import "DFCItem+Private.h"

@interface DFCItem() {
    DFCDropdownParameters* _parameters;
    NSTextField* _titleView;
    NSImageView* _imageView;
#ifdef __GUI_DEBUG__
    NSRect _geomArea;
#endif
    NSRect _titleRect;
    NSRect _imageRect;
    
    DFCTextParameters _textParams;
}
@property (readonly,nonatomic) NSImageView* imageView;
@property (readonly,nonatomic) NSTextField* titleView;
@property (assign, nonatomic) id messagingCallback;
- (NSImageView*) newImageView;
- (NSTextField*) newTextField;
@end

@implementation DFCItem
@dynamic image;
@dynamic title;
@synthesize messagingCallback;
@dynamic imageView;
@dynamic titleView;
- (id) initWithParameters:(DFCDropdownParameters*)parameters {
    if (self = [super init]) {
        _parameters = [parameters retain];
        _textParams = [self getTextParameters];
    }
    return self;
}
- (void) dealloc {
    [_imageView release],_imageView = nil;
    [_titleView release],_titleView = nil;
    
    [_parameters release];
    [super dealloc];
}
- (NSString*) title {
    return self.titleView.stringValue;
}
- (void) setTitle:(NSString *)title {
    if (![self.titleView.stringValue isEqualToString:title]) {
        self.titleView.stringValue = title;
        [self setNeedsDisplay:YES];
    }
}
- (NSImage*) image {
    return self.imageView.image;
}
- (void) setImage:(NSImage *)image {
    if (![self.imageView.image isEqualTo:image]) {
        self.imageView.image = image;
        [self setNeedsDisplay:YES];
    }
}

- (NSImageView*) imageView {
    if (!_imageView) {
        _imageView = [self newImageView];
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (NSTextField*) titleView {
    if (!_titleView) {
        _titleView = [self newTextField];
        _titleView.textColor = _textParams.textColor;
        [_titleView setBezeled:NO];
        [_titleView setDrawsBackground:NO];
        [_titleView setEditable:NO];
        [_titleView setSelectable:NO];
        [_titleView setAlignment:_textParams.textAlignment];
        [_titleView setFont:_textParams.textFont];
        [_titleView.cell setLineBreakMode:_textParams.textLineBreakMode];
        [self addSubview:_titleView];
    }
    return _titleView;
}

- (void)drawRect:(NSRect)dirtyRect {
#ifdef __GUI_DEBUG__
    [NSGraphicsContext saveGraphicsState];
    [[NSColor greenColor] setFill];
    [NSBezierPath fillRect:_geomArea];
    [NSGraphicsContext restoreGraphicsState];
    
    [NSGraphicsContext saveGraphicsState];
    [[NSColor redColor] setFill];
    [NSBezierPath fillRect:_imageRect];
    [NSGraphicsContext restoreGraphicsState];
    
    [NSGraphicsContext saveGraphicsState];
    [[NSColor redColor] setFill];
    [NSBezierPath fillRect:_titleRect];
    [NSGraphicsContext restoreGraphicsState];
#endif
}


- (void) layoutContent {
    NSRect area = self.frame;
    area.origin = NSZeroPoint;
    area = NSInsetRect(area, _textParams.textMargin.width, _textParams.textMargin.height);
#ifdef __GUI_DEBUG__
    _geomArea = area;
#endif
    NSSize cellS = self.image.size;
    
    _imageRect = area;
    _imageRect.size = cellS;
    _imageRect.origin.y += MAX((area.size.height - cellS.height) / 2,0);
    _imageRect.size.height = MIN(area.size.height,cellS.height);
    
    if (!NSEqualSizes(_imageRect.size, NSZeroSize)) {
        area.origin.x += (_imageRect.size.width + _textParams.textGap);
    }
    area.size.width -= area.origin.x;
    
    cellS = [self.titleView.cell cellSize];
    _titleRect = area;
    _titleRect.origin.y += MAX((area.size.height - cellS.height) / 2,0);
    _titleRect.size.height = MIN(area.size.height,cellS.height);
    
    _titleView.frame = _titleRect;
    _imageView.frame = _imageRect;
}


- (DFCTextParameters) getTextParameters {
    return _parameters.itemTextParameters;
}
- (DFCDropdownParameters*) getParameters {
    return _parameters;
}
- (NSTextField*) getTitleView {
    return self.titleView;
}
- (NSImageView*) getImageView {
    return self.imageView;
}
- (NSImageView*) newImageView {
    return [NSImageView new];
}
- (NSTextField*) newTextField {
    return [NSTextField new];
}

@end
