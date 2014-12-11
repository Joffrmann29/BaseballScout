//
//  Game.h
//  GaTechScouting
//
//  Created by Joffrey Mann on 12/10/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSDate *gameDate;
@property (nonatomic, strong) NSString *opponent;
@property (nonatomic, strong) NSString *stadium;
@property (nonatomic, strong) NSString *username;

+(Game *)getSingleObject;
@end
