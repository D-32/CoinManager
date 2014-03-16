//
//  SuperTextFieldView.m
//  CoinManager
//
//  Created by Dylan Marriott on 16/03/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "SuperTextFieldView.h"
#import "SuperTextFieldDelegate.h"

@implementation SuperTextFieldView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.prevString = self.stringValue;
    return self;
}

- (void)keyUp:(NSEvent *)theEvent {
    self.stringValue = [[self.stringValue componentsSeparatedByCharactersInSet:
                         [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]]
                        componentsJoinedByString:@""];
    self.value = self.stringValue.doubleValue;
    [self.superDelegate textField:self changedText:self.stringValue];
    self.prevString = self.stringValue;
}

@end
