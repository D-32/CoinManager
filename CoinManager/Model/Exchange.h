//
//  ExchangeState.h
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exchange : NSObject <NSCoding>

@property (nonatomic) BOOL complete;
@property (nonatomic) NSString* currency;
@property (nonatomic) float current;
@property (nonatomic) NSData* image;

@end
