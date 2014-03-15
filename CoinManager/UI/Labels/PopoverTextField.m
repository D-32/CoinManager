//
//  PopoverTextField.m
//  CoinManager
//
//  Created by Dylan Marriott on 15.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "PopoverTextField.h"
#import "SFBPopover.h"

@implementation PopoverTextField {
    BOOL _active;
    SFBPopover* _popover;
}

- (void) viewWillMoveToWindow:(NSWindow *)newWindow {
    NSTrackingArea* trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options: (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways) owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (void)mouseEntered:(NSEvent *)event {
    if (!_active) {
        _active = YES;
        NSView* view = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        _popover = [[SFBPopover alloc] initWithContentView:view];
        [_popover displayPopoverInWindow:self.window atPoint:event.locationInWindow];
    }
    NSLog(@"open");
}

- (void)mouseExited:(NSEvent *)event {
    _active = NO;
    [_popover closePopover:self];
    NSLog(@"close");
}

@end
