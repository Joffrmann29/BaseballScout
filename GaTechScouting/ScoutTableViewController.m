//
//  ScoutTableViewController.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 11/19/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import "ScoutTableViewController.h"
#import "MBProgressHUD.h"
#import <MessageUI/MessageUI.h>

@interface ScoutTableViewController ()<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSArray *scouts;

@end

@implementation ScoutTableViewController
MBProgressHUD *hud;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadingOverlay];
    
    CALayer * bgGradientLayer = [self gradientBGLayerForBounds:self.navigationController.navigationBar.bounds];
    UIGraphicsBeginImageContext(bgGradientLayer.bounds.size);
    [bgGradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * bgAsImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (bgAsImage != nil)
    {
        [[UINavigationBar appearance] setBackgroundImage:bgAsImage
                                           forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        NSLog(@"Failded to create gradient bg image, user will see standard tint color gradient.");
    }
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Arial" size:21.0], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.scouts = [[NSArray alloc]init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated{
    [self retieveProgress];
}

-(void)loadingOverlay
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) retieveProgress{
    PFQuery *retrievePlayer = [PFQuery queryWithClassName:@"_User"];
    [retrievePlayer whereKey:@"UserType" equalTo:@"Scout"];
    [retrievePlayer findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _scouts = objects;
            NSLog(@"%@", objects);
            [self.tableView reloadData];
            [hud hide:YES];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.scouts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    PFUser *scoutUser = self.scouts[indexPath.row];
    NSString *scoutFirstName = scoutUser[@"FirstName"];
    NSString *scoutLastName = scoutUser[@"LastName"];
    NSString *groupName = scoutUser[@"Group"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", scoutLastName, scoutFirstName];
    cell.detailTextLabel.text = groupName;
    PFFile *file = scoutUser[@"UserImage"];
    NSData *data = [file getData];
    UIImage *image = [UIImage imageWithData:data];
    UIImage *finalImage = [self resizeImage:image];
    cell.imageView.image = finalImage;
    cell.imageView.layer.cornerRadius = 10;
    cell.imageView.clipsToBounds = YES;
    cell.textLabel.textColor = [UIColor colorWithRed:42.0f / 255.0f green:92.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:42.0f / 255.0f green:92.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser *scoutUser = self.scouts[indexPath.row];
    NSString *scoutEmail = scoutUser[@"email"];
    
    NSArray *toRecipents = [NSArray arrayWithObject:scoutEmail];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:nil];
    [mc setSubject:nil];
    [mc setMessageBody:nil isHTML:NO];
    [mc setToRecipients:toRecipents];
        
    // Present mail view controller on screen
    [self.navigationController presentViewController:mc animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self setNeedsStatusBarAppearanceUpdate];
        [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    }];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(UIImage *)resizeImage:(UIImage *)image
{
    CGRect rect = CGRectMake(0, 0, 54, 54);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *transformedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imgData = UIImagePNGRepresentation(transformedImage);
    UIImage *finalImage = [UIImage imageWithData:imgData];
    
    return finalImage;
}

- (CALayer *)gradientCellLayerForBounds:(CGRect)bounds
{
    CAGradientLayer * gradientBG = [CAGradientLayer layer];
    gradientBG.frame = bounds;
    gradientBG.colors = [NSArray arrayWithObjects:
                         (id)[[UIColor colorWithRed:42.0f / 255.0f green:92.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f] CGColor],
                         (id)[[UIColor colorWithRed:11.0f / 255.0f green:51.0f / 255.0f blue:101.0f / 255.0f alpha:1.0f] CGColor],
                         nil];
    return gradientBG;
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
