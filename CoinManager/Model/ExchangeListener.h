//
//  ExchangeListener.h
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Exchange.h"

@protocol ExchangeListener <NSObject>

- (void)exchangeChanged:(Exchange *)exchange;

@end
