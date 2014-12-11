//
//  UIHandler.m
//  FitTabulous
//
//  Created by Joffrey Mann on 12/5/14.
//  Copyright (c) 2014 Nutech. All rights reserved.
//

#import "UIHandler.h"

@implementation UIHandler

+(CustomTextField *)returnTextFieldWithRect:(CGRect)rect withPlaceholder:(NSString *)placeholder
{
    CustomTextField *setField = [[CustomTextField alloc]initWithFrame:rect];
    setField.placeholder = placeholder;
    UIColor *textfieldPlaceholderColor = [UIColor whiteColor];
    [setField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    return setField;
}

@end
