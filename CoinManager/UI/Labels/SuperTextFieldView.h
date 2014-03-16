//
//  SuperTextFieldView.h
//  CoinManager
//
//  Created by Dylan Marriott on 16/03/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol SuperTextFieldDelegate;

@interface SuperTextFieldView : NSTextField

@property (nonatomic, weak) id<SuperTextFieldDelegate> superDelegate;
@property (nonatomic, strong) NSString* prevString;
@property (nonatomic, assign) double value;

@end
