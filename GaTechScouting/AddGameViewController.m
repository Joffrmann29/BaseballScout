//
//  AddGameViewController.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 12/10/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import "AddGameViewController.h"
#import "CustomTextField.h"
#import "UIHandler.h"
#import "GameHandler.h"
#import "GameTableViewController.h"

@interface AddGameViewController ()<UITextFieldDelegate,GameHandlerDelegate>
@property (nonatomic, strong) CustomTextField *cityField;
@property (nonatomic, strong) CustomTextField *stateField;
@property (nonatomic, strong) CustomTextField *opponentField;
@property (nonatomic, strong) CustomTextField *stadiumField;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation AddGameViewController

- (void)viewDidLoad {
    
    CGRect cityRect = CGRectMake(76, 94, 168, 30);
    CGRect stateRect = CGRectMake(76, 154, 168, 30);
    CGRect opponentRect = CGRectMake(76, 214, 168, 30);
    CGRect stadiumRect = CGRectMake(76, 274, 168, 30);
    CGRect dateRect = CGRectMake(0, 334, _datePicker.frame.size.width, 200);
    
    _cityField = [UIHandler returnTextFieldWithRect:cityRect withPlaceholder:@"City"];
    _cityField.delegate = self;
    _stateField = [UIHandler returnTextFieldWithRect:stateRect withPlaceholder:@"State"];
    _stateField.delegate = self;
    _opponentField = [UIHandler returnTextFieldWithRect:opponentRect withPlaceholder:@"Opponent"];
    _opponentField.delegate = self;
    _stadiumField = [UIHandler returnTextFieldWithRect:stadiumRect withPlaceholder:@"Stadium"];
    _stadiumField.delegate = self;
    
    _datePicker = [[UIDatePicker alloc]initWithFrame:dateRect];
    [self.view addSubview:_cityField];
    [self.view addSubview:_stateField];
    [self.view addSubview:_opponentField];
    [self.view addSubview:_stadiumField];
    [self.view addSubview:_datePicker];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(Game *)getGame
{
    Game *game = [Game getSingleObject];
    game.city = _cityField.text;
    game.state = _stateField.text;
    game.opponent = _opponentField.text;
    game.stadium = _stadiumField.text;
    game.gameDate = _datePicker.date;
    game.username = [PFUser currentUser].username;
    
    return game;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier]isEqualToString:@"toGames"])
    {
        GameTableViewController *gameController = segue.destinationViewController;
        gameController.user = [PFUser currentUser].username;
    }
}


-(IBAction)addGame:(id)sender
{
    if([_cityField.text length] == 0 || [_stateField.text length] == 0 || [_opponentField.text length] == 0 || [_stadiumField.text length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You must fill in required information to record workout." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        GameHandler *handler = [[GameHandler alloc]init];
        [handler postGame:[self getGame]];
        handler.delegate = self;
    }
}

-(void)gameSegue
{
    [self performSegueWithIdentifier:@"toGames" sender:self];
}

@end
