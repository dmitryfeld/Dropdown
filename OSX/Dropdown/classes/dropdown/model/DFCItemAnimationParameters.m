//
//  DFCItemAnimationParameters.m
//  Dropdown
//
//  Created by Dmitry Feld on 2013-10-05.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCItemAnimationParameters.h"

@implementation DFCItemAnimationParameters
@synthesize type;
@synthesize duration;
@synthesize continuous;
@synthesize imageReplacement;
- (id) init {
    if (self = [super init]) {
        self.type = kDFCItemIconAnimationTypeSpin;
        self.duration = .5f;
        self.continuous = YES;
    }
    return self;
}
@end
