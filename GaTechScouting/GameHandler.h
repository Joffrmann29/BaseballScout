//
//  GameHandler.h
//  GaTechScouting
//
//  Created by Joffrey Mann on 12/10/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"

@protocol GameHandlerDelegate <NSObject>

-(void)gameSegue;

@end

@interface GameHandler : NSObject

-(void)postGame:(Game *)game;
@property (weak, nonatomic) id <GameHandlerDelegate> delegate;
@end
