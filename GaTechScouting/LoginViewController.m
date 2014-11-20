//
//  LoginViewController.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 10/10/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//
#define kOFFSET_FOR_KEYBOARD 80.0
#import "LoginViewController.h"
#import "BackgroundLayer.h"

@interface LoginViewController ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UITextField *userField;
@property (strong, nonatomic) UITextField *passField;
@property (strong, nonatomic) UILabel *headLabel;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *registrationButton;
@property (strong, nonatomic) UIButton *registerAsPlayerButton;

@end

@implementation LoginViewController

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
    
    self.userField.delegate = self;
    self.passField.delegate = self;
    
    CGRect userRect = CGRectMake(50, 160, 210, 30);
    CGRect passRect = CGRectMake(50, 220, 210, 30);
    CGRect titleRect = CGRectMake(50, 60, 220, 30);
    CGRect loginRect = CGRectMake(60, 320, 200, 30);
    CGRect registerRect = CGRectMake(60, 380, 200, 30);
    CGRect registerAsPlayerRect = CGRectMake(60, 440, 200, 30);
    
    self.userField = [[UITextField alloc]initWithFrame:userRect];
    self.passField = [[UITextField alloc]initWithFrame:passRect];
    [self.passField setSecureTextEntry:YES];
    
    [self.userField addTarget:self
                  action:@selector(textFieldDidChange)
        forControlEvents:UIControlEventEditingDidBegin];
    
    [self.passField addTarget:self
                       action:@selector(textFieldDidChange)
             forControlEvents:UIControlEventEditingDidBegin];
    
    self.headLabel = [[UILabel alloc]initWithFrame:titleRect];
    self.headLabel.textColor = [UIColor darkTextColor];
    self.headLabel.textAlignment = NSTextAlignmentCenter;
    self.headLabel.shadowColor = [UIColor whiteColor];
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.loginButton addTarget:self
                         action:@selector(login:)
               forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleShadowColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    self.loginButton.frame = loginRect;
    
    self.registrationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.registrationButton addTarget:self
                         action:@selector(addScoutUser:)
               forControlEvents:UIControlEventTouchUpInside];
    [self.registrationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registrationButton setTitleShadowColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.registrationButton setTitle:@"Register As Scout" forState:UIControlStateNormal];
    self.registrationButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    self.registrationButton.frame = registerRect;
    
    self.registerAsPlayerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.registerAsPlayerButton addTarget:self
                                action:@selector(addPlayerUser:)
                      forControlEvents:UIControlEventTouchUpInside];
    [self.registerAsPlayerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registerAsPlayerButton setTitleShadowColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.registerAsPlayerButton setTitle:@"Register As Player" forState:UIControlStateNormal];
    self.registerAsPlayerButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    self.registerAsPlayerButton.frame = registerAsPlayerRect;
    
    self.userField.layer.cornerRadius = 10;
    self.passField.layer.cornerRadius = 10;
    
    self.userField.backgroundColor = [UIColor blackColor];
    self.passField.backgroundColor = [UIColor blackColor];
    self.userField.textColor = [UIColor whiteColor];
    self.passField.textColor = [UIColor whiteColor];
    
    self.userField.placeholder = @"Username";
    self.passField.placeholder = @"Password";
    self.headLabel.text = @"ScoutOnTheGo";
    
    self.userField.textAlignment = NSTextAlignmentCenter;
    self.passField.textAlignment = NSTextAlignmentCenter;
    
    UIColor *textfieldPlaceholderColor = [UIColor darkGrayColor];
    [self.userField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.passField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    CAGradientLayer * gradientBG = [CAGradientLayer layer];
    gradientBG.frame = self.view.bounds;
    gradientBG.colors = [NSArray arrayWithObjects:
                         (id)[[UIColor colorWithRed:252.0f / 255.0f green:31.0f / 255.0f blue:10.0f / 255.0f alpha:1.0f] CGColor],
                         (id)[[UIColor colorWithRed:195.0f / 255.0f green:17.0f / 255.0f blue:3.0f / 255.0f alpha:1.0f] CGColor],
                         (id)[[UIColor colorWithRed:195.0f / 255.0f green:17.0f / 255.0f blue:3.0f / 255.0f alpha:1.0f] CGColor],
                         (id)[[UIColor colorWithRed:252.0f / 255.0f green:31.0f / 255.0f blue:10.0f / 255.0f alpha:1.0f] CGColor],
                         (id)[[UIColor colorWithRed:252.0f / 255.0f green:31.0f / 255.0f blue:10.0f / 255.0f alpha:1.0f] CGColor],
                         (id)[[UIColor colorWithRed:195.0f / 255.0f green:17.0f / 255.0f blue:3.0f / 255.0f alpha:1.0f] CGColor],
                         nil];
    [self.view.layer insertSublayer:gradientBG atIndex:0];
    
    CAGradientLayer *bgLayer = [BackgroundLayer blueGradient];
    bgLayer.frame = self.loginButton.bounds;
    [self.loginButton.layer insertSublayer:bgLayer atIndex:0];
    
    CALayer *btnLayer = [_loginButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:10.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    CAGradientLayer *regLayer = [BackgroundLayer blueGradient];
    regLayer.frame = self.registrationButton.bounds;
    [self.registrationButton.layer insertSublayer:regLayer atIndex:0];
    self.registrationButton.layer.cornerRadius = 10;
    
    CALayer *btnRegLayer = [_registrationButton layer];
    [btnRegLayer setMasksToBounds:YES];
    [btnRegLayer setCornerRadius:10.0f];
    [btnRegLayer setBorderWidth:1.0f];
    [btnRegLayer setBorderColor:[[UIColor whiteColor]CGColor]];
    
    CAGradientLayer *playerLayer = [BackgroundLayer blueGradient];
    playerLayer.frame = self.registerAsPlayerButton.bounds;
    [self.registerAsPlayerButton.layer insertSublayer:playerLayer atIndex:0];
    
    CALayer *btnPlayerLayer = [_registerAsPlayerButton layer];
    [btnPlayerLayer setMasksToBounds:YES];
    [btnPlayerLayer setCornerRadius:10.0f];
    [btnPlayerLayer setBorderWidth:1.0f];
    [btnPlayerLayer setBorderColor:[[UIColor whiteColor]CGColor]];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismissKeyboard:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
    
    [self.view addSubview:self.userField];
    [self.view addSubview:self.passField];
    [self.view addSubview:self.headLabel];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registrationButton];
    [self.view addSubview:self.registerAsPlayerButton];
}

- (void)tapToDismissKeyboard:(UITapGestureRecognizer *)recognizer {
    [self resignKeyboard];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (IBAction)login:(UIButton *)sender
{
    [PFUser logInWithUsernameInBackground:self.userField.text password:self.passField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            //Open the wall
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"You have successfully logged in" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            if([user[@"UserType"] isEqualToString:@"Player"]){
                [self performSegueWithIdentifier:@"toScouts" sender:self];
            }
            else{
            [self performSegueWithIdentifier:@"toHome" sender:self];
            }
        } else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
    [self resignKeyboard];
}

- (IBAction)addScoutUser:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"toRegister" sender:self];
}

- (IBAction)addPlayerUser:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"toRegisterPlayer" sender:self];
}

-(void)resignKeyboard
{
    [self.userField resignFirstResponder];
    [self.passField resignFirstResponder];
    if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
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

-(void)textFieldDidChange
{
    //move the main view, so that the keyboard does not hide it.
    if  (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
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

@end
