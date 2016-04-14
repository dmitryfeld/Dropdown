//
//  DFCTestTableViewController.m
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-29.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCTestTableViewController.h"
#import "DFCTestTableRecord.h"

@interface DFCTestTableViewController () {
    NSTimer* _updateTimer;
    BOOL _stickToBottom;
}
@property (retain, nonatomic) IBOutlet NSArrayController* records;
@property (retain, nonatomic) IBOutlet NSTableView* table;
@end

@implementation DFCTestTableViewController
@synthesize records = _records;
@synthesize table = _table;
- (id)init {
    self = [super initWithNibName:@"DFCTestTableViewController" bundle:nil];
    if (self) {
        [self setupTimer];
    }
    return self;
}
- (void) dealloc {
    [_records release],_records = nil;
    [_updateTimer invalidate],_updateTimer = nil;
    [super dealloc];
}
- (void) awakeFromNib {
    [super awakeFromNib];
    [self.table.enclosingScrollView.contentView setPostsBoundsChangedNotifications:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boundDidChange:) name:NSViewBoundsDidChangeNotification object:self.table.enclosingScrollView.contentView];
    self.table.delegate = self;
}
- (void) setupTimer {
    _stickToBottom = YES;
    [_updateTimer invalidate],_updateTimer = nil;
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}
- (void) onTimer:(NSTimer*)timer {
    [self.records addObject:[DFCTestTableRecord nextRecord]];
    if (_stickToBottom) {
        [self.table scrollRowToVisible:self.table.numberOfRows - 1];
    }
}
- (void)boundDidChange:(NSNotification *)notification {
    _stickToBottom = NO;
    if ([self isLastRowVisible]) {
        _stickToBottom = YES;
    }
}
- (BOOL) isLastRowVisible {
    CGRect visibleRect = self.table.enclosingScrollView.contentView.visibleRect;
    NSRange range = [self.table rowsInRect:visibleRect];
    return (range.length + range.location) >= self.table.numberOfRows;
}
- (IBAction) onClear:(id)sender {
    [self.records.content removeAllObjects];
}
- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    return NO;
}
@end
