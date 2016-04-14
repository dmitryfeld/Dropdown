//
//  DFCTestView.h
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-29.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DFCTestView : NSView
+(DFCTestView*) viewWithNibName:(NSString*)nibName owner:(NSObject *)owner;
+(DFCTestView*) viewWithOwner:(NSObject *)owner;
@end
