//
//  DFCCloseDecorationView.m
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-30.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCCloseDecorationView.h"

@interface DFCCloseDecorationView() {
    NSButton* _closeButton;
}

@end;

@implementation DFCCloseDecorationView
@synthesize closeButton = _closeButton;
- (id)init {
    if (self = [super init]) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor clearColor].CGColor;
        _closeButton = [NSButton new];
        [_closeButton setImage:[NSImage imageNamed:@"cancel"]];
        [_closeButton setImagePosition:NSImageOnly];
        [_closeButton setBordered:NO];
        [_closeButton setButtonType:NSMomentaryChangeButton];
        [_closeButton setBezelStyle:NSRegularSquareBezelStyle];
        [self addSubview:_closeButton];
    }
    return self;
}

- (void) dealloc {
    [_closeButton release];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];
}

- (void) layoutContent {
    NSRect rect = NSMakeRect(5, 10, 16, 16);
    _closeButton.frame = rect;
}

@end
