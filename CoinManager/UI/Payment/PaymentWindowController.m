//
//  PaymentWindowController.m
//  CoinManager
//
//  Created by Dylan Marriott on 16/03/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "PaymentWindowController.h"
#import "PaymentViewController.h"

@interface PaymentWindowController ()
@property (nonatomic, strong) PaymentViewController* paymentViewController;
@end

@implementation PaymentWindowController

- (id)initWithWindowNibName:(NSString *)windowNibName {
	if (self = [super initWithWindowNibName:windowNibName]) {
        self.paymentViewController = [[PaymentViewController alloc] initWithNibName:@"PaymentViewController" bundle:nil];
        [self.window.contentView addSubview:self.paymentViewController.view];
        self.paymentViewController.view.frame = ((NSView *)self.window.contentView).bounds;
	}
	return self;
}

- (void)setExchange:(Exchange *)exchange {
    self.paymentViewController.exchange = exchange;
}

@end
