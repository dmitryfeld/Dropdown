//
//  DFCItem_Private.h
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-30.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCItem.h"

@interface DFCItem(Private) {
    
}
- (DFCTextParameters) getTextParameters;
- (DFCDropdownParameters*) getParameters;
- (NSTextField*) getTitleView;
- (NSImageView*) getImageView;
@end
