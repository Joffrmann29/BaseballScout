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
#import "LoginViewController.h"

@interface SearchTableViewController ()

@property (strong, nonatomic) NSMutableArray *players;
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
- (IBAction)logout:(UIBarButtonItem *)sender;
@end

@implementation SearchTableViewController
MBProgressHUD *hud;
BOOL successfulSearch;
BOOL successfulLastNameSearch;
BOOL successfulPositionSearch;
UIAlertView *logalert;
UIAlertView *errorAlert;

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
    
    self.view.backgroundColor = [UIColor colorWithRed:42.0f / 255.0f green:92.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f];
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
    NSString *displayFullList = @"Display All Players";
    NSString *cancelTitle = @"Cancel Button";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:searchByPlayerFirstName
                                  otherButtonTitles:searchByPlayerLastName,searchByTeam, displayFullList, nil];
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
            _players = [objects mutableCopy];
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
            
            else if(alertView == logalert == buttonIndex == 1)
            {
                LoginViewController *lController = [[LoginViewController alloc]init];
                lController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
                [self presentViewController:lController animated:YES completion:nil];
                [PFUser logOut];
            }
            
            else if(alertView == _searchByFirstAlert || alertView == _searchByLastAlert || alertView == _searchByPositionAlert || alertView == errorAlert)
            {
                if(textField.text.length == 0){
                    errorAlert = [[UIAlertView alloc] initWithTitle:@"You must enter a search term"
                                                            message:@"In order to complete the search you must enter player info."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Go",nil];
                    
                    errorAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
                    [errorAlert show];
                }
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
    
    PFObject *player;
    
    if(successfulSearch){
        player = [self.searchedPlayers objectAtIndex:indexPath.row];
    }
    
    else if(successfulLastNameSearch){
        player = [self.searchedPlayersByLastName objectAtIndex:indexPath.row];
    }
    
    else if(successfulPositionSearch){
        player = [self.searchedPlayersByPosition objectAtIndex:indexPath.row];
    }
    
    else{
        player = [self.players objectAtIndex:indexPath.row];
    }
    
    PFFile *file = player[@"PlayerImage"];
    NSData *imageData = [file getData];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImage *finalImage = [self resizeImage:image];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",player[@"FirstName"],player[@"LastName"]];
    cell.detailTextLabel.text = player[@"Position"];
    cell.imageView.image = finalImage;
    cell.imageView.layer.cornerRadius = cell.frame.size.height/2;
    cell.imageView.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Add your Colour.
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self setCellColor:[UIColor blackColor] ForCell:cell];  //highlight colour
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.tintColor = [UIColor whiteColor];
}

- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
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
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [defaultACL setPublicWriteAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    PFObject *player = self.players[indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.section == 0){
        /* If a user deletes the row remove the task at that row from the tasksArray */
        [self.players removeObjectAtIndex:indexPath.row];
        [player deleteInBackground];
    }
    
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

- (CALayer *)gradientBGLayerForBounds:(CGRect)bounds
{
    CAGradientLayer * gradientBG = [CAGradientLayer layer];
    gradientBG.frame = bounds;
    gradientBG.colors = [NSArray arrayWithObjects:
                         (id)[[UIColor colorWithRed:42.0f / 255.0f green:92.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f] CGColor],
                         (id)[[UIColor colorWithRed:11.0f / 255.0f green:51.0f / 255.0f blue:101.0f / 255.0f alpha:1.0f] CGColor],
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

- (IBAction)logout:(UIBarButtonItem *)sender
{
    logalert = [[UIAlertView alloc]initWithTitle:@"Log Out" message:@"Are you sure you want to log out? "delegate:self cancelButtonTitle:nil otherButtonTitles:@"No", @"Yes", nil];
    [logalert show];
}

@end
