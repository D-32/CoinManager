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
    NSTrackingArea* trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options: (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingMouseMoved) owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (void)mouseEntered:(NSEvent *)event {
    if (!_active && !CGRectEqualToRect(self.visibleRect, CGRectZero)) {
        _active = YES;
        NSFont* font = [NSFont systemFontOfSize:12];
        CGSize textSize = NSSizeToCGSize([self.popoverText sizeWithAttributes:[NSDictionary dictionaryWithObject:font forKey: NSFontAttributeName]]);
        NSView* container = [[NSView alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 20, 32)];
        NSTextField* textField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 8, container.frame.size.width, 16)];
        textField.editable = NO;
        textField.bezeled = NO;
        textField.drawsBackground = NO;
        textField.alignment = NSCenterTextAlignment;
        textField.font = font;
        textField.textColor = [NSColor whiteColor];
        textField.stringValue = self.popoverText;
        [container addSubview:textField];
        _popover = [[SFBPopover alloc] initWithContentView:container];
        [_popover setDistance:12];
        [_popover setArrowHeight:10];
        [_popover displayPopoverInWindow:self.window atPoint:event.locationInWindow];
    }
}

- (void)mouseMoved:(NSEvent *)event {
    [_popover movePopoverToPoint:event.locationInWindow];
}

- (void)mouseExited:(NSEvent *)event {
    _active = NO;
    [_popover closePopover:self];
}

@end
