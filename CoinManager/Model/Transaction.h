//
//  Transaction.h
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject <NSCoding>

@property (nonatomic, strong) NSString* sender;
@property (nonatomic, strong) NSArray* receiver; // with Receiver (ex. sender addr)
@property (nonatomic, assign) double timestamp;
@property (nonatomic, assign) int createdBlockHeight;

@end
