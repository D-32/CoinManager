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
#import "PopoverTextField.h"
#import "StringUtil.h"

@interface TransactionTableCellView () <ExchangeListener>
@property (nonatomic, weak) IBOutlet NSImageView* imageView;
@property (nonatomic, weak) IBOutlet PopoverTextField* totalLabel;
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
    } else {
        // in
        self.imageView.image = [NSImage imageNamed:@"Plus"];
    }

    self.totalLabel.stringValue = [NSString stringWithFormat:@"%.4f BTC", _transaction.amount];
    self.totalLabel.popoverText = [NSString stringWithFormat:@"%.2f USD", _transaction.amount * _exchange.current];
    if (_transaction.amount < 0) {
        self.totalLabel.textColor = [NSColor colorWithRed:0.77 green:0.00 blue:0.02 alpha:1.00];
    } else if (_transaction.amount > 0) {
        self.totalLabel.textColor = [NSColor colorWithRed:0.13 green:0.54 blue:0.03 alpha:1.00];
    }
    CGFloat width = [StringUtil widthOfString:self.totalLabel.stringValue withFont:self.totalLabel.font];
    self.totalLabel.frame = CGRectMake(self.totalLabel.frame.origin.x + (self.totalLabel.frame.size.width - (width + 10)), self.totalLabel.frame.origin.y, width + 10, self.totalLabel.frame.size.height);
    
    CGContextSetShouldSmoothFonts([[NSGraphicsContext currentContext] graphicsPort], false);
    
    
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
