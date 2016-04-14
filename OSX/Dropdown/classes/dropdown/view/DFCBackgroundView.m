//
//  DFCBackgroundView.h
//  BriefcasePOC
//
//  Created by Dmitry Feld on 2013-08-29.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#include <QuartzCore/QuartzCore.h>
#include <CoreGraphics/CoreGraphics.h>

#import "DFCBackgroundView.h"
#import "DFCDropdownItem.h"

@interface DFCBackgroundView() {
    NSRect _calculatedClientFrame;
    NSRect _calculatedDecorationFrame;
    DFCDropdownParameters* _parameters;
    id _parent;
}
- (NSBezierPath*) popupPath;
- (NSBezierPath*) popupPathTop;
- (NSBezierPath*) popupPathBottom;
- (NSBezierPath*) popupPathLeft;
- (NSBezierPath*) popupPathRight;
- (void) calculateClientFrame;
- (NSRect) decorationBounds;
- (NSView*) newClientViewFromDatasource;
- (NSView*) newDecorationViewFromDatasource;
- (void) layoutItems;
- (NSUInteger) itemCount;
- (DFCDropdownItem*) newItemForIndex:(NSUInteger)index;
@end


@implementation DFCBackgroundView
@synthesize arrowPoint = _arrowPoint;
@synthesize clientView = _clientView;
@synthesize decorationView = _decorationView;
@synthesize clientItems = _clientItems;
@synthesize delegate = _delegate;
@synthesize datasource = _datasource;

- (id) initWithParameters:(DFCDropdownParameters*)parameters andParent:(id)parent {
    if (self = [super init]) {
        _parameters = [parameters retain];
        _parent = parent;
    }
    return self;
}

- (void) dealloc {
    [_clientItems release],_clientItems = nil;
    [_clientView release], _clientView = nil;
    [_decorationView release], _decorationView = nil;
    [_parameters release], _parameters = nil;
    [super dealloc];
}

- (void) rebuild {
    if (_clientItems) {
        for (NSView* item in _clientItems) {
            [item removeFromSuperview];
        }
        [_clientItems release],_clientItems = nil;
    }
    if (_clientView) {
        [_clientView removeFromSuperview];
        [_clientView release],_clientView = nil;
        [self clientView];
    }
    if (_decorationView) {
        [_decorationView removeFromSuperview];
        [_decorationView release],_decorationView = nil;
        [self decorationView];
    }
    for (NSView* item in self.clientItems) {
        [self.clientView addSubview:item];
    }
    [self layoutItems];
}

