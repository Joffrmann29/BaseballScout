//
//  GeneralUI.h
//  GaTechScouting
//
//  Created by Joffrey Mann on 9/24/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralUI : NSObject

+(UILabel *)drawPositionLabel;
+(UILabel *)drawThrowingLabel;
+(UILabel *)drawBattingLabel;
+(UILabel *)drawHeightLabel;
+(UISegmentedControl *)drawPositionSegmentedControl;
+(UISegmentedControl *)drawBatSegmentedControl;
+(UISegmentedControl *)drawThrowSegmentedControl;

@end
