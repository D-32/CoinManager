//
//  UserListener.h
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserListener <NSObject>

- (void)userChanged:(User *)user;

@end
