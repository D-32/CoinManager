//
//  RequestHelper.m
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "RequestHelper.h"

static RequestHelper* instance;

@interface RequestHelper () <NSURLConnectionDataDelegate>

@end

@implementation RequestHelper {
    SuccessBlock _successBlock;
    ErrorBlock _errorBlock;
    NSMutableData* _currentData;
	NSMutableArray* _queue;
	NSMutableArray* _data;
	BOOL _post;
}

- (void)startRequestWithUrl:(NSString *)url post:(BOOL)post success:(SuccessBlock)successBlock error:(ErrorBlock)errorBlock {
    _successBlock = successBlock;
    _errorBlock = errorBlock;
	
	_queue = [[NSMutableArray alloc] initWithObjects:url, nil];
	_post = post;
	[self start];
}

- (void)startRequestWithUrls:(NSArray *)urls post:(BOOL)post success:(SuccessBlock)successBlock error:(ErrorBlock)errorBlock {
	_successBlock = successBlock;
    _errorBlock = errorBlock;
	
	_queue = [[NSMutableArray alloc] initWithArray:urls];
	_post = post;
	[self start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [_currentData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_currentData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[self finishedRequest];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	_errorBlock(error);
}

- (void)start {
	if (_data == nil) {
		_data = [[NSMutableArray alloc] init];
	}
	
	NSString* url = [_queue firstObject];
	[_queue removeObjectAtIndex:0];
	
	NSLog(@"RequestHelper: %@", url);
	
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
	if (_post) {
		[request setHTTPMethod:@"POST"];
	}
    _currentData = [NSMutableData dataWithCapacity: 0];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (!connection) {
        _currentData = nil;
		_errorBlock(nil);
    }
}

- (void)finishedRequest {
	[_data addObject:_currentData];
	_currentData = nil;
	if (_queue.count == 0) {
		_successBlock(_data);
	} else {
		[self start];
	}
}

@end
