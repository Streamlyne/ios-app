//
//  UITextField+PlaceholderColor.m
//  Streamlyne
//
//  Created by Glavin Wiechert on 2014-08-21.
//  Copyright (c) 2014 Streamlyne Technologies. All rights reserved.
//

#import "UITextField+PlaceholderColor.h"

@implementation UITextField (PlaceholderColor)

- (BOOL) setPlaceholderColor:(UIColor *)color
{
    
    if ([self respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[self placeholder] attributes:@{NSForegroundColorAttributeName: color}];
        return true;
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
        return false;
    }
}

@end
