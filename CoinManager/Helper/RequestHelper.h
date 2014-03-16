//
//  RequestHelper.h
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(NSArray *);
typedef void (^ErrorBlock)(NSError *);

@interface RequestHelper : NSObject

// TODO do extra get / post methods
- (void)startRequestWithUrl:(NSString *)url post:(BOOL)post postData:(NSString *)postData success:(SuccessBlock)successBlock error:(ErrorBlock)errorBlock;
- (void)startRequestWithUrls:(NSArray *)urls post:(BOOL)post postData:(NSString *)postData success:(SuccessBlock)successBlock error:(ErrorBlock)errorBlock;

@end
