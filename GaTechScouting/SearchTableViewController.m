//
//  SearchTableViewController.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 9/3/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import "SearchTableViewController.h"
#import "MBProgressHUD.h"
#import "PlayerScorecardController.h"
#import "SearchPitcherTableViewController.h"
#import "EditPlayerViewController.h"

@interface SearchTableViewController ()

@property (strong, nonatomic) NSArray *players;
@property (strong, nonatomic) NSArray *searchedPlayers;
@property (strong, nonatomic) NSArray *searchedPlayersByLastName;
@property (strong, nonatomic) NSArray *searchedPlayersByPosition;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) NSString *searchTerm;
@property (strong, nonatomic) UIAlertView *searchByFirstAlert;
@property (strong, nonatomic) UIAlertView *searchByLastAlert;
@property (strong, nonatomic) UIAlertView *searchByPositionAlert;
@property (strong, nonatomic) UIAlertView *playerOptions;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

- (IBAction)searchButtonPressed:(UIBarButtonItem *)sender;
@end

@implementation SearchTableViewController
MBProgressHUD *hud;
BOOL successfulSearch;
BOOL successfulLastNameSearch;
BOOL successfulPositionSearch;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(reloadTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self loadingOverlay];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Arial" size:17.0], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.view.backgroundColor = [UIColor colorWithRed:252.0f / 255.0f green:31.0f / 255.0f blue:10.0f / 255.0f alpha:1.0f];
}

- (void)reloadTable {
    //TODO: refresh your data
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

-(void)loadingOverlay
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
}

-(void) viewWillAppear:(BOOL)animated{
    [self retieveProgress];
}

-(void)showAction
{
    NSString *actionSheetTitle = @"Menu Options"; //Action Sheet Title
    NSString *searchByPlayerFirstName = @"Search By First Name";
    NSString *searchByPlayerLastName = @"Search By Last Name";
    NSString *searchByTeam = @"Search By Position";
    NSString *searchPitchers = @"Search For Pitchers";
    NSString *displayFullList = @"Display All Players";
    NSString *cancelTitle = @"Cancel Button";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:searchByPlayerFirstName
                                  otherButtonTitles:searchByPlayerLastName,searchByTeam, searchPitchers, displayFullList, nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        _searchByFirstAlert = [[UIAlertView alloc] initWithTitle:@"Search By First Name"
                                                        message:@"Please search for a player"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Go",nil];
        _searchByFirstAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [_searchByFirstAlert show];
    }
    
    else if(buttonIndex == 1)
    {
        _searchByLastAlert = [[UIAlertView alloc] initWithTitle:@"Search By Last Name"
                                                         message:@"Please search for a player"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Go",nil];
        _searchByLastAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [_searchByLastAlert show];
    }
    
    else if(buttonIndex == 2)
    {
        _searchByPositionAlert = [[UIAlertView alloc] initWithTitle:@"Search By Position"
                                                         message:@"Please search for a player"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Go",nil];
        _searchByPositionAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [_searchByPositionAlert show];
    }
    
    else if(buttonIndex == 3){
        [self performSegueWithIdentifier:@"toSearchPitcher" sender:nil];
    }
    
    else{
        [self retieveProgress];
        successfulSearch = 0;
        successfulLastNameSearch = 0;
        successfulPositionSearch = 0;
    }
}

-(void)filterResultsByFirstName:(NSString *)searchTerm {
    PFQuery *query = [PFQuery queryWithClassName: @"Player"];
    [query whereKey:@"scout" equalTo:[PFUser currentUser].username];
    [query whereKey:@"FirstName" containsString:searchTerm];
    query.limit = 50;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
        NSLog(@"%@", objects);
        _searchedPlayers = objects;
        [self.tableView reloadData];
        [hud hide:YES];
        }
     }];
}

-(void)filterResultsByLastName:(NSString *)searchTerm{
    PFQuery *query = [PFQuery queryWithClassName: @"Player"];
    [query whereKey:@"scout" equalTo:[PFUser currentUser].username];
    [query whereKey:@"LastName" containsString:searchTerm];
    query.limit = 50;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            NSLog(@"%@", objects);
            _searchedPlayersByLastName = objects;
            [self.tableView reloadData];
            [hud hide:YES];
        }
    }];
}

