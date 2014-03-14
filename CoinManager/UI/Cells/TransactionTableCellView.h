//
//  TransactionTableCellView.h
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Transaction;

@interface TransactionTableCellView : NSTableCellView

- (void)setTransaction:(Transaction *)transaction;

@end
