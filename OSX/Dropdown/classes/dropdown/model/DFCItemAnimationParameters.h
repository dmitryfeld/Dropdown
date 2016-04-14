//
//  DFCItemAnimationParameters.h
//  Dropdown
//
//  Created by Dmitry Feld on 2013-10-05.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum __DFCItemAnimationType__ {
    kDFCItemIconAnimationTypeSpin = 0x0001,
    kDFCItemIconAnimationTypeReplace = 0x0002,
    kDFCItemIconAnimationTypeAlphaFade = 0x0004,
} DFCItemAnimationType;


@interface DFCItemAnimationParameters : NSObject
@property (nonatomic,assign) DFCItemAnimationType type;
@property (nonatomic,assign) CGFloat duration;
@property (nonatomic,assign) BOOL continuous;
@property (nonatomic,retain) NSImage* imageReplacement;
@end
