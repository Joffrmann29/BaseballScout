//
//  PlayerScorecardController.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 9/17/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import "PlayerScorecardController.h"
#import "Gradients.h"

@interface PlayerScorecardController ()

@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)backToSearch:(UIBarButtonItem *)sender;
@end

@implementation PlayerScorecardController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *attributeView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, 195)];
    
    Gradients *grad = [[Gradients alloc]init];
    CAGradientLayer *attrGradient = [grad redGradient];
    attrGradient.frame = attributeView.bounds;
    [attributeView.layer insertSublayer:attrGradient atIndex:0];
    
    UIImageView *playerView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
    PFFile *file = _player[@"PlayerImage"];
    NSData *imageData = [file getData];
    playerView.image = [UIImage imageWithData:imageData];
    playerView.layer.cornerRadius = 50;
    playerView.clipsToBounds = YES;
    [attributeView addSubview:playerView];
    
    UILabel *attributeHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(115, 0, 160, 30)];
    attributeHeaderLabel.textColor = [UIColor whiteColor];
    attributeHeaderLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    attributeHeaderLabel.text = @"Attributes";
    [attributeView addSubview:attributeHeaderLabel];
    
    UILabel *firstNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 50, 150, 40)];
    firstNameLabel.textColor = [UIColor whiteColor];
    firstNameLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    firstNameLabel.text = [NSString stringWithFormat:@"First Name: %@",_player[@"FirstName"]];
    [attributeView addSubview:firstNameLabel];
    
    UILabel *lastNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 100, 150, 40)];
    lastNameLabel.textColor = [UIColor whiteColor];
    lastNameLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    lastNameLabel.text = [NSString stringWithFormat:@"Last Name: %@",_player[@"LastName"]];
    [attributeView addSubview:lastNameLabel];
    
    UILabel *heightLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 150, 130, 40)];
    heightLabel.textColor = [UIColor whiteColor];
    heightLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    heightLabel.text = [NSString stringWithFormat:@"Height: %@",_player[@"height"]];
    [attributeView addSubview:heightLabel];
    
    UILabel *weightLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 150, 130, 40)];
    weightLabel.textColor = [UIColor whiteColor];
    weightLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int weightInt = [_player[@"Weight"]intValue];
    weightLabel.text = [NSString stringWithFormat:@"Weight: %i",weightInt];
    [attributeView addSubview:weightLabel];
    
    UIView *hittingView = [[UIView alloc]initWithFrame:CGRectMake(0, 240, 320, 85)];
    
    UILabel *hittingLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 160, 30)];
    hittingLabel.textColor = [UIColor blueColor];
    hittingLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    hittingLabel.text = @"Batting Info";
    [hittingView addSubview:hittingLabel];
    
    UILabel *hittingRatingLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 75, 40)];
    hittingRatingLabel.textColor = [UIColor blueColor];
    hittingRatingLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int hittingRating = [_player[@"Hitting"]intValue];
    hittingRatingLabel.text = [NSString stringWithFormat:@"Hitting:%i", hittingRating];
    [hittingView addSubview:hittingRatingLabel];
    
    UILabel *powerLabel = [[UILabel alloc]initWithFrame:CGRectMake(122, 40, 75, 40)];
    powerLabel.textColor = [UIColor blueColor];
    powerLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int powerRating = [_player[@"Power"]intValue];
    powerLabel.text = [NSString stringWithFormat:@"Power:%i", powerRating];
    [hittingView addSubview:powerLabel];
    
    UILabel *battingLabel = [[UILabel alloc]initWithFrame:CGRectMake(235, 40, 75, 40)];
    battingLabel.textColor = [UIColor blueColor];
    battingLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    battingLabel.text = [NSString stringWithFormat:@"Bats:%@", _player[@"Bats"]];
    [hittingView addSubview:battingLabel];
    
    UIView *fieldingView = [[UIView alloc]initWithFrame:CGRectMake(0, 376, 320, 192)];
    //fieldingView.backgroundColor = [UIColor blueColor];
    
    UILabel *fieldingLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 160, 30)];
    fieldingLabel.textColor = [UIColor redColor];
    fieldingLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    fieldingLabel.text = @"Fielding";
    [fieldingView addSubview:fieldingLabel];
    
    UILabel *armAccuracyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 150, 40)];
    armAccuracyLabel.textColor = [UIColor redColor];
    armAccuracyLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int armAccuracyInt = [_player[@"ArmAccuracy"]intValue];
    armAccuracyLabel.text = [NSString stringWithFormat:@"Arm Accuracy: %i", armAccuracyInt];
    [fieldingView addSubview:armAccuracyLabel];
    
    UILabel *armStrengthLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 40, 150, 40)];
    armStrengthLabel.textColor = [UIColor redColor];
    armStrengthLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int armStrengthInt = [_player[@"ArmStrength"]intValue];
    armStrengthLabel.text = [NSString stringWithFormat:@"Arm Strength: %i", armStrengthInt];
    [fieldingView addSubview:armStrengthLabel];
    
    UILabel *fieldingRatingLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 90, 150, 40)];
    fieldingRatingLabel.textColor = [UIColor redColor];
    fieldingRatingLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int fielding = [_player[@"Fielding"]intValue];
    fieldingRatingLabel.text = [NSString stringWithFormat:@"Fielding: %i", fielding];
    [fieldingView addSubview:fieldingRatingLabel];
    
    UILabel *throwingLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 90, 130, 40)];
    throwingLabel.textColor = [UIColor redColor];
    throwingLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    throwingLabel.text = [NSString stringWithFormat:@"Throws: %@", _player[@"Throws"]];
    [fieldingView addSubview:throwingLabel];
    
    UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 140, 130, 40)];
    positionLabel.textColor = [UIColor redColor];
    positionLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    positionLabel.text = [NSString stringWithFormat:@"Position: %@", _player[@"Position"]];
    [fieldingView addSubview:positionLabel];
    
    CAGradientLayer *fieldGradient = [grad blueGradient];
    fieldGradient.frame = fieldingView.bounds;
    [fieldingView.layer insertSublayer:fieldGradient atIndex:0];
    
    [self.view addSubview:attributeView];
    [self.view addSubview:hittingView];
    [self.view addSubview:fieldingView];
    _scrollView.contentSize = CGSizeMake(320, 568);
    [self.view addSubview:_scrollView];
    
    [self.navBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Helvetica" size:17],
      NSFontAttributeName, nil]];
    self.navBar.frame = CGRectMake(0, 0, 320, 50);
    NSLog(@"%@, %@", _player[@"LastName"], _player[@"FirstName"]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backToSearch:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
