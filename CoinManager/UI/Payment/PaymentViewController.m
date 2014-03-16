//
//  PaymentViewController.m
//  CoinManager
//
//  Created by Dylan Marriott on 16/03/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "PaymentViewController.h"
#import "SuperTextFieldView.h"
#import "SuperTextFieldDelegate.h"
#import "Exchange.h"

@interface PaymentViewController () <SuperTextFieldDelegate>
@property (weak) IBOutlet NSTextField* addressField;
@property (weak) IBOutlet SuperTextFieldView* btcField;
@property (weak) IBOutlet SuperTextFieldView* currencyField;
@end

@implementation PaymentViewController

- (void)awakeFromNib {
    [self.btcField setSuperDelegate:self];
    [self.currencyField setSuperDelegate:self];
    [self.addressField becomeFirstResponder];
}

- (void)loadView {
    [super loadView];
    [self.addressField becomeFirstResponder];
}

- (void)textField:(SuperTextFieldView *)textField changedText:(NSString *)text {
    if (textField == self.btcField && ![self.btcField.stringValue isEqualToString:self.btcField.prevString]) {
        // calc currencyField
        NSString* value = [NSString stringWithFormat:@"%.8f", self.btcField.value *  _exchange.current];
        value = [value substringToIndex:value.length - 6];
        self.currencyField.stringValue = value;
        self.currencyField.prevString = value;
    } else if (textField == self.currencyField && ![self.currencyField.stringValue isEqualToString:self.currencyField.prevString]) {
        // calc btc field
        NSString* value = [NSString stringWithFormat:@"%.8f", self.currencyField.value /  _exchange.current];
        value = [value substringToIndex:value.length - 4];
        self.btcField.stringValue = value;
        self.btcField.prevString = value;
    }
}

@end
