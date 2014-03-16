//
//  SuperTextFieldDelegate.h
//  CoinManager
//
//  Created by Dylan Marriott on 16/03/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperTextFieldView.h"

@protocol SuperTextFieldDelegate <NSObject>

- (void)textField:(SuperTextFieldView *)textField changedText:(NSString *)text;

@end
