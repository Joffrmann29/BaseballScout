//
//  AddPlayerViewController.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 9/9/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import "AddPlayerViewController.h"
#import "MBProgressHUD.h"
#import "Gradients.h"
#import "CustomTextFieldAppearance.h"
#import "LayerViewObjects.h"
#import "GeneralUI.h"
#import "BackgroundLayer.h"

@interface AddPlayerViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSArray *recordArray;
@property (strong, nonatomic) NSArray *pickerFeetArray;
@property (strong, nonatomic) NSArray *pickerInchesArray;
@property (strong, nonatomic) UITextField *firstNameField;
@property (strong, nonatomic) UITextField *lastNameField;
@property (strong, nonatomic) UITextField *armStrengthField;
@property (strong, nonatomic) UITextField *fieldingPctField;
@property (strong, nonatomic) UITextField *hittingField;
@property (strong, nonatomic) UITextField *powerField;
@property (strong, nonatomic) UITextField *armAccuracyField;
@property (strong, nonatomic) UITextField *weightField;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UISegmentedControl *positionSegControl;
@property (strong, nonatomic) UISegmentedControl *batSegmentedControl;
@property (strong, nonatomic) UISegmentedControl *throwSegmentedControl;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) UILabel *positionLabel;
@property (strong, nonatomic) UILabel *throwLabel;
@property (strong, nonatomic) UILabel *batLabel;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) UILabel *heightLabel;
@property (strong, nonatomic) IBOutlet UIView *containerView;

- (IBAction)add:(UIBarButtonItem *)sender;
@end

@implementation AddPlayerViewController
UIColor *textfieldPlaceholderColor;
NSString *heightString;
UIImage *chosenImage;
UIImage *finalImage;
MBProgressHUD *hud;

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
    self.recordArray = [[NSArray alloc]initWithObjects:@"First Name", @"Last Name", @"Weight", @"Arm Strength", @"Arm Accuracy", @"Fielding", @"Hitting", @"Power", nil];
    self.pickerFeetArray = [[NSArray alloc]initWithObjects:@"5'", @"6'", @"7'", nil];
    self.pickerInchesArray = [[NSArray alloc]initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", nil];
    
    if(!_player) self.player = [PFObject objectWithClassName:@"Player"];
    NSLog(@"%@", _player[@"FirstName"]);
    [self drawTextFields];
    _scroll.delegate = self;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(30, 0, 260, 273)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 483, 320, 162)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNavBar:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    singleTap.delegate = self;
    [self.navBar addGestureRecognizer:singleTap];
    
    self.navBar.userInteractionEnabled = YES; //disabled by default
    [self drawUI];
    [self addLayerObjects];
    [self addSubviewsToScroll];
    _scroll.contentSize = CGSizeMake(320, 1000);
    _scroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scroll];
    
    CALayer * bgGradientLayer = [self gradientBGLayerForBounds:self.navBar.bounds];
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
    
    CAGradientLayer *scrollLayer = [BackgroundLayer greyGradient];
    scrollLayer.frame = self.scroll.bounds;
    [self.scroll.layer insertSublayer:scrollLayer atIndex:0];
    
    CALayer *containerLayer = [self gradientBGLayerForBounds:self.view.bounds];
    [self.view.layer insertSublayer:containerLayer atIndex:0];
    
    CAGradientLayer *tabLayer = [CAGradientLayer layer];
    tabLayer.frame = self.tabBarController.tabBar.bounds;
    tabLayer.colors = [NSArray arrayWithObjects:
                           (id)[[UIColor blackColor] CGColor],
                           (id)[[UIColor darkGrayColor] CGColor],
                           nil];
    [self.tabBarController.tabBar.layer insertSublayer:tabLayer atIndex:0];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Arial" size:17.0], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.firstNameField.textColor = [UIColor redColor];
    self.lastNameField.textColor = [UIColor redColor];
    self.weightField.textColor = [UIColor redColor];
    self.hittingField.textColor = [UIColor redColor];
    self.fieldingPctField.textColor = [UIColor redColor];
    self.armStrengthField.textColor = [UIColor redColor];
    self.armAccuracyField.textColor = [UIColor redColor];
    self.powerField.textColor = [UIColor redColor];
}

