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
#import "KBButton.h"
#import "KBButtonCell.h"
#import <Quartz/Quartz.h>
#import <WebKit/WebKit.h>
#import "PaymentController.h"
#import "PaymentWindowController.h"

@interface MainViewController () <NSMenuDelegate, ExchangeListener, UserListener> {
    NSMutableArray* _addresses;
}
@property (strong) IBOutlet DetailViewController* descriptionViewController;
@property (nonatomic, strong) IBOutlet NSTableView* tableView;
@property (nonatomic, strong) IBOutlet NSMenu* menu;
@property (weak) IBOutlet NSView* topView;
@property (weak) IBOutlet NSView* bottomView;
@property (weak) IBOutlet NSImageView* userImage;
@property (weak) IBOutlet NSTextField* addressLabel;
@property (weak) IBOutlet NSTextField* balanceLabel;
@property (weak) IBOutlet KBButton* payButton;
@property (weak) IBOutlet KBButton *refreshButton;
@property (weak) IBOutlet WebView* webView;

- (IBAction)actionCopyAddress:(id)sender;
- (IBAction)actionDelete:(id)sender;
@end

@implementation MainViewController {
    Exchange* _exchange;
    User* _user;
    
    NSImage* _refreshImage;
    NSProgressIndicator* _refreshIndicator;
    PaymentWindowController* _paymentWindowController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.autoresizingMask = NSViewHeightSizable | NSViewWidthSizable;
        [self.menu setDelegate:self];
        
        CALayer* topLayer = [CALayer layer];
        [topLayer setBackgroundColor:[NSColor whiteColor].CGColor];
        [topLayer setShadowOffset:CGSizeMake(0, -2)];
        [topLayer setShadowColor:[NSColor lightGrayColor].CGColor];
        [topLayer setShadowRadius:2];
        [topLayer setShadowOpacity:0.5];
        [self.topView setWantsLayer:YES];
        [self.topView setLayer:topLayer];
        
        
        CALayer* bottomLayer = [CALayer layer];
        [bottomLayer setBackgroundColor:[NSColor whiteColor].CGColor];
        [bottomLayer setShadowOffset:CGSizeMake(0, 2)];
        [bottomLayer setShadowColor:[NSColor lightGrayColor].CGColor];
        [bottomLayer setShadowRadius:2];
        [bottomLayer setShadowOpacity:0.5];
        [self.bottomView setWantsLayer:YES];
        [self.bottomView setLayer:bottomLayer];
        
        [[[self.webView mainFrame] frameView] setAllowsScrolling:NO];
        
        _refreshImage = self.refreshButton.image;
        _refreshIndicator = [[NSProgressIndicator alloc] initWithFrame:CGRectMake(13, 7, 16, 16)];
        [_refreshIndicator setStyle:NSProgressIndicatorSpinningStyle];
        [_refreshIndicator setControlSize:NSSmallControlSize];
        
        [self.payButton setKBButtonType:BButtonTypePrimary];
        [self.payButton setTarget:self];
        [self.payButton setAction:@selector(actionPay:)];
        [self.refreshButton setKBButtonType:BButtonTypeDefault];
        [self.refreshButton setTarget:self];
        [self.refreshButton setAction:@selector(actionRefresh:)];
        
        [[ExchangeHelper instance] addExchangeListener:self];
        [[UserHelper instance] addUserListener:self];
    }
    return self;
}

- (void)actionRefresh:(id)sender {
    [self setRefreshProgress:YES];
    [[UserHelper instance] refresh];
    
}

- (void)actionPay:(id)sender {
    /*
    PaymentController* paymentController = [[PaymentController alloc] init];
    [paymentController startPaymentWithWindow:self.view.window completionHandler:^() {
        self.payButton.enabled = YES;
    }];
     */
    
    _paymentWindowController = [[PaymentWindowController alloc] initWithWindowNibName:@"PaymentWindowController"];
    [_paymentWindowController.window setFrame:CGRectMake(self.view.window.frame.origin.x + 50,  self.view.window.frame.origin.y + self.view.window.frame.size.height - 300, 350, 250) display:YES];
    [_paymentWindowController setExchange:_exchange];
    [_paymentWindowController.window makeKeyAndOrderFront:sender];
}

#pragma mark - ExchangeListener
- (void)exchangeChanged:(Exchange *)exchange {
    _exchange = exchange;
    [self updateBalance];
}

#pragma mark - UserListener
- (void)userChanged:(User *)user {
    [self setRefreshProgress:NO];
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
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://46.105.26.1/coinmanager/test.html"]];
    [self.webView.mainFrame loadRequest:request];
}

- (void)setRefreshProgress:(BOOL)inProgress {
    if (inProgress) {
        self.refreshButton.enabled = NO;
        [self.refreshButton addSubview:_refreshIndicator];
        [_refreshIndicator startAnimation:self];
        self.refreshButton.image = nil;
    } else {
        self.refreshButton.enabled = YES;
        [_refreshIndicator stopAnimation:self];
        [_refreshIndicator removeFromSuperview];
        self.refreshButton.image = _refreshImage;
    }
}

#pragma mark - NSMenuDelegate
- (void)menuWillOpen:(NSMenu *)menu {
    NSInteger index = [self.tableView clickedRow];
    for (NSMenuItem* item in menu.itemArray) {
        [item setEnabled:(index >= 0)];
    }
}

@end
