//
//  DFCDropdown.h
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-16.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DFCDropdownProtocols.h"
#import "DFCDropdownParameters.h"

@interface DFCDropdown : NSPanel<DFCDynamicLayout,DFCDropdownDelegate,NSWindowDelegate>
@property (assign) BOOL isPrincipal;
@property (nonatomic, assign) DFCDropdown* cascadeParent;
@property (nonatomic, retain) DFCDropdownParameters* parameters;
@property (atomic, assign) id<DFCDropdownDelegate> delegate;
@property (nonatomic, assign) id<DFCDropdownDatasource> datasource;
@property (readonly, nonatomic) NSSize contentSize;
@property (readonly) BOOL isOpen;
- (void) openDropdownAtPoint:(NSPoint)point;
- (void) closeDropdown;
- (void) addSubview:(NSView*)subview;
- (void) rebuild;
//- (void) tearOff;
@end