#pragma mark -
- (void)drawRect:(NSRect)dirtyRect {
    NSBezierPath* path = [self popupPath];
    //Fill the background
    [NSGraphicsContext saveGraphicsState];
    [_parameters.fillColor setFill];
    [path fill];
    [NSGraphicsContext restoreGraphicsState];
    
    //Draw the decoration
    if (kDFCDecorationTypeNone != _parameters.decorationType) {
        NSRect decBounds = [self decorationBounds];
        [NSGraphicsContext saveGraphicsState];
        NSBezierPath* clipPath = [NSBezierPath bezierPath];
        [clipPath appendBezierPath:path];
        [clipPath addClip];
        if (_parameters.decorationImage && (kDFCDecorationTypeImage == _parameters.decorationType)) {
            [_parameters.decorationImage drawInRect:decBounds fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
        }
        if (_parameters.decorationColor && (kDFCDecorationTypeColor == _parameters.decorationType)) {
            [_parameters.decorationColor setFill];
            NSRectFill(decBounds);
        }
        if (_parameters.decorationGradient && (kDFCDecorationTypeGradient == _parameters.decorationType)) {
            [_parameters.decorationGradient drawInRect:decBounds angle:_parameters.decorationGradientAngle];
        }
        [NSGraphicsContext restoreGraphicsState];
    }

    //Draw the border
    [NSGraphicsContext saveGraphicsState];
    [path setLineWidth:_parameters.lineThickness];
    [_parameters.strokeColor setStroke];
    [path stroke];
    [NSGraphicsContext restoreGraphicsState];
}

- (NSBezierPath*) popupPath {
    if (kDFCDropdownArrowOrientationTop == _parameters.arrowOrientation) {
        return [self popupPathTop];
    }
    if (kDFCDropdownArrowOrientationLeft == _parameters.arrowOrientation) {
        return [self popupPathLeft];
    }
    if (kDFCDropdownArrowOrientationRight == _parameters.arrowOrientation) {
        return [self popupPathRight];
    }
    return [self popupPathBottom];
}

- (NSBezierPath*) popupPathTop {
    NSRect contentRect = NSInsetRect([self bounds], _parameters.lineThickness, _parameters.lineThickness);
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    [path moveToPoint:NSMakePoint(_arrowPoint, NSMaxY(contentRect))];
    [path lineToPoint:NSMakePoint(_arrowPoint + _parameters.arrowSize.width / 2, NSMaxY(contentRect) - _parameters.arrowSize.height)];
    [path lineToPoint:NSMakePoint(NSMaxX(contentRect) - _parameters.cornerRadius, NSMaxY(contentRect) - _parameters.arrowSize.height)];
    
    NSPoint topRightCorner = NSMakePoint(NSMaxX(contentRect), NSMaxY(contentRect) - _parameters.arrowSize.height);
    [path curveToPoint:NSMakePoint(NSMaxX(contentRect), NSMaxY(contentRect) - _parameters.arrowSize.height - _parameters.cornerRadius)
         controlPoint1:topRightCorner controlPoint2:topRightCorner];
    
    [path lineToPoint:NSMakePoint(NSMaxX(contentRect), NSMinY(contentRect) + _parameters.cornerRadius)];
    
    NSPoint bottomRightCorner = NSMakePoint(NSMaxX(contentRect), NSMinY(contentRect));
    [path curveToPoint:NSMakePoint(NSMaxX(contentRect) - _parameters.cornerRadius, NSMinY(contentRect))
         controlPoint1:bottomRightCorner controlPoint2:bottomRightCorner];
    
    [path lineToPoint:NSMakePoint(NSMinX(contentRect) + _parameters.cornerRadius, NSMinY(contentRect))];
    
    [path curveToPoint:NSMakePoint(NSMinX(contentRect), NSMinY(contentRect) + _parameters.cornerRadius)
         controlPoint1:contentRect.origin controlPoint2:contentRect.origin];
    
    [path lineToPoint:NSMakePoint(NSMinX(contentRect), NSMaxY(contentRect) - _parameters.arrowSize.height - _parameters.cornerRadius)];
    
    NSPoint topLeftCorner = NSMakePoint(NSMinX(contentRect), NSMaxY(contentRect) - _parameters.arrowSize.height);
    [path curveToPoint:NSMakePoint(NSMinX(contentRect) + _parameters.cornerRadius, NSMaxY(contentRect) - _parameters.arrowSize.height)
         controlPoint1:topLeftCorner controlPoint2:topLeftCorner];
    
    [path lineToPoint:NSMakePoint(_arrowPoint - _parameters.arrowSize.width / 2, NSMaxY(contentRect) - _parameters.arrowSize.height)];
    [path closePath];
    
    return path;
}

- (NSBezierPath*) popupPathBottom {
    NSRect contentRect = NSInsetRect([self bounds], _parameters.lineThickness, _parameters.lineThickness);
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    [path moveToPoint:NSMakePoint(_arrowPoint, NSMinY(contentRect))];
    [path lineToPoint:NSMakePoint(_arrowPoint + _parameters.arrowSize.width / 2, NSMinY(contentRect) + _parameters.arrowSize.height)];
    [path lineToPoint:NSMakePoint(NSMaxX(contentRect) - _parameters.cornerRadius, NSMinY(contentRect) + _parameters.arrowSize.height)];

    NSPoint bottomRightCorner = NSMakePoint(NSMaxX(contentRect), NSMinY(contentRect) + _parameters.arrowSize.height);
    [path curveToPoint:NSMakePoint(NSMaxX(contentRect), NSMinY(contentRect) + _parameters.arrowSize.height + _parameters.cornerRadius)
         controlPoint1:bottomRightCorner controlPoint2:bottomRightCorner];
    
    [path lineToPoint:NSMakePoint(NSMaxX(contentRect), NSMaxY(contentRect) - _parameters.cornerRadius)];
    
    NSPoint topRightCorner = NSMakePoint(NSMaxX(contentRect), NSMaxY(contentRect));
    [path curveToPoint:NSMakePoint(NSMaxX(contentRect) - _parameters.cornerRadius, NSMaxY(contentRect))
         controlPoint1:topRightCorner controlPoint2:topRightCorner];
    
    [path lineToPoint:NSMakePoint(NSMinX(contentRect) + _parameters.cornerRadius, NSMaxY(contentRect))];
    
    NSPoint topLeftCorner = NSMakePoint(NSMinX(contentRect), NSMaxY(contentRect));
    [path curveToPoint:NSMakePoint(NSMinX(contentRect), NSMaxY(contentRect) - _parameters.cornerRadius) controlPoint1:topLeftCorner controlPoint2:topLeftCorner];
    
    [path lineToPoint:NSMakePoint(NSMinX(contentRect), NSMaxY(contentRect) - _parameters.arrowSize.height - _parameters.cornerRadius)];
    [path lineToPoint:NSMakePoint(NSMinX(contentRect), NSMinY(contentRect) + _parameters.arrowSize.height + _parameters.cornerRadius)];
    
    NSPoint bottomLeftCorner = NSMakePoint(NSMinX(contentRect), NSMinY(contentRect) + _parameters.arrowSize.height);
    [path curveToPoint:NSMakePoint(NSMinX(contentRect) + _parameters.cornerRadius, NSMinY(contentRect) + _parameters.arrowSize.height) controlPoint1:bottomLeftCorner controlPoint2:bottomLeftCorner];
    
    [path lineToPoint:NSMakePoint(_arrowPoint - _parameters.arrowSize.width / 2, NSMinY(contentRect) + _parameters.arrowSize.height)];
    
    [path closePath];
    
    return path;
}
- (NSBezierPath*) popupPathRight {
    NSRect contentRect = NSInsetRect([self bounds], _parameters.lineThickness, _parameters.lineThickness);
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    [path moveToPoint:NSMakePoint(NSMaxX(contentRect),_arrowPoint)];
    
    [path lineToPoint:NSMakePoint( NSMaxX(contentRect) - _parameters.arrowSize.width,_arrowPoint + _parameters.arrowSize.height / 2)];
    
     [path lineToPoint:NSMakePoint(NSMaxX(contentRect) - _parameters.arrowSize.width,NSMaxY(contentRect) - _parameters.cornerRadius)];
    
    NSPoint topRightCorner = NSMakePoint(NSMaxX(contentRect) - _parameters.arrowSize.width,NSMaxY(contentRect));
    [path curveToPoint:NSMakePoint(NSMaxX(contentRect) - _parameters.arrowSize.width - _parameters.cornerRadius,NSMaxY(contentRect)) controlPoint1:topRightCorner controlPoint2:topRightCorner];
    
    [path lineToPoint:NSMakePoint(NSMinX(contentRect) + _parameters.cornerRadius,NSMaxY(contentRect))];
    
    NSPoint topLeftCorner = NSMakePoint(NSMinX(contentRect),NSMaxY(contentRect));
    [path curveToPoint:NSMakePoint(NSMinX(contentRect),NSMaxY(contentRect) - _parameters.cornerRadius)
         controlPoint1:topLeftCorner controlPoint2:topLeftCorner];
    
    [path lineToPoint:NSMakePoint(NSMinX(contentRect),NSMinY(contentRect) + _parameters.cornerRadius)];
    
    [path curveToPoint:NSMakePoint(NSMinX(contentRect) + _parameters.cornerRadius,NSMinY(contentRect))
         controlPoint1:contentRect.origin controlPoint2:contentRect.origin];
    
    [path lineToPoint:NSMakePoint(NSMaxX(contentRect) - _parameters.arrowSize.width - _parameters.cornerRadius,NSMinY(contentRect))];
    
    NSPoint bottomRightCorner = NSMakePoint(NSMaxX(contentRect) - _parameters.arrowSize.width,NSMinY(contentRect));
    [path curveToPoint:NSMakePoint(NSMaxX(contentRect) - _parameters.arrowSize.width,NSMinY(contentRect) + _parameters.cornerRadius) controlPoint1:bottomRightCorner controlPoint2:bottomRightCorner];
    
    [path lineToPoint:NSMakePoint(NSMaxX(contentRect) - _parameters.arrowSize.width,_arrowPoint - _parameters.arrowSize.height / 2)];
     
    [path closePath];
    
    return path;
}
- (NSBezierPath*) popupPathLeft {
    NSRect contentRect = NSInsetRect([self bounds], _parameters.lineThickness, _parameters.lineThickness);
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    [path moveToPoint:NSMakePoint(NSMinX(contentRect),_arrowPoint)];
    
    
    [path lineToPoint:NSMakePoint( NSMinX(contentRect) + _parameters.arrowSize.width,_arrowPoint + _parameters.arrowSize.height / 2)];
    
    [path lineToPoint:NSMakePoint(NSMinX(contentRect) + _parameters.arrowSize.width,NSMaxY(contentRect) - _parameters.cornerRadius)];
    
    NSPoint topLeftCorner = NSMakePoint(NSMinX(contentRect) + _parameters.arrowSize.width,NSMaxY(contentRect));
    [path curveToPoint:NSMakePoint(NSMinX(contentRect) + _parameters.arrowSize.width + _parameters.cornerRadius,NSMaxY(contentRect)) controlPoint1:topLeftCorner controlPoint2:topLeftCorner];
    
    [path lineToPoint:NSMakePoint(NSMaxX(contentRect) - _parameters.cornerRadius,NSMaxY(contentRect))];
    
    NSPoint topRightCorner = NSMakePoint(NSMaxX(contentRect),NSMaxY(contentRect));
    [path curveToPoint:NSMakePoint(NSMaxX(contentRect),NSMaxY(contentRect) - _parameters.cornerRadius)
         controlPoint1:topRightCorner controlPoint2:topRightCorner];
    
    [path lineToPoint:NSMakePoint(NSMaxX(contentRect),NSMinY(contentRect) + _parameters.cornerRadius)];
    
    NSPoint bottomRightCorner = NSMakePoint(NSMaxX(contentRect),NSMinY(contentRect));
    [path curveToPoint:NSMakePoint(NSMaxX(contentRect) - _parameters.cornerRadius,NSMinY(contentRect))
         controlPoint1:bottomRightCorner controlPoint2:bottomRightCorner];
    
    [path lineToPoint:NSMakePoint(NSMinX(contentRect) + _parameters.arrowSize.width + _parameters.cornerRadius,NSMinY(contentRect))];
    
    NSPoint bottomLeftCorner = NSMakePoint(NSMinX(contentRect) + _parameters.arrowSize.width,NSMinY(contentRect));
    [path curveToPoint:NSMakePoint(NSMinX(contentRect) + _parameters.arrowSize.width,NSMinY(contentRect) + _parameters.cornerRadius) controlPoint1:bottomLeftCorner controlPoint2:bottomLeftCorner];
    
    [path lineToPoint:NSMakePoint(NSMinX(contentRect) + _parameters.arrowSize.width,_arrowPoint - _parameters.arrowSize.height / 2)];

    [path closePath];
    
    return path;
}


#pragma mark -
#pragma mark Public accessors
- (void)setArrowPoint:(NSInteger)value {
    _arrowPoint = value;
    [self setNeedsDisplay:YES];
}
- (NSView*) clientView {
    if (!_clientView) {
        _clientView = [self newClientViewFromDatasource];
        _clientView.wantsLayer = YES;
        _clientView.layer = [CALayer layer];
        _clientView.layer.masksToBounds = YES;
        _clientView.layer.cornerRadius = _parameters.cornerRadius * .25;
        _clientView.layer.backgroundColor = _parameters.clientBackgroundColor.CGColor;
        [self addSubview:_clientView];
        [self layoutContent];
    }
    return _clientView;
}
- (NSView*) decorationView {
    if (!_decorationView) {
        _decorationView = [self newDecorationViewFromDatasource];
        if (_decorationView) {
            _decorationView.wantsLayer = YES;
            _decorationView.layer.masksToBounds = YES;
            _decorationView.layer.cornerRadius = _parameters.cornerRadius * .25;
            _decorationView.layer.backgroundColor = [NSColor clearColor].CGColor;
            //_decorationView.alphaValue = .5;
            [self addSubview:_decorationView];
            [self layoutContent];
        }
    }
    return _decorationView;
}
- (NSArray*) clientItems {
    if (!_clientItems) {
        NSMutableArray* items = [NSMutableArray new];
        NSUInteger itemCount = [self itemCount];
        DFCDropdownItem* temp;
        for (NSUInteger index = 0; index < itemCount; index ++) {
            temp = [self newItemForIndex:index];
            temp.delegate = self;
            [items addObject:temp];
            [temp release];
        }
        _clientItems = items;
    }
    return _clientItems;
}

- (void) layoutContent {
    [self calculateClientFrame];
    [self calculateDecorationFrame];
    [self.clientView setFrame:_calculatedClientFrame];
    [self.decorationView setFrame:_calculatedDecorationFrame];
    if ([self.clientView respondsToSelector:@selector(layoutContent)]) {
        [self.clientView performSelector:@selector(layoutContent)];
    }
    if ([self.decorationView respondsToSelector:@selector(layoutContent)]) {
        [self.decorationView performSelector:@selector(layoutContent)];
    }
    [self layoutItems];
}

- (void) calculateClientFrame {
    CGFloat thicknessFactor = (1.5f * _parameters.lineThickness);

    _calculatedClientFrame = [self bounds];
    _calculatedClientFrame.origin = NSZeroPoint;
    
    if (kDFCDropdownArrowOrientationTop == _parameters.arrowOrientation) {
        _calculatedClientFrame.size.height -= _parameters.arrowSize.height;
    }
    if (kDFCDropdownArrowOrientationRight == _parameters.arrowOrientation) {
        _calculatedClientFrame.size.width -= _parameters.arrowSize.width;
    }
    if (kDFCDropdownArrowOrientationBottom == _parameters.arrowOrientation) {
        _calculatedClientFrame.origin.y += _parameters.arrowSize.height;
        _calculatedClientFrame.size.height -= _parameters.arrowSize.height;
    }
    if (kDFCDropdownArrowOrientationLeft == _parameters.arrowOrientation) {
        _calculatedClientFrame.origin.x += _parameters.arrowSize.width;
        _calculatedClientFrame.size.width -= _parameters.arrowSize.width;
    }
    
    if (kDFCDecorationTypeNone != _parameters.decorationType) {
        CGFloat decorationFactor = _parameters.decorationDimension - thicknessFactor;
        if (kDFCDecorationPositionLeft == _parameters.decorationPosition) {
            _calculatedClientFrame.origin.x += decorationFactor;
            _calculatedClientFrame.size.width -= decorationFactor;
        }
        if (kDFCDecorationPositionBottom == _parameters.decorationPosition) {
            _calculatedClientFrame.origin.y += decorationFactor;
            _calculatedClientFrame.size.height -= decorationFactor;
        }
        if (kDFCDecorationPositionRight == _parameters.decorationPosition) {
            _calculatedClientFrame.size.width -= decorationFactor;
        }
        if (kDFCDecorationPositionTop == _parameters.decorationPosition) {
            _calculatedClientFrame.size.height -= decorationFactor;
        }
    }

    _calculatedClientFrame = NSInsetRect(_calculatedClientFrame,thicknessFactor,thicknessFactor);
    _calculatedDecorationFrame = [self decorationBounds];
}
- (void) calculateDecorationFrame {
    CGFloat thicknessFactor = (1.5f * _parameters.lineThickness);
    
    _calculatedDecorationFrame = NSZeroRect;
    
    if (kDFCDecorationTypeNone != _parameters.decorationType) {
        _calculatedDecorationFrame = self.bounds;
        NSSize size = _calculatedDecorationFrame.size;
        _calculatedDecorationFrame.origin = NSZeroPoint;
        if (kDFCDecorationPositionLeft == _parameters.decorationPosition) {
            _calculatedDecorationFrame.size.width = _parameters.decorationDimension;
            if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationLeft) {
                _calculatedDecorationFrame.origin.x += _parameters.arrowSize.width;
            }
            if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationBottom) {
                _calculatedDecorationFrame.origin.y += _parameters.arrowSize.height;
                _calculatedDecorationFrame.size.height -= _parameters.arrowSize.height;
            }
            if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationTop) {
                _calculatedDecorationFrame.size.height -= _parameters.arrowSize.height;
            }
            _calculatedDecorationFrame.origin.x += thicknessFactor;
            _calculatedDecorationFrame.size.width -= thicknessFactor;
            _calculatedDecorationFrame = NSInsetRect(_calculatedDecorationFrame,0,thicknessFactor);
        }
        if (kDFCDecorationPositionBottom == _parameters.decorationPosition) {
            _calculatedDecorationFrame.size.height = _parameters.decorationDimension;
            if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationBottom) {
                _calculatedDecorationFrame.origin.y += _parameters.arrowSize.height;
            }
            if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationRight) {
                _calculatedDecorationFrame.size.width -= _parameters.arrowSize.width;
            }
            if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationLeft) {
                _calculatedDecorationFrame.size.width -= _parameters.arrowSize.width;
                _calculatedDecorationFrame.origin.x += _parameters.arrowSize.width;
            }
            _calculatedDecorationFrame.origin.y += thicknessFactor;
            _calculatedDecorationFrame.size.height -= thicknessFactor;
            _calculatedDecorationFrame = NSInsetRect(_calculatedDecorationFrame,thicknessFactor,0);
        }
        if (kDFCDecorationPositionRight == _parameters.decorationPosition) {
            _calculatedDecorationFrame.size.width = _parameters.decorationDimension;
            _calculatedDecorationFrame.origin.x += (size.width - _calculatedDecorationFrame.size.width);
            if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationRight) {
                _calculatedDecorationFrame.origin.x -= _parameters.arrowSize.width;
            }
            if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationBottom) {
                _calculatedDecorationFrame.origin.y += _parameters.arrowSize.height;
                _calculatedDecorationFrame.size.height -= _parameters.arrowSize.height;
            }
            if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationTop) {
                _calculatedDecorationFrame.size.height -= _parameters.arrowSize.height;
            }
            _calculatedDecorationFrame.size.width -= thicknessFactor;
            _calculatedDecorationFrame = NSInsetRect(_calculatedDecorationFrame,0,thicknessFactor);
        }
        if (kDFCDecorationPositionTop == _parameters.decorationPosition) {
            _calculatedDecorationFrame.size.height = _parameters.decorationDimension;
            _calculatedDecorationFrame.origin.y += (size.height - _parameters.decorationDimension);
            if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationTop) {
                _calculatedDecorationFrame.origin.y -= _parameters.arrowSize.height;
            }
            if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationRight) {
                _calculatedDecorationFrame.size.width -= _parameters.arrowSize.width;
            }
            if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationLeft) {
                _calculatedDecorationFrame.size.width -= _parameters.arrowSize.width;
                _calculatedDecorationFrame.origin.x += _parameters.arrowSize.width;
            }
            _calculatedDecorationFrame.size.height -= thicknessFactor;
            _calculatedDecorationFrame = NSInsetRect(_calculatedDecorationFrame,thicknessFactor,0);
        }
    }
}

