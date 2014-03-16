//
//  AppDelegate.m
//  CoinManager
//
//  Created by Dylan Marriott on 14.03.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import <WebKit/WebKit.h>
#import "OAuthHelper.h"

@interface  AppDelegate()

@property (weak) IBOutlet NSToolbarItem *payItem;
@property (weak) IBOutlet NSToolbarItem *donateItem;
- (IBAction)actionToolbarAdd:(id)sender;
- (IBAction)actionToolbarContacts:(id)sender;
- (IBAction)actionToolbarGenerate:(id)sender;
- (IBAction)actionToolbarPay:(id)sender;
- (IBAction)actionToolbarDonate:(id)sender;
- (IBAction)actionToolbarExchange:(id)sender;
@property (nonatomic, strong) MainViewController* mainViewController;
@end

@implementation AppDelegate {
    WebView* _webview;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[self.window windowController] setShouldCascadeWindows:NO];
    [self.window setFrameUsingName:@"CoinManagerWindow"];
    [self.window makeKeyAndOrderFront:nil];
    
    _webview = [[WebView alloc] initWithFrame:((NSView *)self.window.contentView).bounds];
    _webview.frameLoadDelegate = self;
    [self.window.contentView addSubview:_webview];
	
    OAuthHelper* oah = [[OAuthHelper alloc] init];
    if ([oah needsAuth]) {
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://coinbase.com/oauth/authorize/?client_id=baf65d2585886be2041b1ea7df553d393b53cbe0a91e8ccf01b6001990e853fc&response_type=code&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob"]];
        [_webview.mainFrame loadRequest:request];
    } else {
        [self showMainView];
    }
}

- (void)webView:(WebView *)webView didFinishLoadForFrame:(WebFrame *)webFrame {
    NSString* currentURL = [[[[webFrame dataSource] request] URL] absoluteString];
    if ([currentURL hasPrefix:@"https://coinbase.com/oauth/authorize/"] && ![currentURL hasPrefix:@"https://coinbase.com/oauth/authorize/?"]) {
		NSString* authCode = [currentURL substringFromIndex:37];
		OAuthHelper* oah = [[OAuthHelper alloc] init];
		[oah authorize:authCode completion:^() {
            [self showMainView];
		}];
    }
}

- (void)webView:(WebView *)sender resource:(id)identifier didFailLoadingWithError:(NSError *)error fromDataSource:(WebDataSource *)dataSource {
    [self showMainView];
}

- (void)showMainView {
    [_webview removeFromSuperview];
    self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    [self.window.contentView addSubview:self.mainViewController.view];
    self.mainViewController.view.frame = ((NSView *)self.window.contentView).bounds;
}

-(BOOL)validateToolbarItem:(NSToolbarItem *)toolbarItem {
    return [toolbarItem isEnabled] ;
}

@end
