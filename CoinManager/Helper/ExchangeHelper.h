//
//  ExchangeHelper.h
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ExchangeListener;

@interface ExchangeHelper : NSObject

+ (ExchangeHelper *)instance;

- (void)refresh;
- (void)changeCurreny:(NSString *)currency;
- (void)addExchangeListener:(id<ExchangeListener>)listener;
- (void)removeExchangeListener:(id<ExchangeListener>)listener;

@end
