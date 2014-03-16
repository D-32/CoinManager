//
//  PaymentController.m
//  CoinManager
//
//  Created by Dylan Marriott on 16/03/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "PaymentController.h"
#import "PaymentViewController.h"
#import "User.h"
#import "UserListener.h"
#import "UserHelper.h"
#import "Exchange.h"
#import "ExchangeListener.h"
#import "ExchangeHelper.h"
#import "OAuthHelper.h"

@interface PaymentController () <UserListener, ExchangeListener>
@end

@implementation PaymentController {
    NSAlert* _alert;
    User* _user;
    Exchange* _exchange;
    PaymentViewController* _paymentViewController;
    CompletionBlock _completionHandler;
    NSWindow* _window;
}

- (void)startPaymentWithWindow:(NSWindow *)window completionHandler:(CompletionBlock)completionHandler {
    _window = window;
    _completionHandler = completionHandler;
    _alert = [NSAlert alertWithMessageText:@"New Payment"
                                     defaultButton:@"Send Money"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@""];
    _paymentViewController = [[PaymentViewController alloc] initWithNibName:@"PaymentViewController" bundle:nil];
    
    [[UserHelper instance] addUserListener:self];
    [[ExchangeHelper instance] addExchangeListener:self];
}

- (void)removeListeners {
    [[UserHelper instance] removeUserListener:self];
    [[ExchangeHelper instance] removeExchangeListener:self];
}

- (void)startPayment {
    NSAlert* alert = [self progressAlert];
    [alert beginSheetModalForWindow:_window completionHandler:^(NSModalResponse response) {
        _completionHandler();
    }];
    OAuthHelper* oah = [[OAuthHelper alloc] init];
    [oah startRequest:@"" completion:^(NSData* data) {
    
    }];
}

- (NSAlert *)progressAlert {
    NSAlert* alert = [[NSAlert alloc] init];
    alert.messageText = @"Please wait";
    alert.informativeText = @"Payment is beeing executed...";
    [alert addButtonWithTitle:@"Cancel"];
    NSProgressIndicator* progressIndicator = [[NSProgressIndicator alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    progressIndicator.style = NSProgressIndicatorPreferredSmallThickness;
    [progressIndicator startAnimation:nil];
    alert.accessoryView = progressIndicator;
    return alert;
}

#pragma mark - UserListener
- (void)userChanged:(User *)user {
    _user = user;
    _alert.informativeText = [NSString stringWithFormat:@"Current balance: %.8f BTC", _user.balance];
}

#pragma mark - ExchangeListener
- (void)exchangeChanged:(Exchange *)exchange {
    _exchange = exchange;
    [_paymentViewController setExchange:_exchange];
}

@end
