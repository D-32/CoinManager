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
#import "KBButton.h"
#import "OAuthHelper.h"
#import "UserHelper.h"

@interface PaymentViewController () <SuperTextFieldDelegate>
@property (weak) IBOutlet NSTextField* addressField;
@property (weak) IBOutlet SuperTextFieldView* btcField;
@property (weak) IBOutlet SuperTextFieldView* currencyField;
@property (weak) IBOutlet KBButton* payButton;
@property (weak) IBOutlet KBButton* cancelButton;
@property (weak) IBOutlet NSTextField* errorField;
@end

@implementation PaymentViewController {
    NSProgressIndicator* _refreshIndicator;
    NSString* _payButtonTitle;
}

- (void)awakeFromNib {
    [self.btcField setSuperDelegate:self];
    [self.currencyField setSuperDelegate:self];
    [self.addressField becomeFirstResponder];
    [[self.addressField window] makeFirstResponder:self.addressField];
    
    [self.payButton setKBButtonType:BButtonTypePrimary];
    [self.payButton setTarget:self];
    [self.payButton setAction:@selector(actionPay)];
    
    [self.cancelButton setKBButtonType:BButtonTypeDefault];
    [self.cancelButton setTarget:self];
    [self.cancelButton setAction:@selector(actionCancel)];
    
    _payButtonTitle = self.payButton.title;
    _refreshIndicator = [[NSProgressIndicator alloc] initWithFrame:CGRectMake(35, 7, 16, 16)];
    [_refreshIndicator setStyle:NSProgressIndicatorSpinningStyle];
    [_refreshIndicator setControlSize:NSSmallControlSize];
    
    [[[NSApplication sharedApplication] mainWindow]
     performSelector: @selector(makeFirstResponder:)
     withObject:self.addressField
     afterDelay:0.01];
}

- (void)actionPay {
    [self setRefreshProgress:YES];
    NSString* json = [NSString stringWithFormat:@"{\"transaction\": {\"to\": \"%@\",\"amount\": \"%@\",\"notes\": \"\"}}", self.addressField.stringValue, self.btcField.stringValue];
    
    OAuthHelper* oah = [[OAuthHelper alloc] init];
    [oah startRequest:@"https://coinbase.com/api/v1/transactions/send_money" extraParms:nil postData:json completion:^(NSData* data) {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        BOOL success = json[@"success"];
        
        [self setRefreshProgress:NO];
        
        if (success) {
            [[UserHelper instance] refresh];
            self.errorField.stringValue = @"";
            [self.view.window close];
        } else {
            NSString* error = json[@"errors"][0];
            self.errorField.stringValue = error;
        }
    }];
}

- (void)actionCancel {
    [self setRefreshProgress:NO];
    self.errorField.stringValue = @"";
    [self.view.window close];
}

- (void)setRefreshProgress:(BOOL)inProgress {
    if (inProgress) {
        self.payButton.enabled = NO;
        [self.payButton addSubview:_refreshIndicator];
        [_refreshIndicator startAnimation:self];
        self.payButton.title = nil;
    } else {
        self.payButton.enabled = YES;
        [_refreshIndicator stopAnimation:self];
        [_refreshIndicator removeFromSuperview];
        self.payButton.title = _payButtonTitle;
    }
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
