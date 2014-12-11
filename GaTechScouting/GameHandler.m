//
//  GameHandler.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 12/10/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import "GameHandler.h"

@implementation GameHandler

-(void)postGame:(Game *)game
{
    game = [Game getSingleObject];
    PFObject *gameObject = [PFObject objectWithClassName:@"Game"];
    [gameObject setObject:game.city forKey:@"City"];
    [gameObject setObject:game.state forKey:@"State"];
    [gameObject setObject:game.gameDate forKey:@"GameDate"];
    [gameObject setObject:game.opponent forKey:@"Opponent"];
    [gameObject setObject:game.stadium forKey:@"Stadium"];
    [gameObject setObject:game.username forKey:@"Username"];
    
    [gameObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded)
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Your game has been successfully added." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
            [self.delegate gameSegue];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

@end
