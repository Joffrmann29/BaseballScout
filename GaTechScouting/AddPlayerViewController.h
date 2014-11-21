//
//  AddPlayerViewController.h
//  GaTechScouting
//
//  Created by Joffrey Mann on 9/9/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerTableViewCell.h"

@interface AddPlayerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) PlayerTableViewCell *pCell;

@property (strong, nonatomic) PFObject *player;

@end
