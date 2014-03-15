//
//  Transaction.h
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject <NSCoding>

@property (nonatomic, strong) NSString* transactionId;
@property (nonatomic, strong) NSDate* date;
@property (nonatomic, assign) double amount;
@property (nonatomic, strong) NSString* sender;
@property (nonatomic, strong) NSString* recipient;
@property (nonatomic, strong) NSString* status;

@end
