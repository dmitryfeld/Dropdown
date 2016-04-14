//
//  DFCTestView.m
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-29.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCTestView.h"
#import "DFCDropdownParameters.h"

@interface DFCTestView() {
    
}
@end

@implementation DFCTestView
+(DFCTestView*) viewWithNibName:(NSString *)nibName owner:(NSObject *)owner {
    NSArray* nibContent;
    id customView = nil;
    BOOL result = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner topLevelObjects:&nibContent];
    if (result) {
        nibContent = [nibContent retain];
        NSEnumerator *nibEnumerator = [nibContent objectEnumerator];
        
        NSObject* nibItem = nil;
        while ((nibItem = [nibEnumerator nextObject]) != nil) {
            if ([nibItem isKindOfClass:[self class]]) {
                customView = nibItem;
                break;
            }
        }
        [nibContent release];
    }
    return customView;
}
+(DFCTestView*) viewWithOwner:(NSObject *)owner {
    return [DFCTestView viewWithNibName:@"DFCTestView" owner:owner];
}
- (id)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code here.
    }
    return self;
}
@end
