//
//  EditPitcherViewController.h
//  GaTechScouting
//
//  Created by Joffrey Mann on 11/22/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerTableViewCell.h"

@interface EditPitcherViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) PlayerTableViewCell *pCell;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) PFObject *pitcher;

@end
