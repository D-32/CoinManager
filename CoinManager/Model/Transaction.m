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
        self.sender = [decoder decodeObjectForKey:@"sender"];
        self.receiver = [decoder decodeObjectForKey:@"receiver"];
        self.timestamp = [decoder decodeDoubleForKey:@"timestamp"];
        self.createdBlockHeight = [decoder decodeIntForKey:@"createdBlockHeight"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.sender forKey:@"sender"];
    [encoder encodeObject:self.receiver forKey:@"receiver"];
    [encoder encodeDouble:self.timestamp forKey:@"timestamp"];
    [encoder encodeInt:self.createdBlockHeight forKey:@"createdBlockHeight"];
}

@end
