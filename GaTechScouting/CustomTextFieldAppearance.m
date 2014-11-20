//
//  CustomTextFieldAppearance.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 9/24/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import "CustomTextFieldAppearance.h"

@implementation CustomTextFieldAppearance

-(UITextField *)changeTextFieldAppearance
{
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 260, 30)];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.keyboardAppearance = UIKeyboardAppearanceAlert;
    
    return textField;
}

@end
