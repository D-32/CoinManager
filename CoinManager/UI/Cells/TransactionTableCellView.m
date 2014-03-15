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
    
    if (_transaction.amount < 0) {
        // out
        self.imageView.image = [NSImage imageNamed:@"Minus"];
        self.addressLabel.stringValue = [NSString stringWithFormat:@"To: %@", _transaction.recipient];
    } else {
        // in
        self.imageView.image = [NSImage imageNamed:@"Plus"];
        self.addressLabel.stringValue = [NSString stringWithFormat:@"From: %@", _transaction.sender];
    }

    self.totalLabel.stringValue = [NSString stringWithFormat:@"%.4f BTC  (%.2f %@)", _transaction.amount,_exchange.current * _transaction.amount, _exchange.currency];
    
    self.dateLabel.stringValue = [NSDateFormatter localizedStringFromDate:_transaction.date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
	
    if ([_transaction.status isEqualToString:@"pending"]) {
        self.confirmationsLabel.stringValue = @"Pending";
        self.confirmationsLabel.textColor = [NSColor orangeColor];
    } else if ([_transaction.status isEqualToString:@"complete"]) {
        self.confirmationsLabel.stringValue = @"Complete";
        self.confirmationsLabel.textColor = [NSColor grayColor];
    }
}

#pragma mark - ExchangeListener
- (void)exchangeChanged:(Exchange *)exchange {
    _exchange = exchange;
    [self update];
}

@end
