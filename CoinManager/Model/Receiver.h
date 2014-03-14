//
//  Receiver.h
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Receiver : NSObject <NSCoding>

@property (nonatomic, strong) NSString* address;
@property (nonatomic, assign) long amount;

@end
