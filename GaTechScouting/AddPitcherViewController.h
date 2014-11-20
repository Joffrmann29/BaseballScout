//
//  AddPitcherViewController.h
//  GaTechScouting
//
//  Created by Joffrey Mann on 9/25/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerTableViewCell.h"

@interface AddPitcherViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) PlayerTableViewCell *pCell;
@end
