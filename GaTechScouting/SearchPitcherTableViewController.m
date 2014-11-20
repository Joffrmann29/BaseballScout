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

- (IBAction)searchButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)back:(UIBarButtonItem *)sender;
@end

@implementation SearchPitcherTableViewController
MBProgressHUD *hud;
BOOL successfulSearch;
BOOL successfulLastNameSearch;
BOOL successfulPositionSearch;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self loadingOverlay];
    
    [self.navBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Helvetica" size:17],
      NSFontAttributeName, nil]];
    _searchedPitchers = [[NSArray alloc]init];
    [self filterResultsByFirstName:self.searchTerm];
    [self filterResultsByLastName:self.searchTerm];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    if(successfulSearch){
        PFObject *player = [self.searchedPitchers objectAtIndex:indexPath.row];
        PFFile *file = player[@"PlayerImage"];
        NSData *imageData = [file getData];
        UIImage *image = [UIImage imageWithData:imageData];
        UIImage *finalImage = [self resizeImage:image];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",player[@"FirstName"],player[@"LastName"]];
        cell.detailTextLabel.text = player[@"Position"];
        cell.imageView.image = finalImage;
    }
    
    else if(successfulLastNameSearch){
        PFObject *player = [self.searchedPitchersByLastName objectAtIndex:indexPath.row];
        PFFile *file = player[@"PlayerImage"];
        NSData *imageData = [file getData];
        UIImage *image = [UIImage imageWithData:imageData];
        UIImage *finalImage = [self resizeImage:image];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",player[@"FirstName"],player[@"LastName"]];
        cell.detailTextLabel.text = player[@"Position"];
        cell.imageView.image = finalImage;
    }
    
    else if(successfulPositionSearch){
        PFObject *pitcher = [self.searchedPitchersByPosition objectAtIndex:indexPath.row];
        PFFile *file = pitcher[@"PlayerImage"];
        NSData *imageData = [file getData];
        UIImage *image = [UIImage imageWithData:imageData];
        UIImage *finalImage = [self resizeImage:image];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",pitcher[@"FirstName"],pitcher[@"LastName"]];
        cell.detailTextLabel.text = pitcher[@"Position"];
        cell.imageView.image = finalImage;
    }
    
    else{
        PFObject *pitcher = [self.pitchers objectAtIndex:indexPath.row];
        PFFile *file = pitcher[@"PlayerImage"];
        NSData *imageData = [file getData];
        UIImage *image = [UIImage imageWithData:imageData];
        UIImage *finalImage = [self resizeImage:image];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",pitcher[@"FirstName"],pitcher[@"LastName"]];
        cell.detailTextLabel.text = pitcher[@"Pitcher"];
        cell.imageView.image = finalImage;
    }

    return cell;
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
}

-(IBAction)back:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
