//
//  ExchangeHelper.m
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "ExchangeHelper.h"
#import "Exchange.h"
#import "UserDefaults.h"
#import "ExchangeListener.h"
#import "RequestHelper.h"

@implementation ExchangeHelper {
    BOOL _busy;
	NSMutableArray* _listeners;
    Exchange* _exchange;
}

static ExchangeHelper* sharedHelper;
static int DELAY = 60;

+ (void)initialize {
    [super initialize];
    sharedHelper = [[ExchangeHelper alloc] init];
}

+ (ExchangeHelper *)instance {
    return sharedHelper;
}

- (id)init {
    self = [super init];
    
    _busy = NO;
    _listeners = [[NSMutableArray alloc] init];
    [self loadState];
	[self performSelector:@selector(update) withObject:nil afterDelay:1.0];
	
    return self;
}

#pragma mark - Public
- (void)changeCurreny:(NSString *)currency {
    _exchange.currency = currency;
    _exchange.complete = NO;
    [self storeState];

	[self update:NO];
}

- (void)refresh {
    [self update:NO];
}

#pragma mark - Private
- (NSString *)stockUrl {
    return [NSString stringWithFormat:@"http://46.105.26.1/coinmanager/api/get_market_data.php?c=%@", _exchange.currency];
}

- (void)update {
	[self update:YES];
}

- (void)update:(BOOL)cont {
    if (_busy) {
        return;
    }
    _busy = YES;
	RequestHelper* requestHelper = [[RequestHelper alloc] init];
	[requestHelper startRequestWithUrl:[self stockUrl] post:NO postData:nil success:^(NSArray* data){
		[self parseResponse:[data objectAtIndex:0]];
		
		_exchange.complete = YES;
		[self storeState];
		[self notifyListeners];
		if (cont) {
			[self performSelector:@selector(update) withObject:nil afterDelay:DELAY];
		}
		_busy = NO;
	} error:^(NSError* error) {
		if (cont) {
			[self performSelector:@selector(update) withObject:nil afterDelay:DELAY];
		}
        _busy = NO;
	}];
}

- (void)parseResponse:(NSData *)data {
    NSString* response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (response.floatValue > 0) {
        _exchange.current = response.floatValue;
    }
}

#pragma mark - Storage
- (void)storeState {
	[UserDefaults instance].exchange = _exchange;
}

- (void)loadState {
	//[UserDefaults instance].exchangeState = nil;
	_exchange = [UserDefaults instance].exchange;
    if (_exchange == nil) {
		_exchange = [[Exchange alloc] init];
        [self storeState];
    }
}

#pragma mark - Listeners
- (void)addExchangeListener:(id<ExchangeListener>)listener {
    [_listeners removeObject:listener];
    [_listeners addObject:listener];
	[listener exchangeChanged:_exchange];
    NSLog(@"%lu exchange listener", _listeners.count);
}

- (void)removeExchangeListener:(id<ExchangeListener>)listener {
    [_listeners removeObject:listener];
}

- (void)notifyListeners {
	for (id<ExchangeListener> listener in _listeners) {
		[listener exchangeChanged:_exchange];
	}
}

@end
