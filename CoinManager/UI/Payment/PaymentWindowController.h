//
//  PaymentWindowController.h
//  CoinManager
//
//  Created by Dylan Marriott on 16/03/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Exchange.h"

@interface PaymentWindowController : NSWindowController

- (void)setExchange:(Exchange *)exchange;

@end
