//
//  SearchPlayerAccountsViewController.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 12/9/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import "SearchPlayerAccountsViewController.h"
#import "ImprovedChatViewController.h"
#import "GameTableViewController.h"

@interface SearchPlayerAccountsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *players;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation SearchPlayerAccountsViewController
static UIColor *selectedColor;
static UIColor *notSelectedColor;

- (void)viewDidLoad {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self retrieveProgress];
    selectedColor = [UIColor blueColor];
    notSelectedColor = [UIColor clearColor];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(reloadTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)reloadTable {
    //TODO: refresh your data
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

-(void) retrieveProgress{
    PFQuery *retrievePlayer = [PFQuery queryWithClassName:@"_User"];
    [retrievePlayer whereKey:@"UserType" equalTo:@"Player"];
    [retrievePlayer findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _players = [objects mutableCopy];
            NSLog(@"%@", objects);
            [self.tableView reloadData];
            //[hud hide:YES];
        }
        else{
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
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
    return [_players count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // Configure the cell...
    
    PFObject *player = _players[indexPath.row];
    cell.textLabel.text = player[@"FirstName"];
    cell.detailTextLabel.text = player[@"LastName"];
    PFFile *file = player[@"UserImage"];
    NSData *imageData = [file getData];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImage *finalImage = [self resizeImage:image];
    cell.imageView.image = finalImage;
    cell.imageView.layer.cornerRadius = 22;
    cell.imageView.clipsToBounds = YES;
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor redColor];
    [cell setSelectedBackgroundView:bgColorView];
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    cell.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toGames" sender:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"toGames"])
    {
        NSIndexPath *path = sender;
        PFObject *player = self.players[path.row];
        GameTableViewController *gameController = segue.destinationViewController;
        gameController.user = player[@"username"];
        gameController.player = player;
    }
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

@end
