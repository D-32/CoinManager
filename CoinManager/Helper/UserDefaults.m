//
//  UserDefaults.m
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "UserDefaults.h"
#import "Exchange.h"
#import "User.h"

@implementation UserDefaults {
    NSUserDefaults* _defaults;
}

static UserDefaults* sharedInstance;

+ (void)initialize {
    [super initialize];
    sharedInstance = [[UserDefaults alloc] init];
}

+ (UserDefaults *)instance {
    return sharedInstance;
}

- (id)init {
	self = [super init];
	_defaults = [NSUserDefaults standardUserDefaults];
	return self;
}

#pragma mark - Public

// Exchange
- (Exchange *)exchange {
	return (Exchange *)[self codableObjectForKey:@"exchange"];
}

- (void)setExchange:(Exchange *)exchange {
	[self setCodableObject:exchange forKey:@"exchange"];
}

// User
- (User *)user {
	return (User *)[self codableObjectForKey:@"user"];
}

- (void)setUser:(User *)user {
	[self setCodableObject:user forKey:@"user"];
}

- (NSString *)accessToken {
	return [_defaults objectForKey:@"accessToken"];
}

- (void)setAccessToken:(NSString *)accessToken {
	[_defaults setObject:accessToken forKey:@"accessToken"];
	[_defaults synchronize];
}

- (NSString *)refreshToken {
	return [_defaults objectForKey:@"refreshToken"];
}

- (void)setRefreshToken:(NSString *)refreshToken {
	[_defaults setObject:refreshToken forKey:@"refreshToken"];
	[_defaults synchronize];
}

#pragma mark - Private
- (void)setCodableObject:(id<NSCoding>)object forKey:(NSString *)key {
	NSData* encoded = [NSKeyedArchiver archivedDataWithRootObject:object];
	[_defaults setObject:encoded forKey:key];
	[_defaults synchronize];
}

- (id<NSCoding>)codableObjectForKey:(NSString *)key {
	NSData* encoded = [_defaults objectForKey:key];
	id<NSCoding> ret = [NSKeyedUnarchiver unarchiveObjectWithData:encoded];
	return ret;
}

@end
