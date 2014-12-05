//
//  PitcherScorecardController.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 9/29/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#define kOFFSET_FOR_KEYBOARD 64.0
#import "PitcherScorecardController.h"
#import "Gradients.h"
#import <MessageUI/MessageUI.h>

@interface PitcherScorecardController ()<MFMessageComposeViewControllerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)backToSearch:(UIBarButtonItem *)sender;
- (IBAction)composeText:(UIBarButtonItem *)sender;
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
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHide:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    singleTap.delegate = self;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:singleTap];
    
    UIView *attributeView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 320, 195)];
    
    Gradients *grad = [[Gradients alloc]init];
    CAGradientLayer *attrGradient = [grad redGradient];
    attrGradient.frame = attributeView.bounds;
    [attributeView.layer insertSublayer:attrGradient atIndex:0];
    
    UIImageView *pitcherView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 40, 100, 100)];
    PFFile *file = _pitcher[@"PlayerImage"];
    NSData *imageData = [file getData];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImage *finalImage = [self resizeImage:image];
    pitcherView.image = finalImage;
    pitcherView.layer.cornerRadius = 50;
    pitcherView.clipsToBounds = YES;
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
    
    UIView *pitchingView = [[UIView alloc]initWithFrame:CGRectMake(0, 259, 320, 392)];
    
    UILabel *pitchingLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 160, 30)];
    pitchingLabel.textColor = [UIColor colorWithRed:252.0f / 255.0f green:31.0f / 255.0f blue:10.0f / 255.0f alpha:1.0f];;
    pitchingLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    pitchingLabel.text = @"Pitching";
    [pitchingView addSubview:pitchingLabel];
    
    UILabel *armSlotLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 140, 40)];
    armSlotLabel.textColor = [UIColor colorWithRed:252.0f / 255.0f green:31.0f / 255.0f blue:10.0f / 255.0f alpha:1.0f];;
    armSlotLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    armSlotLabel.text = [NSString stringWithFormat:@"Arm Slot: %@",_pitcher[@"ArmSlot"]];
    armSlotLabel.numberOfLines = 0;
    [pitchingView addSubview:armSlotLabel];
    
    UILabel *controlLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 40, 120, 40)];
    controlLabel.textColor = [UIColor colorWithRed:252.0f / 255.0f green:31.0f / 255.0f blue:10.0f / 255.0f alpha:1.0f];;
    controlLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int control = [_pitcher[@"Control"]intValue];
    controlLabel.text = [NSString stringWithFormat:@"Control: %i", control];
    [pitchingView addSubview:controlLabel];
    
    UILabel *movementLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 140, 40)];
    movementLabel.textColor = [UIColor colorWithRed:252.0f / 255.0f green:31.0f / 255.0f blue:10.0f / 255.0f alpha:1.0f];;
    movementLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int movement = [_pitcher[@"Movement"]intValue];
    movementLabel.text = [NSString stringWithFormat:@"Movement: %i", movement];
    [pitchingView addSubview:movementLabel];
    
    UILabel *fastballLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 80, 120, 40)];
    fastballLabel.textColor = [UIColor colorWithRed:252.0f / 255.0f green:31.0f / 255.0f blue:10.0f / 255.0f alpha:1.0f];;
    fastballLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int fastball = [_pitcher[@"Fastball"]intValue];
    fastballLabel.text = [NSString stringWithFormat:@"Fastball: %i", fastball];
    [pitchingView addSubview:fastballLabel];
    
    UILabel *curveLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, 140, 40)];
    curveLabel.textColor = [UIColor colorWithRed:252.0f / 255.0f green:31.0f / 255.0f blue:10.0f / 255.0f alpha:1.0f];;
    curveLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int curve = [_pitcher[@"Curveball"]intValue];
    curveLabel.text = [NSString stringWithFormat:@"Curveball: %i", curve];
    [pitchingView addSubview:curveLabel];
    
    UILabel *sliderLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 120, 120, 40)];
    sliderLabel.textColor = [UIColor colorWithRed:252.0f / 255.0f green:31.0f / 255.0f blue:10.0f / 255.0f alpha:1.0f];;
    sliderLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int slider = [_pitcher[@"Slider"]intValue];
    sliderLabel.text = [NSString stringWithFormat:@"Slider: %i", slider];
    [pitchingView addSubview:sliderLabel];
    
    UILabel *changeupLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, 140, 40)];
    changeupLabel.textColor = [UIColor colorWithRed:252.0f / 255.0f green:31.0f / 255.0f blue:10.0f / 255.0f alpha:1.0f];;
    changeupLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int change = [_pitcher[@"Changeup"]intValue];
    changeupLabel.text = [NSString stringWithFormat:@"Changeup: %i", change];
    [pitchingView addSubview:changeupLabel];
    
    UILabel *otherLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 160, 140, 40)];
    otherLabel.textColor = [UIColor colorWithRed:252.0f / 255.0f green:31.0f / 255.0f blue:10.0f / 255.0f alpha:1.0f];;
    otherLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    if(![_pitcher[@"Other"] isEqualToString:@""]){
        otherLabel.text = [NSString stringWithFormat:@"Other: %@",_pitcher[@"Other"]];
    }
    
    else{
        NSString *notApplicable = @"N/A";
        otherLabel.text = [NSString stringWithFormat:@"Other: %@",notApplicable];
    }
    [pitchingView addSubview:otherLabel];
    
    UILabel *commentsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, 310, 40)];
    commentsLabel.textColor = [UIColor colorWithRed:252.0f / 255.0f green:31.0f / 255.0f blue:10.0f / 255.0f alpha:1.0f];;
    commentsLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    commentsLabel.text = [NSString stringWithFormat:@"Comments: %@", _pitcher[@"Comments"]];
    commentsLabel.numberOfLines = 0;
    [pitchingView addSubview:commentsLabel];
    
    CAGradientLayer *pitchGradient = [grad blueGradient];
    pitchGradient.frame = pitchingView.bounds;
    [pitchingView.layer insertSublayer:pitchGradient atIndex:0];
    
    [self.view addSubview:attributeView];
    [self.view addSubview:pitchingView];
    _scrollView.contentSize = CGSizeMake(320, 568);
    [self.view addSubview:_scrollView];
        
    self.view.backgroundColor = [UIColor colorWithRed:42.0f / 255.0f green:92.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f];
}

-(UIImage *)resizeImage:(UIImage *)image
{
    CGRect rect = CGRectMake(0, 0, 100, 100);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *transformedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imgData = UIImagePNGRepresentation(transformedImage);
    UIImage *finalImage = [UIImage imageWithData:imgData];
    
    return finalImage;
}

- (void)showSMS:(PFObject *)player {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    //NSArray *recipents = @[@"12345678", @"72345524"];
    NSString *message = [NSString stringWithFormat:@"Check out %@ %@", player[@"FirstName"], player[@"LastName"]];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:nil];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self setNeedsStatusBarAppearanceUpdate];
        [messageController setNeedsStatusBarAppearanceUpdate];
        
    }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)navBarWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)navBarWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)tapToHide:(UITapGestureRecognizer *)tap
{
    //move the main view, so that the keyboard does not hide it.
    if  (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    
    else
    {
        [self setViewMovedUp:NO];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}


- (IBAction)backToSearch:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)composeText:(UIBarButtonItem *)sender
{
    [self showSMS:self.pitcher];
}

@end
