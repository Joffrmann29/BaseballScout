//
//  PlayerTableViewCell.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 9/9/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import "PlayerTableViewCell.h"

@implementation PlayerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
