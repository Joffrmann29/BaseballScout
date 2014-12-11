//
//  Game.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 12/10/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import "Game.h"

@implementation Game
static Game *singleInstance;

+(Game *)getSingleObject
{
    if(singleInstance == nil){
        singleInstance = [[super alloc]init];
    }
    return  singleInstance;
}
@end
