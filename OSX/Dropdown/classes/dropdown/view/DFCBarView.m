//
//  DFCBarView.m
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-16.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCBarView.h"

@interface DFCBarView() {
    NSStatusItem* _barItem;
    id _globalMonitor;
}
@property (readonly,nonatomic) NSImageCell* iconCell;
@property (readonly) NSStatusItem* barItem;

- (void) onMouseUp:(NSEvent*)event;
- (void) onMouseDown:(NSEvent*)event;

- (void) onDelegateOpen:(NSEvent*)event;
- (void) onDelegateClose:(NSEvent*)event;

@end

@implementation DFCBarView
@synthesize iconCell = _iconCell;
@synthesize isHighlighted = _isHighlighted;
@synthesize icon = _icon;
@synthesize mode = _mode;
@synthesize delegate = _delegate;
@dynamic barItem;

- (id)init {
    self = [super init];
    if (self) {
        self.layer.backgroundColor = [NSColor redColor].CGColor;
        _iconCell = nil;
        _barItem = nil;
        _isHighlighted = NO;
        _mode = kDFCBarViewModePanel;
        _icon = [[NSImage imageNamed:@"logo32"] retain];
    }
    return self;
}

- (void) dealloc {
    [_icon release];
    [_barItem release];
    [_iconCell release];
    [super dealloc];
}

- (NSImageCell*) iconCell {
    if (!_iconCell) {
        _iconCell = [[NSImageCell alloc] initImageCell:self.icon];
    }
    return _iconCell;
}
- (NSStatusItem*) barItem {
    if (!_barItem) {
        NSStatusBar* systemBar = [NSStatusBar systemStatusBar];
        _barItem = [[systemBar statusItemWithLength:24] retain];
        _barItem.highlightMode = YES;
    }
    return _barItem;
}


- (void) start {
    self.barItem.view = self;
}
- (void) closeDropDown {
    _isHighlighted = NO;
    [self onDelegateClose:nil];
    [self setNeedsDisplay:YES];
}


- (void)mouseDown:(NSEvent *)event {
    [self onMouseDown:event];
}

- (void)rightMouseDown:(NSEvent *)event {
    [self onMouseDown:event];
}

- (void) mouseUp:(NSEvent *)event {
    [self onMouseUp:event];
}
- (void) rightMouseUp:(NSEvent *)event {
    [self onMouseUp:event];
}

- (void) onMouseDown:(NSEvent*)event{
    switch (_mode) {
        case kDFCBarViewModeMenu:
            _isHighlighted = YES;
            break;
        case kDFCBarViewModePanel:
        default:
            _isHighlighted = !_isHighlighted;
            break;
    }
    if (_isHighlighted) {
        [self onDelegateOpen:event];
    } else {
        [self onDelegateClose:event];
    }
    [self setNeedsDisplay:YES];
}

- (void) onMouseUp:(NSEvent*)event{
    switch (_mode) {
        case kDFCBarViewModeMenu:
            _isHighlighted = NO;
            [self onDelegateClose:event];
            [self setNeedsDisplay:YES];
            break;
        case kDFCBarViewModePanel:
        default:
            break;
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [_barItem drawStatusBarBackgroundInRect:dirtyRect withHighlight:_isHighlighted];
    [self.iconCell drawInteriorWithFrame:dirtyRect inView:self];
}
- (void) onDelegateOpen:(NSEvent*)event {
    _globalMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseUpMask handler:^(NSEvent* event){
        switch (_mode) {
            case kDFCBarViewModeMenu:
                [self onMouseUp:event];
                break;
            case kDFCBarViewModePanel:
            default:
                [self onMouseDown:event];
                break;
        }
    }];
    
    if ([_delegate respondsToSelector:@selector(barView:openWithEvent:)]) {
        [_delegate barView:self openWithEvent:event];
    }
}
- (void) onDelegateClose:(NSEvent*)event {
    [NSEvent removeMonitor:_globalMonitor];
    if ([_delegate respondsToSelector:@selector(barView:closeWithEvent:)]) {
        [_delegate barView:self closeWithEvent:event];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MenuBarClosed" object:nil];
}


@end
