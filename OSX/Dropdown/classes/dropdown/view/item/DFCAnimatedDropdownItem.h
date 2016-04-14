//
//  DFCAnimatedDropdownItem.h
//  Dropdown
//
//  Created by Dmitry Feld on 2013-10-05.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCDropdownItem.h"
#import "DFCItemAnimationParameters.h"

@interface DFCAnimatedDropdownItem : DFCDropdownItem
@property (retain,nonatomic) DFCItemAnimationParameters* animationParameters;
@property (readonly,nonatomic) BOOL isPerformingAnimation;
- (void) startAnimation;
- (void) stopAnimation;
@end
