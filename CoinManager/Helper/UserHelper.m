//
//  UserHelper.m
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "UserHelper.h"

#import "User.h"
#import "UserListener.h"
#import "UserDefaults.h"
#import "OAuthHelper.h"
#import "RequestHelper.h"
#import "NSString+MD5.h"
#import "Transaction.h"

@implementation UserHelper {
    BOOL _busy;
    User* _user;
    NSMutableArray* _listeners;
}

static UserHelper* sharedHelper;
static int DELAY = 60;

+ (void)initialize {
    [super initialize];
    sharedHelper = [[UserHelper alloc] init];
}

+ (UserHelper *)instance {
    return sharedHelper;
}

- (id)init {
    self = [super init];
    
    _listeners = [[NSMutableArray alloc] init];
    [self loadState];
	[self performSelector:@selector(update) withObject:nil afterDelay:1.0];
	
    return self;
}

- (void)refresh {
    [self update:NO];
}

- (void)update {
	[self update:YES];
}

- (void)update:(BOOL)cont {
    if (_busy) {
        return;
    }
    _busy = YES;
    OAuthHelper* oah = [[OAuthHelper alloc] init];
    [oah startRequest:@"https://coinbase.com/api/v1/transactions" completion:^(NSData* data){
        if (data != nil) {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSDictionary* user = [json objectForKey:@"current_user"];
            NSDictionary* balance = [json objectForKey:@"balance"];
            NSArray* jsonTransactions = [json objectForKey:@"transactions"];
            
            _user.userId = user[@"id"];
            _user.email = user[@"email"];
            NSString* balanceStr = balance[@"amount"];
            _user.balance = balanceStr.doubleValue;
            
            NSMutableArray* transactions = [[NSMutableArray alloc] init];
            for (NSDictionary* jsonTransactionContainer in jsonTransactions) {
                NSDictionary* jsonTransaction = jsonTransactionContainer[@"transaction"];
                Transaction* transaction = [[Transaction alloc] init];
                transaction.transactionId = jsonTransaction[@"id"];
                
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
                transaction.date = [dateFormatter dateFromString:jsonTransaction[@"created_at"]];
                
                transaction.amount = [jsonTransaction[@"amount"][@"amount"] doubleValue];
                
                NSDictionary* sender = jsonTransaction[@"sender"];
                if (sender != nil) {
                    transaction.sender = sender[@"email"];
                }
                
                NSDictionary* recipient = jsonTransaction[@"recipient"];
                if (recipient != nil) {
                    transaction.recipient = recipient[@"email"];
                } else {
                    transaction.recipient = jsonTransaction[@"recipient_address"];
                }
                
                transaction.status = jsonTransaction[@"status"];
                
                [transactions addObject:transaction];
            }
            _user.transactions = transactions;
            
            [self storeState];
            [self notifyListeners];
            
            if (_user.icon == nil) {
                [self loadUserIcon];
            }
            if (_user.address == nil) {
                [self loadUserAddress];
            }
        }
        
        if (cont) {
			[self performSelector:@selector(update) withObject:nil afterDelay:DELAY];
		}
        _busy = NO;
    }];
}

- (void)loadUserIcon {
    RequestHelper* rh = [[RequestHelper alloc] init];
    [rh startRequestWithUrl:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?d=retro", _user.email.md5] post:NO success:^(NSArray* array){
        NSData* data = array[0];
        _user.icon = data;
        [self storeState];
        [self notifyListeners];
    } error:^(NSError* error) {
    }];
}

- (void)loadUserAddress {
    OAuthHelper* oah = [[OAuthHelper alloc] init];
    [oah startRequest:@"https://coinbase.com/api/v1/account/receive_address" completion:^(NSData* data){
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        _user.address = [json objectForKey:@"address"];
        
        [self storeState];
        [self notifyListeners];
    }];
}

#pragma mark - Storage
- (void)storeState {
	[UserDefaults instance].user = _user;
}

- (void)loadState {
	//[UserDefaults instance].user = nil;
	_user = [UserDefaults instance].user;
    if (_user == nil) {
		_user = [[User alloc] init];
        [self storeState];
    }
}

#pragma mark - Listeners
- (void)addUserListener:(id<UserListener>)listener {
    [_listeners removeObject:listener];
    [_listeners addObject:listener];
	[listener userChanged:_user];
    NSLog(@"%lu user listener", _listeners.count);
}

- (void)removeUserListener:(id<UserListener>)listener {
    [_listeners removeObject:listener];
}

- (void)notifyListeners {
	for (id<UserListener> listener in _listeners) {
		[listener userChanged:_user];
	}
}

@end
