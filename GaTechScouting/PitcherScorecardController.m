//
//  PitcherScorecardController.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 9/29/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import "PitcherScorecardController.h"
#import "Gradients.h"

@interface PitcherScorecardController ()

@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)backToSearch:(UIBarButtonItem *)sender;
@end

@implementation PitcherScorecardController

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
    
    UIImageView *pitcherView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 40, 100, 100)];
    PFFile *file = _pitcher[@"PlayerImage"];
    NSData *imageData = [file getData];
    pitcherView.image = [UIImage imageWithData:imageData];
    [attributeView addSubview:pitcherView];
    
    UILabel *attributeHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(115, 0, 160, 30)];
    attributeHeaderLabel.textColor = [UIColor whiteColor];
    attributeHeaderLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    attributeHeaderLabel.text = @"Attributes";
    [attributeView addSubview:attributeHeaderLabel];
    
    UILabel *firstNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 50, 170, 40)];
    firstNameLabel.textColor = [UIColor whiteColor];
    firstNameLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    firstNameLabel.text = [NSString stringWithFormat:@"First Name: %@",_pitcher[@"FirstName"]];
    [attributeView addSubview:firstNameLabel];
    
    UILabel *lastNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 100, 170, 40)];
    lastNameLabel.textColor = [UIColor whiteColor];
    lastNameLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    lastNameLabel.text = [NSString stringWithFormat:@"Last Name: %@",_pitcher[@"LastName"]];
    [attributeView addSubview:lastNameLabel];
    
    UILabel *heightLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 150, 130, 40)];
    heightLabel.textColor = [UIColor whiteColor];
    heightLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    heightLabel.text = [NSString stringWithFormat:@"Height: %@",_pitcher[@"Height"]];
    [attributeView addSubview:heightLabel];
    
    UILabel *weightLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 150, 130, 40)];
    weightLabel.textColor = [UIColor whiteColor];
    weightLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int weightInt = [_pitcher[@"Weight"]intValue];
    weightLabel.text = [NSString stringWithFormat:@"Weight: %i",weightInt];
    [attributeView addSubview:weightLabel];
    
    UIView *pitchingView = [[UIView alloc]initWithFrame:CGRectMake(0, 239, 320, 328)];
    //fieldingView.backgroundColor = [UIColor blueColor];
    
    UILabel *pitchingLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 160, 30)];
    pitchingLabel.textColor = [UIColor redColor];
    pitchingLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    pitchingLabel.text = @"Fielding";
    [pitchingView addSubview:pitchingLabel];
    
    UILabel *armSlotLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 140, 40)];
    armSlotLabel.textColor = [UIColor redColor];
    armSlotLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    armSlotLabel.text = [NSString stringWithFormat:@"Arm Slot: %@",_pitcher[@"ArmSlot"]];
    [pitchingView addSubview:armSlotLabel];
    
    UILabel *controlLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 40, 120, 40)];
    controlLabel.textColor = [UIColor redColor];
    controlLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int control = [_pitcher[@"Control"]intValue];
    controlLabel.text = [NSString stringWithFormat:@"Control: %i", control];
    [pitchingView addSubview:controlLabel];
    
    UILabel *movementLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 140, 40)];
    movementLabel.textColor = [UIColor redColor];
    movementLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int movement = [_pitcher[@"Movement"]intValue];
    movementLabel.text = [NSString stringWithFormat:@"Movement: %i", movement];
    [pitchingView addSubview:movementLabel];
    
    UILabel *fastballLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 80, 120, 40)];
    fastballLabel.textColor = [UIColor redColor];
    fastballLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int fastball = [_pitcher[@"Fastball"]intValue];
    fastballLabel.text = [NSString stringWithFormat:@"Fastball: %i", fastball];
    [pitchingView addSubview:fastballLabel];
    
    UILabel *curveLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, 140, 40)];
    curveLabel.textColor = [UIColor redColor];
    curveLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int curve = [_pitcher[@"Curveball"]intValue];
    curveLabel.text = [NSString stringWithFormat:@"Curveball: %i", curve];
    [pitchingView addSubview:curveLabel];
    
    UILabel *sliderLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 120, 120, 40)];
    sliderLabel.textColor = [UIColor redColor];
    sliderLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int slider = [_pitcher[@"Slider"]intValue];
    sliderLabel.text = [NSString stringWithFormat:@"Slider: %i", slider];
    [pitchingView addSubview:sliderLabel];
    
    UILabel *changeupLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, 140, 40)];
    changeupLabel.textColor = [UIColor redColor];
    changeupLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int change = [_pitcher[@"Changeup"]intValue];
    changeupLabel.text = [NSString stringWithFormat:@"Changeup: %i", change];
    [pitchingView addSubview:changeupLabel];
    
    UILabel *otherLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 160, 140, 40)];
    otherLabel.textColor = [UIColor redColor];
    otherLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    otherLabel.text = [NSString stringWithFormat:@"Other: %@",_pitcher[@"Other"]];
    [pitchingView addSubview:otherLabel];
    
    UILabel *commentsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, 160, 40)];
    commentsLabel.textColor = [UIColor redColor];
    commentsLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    commentsLabel.text = @"Comments";
    [pitchingView addSubview:commentsLabel];
    
    UITextView *commentsView = [[UITextView alloc]initWithFrame:CGRectMake(0, 240, 320, 90)];
    //commentsView.textColor = [UIColor redColor];
    commentsView.editable = NO;
    commentsView.backgroundColor = [UIColor grayColor];
    commentsView.font = [UIFont fontWithName:@"Helvetica" size:17];
    commentsView.text = _pitcher[@"Comments"];
    [pitchingView addSubview:commentsView];
    
    CAGradientLayer *pitchGradient = [grad blueGradient];
    pitchGradient.frame = pitchingView.bounds;
    [pitchingView.layer insertSublayer:pitchGradient atIndex:0];
    
    [self.view addSubview:attributeView];
    [self.view addSubview:pitchingView];
    _scrollView.contentSize = CGSizeMake(320, 568);
    [self.view addSubview:_scrollView];
    
    [self.navBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Helvetica" size:17],
      NSFontAttributeName, nil]];
    
    NSLog(@"%@, %@", _pitcher[@"LastName"], _pitcher[@"FirstName"]);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}


- (IBAction)backToSearch:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
