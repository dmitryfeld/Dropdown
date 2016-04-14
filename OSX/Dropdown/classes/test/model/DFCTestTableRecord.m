//
//  DFCTestTableRecord.m
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-29.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCTestTableRecord.h"

@interface DFCTestTableRecord() {
    NSString* _code;
    NSString* _message;
    NSString* _context;
}
- (id) initWithCode:(NSString*)code message:(NSString*)message andContext:(NSString*)context;
@end

@implementation DFCTestTableRecord
static NSUInteger recordCount = 0;
@synthesize code = _code;
@synthesize message = _message;
@synthesize context = _context;
+ (DFCTestTableRecord*) nextRecord {
    NSInteger index = recordCount % 7;
    NSArray* messages = @[@"Can not connect to the server",@"No route",@"Broken Pipe",@"URL Not found",@"Server is unaccessible",@"Authentication is required",@"Authentication Failed"];
    NSArray* codes = @[@"500",@"-98",@"-64",@"404",@"501",@"403",@"401"];
    NSArray* contexts = @[@"164-888-89AXYU87ED56PXB",@"918-455-01BFEX68AX48DRF",@"213-650-99AUXI42YI99GNU",@"000-000-00AAAA00AA00AAA",@"193-932-92AIEM38ON73ATY",@"999-999-99ZZZZ99ZZ99ZZZ",@"937-373-42IDGJ87IJ56YTD"];
    DFCTestTableRecord* result = [[DFCTestTableRecord alloc] initWithCode:codes[index] message:messages[index] andContext:contexts[index]];
    recordCount ++;
    return result;
}
- (id) initWithCode:(NSString*)code message:(NSString*)message andContext:(NSString*)context {
    if (self = [super init]) {
        _code = [code retain];
        _message = [message retain];
        _context = [context retain];
    }
    return self;
}
- (void) dealloc {
    [_context release],_context = nil;
    [_message release], _message = nil;
    [_code release],_code = nil;
    [super dealloc];
}
@end
