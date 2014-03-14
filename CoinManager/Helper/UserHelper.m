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

- (void)update {
	if (_busy) {
        return;
    }
	[self update:YES];
}

- (void)update:(BOOL)cont {
    OAuthHelper* oah = [[OAuthHelper alloc] init];
    [oah startRequest:@"https://coinbase.com/api/v1/users" completion:^(NSData* data){
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSDictionary* user = [[[json objectForKey:@"users"] objectAtIndex:0] objectForKey:@"user"];
        
        _user.email = user[@"email"];
        NSString* balanceStr = user[@"balance"][@"amount"];
        _user.balance = balanceStr.doubleValue;
        [self storeState];
        [self notifyListeners];
        
        if (_user.icon == nil) {
            [self loadUserIcon];
        }
        if (_user.address == nil) {
            [self loadUserAddress];
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
