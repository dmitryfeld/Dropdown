//
//  DFCDropdownItem.h
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-26.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCItem.h"

@interface DFCDropdownItem : DFCItem
@property (nonatomic,assign) id delegate;
@property (assign) BOOL isHighlighted;
@property (assign) NSInteger tag;
@end
