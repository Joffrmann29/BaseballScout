//
//  GameTableViewController.h
//  GaTechScouting
//
//  Created by Joffrey Mann on 12/10/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameTableViewController : UIViewController

@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) PFObject *player;

@end
