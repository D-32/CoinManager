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

@interface MainViewController () <NSMenuDelegate, UserListener> {
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
    User* _user;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.autoresizingMask = NSViewHeightSizable | NSViewWidthSizable;
        [self.menu setDelegate:self];
        
        CALayer *viewLayer = [CALayer layer];
        [viewLayer setBackgroundColor:CGColorCreateGenericRGB(1.0, 1.0, 1.0, 1.0)]; //RGB plus Alpha Channel
        [self.topView setWantsLayer:YES]; // view's backing store is using a Core Animation Layer
        [self.topView setLayer:viewLayer];
        
        [[UserHelper instance] addUserListener:self];
    }
    return self;
}

#pragma mark - UserListener
- (void)userChanged:(User *)user {
    _user = user;
    self.userImage.image = [[NSImage alloc] initWithData:_user.icon];
    if (_user.address != nil) {
        self.addressLabel.stringValue = _user.address;
    }
    self.balanceLabel.stringValue = [NSString stringWithFormat:@"%.4f BTC  (0.00 USD)", _user.balance];
}

#pragma mark - Public

#pragma Mark - Menu
/*
- (IBAction)actionCopyAddress:(id)sender {
    NSInteger index = [self.tableView clickedRow];
    if (index >= 0) {
        Address* address = [_addresses objectAtIndex:index];
        [[NSPasteboard generalPasteboard] clearContents];
        [[NSPasteboard generalPasteboard] setString:address.address forType:NSStringPboardType];
    }
}

- (IBAction)actionDelete:(id)sender {
    NSInteger index = [self.tableView clickedRow];
    if (index >= 0) {
        [[AddressHelper instance] removeAddressAtIndex:(int)index];
    }
}
 */

#pragma mark - NSMenuDelegate
- (void)menuWillOpen:(NSMenu *)menu {
    NSInteger index = [self.tableView clickedRow];
    for (NSMenuItem* item in menu.itemArray) {
        [item setEnabled:(index >= 0)];
    }
}

@end
