//
//  User.m
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
        self.email = [decoder decodeObjectForKey:@"email"];
        self.icon = [decoder decodeObjectForKey:@"icon"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.balance = [decoder decodeDoubleForKey:@"balance"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.icon forKey:@"icon"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeDouble:self.balance forKey:@"balance"];
}


@end
