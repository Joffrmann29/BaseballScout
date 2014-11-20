//
//  LayerViewObjects.h
//  GaTechScouting
//
//  Created by Joffrey Mann on 9/24/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LayerViewObjects : NSObject

+(CALayer*)createLabelLayer:(UILabel *)label;
+(CALayer *)createTableLayer:(UITableView *)tableView;
+(CALayer *)createTextLayer:(UITextView *)textView;

@end
