//
//  DFCDropdown.m
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-16.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCDropdown.h"
#import "DFCBackgroundView.h"



@interface DFCDropdown() {
    CGFloat _arrowAdjustment;
    id<DFCDropdownDelegate> __delegate;
    DFCDropdownParameters* _parameters;
    NSPoint _ancorPoint;
    BOOL _isOpen;
}
@property (readonly,nonatomic) DFCBackgroundView* backgroundView;
//@property (readonly,nonatomic) BOOL isTornOff;
@end

@implementation DFCDropdown
@synthesize backgroundView = _backgroundView;
@synthesize isPrincipal = _isPrincipal;
@synthesize cascadeParent = _cascadeParent;
@synthesize datasource = _datasource;
@synthesize isOpen = _isOpen;
@dynamic parameters;
@dynamic delegate;
@dynamic contentSize;
//@dynamic isTornOff;
- (id) init {
    if (self = [super init]) {
        _isPrincipal = YES;
        _parameters = [DFCDropdownParameters new];
        super.delegate = self;
        _datasource = nil;
        self.acceptsMouseMovedEvents = YES;
        self.level = NSPopUpMenuWindowLevel;
        [self setOpaque:NO];
        self.backgroundColor = [NSColor clearColor];
        self.backingType = NSBackingStoreBuffered;
        self.alphaValue = .0f;
        self.styleMask = NSBorderlessWindowMask | NSUtilityWindowMask | NSNonactivatingPanelMask;
        [self setReleasedWhenClosed: NO];
        self.contentView = self.backgroundView;
        [self startWatchingParameters];
        _isOpen = NO;
    }
    return self;
}

- (void) dealloc {
    [self stopWatchingParameters];
    [_parameters release],_parameters = nil;
    [_backgroundView release],_backgroundView = nil;
    [super dealloc];
}

- (void) rebuild {
    [self.backgroundView rebuild];
}

#pragma mark - Delegates Implementation
- (BOOL) canBecomeKeyWindow; {
    return _isPrincipal;
}
- (BOOL) canBecomeMainWindow; {
    return _isPrincipal;
}
- (void)windowWillClose:(NSNotification *)notification {
}

- (void)windowDidResignKey:(NSNotification *)notification {
}

- (void) windowDidResize:(NSNotification *)notification {
    NSRect panelRect = [self frame];
    if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationTop) {
        self.backgroundView.arrowPoint = round(panelRect.size.width / 2) + _arrowAdjustment;
    }
    if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationBottom) {
        self.backgroundView.arrowPoint = round(panelRect.size.width / 2) + _arrowAdjustment;
    }
    if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationLeft) {
        self.backgroundView.arrowPoint = round(panelRect.size.height / 2) + _arrowAdjustment;
    }
    if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationRight) {
        self.backgroundView.arrowPoint = round(panelRect.size.height / 2) + _arrowAdjustment;
    }
    [self layoutContent];
}
#pragma mark Properties Implementation
- (NSSize) contentSize {
    return self.backgroundView.clientView.frame.size;
}
- (id<DFCDropdownDelegate>) delegate {
    return __delegate;
}
- (void) setDelegate:(id<DFCDropdownDelegate>)delegate {
    if (__delegate != delegate) {
        __delegate = delegate;
        self.backgroundView.delegate = __delegate;
        self.backgroundView.datasource = _datasource;
        [self.backgroundView rebuild];
    }
}
- (id<DFCDropdownDatasource>) datasource {
    return _datasource;
}
- (void) setDatasource:(id<DFCDropdownDatasource>)datasource {
    if (_datasource != datasource) {
        _datasource = datasource;
        self.backgroundView.delegate = __delegate;
        self.backgroundView.datasource = _datasource;
        [self.backgroundView rebuild];
    }
}
- (DFCDropdownParameters*) parameters {
    return _parameters;
}
- (void) setParameters:(DFCDropdownParameters *)parameters {
    if (![parameters isEqual:_parameters]) {
        [_parameters release], _parameters = parameters;
        [_backgroundView release], _backgroundView = nil;
        self.contentView = self.backgroundView;
    }
}
- (DFCBackgroundView*) backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[DFCBackgroundView alloc] initWithParameters:_parameters andParent:self];
    }
    return _backgroundView;
}
//- (BOOL) isTornOff {
//    return self.styleMask == (NSTitledWindowMask | NSClosableWindowMask);
//}