-(void)addLayerObjects
{
    [LayerViewObjects createLabelLayer:_positionLabel];
    [LayerViewObjects createLabelLayer:_throwLabel];
    [LayerViewObjects createLabelLayer:_batLabel];
    [LayerViewObjects createLabelLayer:_heightLabel];
    [LayerViewObjects createTableLayer:_tableView];
}

-(void)addSubviewsToScroll
{
    [_scroll addSubview:_tableView];
    [_scroll addSubview:self.pickerView];
    [_scroll addSubview:_positionSegControl];
    [_scroll addSubview:_batSegmentedControl];
    [_scroll addSubview:_throwSegmentedControl];
    [_scroll addSubview:_positionLabel];
    [_scroll addSubview:_throwLabel];
    [_scroll addSubview:_batLabel];
    [_scroll addSubview:_heightLabel];
}

-(void)drawUI
{
    _positionLabel = [GeneralUI drawPositionLabel];
    _throwLabel = [GeneralUI drawThrowingLabel];
    _batLabel = [GeneralUI drawBattingLabel];
    _heightLabel = [GeneralUI drawHeightLabel];
    _positionSegControl = [GeneralUI drawPositionSegmentedControl];
    _batSegmentedControl = [GeneralUI drawBatSegmentedControl];
    _throwSegmentedControl = [GeneralUI drawThrowSegmentedControl];
}