- (NSRect) decorationBounds {
    NSSize size = self.bounds.size;
    NSRect result = NSZeroRect;
    
    if (kDFCDecorationTypeNone != _parameters.decorationType) {
        result.size = size;
        if (kDFCDecorationPositionLeft == _parameters.decorationPosition) {
            result.size.width = _parameters.decorationDimension;
            if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationLeft) {
                result.size.width += _parameters.arrowSize.width;
            }
        }
        if (kDFCDecorationPositionBottom == _parameters.decorationPosition) {
            result.size.height = _parameters.decorationDimension;
            if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationBottom) {
                result.size.height += _parameters.arrowSize.height;
            }
        }
        if (kDFCDecorationPositionRight == _parameters.decorationPosition) {
            result.size.width = _parameters.decorationDimension;
            result.origin.x += (size.width - result.size.width);
            if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationRight) {
                result.size.width += _parameters.arrowSize.width;
                result.origin.x -= _parameters.arrowSize.width;
            }
        }
        if (kDFCDecorationPositionTop == _parameters.decorationPosition) {
            result.size.height = _parameters.decorationDimension;
            result.origin.y += (size.height - result.size.height);
            if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationTop) {
                result.size.height += _parameters.arrowSize.height;
                result.origin.y -= _parameters.arrowSize.height;
            }
        }
    }
    return result;
}

