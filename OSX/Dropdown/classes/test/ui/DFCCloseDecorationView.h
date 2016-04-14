//
//  DFCCloseDecorationView.h
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-30.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCDropdownProtocols.h"

@interface DFCCloseDecorationView : NSView<DFCDynamicLayout>
@property (readonly, nonatomic) NSButton* closeButton;
@end
