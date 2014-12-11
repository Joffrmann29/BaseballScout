//
//  PlayerScorecardController.h
//  GaTechScouting
//
//  Created by Joffrey Mann on 9/17/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerScorecardController : UIViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (nonatomic, strong) PFObject *player;
@property (strong, nonatomic) PFUser *matchedUser;
@end
