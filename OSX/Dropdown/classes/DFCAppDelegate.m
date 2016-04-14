//
//  DFCAppDelegate.m
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-16.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCAppDelegate.h"
#import "DFCTestBarViewController.h"

@interface DFCAppDelegate() {
    DFCTestBarViewController* _barViewController;
}
@end

@implementation DFCAppDelegate

- (void)dealloc {
    [_barViewController release], _barViewController = nil;
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if (!_barViewController) {
        _barViewController = [DFCTestBarViewController new];
    }
    [_barViewController.barView start];
}

@end
