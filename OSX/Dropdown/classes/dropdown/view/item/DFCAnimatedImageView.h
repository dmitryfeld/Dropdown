//
//  DFCAnimatedImageView.h
//  Dropdown
//
//  Created by Dmitry Feld on 2013-10-05.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DFCDropdownProtocols.h"
#import "DFCItemAnimationParameters.h"

@interface DFCAnimatedImageView : NSImageView<DFCAnimated>
@property (nonatomic,retain) DFCItemAnimationParameters* parameters;
@property (nonatomic,assign) id<DFCAnimatedDelegate> delegate;
@property (readonly,nonatomic) BOOL isPerformingAnimation;
- (void) startAnimation;
- (void) stopAnimation;
@end
