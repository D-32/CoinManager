//
//  ExchangeState.m
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "Exchange.h"

@implementation Exchange

- (id)init {
	if (self = [super init]) {
		self.complete = NO;
		self.currency = @"USD";
		self.current = -1;
		self.image = nil;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		self.complete = [decoder decodeBoolForKey:@"complete"];
		self.currency = [decoder decodeObjectForKey:@"currency"];
		self.current = [decoder decodeFloatForKey:@"current"];
		self.image = [decoder decodeObjectForKey:@"image"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeBool:self.complete forKey:@"complete"];
	[encoder encodeObject:self.currency forKey:@"currency"];
	[encoder encodeFloat:self.current forKey:@"current"];
	[encoder encodeObject:self.image forKey:@"image"];
}

@end
