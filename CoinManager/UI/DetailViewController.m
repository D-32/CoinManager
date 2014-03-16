//
//  DetailViewController.m
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "DetailViewController.h"
#import "TransactionTableCellView.h"
#import "User.h"
#import "UserHelper.h"
#import "UserListener.h"
#import "Transaction.h"

@interface DetailViewController () <NSTableViewDataSource, NSTableViewDelegate, UserListener>
@property (weak) IBOutlet NSTableView* tableView;
@end

@implementation DetailViewController {
    User* _user;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [[UserHelper instance] addUserListener:self];
    return self;
}

- (void)awakeFromNib {
    CALayer* viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor:[NSColor colorWithWhite:0.98 alpha:1.0].CGColor];
    [self.view setWantsLayer:YES];
    //[self.view setLayer:viewLayer];
    
    [self.tableView setColumnAutoresizingStyle:NSTableViewUniformColumnAutoresizingStyle];
    //[tableColumn setResizingMask:NSTableColumnAutoresizingMask];
}

#pragma mark - TableView
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    TransactionTableCellView* cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    Transaction* transaction = [_user.transactions objectAtIndex:row];
    [cell setTransaction:transaction];
    return cell;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return MIN(_user.transactions.count, 25);
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 53;
}

#pragma mark - UserListener
- (void)userChanged:(User *)user {
    _user = user;
    [self.tableView reloadData];
}

@end
