//
//  PlayerScorecardController.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 9/17/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import "PlayerScorecardController.h"
#import "Gradients.h"
#import "EditPlayerViewController.h"
#import "BackgroundLayer.h"

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
    UIView *attributeView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 320, 205)];
    
    CALayer *attrLayer = [self gradientBGLayerForBounds:attributeView.bounds];
    [attributeView.layer insertSublayer:attrLayer atIndex:0];
    
    UIImageView *playerView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 100, 100)];
    PFFile *file = _player[@"PlayerImage"];
    NSData *imageData = [file getData];
    playerView.image = [UIImage imageWithData:imageData];
    playerView.layer.cornerRadius = 50;
    playerView.clipsToBounds = YES;
    [attributeView addSubview:playerView];
    
    UILabel *attributeHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(115, 20, 160, 30)];
    attributeHeaderLabel.textColor = [UIColor whiteColor];
    attributeHeaderLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    attributeHeaderLabel.text = @"Attributes";
    [attributeView addSubview:attributeHeaderLabel];
    
    UILabel *firstNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 70, 150, 40)];
    firstNameLabel.textColor = [UIColor whiteColor];
    firstNameLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    firstNameLabel.text = [NSString stringWithFormat:@"First Name: %@",_player[@"FirstName"]];
    firstNameLabel.numberOfLines = 0;
    [attributeView addSubview:firstNameLabel];
    
    UILabel *lastNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 120, 195, 40)];
    lastNameLabel.textColor = [UIColor whiteColor];
    lastNameLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    lastNameLabel.text = [NSString stringWithFormat:@"Last Name: %@",_player[@"LastName"]];
    lastNameLabel.numberOfLines = 0;
    [attributeView addSubview:lastNameLabel];
    
    UILabel *heightLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 170, 130, 40)];
    heightLabel.textColor = [UIColor whiteColor];
    heightLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    heightLabel.text = [NSString stringWithFormat:@"Height: %@",_player[@"height"]];
    [attributeView addSubview:heightLabel];
    
    UILabel *weightLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 170, 130, 40)];
    weightLabel.textColor = [UIColor whiteColor];
    weightLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int weightInt = [_player[@"Weight"]intValue];
    weightLabel.text = [NSString stringWithFormat:@"Weight: %i",weightInt];
    [attributeView addSubview:weightLabel];
    
    UIView *hittingView = [[UIView alloc]initWithFrame:CGRectMake(0, 269, 320, 130)];
    
    UILabel *hittingLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 20, 160, 30)];
    hittingLabel.textColor = [UIColor blueColor];
    hittingLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    hittingLabel.text = @"Batting Info";
    [hittingView addSubview:hittingLabel];
    
    UILabel *hittingRatingLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 75, 40)];
    hittingRatingLabel.textColor = [UIColor blueColor];
    hittingRatingLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int hittingRating = [_player[@"Hitting"]intValue];
    hittingRatingLabel.text = [NSString stringWithFormat:@"Hitting:%i", hittingRating];
    [hittingView addSubview:hittingRatingLabel];
    
    UILabel *powerLabel = [[UILabel alloc]initWithFrame:CGRectMake(122, 60, 75, 40)];
    powerLabel.textColor = [UIColor blueColor];
    powerLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int powerRating = [_player[@"Power"]intValue];
    powerLabel.text = [NSString stringWithFormat:@"Power:%i", powerRating];
    [hittingView addSubview:powerLabel];
    
    UILabel *battingLabel = [[UILabel alloc]initWithFrame:CGRectMake(235, 60, 75, 40)];
    battingLabel.textColor = [UIColor blueColor];
    battingLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    battingLabel.text = [NSString stringWithFormat:@"Bats:%@", _player[@"Bats"]];
    [hittingView addSubview:battingLabel];
    
    UIView *fieldingView = [[UIView alloc]initWithFrame:CGRectMake(0, 396, 320, 192)];
    //fieldingView.backgroundColor = [UIColor blueColor];
    
    UILabel *fieldingLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 20, 160, 30)];
    fieldingLabel.textColor = [UIColor redColor];
    fieldingLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    fieldingLabel.text = @"Fielding";
    [fieldingView addSubview:fieldingLabel];
    
    UILabel *armAccuracyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 150, 40)];
    armAccuracyLabel.textColor = [UIColor redColor];
    armAccuracyLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int armAccuracyInt = [_player[@"ArmAccuracy"]intValue];
    armAccuracyLabel.text = [NSString stringWithFormat:@"Arm Accuracy: %i", armAccuracyInt];
    [fieldingView addSubview:armAccuracyLabel];
    
    UILabel *armStrengthLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 60, 150, 40)];
    armStrengthLabel.textColor = [UIColor redColor];
    armStrengthLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int armStrengthInt = [_player[@"ArmStrength"]intValue];
    armStrengthLabel.text = [NSString stringWithFormat:@"Arm Strength: %i", armStrengthInt];
    [fieldingView addSubview:armStrengthLabel];
    
    UILabel *fieldingRatingLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 110, 150, 40)];
    fieldingRatingLabel.textColor = [UIColor redColor];
    fieldingRatingLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int fielding = [_player[@"Fielding"]intValue];
    fieldingRatingLabel.text = [NSString stringWithFormat:@"Fielding: %i", fielding];
    [fieldingView addSubview:fieldingRatingLabel];
    
    UILabel *throwingLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 110, 130, 40)];
    throwingLabel.textColor = [UIColor redColor];
    throwingLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    throwingLabel.text = [NSString stringWithFormat:@"Throws: %@", _player[@"Throws"]];
    [fieldingView addSubview:throwingLabel];
    
    UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 160, 130, 40)];
    positionLabel.textColor = [UIColor redColor];
    positionLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    positionLabel.text = [NSString stringWithFormat:@"Position: %@", _player[@"Position"]];
    [fieldingView addSubview:positionLabel];
    
    Gradients *grad = [[Gradients alloc]init];
    CAGradientLayer *fieldGradient = [grad blueGradient];
    fieldGradient.frame = fieldingView.bounds;
    [fieldingView.layer insertSublayer:fieldGradient atIndex:0];
    
    CAGradientLayer *hittingLayer = [BackgroundLayer greyGradient];
    hittingLayer.frame = hittingView.bounds;
    [hittingView.layer insertSublayer:hittingLayer atIndex:0];
    
    [self.view addSubview:attributeView];
    [self.view addSubview:hittingView];
    [self.view addSubview:fieldingView];
    _scrollView.contentSize = CGSizeMake(320, 568);
    [self.view addSubview:_scrollView];
    
    self.view.backgroundColor = [UIColor colorWithRed:252.0f / 255.0f green:31.0f / 255.0f blue:10.0f / 255.0f alpha:1.0f];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Arial" size:17.0], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.destinationViewController isKindOfClass:[EditPlayerViewController class]])
    {
        if([segue.identifier isEqualToString:@"toEditPlayer"])
        {
            EditPlayerViewController *editPlayer = segue.destinationViewController;
//            editPlayer.firstName = _player[@"FirstName"];
//            editPlayer.lastName = _player[@"LastName"];
//            editPlayer.weight = [_player[@"Weight"]intValue];
//            editPlayer.height = _player[@"height"];
//            editPlayer.armStrength = [_player[@"ArmStrength"]intValue];
//            editPlayer.armAccuracy = [_player[@"ArmAccuracy"]intValue];
//            editPlayer.fielding = [_player[@"Fielding"]intValue];
//            editPlayer.hitting = [_player[@"Hitting"]intValue];
//            editPlayer.power = [_player[@"Power"]intValue];
//            editPlayer.position = _player[@"Position"];
//            editPlayer.throws = _player[@"Throws"];
//            editPlayer.bats = _player[@"Bats"];
        }
    }
}

- (IBAction)editPlayer:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"toEditPlayer" sender:self];
}

- (IBAction)backToSearch:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
