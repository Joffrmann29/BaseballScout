//
//  SearchPitcherTableViewController.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 9/29/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import "SearchPitcherTableViewController.h"
#import "MBProgressHUD.h"
#import "PitcherScorecardController.h"
#import "EditPitcherViewController.h"
#import "LoginViewController.h"

@interface SearchPitcherTableViewController ()

@property (strong, nonatomic) NSArray *pitchers;
@property (strong, nonatomic) NSArray *searchedPitchers;
@property (strong, nonatomic) NSArray *searchedPitchersByLastName;
@property (strong, nonatomic) NSArray *searchedPitchersByPosition;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) NSString *searchTerm;
@property (strong, nonatomic) UIAlertView *searchByFirstAlert;
@property (strong, nonatomic) UIAlertView *searchByLastAlert;
@property (strong, nonatomic) UIAlertView *searchByPositionAlert;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

- (IBAction)searchButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)logout:(UIBarButtonItem *)sender;
@end

@implementation SearchPitcherTableViewController
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
    
    _searchedPitchers = [[NSArray alloc]init];
    [self filterResultsByFirstName:self.searchTerm];
    [self filterResultsByLastName:self.searchTerm];
    
    self.view.backgroundColor = [UIColor colorWithRed:42.0f / 255.0f green:92.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

-(void)filterResultsByFirstName:(NSString *)searchTerm {
    PFQuery *query = [PFQuery queryWithClassName: @"Pitcher"];
    [query whereKey:@"FirstName" containsString:searchTerm];
    query.limit = 50;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            NSLog(@"%@", objects);
            _searchedPitchers = objects;
            [self.tableView reloadData];
            [hud hide:YES];
        }
    }];
}

-(void)filterResultsByLastName:(NSString *)searchTerm{
    PFQuery *query = [PFQuery queryWithClassName: @"Pitcher"];
    [query whereKey:@"LastName" containsString:searchTerm];
    query.limit = 50;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            NSLog(@"%@", objects);
            _searchedPitchersByLastName = objects;
            [self.tableView reloadData];
            [hud hide:YES];
        }
    }];
}

-(void)filterResultsByPosition:(NSString *)searchTerm{
    PFQuery *query = [PFQuery queryWithClassName: @"Pitcher"];
    [query whereKey:@"SchoolClass" containsString:searchTerm];
    query.limit = 50;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            NSLog(@"%@", objects);
            _searchedPitchersByPosition = objects;
            [self.tableView reloadData];
            [hud hide:YES];
        }
    }];
}

-(void) retieveProgress{
    PFQuery *retrievePlayer = [PFQuery queryWithClassName:@"Pitcher"];
    [retrievePlayer whereKey:@"scout" equalTo:[PFUser currentUser].username];
    [retrievePlayer findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _pitchers = objects;
            NSLog(@"%@", objects);
            [self.tableView reloadData];
            [hud hide:YES];
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)showAction
{
    NSString *actionSheetTitle = @"Menu Options"; //Action Sheet Title
    NSString *searchByPitcherFirstName = @"Search By First Name";
    NSString *searchByPitcherLastName = @"Search By Last Name";
    NSString *searchByClass = @"Search By Class";
    NSString *displayFullList = @"Display All Pitchers";
    NSString *cancelTitle = @"Cancel Button";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:searchByPitcherFirstName
                                  otherButtonTitles:searchByPitcherLastName,searchByClass, displayFullList, nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        _searchByFirstAlert = [[UIAlertView alloc] initWithTitle:@"Search By First Name"
                                                         message:@"Please search for a pitcher"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Go",nil];
        _searchByFirstAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [_searchByFirstAlert show];
    }
    
    else if(buttonIndex == 1)
    {
        _searchByLastAlert = [[UIAlertView alloc] initWithTitle:@"Search By Last Name"
                                                        message:@"Please search for a pitcher"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Go",nil];
        _searchByLastAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [_searchByLastAlert show];
    }
    
    else if(buttonIndex == 2)
    {
        _searchByPositionAlert = [[UIAlertView alloc] initWithTitle:@"Search By Class"
                                                            message:@"Please search for a pitcher"
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
    if(successfulSearch){
        return [_searchedPitchers count];
    }
    else if(successfulLastNameSearch){
        return [_searchedPitchersByLastName count];
    }
    
    else if(successfulPositionSearch){
        return [_searchedPitchersByPosition count];
    }
    else{
        return [_pitchers count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    PFObject *pitcher;
    if(successfulSearch){
        pitcher = [self.searchedPitchers objectAtIndex:indexPath.row];
    }
    
    else if(successfulLastNameSearch){
        pitcher = [self.searchedPitchersByLastName objectAtIndex:indexPath.row];
    }
    
    else if(successfulPositionSearch){
        pitcher = [self.searchedPitchersByPosition objectAtIndex:indexPath.row];
    }
    
    else{
        pitcher = [self.pitchers objectAtIndex:indexPath.row];
    }
    
    PFFile *file = pitcher[@"PlayerImage"];
    NSData *imageData = [file getData];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImage *finalImage = [self resizeImage:image];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",pitcher[@"FirstName"],pitcher[@"LastName"]];
    int class = [pitcher[@"SchoolClass"]intValue];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", class];
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
    cell.tintColor = color;
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

- (IBAction)searchButtonPressed:(UIBarButtonItem *)sender
{
    [self showAction];
}

/* When the user taps the accessory button transition to the PlayerScorecardController */
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toEditPlayer" sender:indexPath];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[PitcherScorecardController class]]){
        PitcherScorecardController *detailViewController = segue.destinationViewController;
        NSIndexPath *path = sender;
        PFObject *pitcher;
        
        if(successfulLastNameSearch){
            pitcher = self.searchedPitchersByLastName[path.row];
            detailViewController.pitcher = pitcher;
        }
        
        else if(successfulPositionSearch){
            pitcher = self.searchedPitchersByPosition[path.row];
            detailViewController.pitcher = pitcher;
        }
        
        else if(successfulSearch){
            pitcher = self.searchedPitchers[path.row];
            detailViewController.pitcher = pitcher;
        }
        
        else{
            pitcher = [self.pitchers objectAtIndex:path.row];
            detailViewController.pitcher = pitcher;
        }
    }
    
    else if([segue.destinationViewController isKindOfClass:[EditPitcherViewController class]])
    {
        EditPitcherViewController *editController = segue.destinationViewController;
        NSIndexPath *indexPath = sender;
        PFObject *pitcher;
        
        if(successfulLastNameSearch){
            pitcher = self.searchedPitchersByLastName[indexPath.row];
            editController.pitcher = pitcher;
        }
        
        else if(successfulPositionSearch){
            pitcher = self.searchedPitchersByPosition[indexPath.row];
            editController.pitcher = pitcher;
        }
        
        else if(successfulSearch){
            pitcher = self.searchedPitchers[indexPath.row];
            editController.pitcher = pitcher;
        }
        
        else{
            pitcher = [self.pitchers objectAtIndex:indexPath.row];
            editController.pitcher = pitcher;
        }
    }
}

- (IBAction)logout:(UIBarButtonItem *)sender
{
    logalert = [[UIAlertView alloc]initWithTitle:@"Log Out" message:@"Are you sure you want to log out? "delegate:self cancelButtonTitle:nil otherButtonTitles:@"No", @"Yes", nil];
    [logalert show];
}

@end