- (NSView*) newClientViewFromDatasource {
    NSView* result = nil;
    
    if ([self.datasource respondsToSelector:@selector(newClientViewForDropdown:)]) {
        result = [self.datasource newClientViewForDropdown:_parent];
    }
    
    if (!result) {
        result = [NSView new];
    }
    
    return result;
}

- (NSView*) newDecorationViewFromDatasource {
    NSView* result = nil;
    if ([self.datasource respondsToSelector:@selector(newDecorationViewForDropdown:)]) {
        result = [self.datasource newDecorationViewForDropdown:_parent];
    }
    return result;
}


- (void) layoutItems {
    if (self.clientItems.count) {
        NSRect area = self.clientView.frame;
        CGFloat itemHeigh = (area.size.height/self.clientItems.count);
        area.origin.x = 0;
        area.origin.y = (area.size.height - itemHeigh);
        area.size.height = itemHeigh;
        for (NSView* item in self.clientItems) {
            [item setFrame:area];
            if ([item respondsToSelector:@selector(layoutContent)]) {
                [item performSelector:@selector(layoutContent)];
            }
            area.origin.y -= itemHeigh;
        }
    }
}

- (NSUInteger) itemCount {
    NSUInteger result = 0;
    if ([self.datasource respondsToSelector:@selector(itemCountForDropdown:)]) {
        result = [self.datasource itemCountForDropdown:_parent];
    }
    return result;
}
- (DFCDropdownItem*) newItemForIndex:(NSUInteger)index {
    DFCDropdownItem* result = nil;
    if ([self.datasource respondsToSelector:@selector(newItemForDropdown: atIndex:)]) {
        result = [self.datasource newItemForDropdown:_parent atIndex:index];
    }
    return result;
}

- (void) itemViewPressed:(DFCDropdownItem*)item {
    if ([self.delegate respondsToSelector:@selector(dropdown:didPressItem:)]) {
        [self.delegate dropdown:_parent didPressItem:item];
    }
}
- (void) itemViewReleased:(DFCDropdownItem*)item {
    if ([self.delegate respondsToSelector:@selector(dropdown:didReleaseItem:)]) {
        [self.delegate dropdown:_parent didReleaseItem:item];
    }
}
- (void) itemViewEntered:(DFCDropdownItem*)item {
    if ([self.delegate respondsToSelector:@selector(dropdown:didEnterItem:)]) {
        [self.delegate dropdown:_parent didEnterItem:item];
    }
    if ([_parent respondsToSelector:@selector(acquireKey)]) {
        id<DFCDynamicallyKeyable> window = _parent;
        [window acquireKey];
    }
}
- (void) itemViewExited:(DFCDropdownItem*)item {
    if ([self.delegate respondsToSelector:@selector(dropdown:didExitItem:)]) {
        [self.delegate dropdown:_parent didExitItem:item];
    }
}
@end
