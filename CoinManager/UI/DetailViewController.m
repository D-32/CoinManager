//
//  DetailViewController.m
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "DetailViewController.h"
#import "TransactionTableCellView.h"

@interface DetailViewController () <NSTableViewDataSource, NSTableViewDelegate> {
}
@property (weak) IBOutlet NSTextFieldCell* titleLabel;
@property (weak) IBOutlet NSTextField* addressLabel;
@property (weak) IBOutlet NSTableView* tableView;
@end

@implementation DetailViewController

#pragma mark - TableView
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    TransactionTableCellView* cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    //Transaction* transaction = [_address.transactions objectAtIndex:row];
    //[cell setTransaction:transaction];
    return cell;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 0;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 53;
}

@end
