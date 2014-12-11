//
//  UIHandler.h
//  FitTabulous
//
//  Created by Joffrey Mann on 12/5/14.
//  Copyright (c) 2014 Nutech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CustomTextField.h"


@interface UIHandler : NSObject<UITextFieldDelegate>

+(CustomTextField *)returnTextFieldWithRect:(CGRect)rect withPlaceholder:(NSString *)placeholder;

@end
