//
//  TransactionTableCellView.m
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "TransactionTableCellView.h"
#import "Transaction.h"
#import "Receiver.h"
#import "Exchange.h"
#import "ExchangeHelper.h"
#import "ExchangeListener.h"

static int CONFIRMATION_WARNING_MIN = 6;

@interface TransactionTableCellView () <ExchangeListener>
@property (nonatomic, weak) IBOutlet NSImageView* imageView;
@property (nonatomic, weak) IBOutlet NSTextField* addressLabel;
@property (nonatomic, weak) IBOutlet NSTextField* totalLabel;
@property (nonatomic, weak) IBOutlet NSTextField* dateLabel;
@property (nonatomic, weak) IBOutlet NSTextField* confirmationsLabel;
@end

@implementation TransactionTableCellView {
    Transaction* _transaction;
    Exchange* _exchange;
}

- (void)setTransaction:(Transaction *)transaction {
    _transaction = transaction;
    [[ExchangeHelper instance] addExchangeListener:self];
}

#pragma mark - Private
- (void)update {
    /*
    float amount = 0;
    for (Receiver* receiver in _transaction.receiver) {
        amount += receiver.amount;
    }
    
    int more = (int)MAX(0, _transaction.receiver.count - 1);
    
    Receiver* receiver = _transaction.receiver[0];
    if ([_transaction.orgAddress.address isEqualToString:_transaction.sender]) {
        // out
        self.imageView.image = [NSImage imageNamed:@"Minus"];
        self.addressLabel.stringValue = [NSString stringWithFormat:@"To: %@", receiver.address];
    } else {
        // in
        self.imageView.image = [NSImage imageNamed:@"Plus"];
        self.addressLabel.stringValue = [NSString stringWithFormat:@"From: %@", _transaction.sender];
    }
    if (more > 0) {
        self.addressLabel.stringValue = [NSString stringWithFormat:@"%@ (+%i)", self.addressLabel.stringValue, more];
    }
    
    NSString* total = [NSString stringWithFormat:@"%4.6f", amount / 100000000.0f];
    NSString* currencySimbol = @"";
    if ([_exchange.currency isEqualToString:@"USD"]) {
        currencySimbol = @"$";
    } else if ([_exchange.currency isEqualToString:@"EUR"]) {
        currencySimbol = @"€";
    }
    self.totalLabel.stringValue = [NSString stringWithFormat:@"%@ BTC  (%@%.2f)", total, currencySimbol, _exchange.current * (amount / 100000000.0f)];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:_transaction.timestamp];
    self.dateLabel.stringValue = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
	
	int confirmations = _transaction.orgAddress.currentBlockHeight - _transaction.createdBlockHeight + 1;
	if (_transaction.createdBlockHeight == 0) {
		confirmations = 0;
	}
	self.confirmationsLabel.stringValue = [NSString stringWithFormat:@"(%i Confirmations)", confirmations];
	if (confirmations < CONFIRMATION_WARNING_MIN) {
		self.confirmationsLabel.textColor = [NSColor redColor];
	} else {
        self.confirmationsLabel.textColor = [NSColor grayColor];
    }
     */
	
}

#pragma mark - ExchangeListener
- (void)exchangeChanged:(Exchange *)exchange {
    _exchange = exchange;
    [self update];
}

@end
