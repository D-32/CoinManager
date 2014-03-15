//
//  Transaction.m
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
        self.transactionId = [decoder decodeObjectForKey:@"transactionId"];
        self.date = [decoder decodeObjectForKey:@"date"];
        self.amount = [decoder decodeDoubleForKey:@"amount"];
        self.sender = [decoder decodeObjectForKey:@"sender"];
        self.recipient = [decoder decodeObjectForKey:@"recipient"];
        self.status = [decoder decodeObjectForKey:@"status"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.transactionId forKey:@"transactionId"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeDouble:self.amount forKey:@"amount"];
    [encoder encodeObject:self.sender forKey:@"sender"];
    [encoder encodeObject:self.recipient forKey:@"recipient"];
    [encoder encodeObject:self.status forKey:@"status"];
}

@end
