//
//  DFCBarViewController.h
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-16.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFCBarView.h"

@interface DFCBarViewController : NSObject<DFCBarViewDelegate>
@property (retain,nonatomic) DFCBarView* barView;
@end
