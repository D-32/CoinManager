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

- (void)startRequestWithUrl:(NSString *)url post:(BOOL)post success:(SuccessBlock)successBlock error:(ErrorBlock)errorBlock;
- (void)startRequestWithUrls:(NSArray *)urls post:(BOOL)post success:(SuccessBlock)successBlock error:(ErrorBlock)errorBlock;

@end
