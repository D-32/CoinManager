//
//  PaymentController.h
//  CoinManager
//
//  Created by Dylan Marriott on 16/03/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)();

@interface PaymentController : NSObject

- (void)startPaymentWithWindow:(NSWindow *)window completionHandler:(CompletionBlock)completionHandler;

@end
