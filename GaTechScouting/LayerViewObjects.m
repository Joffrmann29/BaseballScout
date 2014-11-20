//
//  LayerViewObjects.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 9/24/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import "LayerViewObjects.h"

@implementation LayerViewObjects

+(CALayer*)createLabelLayer:(UILabel *)label
{
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 293, 320, 25)];
    CALayer *labelLayer = [label layer];
    [labelLayer setMasksToBounds:YES];
    [labelLayer setCornerRadius:5.0f];
    [labelLayer setBorderWidth:1.0f];
    [labelLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    return labelLayer;
}

+(CALayer *)createTableLayer:(UITableView *)tableView
{
    CALayer *tableLayer = [tableView layer];
    [tableLayer setMasksToBounds:YES];
    [tableLayer setCornerRadius:5.0f];
    [tableLayer setBorderWidth:1.0f];
    [tableLayer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    return tableLayer;
}

+(CALayer *)createTextLayer:(UITextView *)textView
{
    CALayer *textLayer = [textView layer];
    [textLayer setMasksToBounds:YES];
    [textLayer setCornerRadius:5.0f];
    [textLayer setBorderWidth:1.0f];
    [textLayer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    return textLayer;
}

@end
