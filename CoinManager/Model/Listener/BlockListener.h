//
//  BlockListener.h
//  CoinManager
//
//  Created by Dylan Marriott on 16/03/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BlockListener <NSObject>

- (void)blockChanged:(BOOL)block;

@end
