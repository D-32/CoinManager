//
//  ExchangeWindowController.m
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "ExchangeWindowController.h"
#import "ExchangeViewController.h"

@interface ExchangeWindowController ()
@property (nonatomic, strong) ExchangeViewController* exchangeViewController;
@end

@implementation ExchangeWindowController

- (id)initWithWindowNibName:(NSString *)windowNibName {
	if (self = [super initWithWindowNibName:windowNibName]) {
        self.exchangeViewController = [[ExchangeViewController alloc] initWithNibName:@"ExchangeViewController" bundle:nil];
        [self.window.contentView addSubview:self.exchangeViewController.view];
        self.exchangeViewController.view.frame = ((NSView *)self.window.contentView).bounds;
        
	}
	return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    //[self.window setFrameUsingName:@"ExchangeWindow_" force:YES];
}

- (void)windowDidMove:(NSNotification *)aNotification {
    [[self window] saveFrameUsingName:@"ExchangeWindow_"];
}

@end
