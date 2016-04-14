//
//  DFCItem.h
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-26.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#include "DFCDropdownProtocols.h"
#include "DFCDropdownParameters.h"


@interface DFCItem : NSView<DFCDynamicLayout>
@property (nonatomic,retain) NSImage* image;
@property (nonatomic,retain) NSString* title;
- (id) initWithParameters:(DFCDropdownParameters*)parameters;
@end
