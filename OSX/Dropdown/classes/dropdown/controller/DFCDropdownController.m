//
//  DFCDropdownController.m
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-16.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCDropdownController.h"

@implementation DFCDropdownController
@synthesize dropdown = _dropdown;
- (id) init {
    if (self = [super init]) {
        _dropdown = [DFCDropdown new];
        _dropdown.delegate = self;
        _dropdown.datasource = self;
        //self.window = _dropdown;
    }
    return self;
}
- (void) dealloc {
    [_dropdown release],_dropdown = nil;
    [super dealloc];
}
- (void) dropdownDidOpen:(DFCDropdown*)dropdown {
    
}
- (void) dropdownDidClose:(DFCDropdown*)dropdown {
    
}
- (void) dropdown:(DFCDropdown *)dropdown didPressItem:(DFCDropdownItem*)item {
    
}
- (void) dropdown:(DFCDropdown *)dropdown didReleaseItem:(DFCDropdownItem*)item {
    
}

@end
