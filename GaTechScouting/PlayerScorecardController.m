//
//  PlayerScorecardController.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 9/17/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#define kOFFSET_FOR_KEYBOARD 64.0

#import "PlayerScorecardController.h"
#import "Gradients.h"
#import "EditPlayerViewController.h"
#import "BackgroundLayer.h"
#import <MessageUI/MessageUI.h>
#import "ImprovedChatViewController.h"

@interface PlayerScorecardController ()<MFMessageComposeViewControllerDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imgView;
- (IBAction)backToSearch:(UIBarButtonItem *)sender;
- (IBAction)composeText:(UIBarButtonItem *)sender;
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
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHide:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    singleTap.delegate = self;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:singleTap];
    
    // Do any additional setup after loading the view.
    UIView *attributeView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, 225)];
    
    CALayer *attrLayer = [self gradientBGLayerForBounds:attributeView.bounds];
    [attributeView.layer insertSublayer:attrLayer atIndex:0];
    
    UIImageView *playerView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 100, 100)];
    PFFile *file = _player[@"PlayerImage"];
    NSData *imageData = [file getData];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImage *finalImage = [self resizeImage:image];
    playerView.image = finalImage;
    playerView.layer.cornerRadius = 50;
    playerView.clipsToBounds = YES;
    [attributeView addSubview:playerView];
    self.imgView = playerView;
    
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
    
    UIView *hittingView = [[UIView alloc]initWithFrame:CGRectMake(0, 249, 320, 100)];
    
    UILabel *hittingLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 20, 160, 25)];
    hittingLabel.textColor = [UIColor blueColor];
    hittingLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    hittingLabel.text = @"Batting Info";
    [hittingView addSubview:hittingLabel];
    
    UILabel *hittingRatingLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 75, 20)];
    hittingRatingLabel.textColor = [UIColor blueColor];
    hittingRatingLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int hittingRating = [_player[@"Hitting"]intValue];
    hittingRatingLabel.text = [NSString stringWithFormat:@"Hitting:%i", hittingRating];
    [hittingView addSubview:hittingRatingLabel];
    
    UILabel *powerLabel = [[UILabel alloc]initWithFrame:CGRectMake(122, 50, 75, 20)];
    powerLabel.textColor = [UIColor blueColor];
    powerLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    int powerRating = [_player[@"Power"]intValue];
    powerLabel.text = [NSString stringWithFormat:@"Power:%i", powerRating];
    [hittingView addSubview:powerLabel];
    
    UILabel *battingLabel = [[UILabel alloc]initWithFrame:CGRectMake(235, 50, 75, 20)];
    battingLabel.textColor = [UIColor blueColor];
    battingLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    battingLabel.text = [NSString stringWithFormat:@"Bats:%@", _player[@"Bats"]];
    [hittingView addSubview:battingLabel];
    
    UIView *fieldingView = [[UIView alloc]initWithFrame:CGRectMake(0, 329, 320, 320)];
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
    
//    self.view.backgroundColor = [UIColor colorWithRed:42.0f / 255.0f green:92.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f];
}

-(void)showAction
{
    NSString *actionSheetTitle = @"Menu Options"; //Action Sheet Title
    NSString *addPlayer = @"Create Scout User";
    NSString *selectPhoto = @"Select Photo";
    NSString *takePicture = @"Take Picture";
    NSString *cancelTitle = @"Cancel Button";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:addPlayer
                                  otherButtonTitles:selectPhoto,takePicture, nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
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
    NSString *message = [NSString stringWithFormat:@"Check out %@, %@", player[@"FirstName"], player[@"LastName"]];
    
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

- (IBAction)backToSearch:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)composeText:(UIBarButtonItem *)sender
{
    //[self showSMS:self.player];
//    PFFile *theImage = [[PFUser currentUser] objectForKey:@"UserImage"];
//    [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//        UIImage *image = [UIImage imageWithData:data];
//        
//        ImprovedChatViewController *ivc = [ImprovedChatViewController messagesViewController];
//        ivc.matchedUser = _matchedUser;
//        ivc.matchedImage = self.imgView.image;
//        ivc.currentImage = image;
//        [self.navigationController pushViewController:ivc animated:YES];
//    }];
}

@end
