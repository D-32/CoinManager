//
//  OAuthHelper.m
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "OAuthHelper.h"
#import "UserDefaults.h"
#import "RequestHelper.h"

@implementation OAuthHelper

- (BOOL)needsAuth {
	UserDefaults* userDefaults = [UserDefaults instance];
	return userDefaults.accessToken == nil;
}

- (void)authorize:(NSString *)code completion:(CompletionBlock)completionBlock {
	RequestHelper* rh = [[RequestHelper alloc] init];
	[rh startRequestWithUrl:[NSString stringWithFormat:@"https://coinbase.com/oauth/token?grant_type=authorization_code&code=%@&redirect_uri=urn:ietf:wg:oauth:2.0:oob&client_id=baf65d2585886be2041b1ea7df553d393b53cbe0a91e8ccf01b6001990e853fc&client_secret=c0a9d5807e8b526d06feef12f16c6e890aed737cb0add5d05bee26bc6fc87d5c", code] post:YES success:^(NSArray* result) {
		NSData* data = result[0];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        UserDefaults* userDefaults = [UserDefaults instance];
        userDefaults.accessToken = [json objectForKey:@"access_token"];
        userDefaults.refreshToken = [json objectForKey:@"refresh_token"];
		completionBlock();
	} error:^(NSError* error) {
		NSLog(@"%@", error.localizedDescription);
        completionBlock();
	}];
    
}

- (void)refreshWithCompletion:(CompletionBlock)completionBlock {
	RequestHelper* rh = [[RequestHelper alloc] init];
	[rh startRequestWithUrl:[NSString stringWithFormat:@"https://coinbase.com/oauth/token?grant_type=refresh_token&refresh_token=%@&redirect_uri=urn:ietf:wg:oauth:2.0:oob&client_id=baf65d2585886be2041b1ea7df553d393b53cbe0a91e8ccf01b6001990e853fc&client_secret=c0a9d5807e8b526d06feef12f16c6e890aed737cb0add5d05bee26bc6fc87d5c", [UserDefaults instance].refreshToken] post:YES success:^(NSArray* result) {
		NSData* data = result[0];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        UserDefaults* userDefaults = [UserDefaults instance];
        userDefaults.accessToken = [json objectForKey:@"access_token"];
        userDefaults.refreshToken = [json objectForKey:@"refresh_token"];
		completionBlock();
	} error:^(NSError* error) {
		NSLog(@"%@", error.localizedDescription);
        completionBlock();
	}];
}

- (void)startRequest:(NSString *)url completion:(CompletionBlockWithData)completionBlock {
    RequestHelper* rh = [[RequestHelper alloc] init];
    [rh startRequestWithUrl:[NSString stringWithFormat:@"%@?access_token=%@", url, [UserDefaults instance].accessToken] post:NO success:^(NSArray* result){
        NSData* data = result[0];
        if (data.length == 1) {
            [self refreshWithCompletion:^(){
                [self startRequest:url completion:completionBlock];
            }];
        } else {
            completionBlock(data);
        }
    } error:^(NSError* error){
        completionBlock(nil);
    }];
}

@end
