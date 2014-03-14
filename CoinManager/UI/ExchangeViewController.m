//
//  ExchangeViewController.m
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "ExchangeViewController.h"
#import "Exchange.h"
#import "ExchangeHelper.h"
#import "ExchangeListener.h"

@interface ExchangeViewController () <ExchangeListener> {
	Exchange* _exchange;
}
@property (weak) IBOutlet NSPopUpButton* currencySelection;
@property (weak) IBOutlet NSTextField* currencyLabel;
@property (weak) IBOutlet NSTextField* currentLabel;
@property (weak) IBOutlet NSImageView* historyView;

- (IBAction)actionCurrencySelection:(id)sender;

@end

@implementation ExchangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[ExchangeHelper instance] addExchangeListener:self];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self updateValues];
	[self updateGraph];
}

- (IBAction)actionCurrencySelection:(id)sender {
    NSString* currency;
    NSString* title = self.currencySelection.selectedItem.title;
    if ([title isEqualToString:@"USD $"]) {
        currency = @"USD";
    } else if ([title isEqualToString:@"EUR €"]) {
        currency = @"EUR";
    }
    
    [[ExchangeHelper instance] changeCurreny:currency];
}

- (void)exchangeChanged:(Exchange *)exchange {
	_exchange = exchange;
	[self updateValues];
	[self updateGraph];
}

- (void)updateValues {
    NSString* currency = _exchange.currency;
    if ([currency isEqualToString:@"USD"]) {
        self.currencyLabel.stringValue = @"USD $";
        [self.currencySelection selectItemAtIndex:0];
    } else if ([currency isEqualToString:@"EUR"]) {
        self.currencyLabel.stringValue = @"EUR €";
        [self.currencySelection selectItemAtIndex:1];
    }
    
    self.currentLabel.stringValue = [NSString stringWithFormat:@"%.2f", _exchange.current];
}

- (void)updateGraph {
	self.historyView.image = [[NSImage alloc] initWithData:_exchange.image];
	[self.historyView setNeedsLayout:YES];
}

@end
