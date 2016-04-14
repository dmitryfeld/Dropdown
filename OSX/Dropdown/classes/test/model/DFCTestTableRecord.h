//
//  DFCTestTableRecord.h
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-29.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFCTestTableRecord : NSObject
@property (readonly, nonatomic) NSString* code;
@property (readonly, nonatomic) NSString* message;
@property (readonly, nonatomic) NSString* context;
+ (DFCTestTableRecord*) nextRecord;
@end
