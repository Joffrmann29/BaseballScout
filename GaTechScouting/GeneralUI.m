//
//  GeneralUI.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 9/24/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import "GeneralUI.h"

@implementation GeneralUI

+(UILabel *)drawPositionLabel
{
    UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 293, 320, 25)];
    positionLabel.backgroundColor = [UIColor clearColor];
    positionLabel.textAlignment = NSTextAlignmentCenter;
    positionLabel.textColor = [UIColor whiteColor];
    positionLabel.text = @"Player Position";
    return positionLabel;
}

+(UILabel *)drawThrowingLabel
{
    UILabel *throwLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 363, 320, 25)];
    throwLabel.backgroundColor = [UIColor clearColor];
    throwLabel.textAlignment = NSTextAlignmentCenter;
    throwLabel.textColor = [UIColor whiteColor];
    throwLabel.text = @"Throws";
    return throwLabel;
}

+(UILabel *)drawBattingLabel
{
    UILabel *batLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 433, 320, 25)];
    batLabel.backgroundColor = [UIColor clearColor];
    batLabel.textAlignment = NSTextAlignmentCenter;
    batLabel.textColor = [UIColor whiteColor];
    batLabel.text = @"Bats";
    return batLabel;
}

+(UILabel *)drawHeightLabel
{
    UILabel *heightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 503, 320, 25)];
    heightLabel.backgroundColor = [UIColor clearColor];
    heightLabel.textAlignment = NSTextAlignmentCenter;
    heightLabel.textColor = [UIColor whiteColor];
    heightLabel.text = @"Select Height";
    return heightLabel;
}

+(UISegmentedControl *)drawPositionSegmentedControl
{
    UISegmentedControl *positionSegControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"P", @"C", @"1B", @"2B", @"SS",@"3B", @"RF", @"CF", @"LF", nil]];

    positionSegControl.frame = CGRectMake(30, 328, 260, 29);
    [positionSegControl setTintColor:[UIColor whiteColor]];
    return positionSegControl;
}

+(UISegmentedControl *)drawBatSegmentedControl
{
    UISegmentedControl *batSegControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"R", @"L", @"S", nil]];
    
    batSegControl.frame = CGRectMake(30, 468, 260, 29);
    [batSegControl setTintColor:[UIColor whiteColor]];
    return batSegControl;
}

+(UISegmentedControl *)drawThrowSegmentedControl
{
    UISegmentedControl *throwSegControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"R", @"L", nil]];
    
    throwSegControl.frame = CGRectMake(30, 398, 260, 29);
    [throwSegControl setTintColor:[UIColor whiteColor]];
    return throwSegControl;
}

@end
