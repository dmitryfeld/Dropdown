//
//  DFCDynamicLayout.h
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-16.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DFCDynamicLayout <NSObject>
@required
- (void) layoutContent;
@end

@protocol DFCDynamicallyKeyable <NSObject>
@required
- (void) acquireKey;
@end


@class DFCDropdown;
@class DFCDropdownItem;
@protocol DFCDropdownDelegate<NSWindowDelegate>
@optional
- (void) dropdownDidOpen:(DFCDropdown*)dropdown;
- (void) dropdownDidClose:(DFCDropdown*)dropdown;
- (BOOL) dropdown:(DFCDropdown*)dropdown willResizeTo:(NSSize)newSize;
- (void) dropdown:(DFCDropdown*)dropdown didResizeTo:(NSSize)newSize;
- (void) dropdown:(DFCDropdown *)dropdown didPressItem:(DFCDropdownItem*)item;
- (void) dropdown:(DFCDropdown *)dropdown didReleaseItem:(DFCDropdownItem*)item;
- (void) dropdown:(DFCDropdown *)dropdown didEnterItem:(DFCDropdownItem*)item;
- (void) dropdown:(DFCDropdown *)dropdown didExitItem:(DFCDropdownItem*)item;
@end

@protocol DFCDropdownDatasource <NSObject>
@optional
- (NSView*) newClientViewForDropdown:(DFCDropdown*)dropdown;
- (NSView*) newDecorationViewForDropdown:(DFCDropdown*)dropdown;
- (NSUInteger) itemCountForDropdown:(DFCDropdown*)dropdown;
- (DFCDropdownItem*) newItemForDropdown:(DFCDropdown*)dropdown atIndex:(NSUInteger)index;
@end

@class DFCItemAnimationParameters;
@protocol DFCAnimated <NSObject>
@required
@property (readonly,nonatomic) BOOL isPerformingAnimation;
- (void) startAnimation;
- (void) stopAnimation;
@end

@protocol DFCAnimatedDelegate <NSObject>
@required
- (void) animated:(id<DFCAnimated>)item hasCompletedAnimationWithParameters:(DFCItemAnimationParameters*)params;
@end

