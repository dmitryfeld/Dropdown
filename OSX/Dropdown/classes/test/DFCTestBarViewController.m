//
//  DFCTestBarViewController.m
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-16.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCTestBarViewController.h"
#import "DFCTestDropdownController.h"

@interface DFCTestBarViewController() {
    DFCTestDropdownController* _dropdown;
}

@end

@implementation DFCTestBarViewController
- (id) init {
    if (self = [super init]) {
        _dropdown = [DFCTestDropdownController new];
    }
    return self;
}

- (void) barView:(DFCBarView*)barView openWithEvent:(NSEvent*)event {
    //NSLog(@"barView:(DFCBarView*)%@ openWithEvent:(NSEvent*)%@",barView,event);
    [_dropdown.dropdown openDropdownAtPoint:[self menuAnchorPoint]];
}
- (void) barView:(DFCBarView*)barView closeWithEvent:(NSEvent*)event {
    //NSLog(@"barView:(DFCBarView*)%@ closeWithEvent:(NSEvent*)%@",barView,event);
    [_dropdown.dropdown closeDropdown];
}
- (NSPoint) menuAnchorPoint {
    NSRect frame = self.barView.frame;
    frame = [self.barView.window convertRectToScreen:frame];
    frame.origin.y = NSMinY(frame);
    return NSMakePoint(NSMidX(frame), frame.origin.y);
}

@end