-(void)filterResultsByPosition:(NSString *)searchTerm{
    PFQuery *query = [PFQuery queryWithClassName: @"Player"];
    [query whereKey:@"scout" equalTo:[PFUser currentUser].username];
    [query whereKey:@"Position" containsString:searchTerm];
    query.limit = 50;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            NSLog(@"%@", objects);
            _searchedPlayersByPosition = objects;
            [self.tableView reloadData];
            [hud hide:YES];
        }
    }];
}

-(void) retieveProgress{
    PFQuery *retrievePlayer = [PFQuery queryWithClassName:@"Player"];
    [retrievePlayer whereKey:@"scout" equalTo:[PFUser currentUser].username];
    [retrievePlayer findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _players = objects;
            NSLog(@"%@", objects);
            [self.tableView reloadData];
            [hud hide:YES];
        }
        else{
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
     
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
    {
        UITextField *textField =  [alertView textFieldAtIndex: 0];
        // NO = 0, YES = 1
        if(buttonIndex == 0)
        {
        }
        else
        {
            if (alertView == _searchByFirstAlert && textField.text && textField.text.length > 0)
            {
                NSLog(@"textfield = %@", textField.text);
                self.searchTerm = textField.text;
                [self filterResultsByFirstName:self.searchTerm];
                [self loadingOverlay];
                successfulSearch = 1;
                successfulLastNameSearch = 0;
                successfulPositionSearch = 0;
            }
            
            else if(alertView == _searchByLastAlert && textField.text && textField.text.length > 0)
            {
                NSLog(@"textfield = %@", textField.text);
                self.searchTerm = textField.text;
                [self filterResultsByLastName:self.searchTerm];
                [self loadingOverlay];
                successfulLastNameSearch = 1;
                successfulSearch = 0;
                successfulPositionSearch = 0;
            }
            
            else if(alertView == _searchByPositionAlert && textField.text && textField.text.length > 0)
            {
                NSLog(@"textfield = %@", textField.text);
                self.searchTerm = textField.text;
                [self filterResultsByPosition:self.searchTerm];
                [self loadingOverlay];
                successfulPositionSearch = 1;
                successfulSearch = 0;
                successfulLastNameSearch = 0;
            }
            
            else if(alertView == _playerOptions)
            {
                if(buttonIndex == 0)
                {
                    [self performSegueWithIdentifier:@"toScorecard" sender:nil];
                }
                else
                {
                    [self performSegueWithIdentifier:@"toEdit" sender:nil];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You must enter a search term"
                                                                message:@"In order to complete the search you must enter a comic to search for in the text box!"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Go",nil];
                
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alert show];
            }
        }
    }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(successfulSearch){
    return [_searchedPlayers count];
    }
    else if(successfulLastNameSearch){
        return [_searchedPlayersByLastName count];
    }
    
    else if(successfulPositionSearch){
        return [_searchedPlayersByPosition count];
    }
    else{
        return [_players count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // Configure the cell...
    if(successfulSearch){
        PFObject *player = [self.searchedPlayers objectAtIndex:indexPath.row];
        PFFile *file = player[@"PlayerImage"];
        NSData *imageData = [file getData];
        UIImage *image = [UIImage imageWithData:imageData];
        UIImage *finalImage = [self resizeImage:image];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",player[@"FirstName"],player[@"LastName"]];
        cell.detailTextLabel.text = player[@"Position"];
        cell.imageView.image = finalImage;
    }
    
    else if(successfulLastNameSearch){
        PFObject *player = [self.searchedPlayersByLastName objectAtIndex:indexPath.row];
        PFFile *file = player[@"PlayerImage"];
        NSData *imageData = [file getData];
        UIImage *image = [UIImage imageWithData:imageData];
        UIImage *finalImage = [self resizeImage:image];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",player[@"FirstName"],player[@"LastName"]];
        cell.detailTextLabel.text = player[@"Position"];
        cell.imageView.image = finalImage;
    }
    
    else if(successfulPositionSearch){
        PFObject *player = [self.searchedPlayersByPosition objectAtIndex:indexPath.row];
        PFFile *file = player[@"PlayerImage"];
        NSData *imageData = [file getData];
        UIImage *image = [UIImage imageWithData:imageData];
        UIImage *finalImage = [self resizeImage:image];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",player[@"FirstName"],player[@"LastName"]];
        cell.detailTextLabel.text = player[@"Position"];
        cell.imageView.image = finalImage;
    }
    
    else{
        PFObject *player = [self.players objectAtIndex:indexPath.row];
        PFFile *file = player[@"PlayerImage"];
        NSData *imageData = [file getData];
        UIImage *image = [UIImage imageWithData:imageData];
        UIImage *finalImage = [self resizeImage:image];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",player[@"FirstName"],player[@"LastName"]];
        cell.detailTextLabel.text = player[@"Position"];
        cell.imageView.image = finalImage;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

/* Allow the user to edit tableViewCells for deletion */
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/* Method called when the users swipes and presses the delete key */
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.section == 0){
//        /* If a user deletes the row remove the task at that row from the tasksArray */
//        [self.players removeObjectAtIndex:indexPath.row];
//    }
//    
//    /* With the updated array of task objects iterate over them and convert them to plists. Save the plists in the newTaskObjectsData NSMutableArray. Save this array to NSUserDefaults. */
//    NSMutableArray *newGoalObjectsData = [[NSMutableArray alloc] init];
//    
//    for (FitnessGoal *goal in self.goalObjects){
//        [newGoalObjectsData addObject:[self goalObjectsAsAPropertyList:goal]];
//    }
//    
//    [[NSUserDefaults standardUserDefaults] setObject:newGoalObjectsData forKey:GOAL_OBJECTS_KEY];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /* Animate the deletion of the cell */
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (IBAction)searchButtonPressed:(UIBarButtonItem *)sender
{
    [self showAction];
}

-(UIImage *)resizeImage:(UIImage *)image
{
    CGRect rect = CGRectMake(0, 0, 75, 75);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *transformedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imgData = UIImagePNGRepresentation(transformedImage);
    UIImage *finalImage = [UIImage imageWithData:imgData];
    
    return finalImage;
}

/* When the user taps the accessory button transition to the PlayerScorecardController */
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toEdit" sender:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toScorecard" sender:indexPath];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (CALayer *)gradientBGLayerForBounds:(CGRect)bounds
{
    CAGradientLayer * gradientBG = [CAGradientLayer layer];
    gradientBG.frame = bounds;
    gradientBG.colors = [NSArray arrayWithObjects:
                         (id)[[UIColor colorWithRed:252.0f / 255.0f green:31.0f / 255.0f blue:10.0f / 255.0f alpha:1.0f] CGColor],
                         (id)[[UIColor colorWithRed:101.0f / 255.0f green:17.0f / 255.0f blue:3.0f / 255.0f alpha:1.0f] CGColor],
                         nil];
    return gradientBG;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.destinationViewController isKindOfClass:[EditPlayerViewController class]])
    {
        EditPlayerViewController *editController = segue.destinationViewController;
        NSIndexPath *indexPath = sender;
        PFObject *player;
        
        if(successfulLastNameSearch){
            player = self.searchedPlayersByLastName[indexPath.row];
            editController.player = player;
        }
        
        else if(successfulPositionSearch){
            player = self.searchedPlayersByPosition[indexPath.row];
            editController.player = player;
        }
        
        else if(successfulSearch){
            player = self.searchedPlayers[indexPath.row];
            editController.player = player;
        }
        
        else{
            player = [self.players objectAtIndex:indexPath.row];
            editController.player = player;
        }
    }
    
    else if ([segue.destinationViewController isKindOfClass:[PlayerScorecardController class]]){
        PlayerScorecardController *detailViewController = segue.destinationViewController;
        NSIndexPath *path = sender;
        PFObject *player;
        
        if(successfulLastNameSearch){
            player = self.searchedPlayersByLastName[path.row];
            detailViewController.player = player;
        }
        
        else if(successfulPositionSearch){
            player = self.searchedPlayersByPosition[path.row];
            detailViewController.player = player;
        }
        
        else if(successfulSearch){
            player = self.searchedPlayers[path.row];
            detailViewController.player = player;
        }
        
        else{
            player = [self.players objectAtIndex:path.row];
            detailViewController.player = player;
        }
    }
}


@end
