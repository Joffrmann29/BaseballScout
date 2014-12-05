//
//  PlayerRegistrationViewController.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 11/19/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//
#define kOFFSET_FOR_KEYBOARD 80.0
#import "PlayerRegistrationViewController.h"
#import "BackgroundLayer.h"
#import "MBProgressHUD.h"

@interface PlayerRegistrationViewController ()<UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextField *firstNameField;
@property (strong, nonatomic) UITextField *lastNameField;
@property (strong, nonatomic) UITextField *userField;
@property (strong, nonatomic) UITextField *passField;
@property (strong, nonatomic) UITextField *confirmPassField;
@property (strong, nonatomic) UITextField *emailField;
@property (strong, nonatomic) UITextField *teamField;
@property (strong, nonatomic) UIButton *registrationButton;
@property (strong, nonatomic) UIButton *backToLoginButton;
@property (strong, nonatomic) UIImage *chosenImage;

@end

@implementation PlayerRegistrationViewController
PFUser *newUser;
MBProgressHUD *hud;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.userField.delegate = self;
    self.passField.delegate = self;
    self.confirmPassField.delegate = self;
    self.emailField.delegate = self;
    self.teamField.delegate = self;
    
    CGRect titleRect = CGRectMake(110, 40, 100, 100);
    CGRect firstNameRect = CGRectMake(50, 160, 210, 30);
    CGRect lastNameRect = CGRectMake(50, 200, 210, 30);
    CGRect userRect = CGRectMake(50, 240, 210, 30);
    CGRect passRect = CGRectMake(50, 280, 210, 30);
    CGRect confirmRect = CGRectMake(50, 320, 210, 30);
    CGRect emailRect = CGRectMake(50, 360, 210, 30);
    CGRect teamRect = CGRectMake(50, 400, 210, 30);
    CGRect registrationRect = CGRectMake(30, 460, 260, 30);
    CGRect backRect = CGRectMake(50, 500, 210, 30);
    
    self.titleLabel = [[UILabel alloc]initWithFrame:titleRect];
    self.firstNameField = [[UITextField alloc]initWithFrame:firstNameRect];
    self.lastNameField = [[UITextField alloc]initWithFrame:lastNameRect];
    self.userField = [[UITextField alloc]initWithFrame:userRect];
    self.passField = [[UITextField alloc]initWithFrame:passRect];
    self.confirmPassField = [[UITextField alloc]initWithFrame:confirmRect];
    self.emailField = [[UITextField alloc]initWithFrame:emailRect];
    self.teamField = [[UITextField alloc]initWithFrame:teamRect];
    
    
    self.registrationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.registrationButton addTarget:self
                                action:@selector(addUser:)
                      forControlEvents:UIControlEventTouchUpInside];
    [self.registrationButton setTitle:@"Account Options" forState:UIControlStateNormal];
    [self.registrationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.registrationButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    self.registrationButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.registrationButton.frame = registrationRect;
    
    self.backToLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.backToLoginButton addTarget:self
                               action:@selector(back:)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.backToLoginButton setTitle:@"Back To Login" forState:UIControlStateNormal];
    [self.backToLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backToLoginButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    self.registrationButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.backToLoginButton.frame = backRect;
    
    UIImageView *playerView = [[UIImageView alloc]initWithFrame:titleRect];
    playerView.image = [UIImage imageNamed:@"GoMobileScout login screen.png"];
    [self.view addSubview:playerView];
    
    CALayer *btnRegLayer = [_registrationButton layer];
    [btnRegLayer setMasksToBounds:YES];
    [btnRegLayer setCornerRadius:10.0f];
    [btnRegLayer setBorderWidth:1.0f];
    [btnRegLayer setBorderColor:[[UIColor whiteColor]CGColor]];
    
    CAGradientLayer *blueLayer = [CAGradientLayer layer];
    blueLayer.frame = self.backToLoginButton.bounds;
    blueLayer.colors = [NSArray arrayWithObjects:
                        (id)[[UIColor colorWithRed:42.0f / 255.0f green:92.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f] CGColor],
                        (id)[[UIColor colorWithRed:11.0f / 255.0f green:51.0f / 255.0f blue:101.0f / 255.0f alpha:1.0f] CGColor],
                        nil];
    [self.backToLoginButton.layer insertSublayer:blueLayer atIndex:0];
    
    CAGradientLayer *blueRegLayer = [CAGradientLayer layer];
    blueRegLayer.frame = self.registrationButton.bounds;
    blueRegLayer.colors = [NSArray arrayWithObjects:
                           (id)[[UIColor colorWithRed:42.0f / 255.0f green:92.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f] CGColor],
                           (id)[[UIColor colorWithRed:11.0f / 255.0f green:51.0f / 255.0f blue:101.0f / 255.0f alpha:1.0f] CGColor],
                           nil];
    [self.registrationButton.layer insertSublayer:blueRegLayer atIndex:0];
    
    CALayer *btnLogLayer = [_backToLoginButton layer];
    [btnLogLayer setMasksToBounds:YES];
    [btnLogLayer setCornerRadius:10.0f];
    [btnLogLayer setBorderWidth:1.0f];
    [btnLogLayer setBorderColor:[[UIColor whiteColor]CGColor]];
    
    self.firstNameField.backgroundColor = [UIColor blackColor];
    self.lastNameField.backgroundColor = [UIColor blackColor];
    self.userField.backgroundColor = [UIColor blackColor];
    self.passField.backgroundColor = [UIColor blackColor];
    self.confirmPassField.backgroundColor = [UIColor blackColor];
    self.emailField.backgroundColor = [UIColor blackColor];
    self.teamField.backgroundColor = [UIColor blackColor];
    
    self.firstNameField.textColor = [UIColor whiteColor];
    self.lastNameField.textColor = [UIColor whiteColor];
    self.userField.textColor = [UIColor whiteColor];
    self.passField.textColor = [UIColor whiteColor];
    self.confirmPassField.textColor = [UIColor whiteColor];
    self.emailField.textColor = [UIColor whiteColor];
    self.teamField.textColor = [UIColor whiteColor];
    
    self.firstNameField.placeholder = @"First Name";
    self.lastNameField.placeholder = @"Last Name";
    self.userField.placeholder = @"Username";
    self.passField.placeholder = @"Password";
    self.confirmPassField.placeholder = @"Confirm Password";
    self.emailField.placeholder = @"E-mail";
    self.teamField.placeholder = @"Team";
    
    UIColor *textfieldPlaceholderColor = [UIColor darkGrayColor];
    [self.firstNameField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.lastNameField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.userField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.passField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.confirmPassField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.emailField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.teamField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    self.firstNameField.layer.cornerRadius = 10;
    self.lastNameField.layer.cornerRadius = 10;
    self.userField.layer.cornerRadius = 10;
    self.passField.layer.cornerRadius = 10;
    self.confirmPassField.layer.cornerRadius = 10;
    self.emailField.layer.cornerRadius = 10;
    self.registrationButton.layer.cornerRadius = 10;
    self.teamField.layer.cornerRadius = 10;
    
    self.firstNameField.textAlignment = NSTextAlignmentCenter;
    self.lastNameField.textAlignment = NSTextAlignmentCenter;
    self.userField.textAlignment = NSTextAlignmentCenter;
    self.passField.textAlignment = NSTextAlignmentCenter;
    self.confirmPassField.textAlignment = NSTextAlignmentCenter;
    self.emailField.textAlignment = NSTextAlignmentCenter;
    self.teamField.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel.text = @"Create Your ScoutOnTheGo Account";
    self.titleLabel.textColor = [UIColor darkTextColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.shadowColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 0;
    
    [self.view addSubview:self.firstNameField];
    [self.view addSubview:self.lastNameField];
    [self.view addSubview:self.userField];
    [self.view addSubview:self.passField];
    [self.view addSubview:self.confirmPassField];
    [self.view addSubview:self.emailField];
    [self.view addSubview:self.teamField];
    [self.view addSubview:self.registrationButton];
    [self.view addSubview:self.backToLoginButton];
    [self.view addSubview:self.titleLabel];
    [self.passField setSecureTextEntry:YES];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismissKeyboard:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
    
    [self.firstNameField addTarget:self
                            action:@selector(textFieldDidChange)
                  forControlEvents:UIControlEventEditingDidBegin];
    
    [self.lastNameField addTarget:self
                           action:@selector(textFieldDidChange)
                 forControlEvents:UIControlEventEditingDidBegin];
    
    [self.userField addTarget:self
                       action:@selector(textFieldDidChange)
             forControlEvents:UIControlEventEditingDidBegin];
    
    [self.passField addTarget:self
                       action:@selector(textFieldDidChange)
             forControlEvents:UIControlEventEditingDidBegin];
    
    [self.confirmPassField addTarget:self
                              action:@selector(textFieldDidChange)
                    forControlEvents:UIControlEventEditingDidBegin];
    
    [self.emailField addTarget:self
                        action:@selector(textFieldDidChange)
              forControlEvents:UIControlEventEditingDidBegin];
    
    //    [self.userTypeField addTarget:self
    //                        action:@selector(textFieldDidChange)
    //              forControlEvents:UIControlEventEditingDidBegin];
    
    [self.teamField addTarget:self
                        action:@selector(textFieldDidChange)
              forControlEvents:UIControlEventEditingDidBegin];
}

- (void)tapToDismissKeyboard:(UITapGestureRecognizer *)recognizer {
    [self resignKeyboard];
}

-(void)textFieldDidChange
{
    //move the main view, so that the keyboard does not hide it.
    if  (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
}

-(void)keyboardWillShow {
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

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
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


-(void)resignKeyboard
{
    [self.firstNameField resignFirstResponder];
    [self.lastNameField resignFirstResponder];
    [self.userField resignFirstResponder];
    [self.passField resignFirstResponder];
    [self.confirmPassField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.teamField resignFirstResponder];
    
    if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAction
{
    NSString *actionSheetTitle = @"Menu Options"; //Action Sheet Title
    NSString *addPlayer = @"Create Player User";
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
    if(buttonIndex == 0)
    {
        if(self.chosenImage)
        {
            if(self.firstNameField.text.length != 0 || self.lastNameField.text.length != 0 || self.userField.text.length != 0 || self.passField.text.length != 0 || self.confirmPassField.text.length != 0 || self.emailField.text.length != 0 || self.teamField.text.length != 0)
            {
                [self didAddPlayer];
            }
        }
        
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must complete all of the required fields and select a photo for your player to be added." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
        }
    }
    
    else if(buttonIndex == 1)
    {
        [self addPicture];
    }
    
    else if(buttonIndex == 2)
    {
        [self takePicture];
    }
}

- (void)addPicture
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)takePicture
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.chosenImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)didAddPlayer
{
    newUser = [PFUser user];
    newUser.username = self.userField.text;
    newUser.password = self.passField.text;
    newUser[@"FirstName"] = self.firstNameField.text;
    newUser[@"LastName"] = self.lastNameField.text;
    newUser[@"email"] = self.emailField.text;
    newUser[@"ConfirmPassword"] = self.confirmPassField.text;
    newUser[@"Team"] = self.teamField.text;
    newUser[@"UserType"] = @"Player";
    NSData *imageData = UIImageJPEGRepresentation(self.chosenImage, 1.0);
    newUser[@"UserImage"] = [self uploadImage:imageData];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error){
                [self dismissViewControllerAnimated:YES completion:^{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Your Player account has been successfully created" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    [hud hide:YES];
                }];
            }
            else{
                NSLog(@"%@", error);
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
                [hud hide:YES];
            }
        }];
}

-(PFFile *)uploadImage:(NSData *)imageData
{
    PFFile *imageFile = [PFFile fileWithName:@"file.jpg" data:imageData];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            // Create a PFObject around a PFFile and associate it with the current user
            [newUser setObject:imageFile forKey:@"PlayerImage"];
            
            /*[player saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
             if (!error)
             {
             //[self refresh:nil];
             }
             else
             {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
             }
             }];*/
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    return imageFile;
}

- (IBAction)addUser:(UIButton *)sender
{
    [self showAction];
}

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
