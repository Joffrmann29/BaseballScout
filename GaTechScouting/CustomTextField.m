//
//  CustomTextField.m
//  FitTabulous
//
//  Created by Joffrey Mann on 12/5/14.
//  Copyright (c) 2014 Nutech. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupView];
    }
    
    return self;
}

-(void)setupView
{
    self.backgroundColor = [UIColor blackColor];
    
    self.delegate = self;
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    self.textColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
}

@end
