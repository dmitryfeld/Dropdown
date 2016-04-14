//
//  DFCTestDropdownController.m
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-16.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import "DFCTestDropdownController.h"
#import "DFCDropdownItem.h"
#import "DFCHorizontalDecoration.h"
#import "DFCTestView.h"

#import "DFCTestTableViewController.h"
#import "DFCCloseDecorationView.h"

#import "DFCAnimatedDropdownItem.h"

@interface DFCTestDropdownController() {
    DFCTestTableViewController* _testTable;
}
@property (retain,nonatomic) IBOutlet NSTextField* width;
@property (retain,nonatomic) IBOutlet NSTextField* height;
@property (retain,nonatomic) IBOutlet NSBox* box;
- (IBAction)onToggleSize:(id)sender;
- (IBAction)onSetSize:(id)sender;
- (IBAction)onGradient:(id)sender;
- (IBAction)onImage:(id)sender;
- (IBAction)onColor:(id)sender;
- (IBAction)onTop:(id)sender;
- (IBAction)onBottom:(id)sender;
- (IBAction)onLeft:(id)sender;
- (IBAction)onRight:(id)sender;
- (IBAction)onTableButton:(id)sender;
- (IBAction)onSettingsButton:(id)sender;
@end

@implementation DFCTestDropdownController
@synthesize bottomDropdown = _bottomDropdown;
@synthesize leftDropdown = _leftDropdown;
@synthesize tableDropdown = _tableDropdown;
@synthesize width;
@synthesize height;
- (id) init {
    if (self = [super init]) {
        
        self.dropdown.parameters.decorationType = kDFCDecorationTypeColor;
        self.dropdown.parameters.decorationPosition = kDFCDecorationPositionRight;
        
        _bottomDropdown = [DFCDropdown new];
        _bottomDropdown.parameters.arrowOrientation = kDFCDropdownArrowOrientationTop;
        _bottomDropdown.delegate = self;
        _bottomDropdown.datasource = self;
        _bottomDropdown.cascadeParent = self.dropdown;
        _bottomDropdown.parameters.popupSize = NSMakeSize(370.0f + 64.f, 270.0f + 64.f);
        _bottomDropdown.parameters.decorationType = kDFCDecorationTypeColor;
        _bottomDropdown.parameters.decorationPosition = kDFCDecorationPositionTop;
        _bottomDropdown.parameters.decorationImage = [NSImage imageNamed:@"insignia128h"];
        _bottomDropdown.isPrincipal = YES;
        _bottomDropdown.parameters.itemMargin = NSMakeSize(5.0f,5.0f);
        
        _leftDropdown = [DFCDropdown new];
        _leftDropdown.parameters.arrowOrientation = kDFCDropdownArrowOrientationRight;
        _leftDropdown.delegate = self;
        _leftDropdown.datasource = self;
        _leftDropdown.cascadeParent = self.dropdown;
        _leftDropdown.parameters.popupSize = NSMakeSize(310.0f, 660.0f);
        _leftDropdown.parameters.decorationType = kDFCDecorationTypeColor;
        _leftDropdown.parameters.decorationPosition = kDFCDecorationPositionLeft;
        _leftDropdown.isPrincipal = NO;
        
        _tableDropdown = [DFCDropdown new];
        _tableDropdown.parameters.arrowOrientation = kDFCDropdownArrowOrientationRight;
        _tableDropdown.delegate = self;
        _tableDropdown.datasource = self;
        _tableDropdown.cascadeParent = self.bottomDropdown;
        _tableDropdown.parameters.popupSize = NSMakeSize(550.0f, 380.0f);
        _tableDropdown.parameters.decorationType = kDFCDecorationTypeColor;
        _tableDropdown.parameters.decorationPosition = kDFCDecorationPositionTop;
        _tableDropdown.parameters.decorationImage = [NSImage imageNamed:@"insignia128h"];
        _tableDropdown.isPrincipal = NO;
    }
    return self;
}
- (void) dealloc {
    [_bottomDropdown release],_bottomDropdown = nil;
    [_leftDropdown release],_leftDropdown = nil;
    [super dealloc];
}
- (void) dropdownDidOpen:(DFCDropdown*)dropdown {
    NSLog(@"dropdownDidOpen:(DFCDropdown*)%@",dropdown);
}
- (void) dropdownDidClose:(DFCDropdown*)dropdown {
    NSLog(@"dropdownDidClose:(DFCDropdown*)%@",dropdown);
    if (self.dropdown == dropdown) {
        [self.leftDropdown closeDropdown];
        [self.bottomDropdown closeDropdown];
        [self.tableDropdown closeDropdown];
    }
}
- (void) dropdown:(DFCDropdown *)dropdown didPressItem:(DFCDropdownItem*)item {
    NSLog(@"dropdown:(DFCDropdown *)%@ didPressItem:(id)%@[%lu]",dropdown,item,(unsigned long)item.tag);
    if (dropdown == self.dropdown) {
        
        if ([item isKindOfClass: [DFCAnimatedDropdownItem class]]) {
            DFCAnimatedDropdownItem* animated = (DFCAnimatedDropdownItem*)item;
            if (animated.isPerformingAnimation) {
                [animated stopAnimation];
            } else {
                [animated startAnimation];
            }
            [self.leftDropdown closeDropdown];
            [self.bottomDropdown closeDropdown];
        } else {
            if (3 == item.tag) {
                [self.leftDropdown closeDropdown];
                [self.bottomDropdown openDropdownAtPoint:[self bottomAnchorPointForView:item]];
            } else {
                
                [self.bottomDropdown closeDropdown];
                [self.leftDropdown openDropdownAtPoint:[self leftAnchorPointForView:item]];

            }
        }
    }
    
    [self.tableDropdown closeDropdown];
}
- (void) dropdown:(DFCDropdown *)dropdown didReleaseItem:(DFCDropdownItem*)item {
    NSLog(@"dropdown:(DFCDropdown *)%@ didReleaseItem:(id)%@[%lu]",dropdown,item,(unsigned long)item.tag);
}
- (BOOL) dropdown:(DFCDropdown *)dropdown willResizeTo:(NSSize)newSize {
    BOOL result = YES;
    
    if (dropdown == _bottomDropdown) {
        if (newSize.width > 1020.0f) {
            result = NO;
        }
        if (newSize.width < 370.0f + 64.f) {
            result = NO;
        }
        if (newSize.height > 1020.0f) {
            result = NO;
        }
        if (newSize.height < 270.0f + 64.f) {
            result = NO;
        }
    }
    
    return result;
}
- (void) dropdown:(DFCDropdown *)dropdown didResizeTo:(NSSize)newSize {
    if (dropdown == _bottomDropdown) {
        self.width.stringValue = [NSString stringWithFormat:@"%f",newSize.width];
        self.height.stringValue = [NSString stringWithFormat:@"%f",newSize.height];
    }
}
- (NSView*) newClientViewForDropdown:(DFCDropdown*)dropdown {
    if (dropdown == self.bottomDropdown) {
        NSView* result = [self loadTestViewFromXIB];
        [result setNeedsDisplay:YES];
        return result;
    }
    if (dropdown == self.tableDropdown) {
        NSView* result = [self loadTestTableViewFromXIB];
        [result setNeedsDisplay:YES];
        return result;
    }
    return [NSView new];
}
- (NSUInteger) itemCountForDropdown:(DFCDropdown *)dropdown {
    if (dropdown == self.dropdown) {
        return 4;
    }
    if (dropdown == self.leftDropdown) {
        return 15;
    }
    return 0;
}
- (DFCDropdownItem*) newItemForDropdown:(DFCDropdown *)dropdown atIndex:(NSUInteger)index {
    DFCDropdownItem* result = [[DFCDropdownItem alloc] initWithParameters:dropdown.parameters];
    
    NSString* text = [NSString stringWithFormat:@"Element Yy[] #%lu",(unsigned long)index];
    if (dropdown == self.dropdown) {
        if (1 == index) {
            [result release],result =  [[DFCAnimatedDropdownItem alloc] initWithParameters:dropdown.parameters];
            ((DFCAnimatedDropdownItem*)result).animationParameters.continuous = YES;
            ((DFCAnimatedDropdownItem*)result).animationParameters.duration = .3f;
            ((DFCAnimatedDropdownItem*)result).animationParameters.type = kDFCItemIconAnimationTypeReplace;
            ((DFCAnimatedDropdownItem*)result).animationParameters.imageReplacement = [NSImage imageNamed:@"logo64b"];
        }
        text = [NSString stringWithFormat:@"DROP ITEM #%lu",(unsigned long)index];
        result.image = [NSImage imageNamed:@"logo64"];
    }
    if (dropdown == self.leftDropdown) {
        text = [NSString stringWithFormat:@"LEFT LONG LONG ITEM #%lu",(unsigned long)index];
        result.image = [NSImage imageNamed:@"logo16"];
    }
    result.tag = index;
    result.title = text;
    return result;
}
- (NSView*) newDecorationViewForDropdown:(DFCDropdown *)dropdown {
    if (dropdown == self.tableDropdown) {
        DFCHorizontalDecoration* result = [[DFCHorizontalDecoration alloc] initWithParameters:self.tableDropdown.parameters];
        result.title = @"Sync Issues";
        [result setNeedsDisplay:YES];
        return result;
    }
    if (dropdown == self.dropdown) {
        DFCCloseDecorationView* result = [DFCCloseDecorationView new];
        result.closeButton.target = self;
        result.closeButton.action = @selector(onCloseButton:);
        return result;
    }
    return nil;
}
- (NSView*) loadTestViewFromXIB {
    DFCTestView* result = [[DFCTestView viewWithOwner:self] retain];
    self.box.borderType = NSGrooveBorder;
    self.box.title = @"";
    self.width.stringValue = [NSString stringWithFormat:@"%f",_bottomDropdown.parameters.popupSize.width];
    self.height.stringValue = [NSString stringWithFormat:@"%f",_bottomDropdown.parameters.popupSize.height];
    return result;
}
- (NSView*) loadTestTableViewFromXIB {
    DFCTestTableViewController* table = [DFCTestTableViewController new];
    [_testTable release], _testTable = table;
    return [table.view retain];
}
- (NSPoint) bottomAnchorPointForView:(NSView*)view {
    NSRect frame = view.frame;
    frame.size.width += _bottomDropdown.parameters.decorationDimension;
    frame = [view.window convertRectToScreen:frame];
    frame.origin.y = NSMinY(frame);
    return NSMakePoint(NSMidX(frame), frame.origin.y);
}
- (NSPoint) topAnchorPointForView:(NSView*)view {
    NSRect frame = view.frame;
    frame.size.width += _bottomDropdown.parameters.decorationDimension;
    frame = [view.window convertRectToScreen:frame];
    frame.origin.y = NSMinY(frame);
    return NSMakePoint(NSMidX(frame), NSMaxY(frame));
}
- (NSPoint) leftAnchorPointForView:(NSView*)view {
    NSRect frame = view.frame;
    frame = [view.window convertRectToScreen:frame];
    return NSMakePoint(NSMinX(frame), NSMidY(frame));
}
- (NSPoint) rightAnchorPointForView:(NSView*)view {
    NSRect frame = view.frame;
    frame = [view.window convertRectToScreen:frame];
    return NSMakePoint(NSMaxX(frame), NSMidY(frame));
}
- (IBAction) onToggleSize:(id)sender {
    NSSize size = self.bottomDropdown.parameters.popupSize;
    NSSize size1 = NSMakeSize(370.0f + 64.f, 270.0f + 64.f);
    NSSize size2 = NSMakeSize(800.0f, 600.0f);
    if (NSEqualSizes(size, size1)) {
        size = size2;
    } else {
        size = size1;
    }
    self.bottomDropdown.parameters.popupSize = size;
    [self.tableDropdown closeDropdown];
}
- (IBAction) onSetSize:(id)sender {
    NSString* widthS = self.width.stringValue;
    NSString* heightS = self.height.stringValue;
    NSSize size = NSMakeSize(widthS.floatValue,heightS.floatValue);
    self.bottomDropdown.parameters.popupSize = size;
    [self.tableDropdown closeDropdown];
}
- (IBAction)onGradient:(id)sender {
    self.bottomDropdown.parameters.decorationType = kDFCDecorationTypeGradient;
}
- (IBAction)onImage:(id)sender {
    self.bottomDropdown.parameters.decorationType = kDFCDecorationTypeImage;
}
- (IBAction)onColor:(id)sender {
    self.bottomDropdown.parameters.decorationType = kDFCDecorationTypeColor;
}
- (IBAction)onTop:(id)sender {
    self.bottomDropdown.parameters.decorationPosition = kDFCDecorationPositionTop;
}
- (IBAction)onBottom:(id)sender {
    self.bottomDropdown.parameters.decorationPosition = kDFCDecorationPositionBottom;
}
- (IBAction)onLeft:(id)sender {
    self.bottomDropdown.parameters.decorationPosition = kDFCDecorationPositionLeft;
}
- (IBAction)onRight:(id)sender {
    self.bottomDropdown.parameters.decorationPosition = kDFCDecorationPositionRight;
}
- (IBAction)onTableButton:(id)sender {
    if (!self.tableDropdown.isOpen) {
        NSPoint point = [self leftAnchorPointForView:self.box];
        point.x -= self.box.frame.origin.x;
        [self.tableDropdown openDropdownAtPoint:point];
    } else {
        [self.tableDropdown closeDropdown];
    }
}
- (IBAction)onSettingsButton:(id)sender {
}
- (IBAction)onCloseButton:(id)sender {
    [[NSApplication sharedApplication] terminate:nil];
}
@end