#pragma mark - Public API Implementation
- (void) openDropdownAtPoint:(NSPoint)point {
    _ancorPoint = point;
    NSScreen* screen = [[NSScreen screens] objectAtIndex:0];
    NSRect visiFrame = [screen visibleFrame];
    NSRect startingRect = NSMakeRect(point.x - 15, point.y - 15, 30, 30);
    NSRect panelRect;
    panelRect.size.width = _parameters.popupSize.width;
    panelRect.size.height = _parameters.popupSize.height;
    if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationTop) {
        panelRect.origin.x = roundf(point.x - NSWidth(panelRect) / 2);
        panelRect.origin.y = point.y - NSHeight(panelRect);
    }
    if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationBottom) {
        panelRect.origin.x = roundf(point.x - NSWidth(panelRect) / 2);
        panelRect.origin.y = point.y;
    }
    if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationRight) {
        panelRect.origin.x = point.x - NSWidth(panelRect);
        panelRect.origin.y = roundf(point.y - NSHeight(panelRect) / 2);
    }
    if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationLeft) {
        panelRect.origin.x = point.x;
        panelRect.origin.y = roundf(point.y - NSHeight(panelRect) / 2);
    }
    panelRect = [self normalizeBounds:panelRect forVisibleFrame:visiFrame];
    
    [[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    [self setAlphaValue:0];
    [self setFrame:startingRect display:NO];
    if (self.isPrincipal) {
        [self makeKeyAndOrderFront:nil];
    } else {
        self.isPrincipal = NO;
        [self orderFront:nil];
    }
    
    NSTimeInterval openDuration = _parameters.openDuration;

#ifdef DEBUG
    NSEvent *currentEvent = [NSApp currentEvent];
    if ([currentEvent type] == NSLeftMouseDown) {
        NSUInteger clearFlags = ([currentEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask);
        BOOL shiftPressed = (clearFlags == NSShiftKeyMask);
        BOOL shiftOptionPressed = (clearFlags == (NSShiftKeyMask | NSAlternateKeyMask));
        if (shiftPressed || shiftOptionPressed) {
            openDuration *= 10;
            if (shiftOptionPressed)
                NSLog(@"Icon is at %@\n\tMenu is on screen %@\n\tWill be animated to %@",
                      NSStringFromRect(startingRect), NSStringFromRect([screen frame]), NSStringFromRect(panelRect));
        }
    }
#endif

    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:openDuration];
    [[self animator] setFrame:panelRect display:YES];
    [[self animator] setAlphaValue:1];
    [NSAnimationContext endGrouping];
    dispatch_after(dispatch_walltime(NULL, NSEC_PER_SEC * _parameters.openDuration * 2), dispatch_get_main_queue(), ^{
        _isOpen = YES;
        [self onDelegateOpen];
    });
}

- (void) closeDropdown {
    [self close];
    _isOpen = NO;
    [self onDelegateClose];
}
- (void) addSubview:(NSView*)subview {
    [self.backgroundView.clientView addSubview:subview];
    [self layoutContent];
}


#pragma mark - Dynamic Layout Implementation
- (void) layoutContent {
    [self.backgroundView layoutContent];
}

- (void) onDelegateOpen {
    if ([self.delegate respondsToSelector:@selector(dropdownDidOpen:)]) {
        [self.delegate dropdownDidOpen:self];
    }
}
- (void) onDelegateClose {
    if ([self.delegate respondsToSelector:@selector(dropdownDidClose:)]) {
        [self.delegate dropdownDidClose:self];
    }
}
- (BOOL) onDelegateWillResizeTo:(NSSize) newSize {
    BOOL result = YES;
    if ([self.delegate respondsToSelector:@selector(dropdown:willResizeTo:)]) {
        result = [self.delegate dropdown:self willResizeTo:newSize];
    }
    return result;
}
- (void) onDelegateDidResizeTo:(NSSize)newSize {
    if ([self.delegate respondsToSelector:@selector(dropdown:didResizeTo:)]) {
        [self.delegate dropdown:self didResizeTo:newSize];
    }
}

#pragma mark - internal geometry methods
- (NSRect) normalizeBounds:(NSRect)bounds forVisibleFrame:(NSRect)visibleFrame {
    _arrowAdjustment = 0.0f;
    if (self.cascadeParent.parameters.arrowOrientation == kDFCDropdownArrowOrientationTop) {
        visibleFrame.size.height -= _parameters.arrowSize.height;
    }
    if (self.cascadeParent.parameters.arrowOrientation == kDFCDropdownArrowOrientationBottom) {
        visibleFrame.origin.y += _parameters.arrowSize.height;
    }
    if (bounds.origin.x < visibleFrame.origin.x) {
        bounds.size.width -= (_arrowAdjustment = visibleFrame.origin.x - bounds.origin.x);
        bounds.origin.x = visibleFrame.origin.x;
    }
    if (bounds.origin.y < visibleFrame.origin.y) {
        bounds.size.height -= (_arrowAdjustment = visibleFrame.origin.y - bounds.origin.y);
        bounds.origin.y = visibleFrame.origin.y;
    }
    if (NSMaxX(bounds) > NSMaxX(visibleFrame)) {
        bounds.origin.x -= (_arrowAdjustment = NSMaxX(bounds) - NSMaxX(visibleFrame));
        bounds.size.width -= (NSMaxX(bounds) - NSMaxX(visibleFrame));
    }
    if (NSMaxY(bounds) > NSMaxY(visibleFrame)) {
        bounds.origin.y -= (_arrowAdjustment = NSMaxY(bounds) - NSMaxY(visibleFrame));
        bounds.size.height -= (NSMaxY(bounds) - NSMaxY(visibleFrame));
    }
    return bounds;
}
#pragma mark - parameters watching methods
- (void) startWatchingParameters {
    if (_parameters) {
        [_parameters addObserver:self
                      forKeyPath:@"popupSize"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
        [_parameters addObserver:self
                      forKeyPath:@"decorationType"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
        [_parameters addObserver:self
                      forKeyPath:@"decorationPosition"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    }
}
- (void) stopWatchingParameters {
    if (_parameters) {
        [_parameters removeObserver:self forKeyPath:@"popupSize"];
        [_parameters removeObserver:self forKeyPath:@"decorationType"];
        [_parameters removeObserver:self forKeyPath:@"decorationPosition"];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"popupSize"]) {
        if ([self onDelegateWillResizeTo:_parameters.popupSize]) {
            [self performResizing];
        }
    }
    if ([keyPath isEqualToString:@"decorationPosition"]) {
        [self.backgroundView setNeedsDisplay:YES];
        [self rebuild];
    }
    if ([keyPath isEqualToString:@"decorationType"]) {
        [self.backgroundView setNeedsDisplay:YES];
    }
}
- (void) performResizing {
    NSScreen* screen = [[NSScreen screens] objectAtIndex:0];
    NSRect visiFrame = [screen visibleFrame];
    NSRect panelRect;
    panelRect.size.width = _parameters.popupSize.width;
    panelRect.size.height = _parameters.popupSize.height;
    if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationTop) {
        panelRect.origin.x = roundf(_ancorPoint.x - NSWidth(panelRect) / 2);
        panelRect.origin.y = _ancorPoint.y - NSHeight(panelRect);
    }
    if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationBottom) {
        panelRect.origin.x = roundf(_ancorPoint.x - NSWidth(panelRect) / 2);
        panelRect.origin.y = _ancorPoint.y;
    }
    if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationRight) {
        panelRect.origin.x = _ancorPoint.x - NSWidth(panelRect);
        panelRect.origin.y = roundf(_ancorPoint.y - NSHeight(panelRect) / 2);
    }
    if (_parameters.arrowOrientation == kDFCDropdownArrowOrientationLeft) {
        panelRect.origin.x = _ancorPoint.x;
        panelRect.origin.y = roundf(_ancorPoint.y - NSHeight(panelRect) / 2);
    }
    panelRect = [self normalizeBounds:panelRect forVisibleFrame:visiFrame];
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:_parameters.openDuration];
    [[self animator] setFrame:panelRect display:YES];
    [[self animator] setAlphaValue:1];
    [NSAnimationContext endGrouping];
    dispatch_after(dispatch_walltime(NULL, NSEC_PER_SEC * _parameters.openDuration * 2), dispatch_get_main_queue(), ^{
        [self onDelegateDidResizeTo:_parameters.popupSize];
    });
}
- (void) acquireKey {
    if (_isPrincipal) {
        [self makeKeyWindow];
    }
}
@end
