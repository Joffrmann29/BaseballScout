//
//  PitcherScorecardController.h
//  GaTechScouting
//
//  Created by Joffrey Mann on 9/29/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PitcherScorecardController : UIViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate,UITextViewDelegate>

@property (nonatomic, strong) PFObject *pitcher;
@end
