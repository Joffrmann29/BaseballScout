//
//  GameTableViewController.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 12/10/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import "GameTableViewController.h"
#import "ImprovedChatViewController.h"

@interface GameTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *games;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation GameTableViewController

- (void)viewDidLoad {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    PFObject *userObject = [PFObject objectWithClassName:@"_User"];
    NSString *userType = userObject[@"UserType"];
    UIBarButtonItem *optionItem;
    if([userType isEqualToString:@"Player"])
    {
        [self retieveProgress];
        optionItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGame:)];
        self.navigationItem.rightBarButtonItem = optionItem;
    }
    
    else
    {
        [self retrieveForScout];
        optionItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(toChat:)];
        self.navigationItem.rightBarButtonItem = optionItem;
    }
    self.navigationItem.title = _user;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) retieveProgress{
    PFQuery *retrievePlayer = [PFQuery queryWithClassName:@"Game"];
    [retrievePlayer whereKey:@"Username" equalTo:[PFUser currentUser].username];
    [retrievePlayer findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _games = [objects mutableCopy];
            NSLog(@"%@", objects);
            [self.tableView reloadData];
        }
    }];
}

-(void) retrieveForScout{
    PFQuery *retrievePlayer = [PFQuery queryWithClassName:@"Game"];
    [retrievePlayer whereKey:@"Username" equalTo:self.user];
    [retrievePlayer findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _games = [objects mutableCopy];
            NSLog(@"%@", objects);
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.games count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    PFObject *game = self.games[indexPath.row];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", game[@"City"], game[@"State"]];
    cell.textLabel.text = game[@"Opponent"];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)addGame:(id)sender
{
    [self performSegueWithIdentifier:@"toAddGame" sender:self];
}

-(IBAction)toChat:(id)sender
{
    PFFile *theImage = [[PFUser currentUser] objectForKey:@"UserImage"];
    [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
    
        //PFObject *player = [PFObject objectWithClassName:@"User"];
        ImprovedChatViewController *ivc = [ImprovedChatViewController messagesViewController];
        PFFile *matchedImage = self.player[@"UserImage"];
        NSData *matchedData = [matchedImage getData];
        UIImage *finalMatchedImage = [UIImage imageWithData:matchedData];
        UIImage *finalImage = [self resizeImage:finalMatchedImage];
        ivc.player = self.player;
        NSLog(@"%@",self.player[@"username"]);
        ivc.matchedImage = finalImage;
        ivc.currentImage = image;
        [self.navigationController pushViewController:ivc animated:YES];
        }];
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
