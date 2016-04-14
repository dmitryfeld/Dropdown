//
//  DFCBackgroundView.h
//  BriefcasePOC
//
//  Created by Dmitry Feld on 2013-08-29.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "DFCDropdownProtocols.h"
#import "DFCDropdownParameters.h"



@interface DFCBackgroundView : NSView<DFCDynamicLayout>
@property (nonatomic, assign) NSInteger arrowPoint;
@property (readonly, nonatomic) NSView* clientView;
@property (readonly, nonatomic) NSView* decorationView;
@property (readonly, nonatomic) NSArray* clientItems;
@property (nonatomic, assign) id<DFCDropdownDelegate> delegate;
@property (nonatomic, assign) id<DFCDropdownDatasource> datasource;
- (id) initWithParameters:(DFCDropdownParameters*)parameters andParent:(id)parent;
- (void) rebuild;
@end