- (void)tapNavBar:(UITapGestureRecognizer *)recognizer {
    [self textFieldShouldReturn:self.weightField];
    [self textFieldShouldReturn:self.armStrengthField];
    [self textFieldShouldReturn:self.armAccuracyField];
    [self textFieldShouldReturn:self.fieldingPctField];
    [self textFieldShouldReturn:self.hittingField];
    [self textFieldShouldReturn:self.powerField];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
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
    chosenImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)showAction
{
    NSString *actionSheetTitle = @"Menu Options"; //Action Sheet Title
    NSString *addPlayer = @"Add Player";
    NSString *selectPhoto = @"Select Photo";
    NSString *takePicture = @"Take Picture";
    NSString *addPitcher = @"Add Pitcher";
    NSString *cancelTitle = @"Cancel Button";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                        initWithTitle:actionSheetTitle
                        delegate:self
                        cancelButtonTitle:cancelTitle
                        destructiveButtonTitle:addPlayer
                        otherButtonTitles:selectPhoto,takePicture, addPitcher, nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        if(chosenImage)
        {
            if(self.firstNameField.text.length != 0 || self.lastNameField.text.length != 0 || self.weightField.text.length != 0 || self.armStrengthField.text.length != 0 || self.armAccuracyField.text.length != 0 || self.fieldingPctField.text.length != 0 || self.hittingField.text.length != 0 || self.powerField.text.length != 0)
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

-(void)didAddPlayer
{
        _player[@"FirstName"] = self.firstNameField.text;
        _player[@"LastName"] = self.lastNameField.text;
        _player[@"height"] = heightString;
        _player[@"Weight"] = [NSNumber numberWithInt:[self.weightField.text intValue]];
        _player[@"ArmStrength"] = [NSNumber numberWithInt:[self.armStrengthField.text intValue]];
        _player[@"ArmAccuracy"] = [NSNumber numberWithInt:[self.armAccuracyField.text intValue]];
        _player[@"Fielding"] = [NSNumber numberWithInt:[self.fieldingPctField.text intValue]];
        _player[@"Hitting"] = [NSNumber numberWithInt:[self.hittingField.text intValue]];
        _player[@"Power"] = [NSNumber numberWithInt:[self.powerField.text intValue]];
    
        NSString *user = [PFUser currentUser].username;
        [_player setObject:user forKey:@"scout"];
    
    if(_batSegmentedControl.selectedSegmentIndex == 0)
    {
        _player[@"Bats"] = [_batSegmentedControl titleForSegmentAtIndex:0];
    }
    
    else if(_batSegmentedControl.selectedSegmentIndex == 1)
    {
        _player[@"Bats"] = [_batSegmentedControl titleForSegmentAtIndex:1];
    }
    
    if(_throwSegmentedControl.selectedSegmentIndex == 0)
    {
        _player[@"Throws"] = [_throwSegmentedControl titleForSegmentAtIndex:0];
    }
    
    else if(_throwSegmentedControl.selectedSegmentIndex == 1)
    {
        _player[@"Throws"] = [_throwSegmentedControl titleForSegmentAtIndex:1];
    }
    
    if(_positionSegControl.selectedSegmentIndex == 0)
    {
        _player[@"Position"] = [_positionSegControl titleForSegmentAtIndex:0];
    }
    
    else if(_positionSegControl.selectedSegmentIndex == 1)
    {
        _player[@"Position"] = [_positionSegControl titleForSegmentAtIndex:1];
    }
    
    else if(_positionSegControl.selectedSegmentIndex == 2)
    {
        _player[@"Position"] = [_positionSegControl titleForSegmentAtIndex:2];
    }
    
    else if(_positionSegControl.selectedSegmentIndex == 3)
    {
        _player[@"Position"] = [_positionSegControl titleForSegmentAtIndex:3];
    }
    
    else if(_positionSegControl.selectedSegmentIndex == 3)
    {
        _player[@"Position"] = [_positionSegControl titleForSegmentAtIndex:3];
    }
    
    else if(_positionSegControl.selectedSegmentIndex == 4)
    {
        _player[@"Position"] = [_positionSegControl titleForSegmentAtIndex:4];
    }
    
    else if(_positionSegControl.selectedSegmentIndex == 5)
    {
        _player[@"Position"] = [_positionSegControl titleForSegmentAtIndex:5];
    }
    
    else if(_positionSegControl.selectedSegmentIndex == 6)
    {
        _player[@"Position"] = [_positionSegControl titleForSegmentAtIndex:6];
    }
    
    else if(_positionSegControl.selectedSegmentIndex == 7)
    {
        _player[@"Position"] = [_positionSegControl titleForSegmentAtIndex:7];
    }
    
    else if(_positionSegControl.selectedSegmentIndex == 8)
    {
        _player[@"Position"] = [_positionSegControl titleForSegmentAtIndex:8];
    }
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 1.0);
    _player[@"PlayerImage"] = [self uploadImage:imageData];
    [_player saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            [hud hide:YES];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Player Added" message:@"The player has been successfuly added to your scouting list." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
        }
        else if(!succeeded)
        {
            [hud hide:YES];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Player cannot be added at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
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
            [_player setObject:imageFile forKey:@"PlayerImage"];
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    return imageFile;
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0){
        return _pickerFeetArray.count;
    }
    
    else{
        return _pickerInchesArray.count;
    }
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    [pickerView setTintColor:[UIColor blueColor]];
    if(component == 0){
        return _pickerFeetArray[row];
    }
    
    else if(component == 1){
        return _pickerInchesArray[row];
    }
    else return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    heightString = [NSString stringWithFormat: @"%@%@", [_pickerFeetArray objectAtIndex:[_pickerView selectedRowInComponent:0]],[_pickerInchesArray objectAtIndex:[_pickerView selectedRowInComponent:1]]];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    if(component == 0){
        title = [NSString stringWithFormat:@"%@", _pickerFeetArray[row]];
    }
    
    else{
        title = [NSString stringWithFormat:@"%@", _pickerInchesArray[row]];
    }
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}

-(void)drawTextFields
{
    CustomTextFieldAppearance *appearance = [[CustomTextFieldAppearance alloc]init];
    _firstNameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 260, 30)];
    _lastNameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 260, 30)];
    _armStrengthField = [appearance changeTextFieldAppearance];
    _armAccuracyField = [appearance changeTextFieldAppearance];
    _fieldingPctField = [appearance changeTextFieldAppearance];
    _hittingField = [appearance changeTextFieldAppearance];
    _powerField = [appearance changeTextFieldAppearance];
    _weightField = [appearance changeTextFieldAppearance];
    
    _firstNameField.delegate = self;
    _lastNameField.delegate = self;
    _armStrengthField.delegate = self;
    _armAccuracyField.delegate = self;
    _fieldingPctField.delegate = self;
    _hittingField.delegate = self;
    _fieldingPctField.delegate = self;
    _powerField.delegate = self;
    _weightField.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

