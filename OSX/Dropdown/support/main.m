//
//  main.m
//  Dropdown
//
//  Created by Dmitry Feld on 2013-09-16.
//  Copyright (c) 2013 Dmitry Feld. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DFCAppDelegate.h"

int main(int argc, char *argv[])
{
    DFCAppDelegate * delegate = [DFCAppDelegate new];
    [[NSApplication sharedApplication] setDelegate:delegate];
    [NSApp run];
}
