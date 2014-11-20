//
//  Gradients.m
//  
//
//  Created by Joffrey Mann on 9/24/14.
//
//

#import "Gradients.h"

@implementation Gradients

-(CAGradientLayer *)redGradient
{
    CAGradientLayer *attrGradient = [CAGradientLayer layer];
    //attrGradient.frame = viewForGradient.bounds;
    attrGradient.colors = [NSArray arrayWithObjects:
                           (id)[[UIColor colorWithRed:195.0f / 255.0f green:29.0f / 255.0f blue:25.0f / 255.0f alpha:1.0f] CGColor],
                           (id)[[UIColor colorWithRed:98.0f / 255.0f green:15.0f / 255.0f blue:13.0f / 255.0f alpha:1.0f] CGColor],
                           nil];
    return attrGradient;
}

-(CAGradientLayer *)blueGradient
{
    CAGradientLayer *fieldGradient = [CAGradientLayer layer];
    //fieldGradient.frame = fieldingView.bounds;
    fieldGradient.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor colorWithRed:25.0f / 255.0f green:29.0f / 255.0f blue:195.0f / 255.0f alpha:1.0f] CGColor],
                            (id)[[UIColor colorWithRed:13.0f / 255.0f green:15.0f / 255.0f blue:96.0f / 255.0f alpha:1.0f] CGColor],
                            nil];
    return fieldGradient;
}

-(CAGradientLayer *)blackGradient
{
    CAGradientLayer *blackGradient = [CAGradientLayer layer];
    //btnGradient.frame = btn.bounds;
    blackGradient.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    //[btn.layer insertSublayer:btnGradient atIndex:0];
    return blackGradient;
}

-(CAGradientLayer *)accessoryGradient
{
    CAGradientLayer *glossLayer = [CAGradientLayer layer];
    //glossLayer.frame = btn.bounds;
    glossLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.0f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                         nil];
    glossLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    return glossLayer;
}
@end
