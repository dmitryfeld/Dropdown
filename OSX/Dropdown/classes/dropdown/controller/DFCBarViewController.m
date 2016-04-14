//
//  DFCBarViewController.m
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-16.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCBarViewController.h"

@interface DFCBarViewController() {
    
}
@end

@implementation DFCBarViewController
@synthesize barView = _barView;

- (id) init {
    if (self = [super init]) {
        _barView = [DFCBarView new];
        _barView.delegate = self;
    }
    return self;
}
- (void) dealloc {
    [_barView release],_barView = nil;
    [super dealloc];
}

- (void) setBarView:(DFCBarView *)barView {
    if (![_barView isEqual:barView]) {
        [_barView release], _barView = [barView retain];
        _barView.delegate = self;
    }
}
- (DFCBarView*) barView {
    return _barView;
}

- (void) barView:(DFCBarView*)barView openWithEvent:(NSEvent*)event {
    
}
- (void) barView:(DFCBarView*)barView closeWithEvent:(NSEvent*)event {
    
}


@end
