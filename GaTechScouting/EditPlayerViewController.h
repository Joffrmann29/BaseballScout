//
//  EditPlayerViewController.h
//  GaTechScouting
//
//  Created by Joffrey Mann on 10/2/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerTableViewCell.h"

@interface EditPlayerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) PlayerTableViewCell *pCell;

@end
