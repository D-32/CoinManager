//
//  OAuthHelper.h
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)();
typedef void (^CompletionBlockWithData)(NSData* data);

@interface OAuthHelper : NSObject

- (BOOL)needsAuth;
- (void)authorize:(NSString *)code completion:(CompletionBlock)completionBlock;
- (void)refreshWithCompletion:(CompletionBlock)completionBlock;
- (void)startRequest:(NSString *)url completion:(CompletionBlockWithData)completionBlock;
- (void)startRequest:(NSString *)url extraParms:(NSString *)parms postData:(NSString *)postData completion:(CompletionBlockWithData)completionBlock;

@end
