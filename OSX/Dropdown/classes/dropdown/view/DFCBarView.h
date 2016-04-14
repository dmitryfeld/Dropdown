//
//  DFCBarView.h
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-16.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum __DFCBarViewModes {
    kDFCBarViewModeMenu,
    kDFCBarViewModePanel
} DFCBarViewModes;

@class DFCBarView;
@protocol DFCBarViewDelegate<NSObject>
@required
- (void) barView:(DFCBarView*)barView openWithEvent:(NSEvent*)event;
- (void) barView:(DFCBarView*)barView closeWithEvent:(NSEvent*)event;
@end

@interface DFCBarView : NSView
@property (assign) id<DFCBarViewDelegate> delegate;
@property (assign) DFCBarViewModes mode;
@property (assign) BOOL isHighlighted;
@property (retain,nonatomic) NSImage* icon;

- (void) start;
- (void) closeDropDown;

@end
