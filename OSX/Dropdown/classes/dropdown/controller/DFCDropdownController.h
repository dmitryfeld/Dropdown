//
//  DFCDropdownController.h
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-16.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFCDropdown.h"

@interface DFCDropdownController : NSObject<DFCDropdownDelegate,DFCDropdownDatasource>
@property (readonly,nonatomic) DFCDropdown* dropdown;
@end
