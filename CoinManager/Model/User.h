//
//  User.h
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSData* icon;
@property (nonatomic, strong) NSString* address;
@property (nonatomic, assign) double balance;

@end
