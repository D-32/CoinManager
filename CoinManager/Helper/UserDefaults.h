//
//  UserDefaults.h
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Exchange;
@class User;

@interface UserDefaults : NSObject

@property (nonatomic) Exchange* exchange;
@property (nonatomic) User* user;
@property (nonatomic) NSString* accessToken;
@property (nonatomic) NSString* refreshToken;

+ (UserDefaults *)instance;

@end
