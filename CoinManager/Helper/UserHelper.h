//
//  UserHelper.h
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@protocol UserListener;

@interface UserHelper : NSObject

+ (UserHelper *)instance;

- (void)refresh;
- (void)addUserListener:(id<UserListener>)listener;
- (void)removeUserListener:(id<UserListener>)listener;

@end
