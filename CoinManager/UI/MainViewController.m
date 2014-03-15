//
//  MainViewController.m
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "MainViewController.h"
#import "RequestHelper.h"
#import "DetailViewController.h"
#import "OAuthHelper.h"
#import "NSString+MD5.h"
#import "User.h"
#import "UserListener.h"
#import "UserHelper.h"
#import "Exchange.h"
#import "ExchangeListener.h"
#import "ExchangeHelper.h"

@interface MainViewController () <NSMenuDelegate, ExchangeListener, UserListener> {
    NSMutableArray* _addresses;
}
@property (strong) IBOutlet DetailViewController* descriptionViewController;
@property (nonatomic, strong) IBOutlet NSTableView* tableView;
@property (nonatomic, strong) IBOutlet NSMenu* menu;
@property (weak) IBOutlet NSView* topView;
@property (weak) IBOutlet NSImageView* userImage;
@property (weak) IBOutlet NSTextField* addressLabel;
@property (weak) IBOutlet NSTextField *balanceLabel;

- (IBAction)actionCopyAddress:(id)sender;
- (IBAction)actionDelete:(id)sender;
@end

@implementation MainViewController {
    Exchange* _exchange;
    User* _user;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.autoresizingMask = NSViewHeightSizable | NSViewWidthSizable;
        [self.menu setDelegate:self];
        
        CALayer* viewLayer = [CALayer layer];
        [viewLayer setBackgroundColor:[NSColor whiteColor].CGColor];
        [viewLayer setShadowOffset:CGSizeMake(0, -2)];
        [viewLayer setShadowColor:[NSColor lightGrayColor].CGColor];
        [viewLayer setShadowRadius:2];
        [viewLayer setShadowOpacity:0.5];
        [self.topView setWantsLayer:YES];
        [self.topView setLayer:viewLayer];
        
        [[ExchangeHelper instance] addExchangeListener:self];
        [[UserHelper instance] addUserListener:self];
    }
    return self;
}

#pragma mark - ExchangeListener
- (void)exchangeChanged:(Exchange *)exchange {
    _exchange = exchange;
    [self updateBalance];
}

#pragma mark - UserListener
- (void)userChanged:(User *)user {
    _user = user;
    self.userImage.image = [[NSImage alloc] initWithData:_user.icon];
    if (_user.address != nil) {
        self.addressLabel.stringValue = _user.address;
    }
    [self updateBalance];
}

#pragma mark - Public

#pragma mark - Private
- (void)updateBalance {
    self.balanceLabel.stringValue = [NSString stringWithFormat:@"%.4f BTC  (%.2f USD)", _user.balance, _user.balance * _exchange.current];
}

#pragma mark - NSMenuDelegate
- (void)menuWillOpen:(NSMenu *)menu {
    NSInteger index = [self.tableView clickedRow];
    for (NSMenuItem* item in menu.itemArray) {
        [item setEnabled:(index >= 0)];
    }
}

@end