- (void)didReceiveMemoryWarning
{
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
    return [self.recordArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PlayerCell";
    PlayerTableViewCell *cell = [[PlayerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    // Configure the cell...
    NSString *attribute = self.recordArray[indexPath.row];
    
    if(indexPath.row == 0){
        [cell.contentView addSubview:_firstNameField];
        _firstNameField.placeholder = attribute;
        _firstNameField.textAlignment = NSTextAlignmentCenter;
        _firstNameField.borderStyle = UITextBorderStyleNone;
        [_firstNameField setBackgroundColor:[UIColor clearColor]];
        if(_player) cell.textLabel.text = _player[@"FirstName"];
    }
    
    else if(indexPath.row == 1){
        [cell.contentView addSubview:_lastNameField];
        _lastNameField.placeholder = attribute;
        _lastNameField.textAlignment = NSTextAlignmentCenter;
        _lastNameField.borderStyle = UITextBorderStyleNone;
        [_lastNameField setBackgroundColor:[UIColor clearColor]];
    }
    
    else if(indexPath.row == 2){
        [cell.contentView addSubview:_weightField];
        _weightField.placeholder = attribute;
        _weightField.textAlignment = NSTextAlignmentCenter;
        _weightField.borderStyle = UITextBorderStyleNone;
        [_weightField setBackgroundColor:[UIColor clearColor]];
    }
    
    else if(indexPath.row == 3){
        [cell.contentView addSubview:_armStrengthField];
        _armStrengthField.placeholder = attribute;
        _armStrengthField.textAlignment = NSTextAlignmentCenter;
        _armStrengthField.borderStyle = UITextBorderStyleNone;
        [_armStrengthField setBackgroundColor:[UIColor clearColor]];
    }
    
    else if(indexPath.row == 4){
        [cell.contentView addSubview:_armAccuracyField];
        _armAccuracyField.placeholder = attribute;
        _armAccuracyField.textAlignment = NSTextAlignmentCenter;
        _armAccuracyField.borderStyle = UITextBorderStyleNone;
        [_armAccuracyField setBackgroundColor:[UIColor clearColor]];
    }
    
    else if(indexPath.row == 5){
        [cell.contentView addSubview:_fieldingPctField];
        _fieldingPctField.placeholder = attribute;
        _fieldingPctField.textAlignment = NSTextAlignmentCenter;
        _fieldingPctField.borderStyle = UITextBorderStyleNone;
        [_fieldingPctField setBackgroundColor:[UIColor clearColor]];
    }
    
    else if(indexPath.row == 6){
        [cell.contentView addSubview:_hittingField];
        _hittingField.placeholder = attribute;
        _hittingField.textAlignment = NSTextAlignmentCenter;
        _hittingField.borderStyle = UITextBorderStyleNone;
        [_hittingField setBackgroundColor:[UIColor clearColor]];
    }
    
    else if(indexPath.row == 7){
        [cell.contentView addSubview:_powerField];
        _powerField.placeholder = attribute;
        _powerField.textAlignment = NSTextAlignmentCenter;
        _powerField.borderStyle = UITextBorderStyleNone;
        [_powerField setBackgroundColor:[UIColor clearColor]];
    }
    
    textfieldPlaceholderColor = [UIColor colorWithRed:42.0f / 255.0f green:92.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f];
    [_firstNameField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [_lastNameField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [_weightField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [_armStrengthField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [_armAccuracyField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [_fieldingPctField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [_hittingField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [_powerField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
}

- (CALayer *)gradientBGLayerForBounds:(CGRect)bounds
{
    CAGradientLayer * gradientBG = [CAGradientLayer layer];
    gradientBG.frame = bounds;
    gradientBG.colors = [NSArray arrayWithObjects:
                         (id)[[UIColor colorWithRed:42.0f / 255.0f green:92.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f] CGColor],
                         (id)[[UIColor colorWithRed:11.0f / 255.0f green:51.0f / 255.0f blue:101.0f / 255.0f alpha:1.0f] CGColor],
                         nil];
    return gradientBG;
}

- (IBAction)add:(UIBarButtonItem *)sender {
    [self showAction];
}

@end
