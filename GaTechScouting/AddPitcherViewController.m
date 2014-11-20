//
//  AddPitcherViewController.m
//  GaTechScouting
//
//  Created by Joffrey Mann on 9/25/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import "AddPitcherViewController.h"
#import "MBProgressHUD.h"
#import "Gradients.h"
#import "CustomTextFieldAppearance.h"
#import "LayerViewObjects.h"
#import "GeneralUI.h"

@interface AddPitcherViewController ()<UIGestureRecognizerDelegate,UIPickerViewDelegate,UIPickerViewDataSource, UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) UITextField *firstNameField;
@property (strong, nonatomic) UITextField *lastNameField;
@property (strong, nonatomic) UITextField *classField;
@property (strong, nonatomic) UITextField *armSlotField;
@property (strong, nonatomic) UITextField *fastballField;
@property (strong, nonatomic) UITextField *curveballField;
@property (strong, nonatomic) UITextField *sliderField;
@property (strong, nonatomic) UITextField *changeupField;
@property (strong, nonatomic) UITextField *otherField;
@property (strong, nonatomic) UITextField *controlField;
@property (strong, nonatomic) UITextField *movementField;
@property (strong, nonatomic) UITextView *commentsView;
@property (strong, nonatomic) UITextField *weightField;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *recordArray;
@property (strong, nonatomic) NSArray *pickerFeetArray;
@property (strong, nonatomic) NSArray *pickerInchesArray;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) UILabel *heightLabel;
@property (strong, nonatomic) UILabel *commentsLabel;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
- (IBAction)addPitcher:(UIBarButtonItem *)sender;

@end

@implementation AddPitcherViewController
UIColor *textfieldPlaceholderColor;
NSString *heightString;
PFObject *pitcher;
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
    
    self.recordArray = [[NSArray alloc]initWithObjects:@"First Name", @"Last Name", @"Weight", @"Class", @"Arm Slot", @"Fastball", @"Curveball", @"Slider", @"Changeup", @"Other", @"Control", @"Movement", @"Remarks", nil];
    self.pickerFeetArray = [[NSArray alloc]initWithObjects:@"5", @"6", @"7", nil];
    self.pickerInchesArray = [[NSArray alloc]initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", nil];
    
    pitcher = [PFObject objectWithClassName:@"Pitcher"];
    [self drawTextFields];
    _scroll.delegate = self;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(30, 0, 260, 273)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 283, 320, 162)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.commentsView = [[UITextView alloc]initWithFrame:CGRectMake(20, 485, 280, 200)];
    self.commentsView.delegate = self;
    
    _heightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 303, 320, 25)];
    _heightLabel.backgroundColor = [UIColor clearColor];
    _heightLabel.textAlignment = NSTextAlignmentCenter;
    _heightLabel.textColor = [UIColor redColor];
    _heightLabel.text = @"Select Height";
    
    _commentsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 460, 320, 25)];
    _commentsLabel.backgroundColor = [UIColor clearColor];
    _commentsLabel.textAlignment = NSTextAlignmentCenter;
    _commentsLabel.textColor = [UIColor redColor];
    _commentsLabel.text = @"Comments";
    
    [self addSubviewsToScroll];
    [self addLayerObjects];
    _scroll.contentSize = CGSizeMake(320, 700);
    _scroll.backgroundColor = [UIColor clearColor];
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.weightField.delegate = self;
    self.changeupField.delegate = self;
    self.controlField.delegate = self;
    self.movementField.delegate = self;
    self.fastballField.delegate = self;
    self.curveballField.delegate = self;
    self.sliderField.delegate = self;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNavBar:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    singleTap.delegate = self;
    [self.navBar addGestureRecognizer:singleTap];
    
    self.navBar.userInteractionEnabled = YES; //disabled by default
}

-(void)addSubviewsToScroll
{
    [_scroll addSubview:_tableView];
    [_scroll addSubview:self.pickerView];
    [_scroll addSubview:_heightLabel];
    [_scroll addSubview:_commentsLabel];
    [_scroll addSubview:_commentsView];
}

-(void)addLayerObjects
{
    [LayerViewObjects createLabelLayer:_heightLabel];
    [LayerViewObjects createTableLayer:_tableView];
    [LayerViewObjects createTextLayer:_commentsView];
}

-(void)didAddPlayer
{
    pitcher[@"FirstName"] = self.firstNameField.text;
    pitcher[@"LastName"] = self.lastNameField.text;
    pitcher[@"Height"] = heightString;
    pitcher[@"Weight"] = [NSNumber numberWithInt:[self.weightField.text intValue]];
    pitcher[@"SchoolClass"] = [NSNumber numberWithInt:[self.classField.text intValue]];
    pitcher[@"ArmSlot"] = self.armSlotField.text;
    pitcher[@"Fastball"] = [NSNumber numberWithInt:[self.fastballField.text intValue]];
    pitcher[@"Curveball"] = [NSNumber numberWithInt:[self.curveballField.text intValue]];
    pitcher[@"Changeup"] = [NSNumber numberWithInt:[self.changeupField.text intValue]];
    pitcher[@"Slider"] = [NSNumber numberWithInt:[self.sliderField.text intValue]];
    pitcher[@"Other"] = self.otherField.text;
    pitcher[@"Control"] = [NSNumber numberWithInt:[self.controlField.text intValue]];
    pitcher[@"Movement"] = [NSNumber numberWithInt:[self.movementField.text intValue]];
    pitcher[@"Comments"] = self.commentsView.text;
 
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 1.0);
    pitcher[@"PlayerImage"] = [self uploadImage:imageData];
    [pitcher saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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

- (void)tapNavBar:(UITapGestureRecognizer *)recognizer {
    [self textFieldShouldReturn:self.weightField];
    [self textFieldShouldReturn:self.controlField];
    [self textFieldShouldReturn:self.fastballField];
    [self textFieldShouldReturn:self.curveballField];
    [self textFieldShouldReturn:self.sliderField];
    [self textFieldShouldReturn:self.changeupField];
    [self textFieldShouldReturn:self.movementField];
    [self textFieldShouldReturn:self.otherField];
}

-(PFFile *)uploadImage:(NSData *)imageData
{
    PFFile *imageFile = [PFFile fileWithName:@"file.jpg" data:imageData];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    return imageFile;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if(component == 0){
        return _pickerFeetArray[row];
    }
    
    else if(component == 1){
        return _pickerInchesArray[row];
    }
    else return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    heightString = [NSString stringWithFormat: @"%@'%@", [_pickerFeetArray objectAtIndex:[_pickerView selectedRowInComponent:0]],[_pickerInchesArray objectAtIndex:[_pickerView selectedRowInComponent:1]]];
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
        [cell.contentView addSubview:_classField];
        _classField.placeholder = attribute;
        _classField.textAlignment = NSTextAlignmentCenter;
        _classField.borderStyle = UITextBorderStyleNone;
        [_classField setBackgroundColor:[UIColor clearColor]];
    }
    
    else if(indexPath.row == 4){
        [cell.contentView addSubview:_armSlotField];
        _armSlotField.placeholder = attribute;
        _armSlotField.textAlignment = NSTextAlignmentCenter;
        _armSlotField.borderStyle = UITextBorderStyleNone;
        [_armSlotField setBackgroundColor:[UIColor clearColor]];
    }
    
    else if(indexPath.row == 5){
        [cell.contentView addSubview:_fastballField];
        _fastballField.placeholder = attribute;
        _fastballField.textAlignment = NSTextAlignmentCenter;
        _fastballField.borderStyle = UITextBorderStyleNone;
        [_fastballField setBackgroundColor:[UIColor clearColor]];
    }
    
    else if(indexPath.row == 6){
        [cell.contentView addSubview:_curveballField];
        _curveballField.placeholder = attribute;
        _curveballField.textAlignment = NSTextAlignmentCenter;
        _curveballField.borderStyle = UITextBorderStyleNone;
        [_curveballField setBackgroundColor:[UIColor clearColor]];
    }
    
    else if(indexPath.row == 7){
        [cell.contentView addSubview:_sliderField];
        _sliderField.placeholder = attribute;
        _sliderField.textAlignment = NSTextAlignmentCenter;
        _sliderField.borderStyle = UITextBorderStyleNone;
        [_sliderField setBackgroundColor:[UIColor clearColor]];
    }
    
    else if(indexPath.row == 8){
        [cell.contentView addSubview:_changeupField];
        _changeupField.placeholder = attribute;
        _changeupField.textAlignment = NSTextAlignmentCenter;
        _changeupField.borderStyle = UITextBorderStyleNone;
        [_changeupField setBackgroundColor:[UIColor clearColor]];
    }
    
    else if(indexPath.row == 9){
        [cell.contentView addSubview:_otherField];
        _otherField.placeholder = attribute;
        _otherField.textAlignment = NSTextAlignmentCenter;
        _otherField.borderStyle = UITextBorderStyleNone;
        [_otherField setBackgroundColor:[UIColor clearColor]];
    }
    
    else if(indexPath.row == 10){
        [cell.contentView addSubview:_controlField];
        _controlField.placeholder = attribute;
        _controlField.textAlignment = NSTextAlignmentCenter;
        _controlField.borderStyle = UITextBorderStyleNone;
        [_controlField setBackgroundColor:[UIColor clearColor]];
    }
    
    else if(indexPath.row == 11){
        [cell.contentView addSubview:_movementField];
        _movementField.placeholder = attribute;
        _movementField.textAlignment = NSTextAlignmentCenter;
        _movementField.borderStyle = UITextBorderStyleNone;
        [_movementField setBackgroundColor:[UIColor clearColor]];
    }
    
    textfieldPlaceholderColor = [UIColor colorWithRed:252.0/255.0 green:14.0/255.0 blue:0 alpha:1.0];
    [_firstNameField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [_lastNameField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [_weightField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [_classField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [_armSlotField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [_fastballField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [_curveballField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [_sliderField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [_changeupField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [_otherField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [_controlField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [_movementField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
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

-(void)drawTextFields
{
    CustomTextFieldAppearance *appearance = [[CustomTextFieldAppearance alloc]init];
    _firstNameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 260, 30)];
    _lastNameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 260, 30)];
    _classField = [appearance changeTextFieldAppearance];
    _armSlotField = [appearance changeTextFieldAppearance];
    _fastballField = [appearance changeTextFieldAppearance];
    _curveballField = [appearance changeTextFieldAppearance];
    _sliderField = [appearance changeTextFieldAppearance];
    _changeupField = [appearance changeTextFieldAppearance];
    _otherField = [appearance changeTextFieldAppearance];
    _controlField = [appearance changeTextFieldAppearance];
    _movementField = [appearance changeTextFieldAppearance];
    _weightField = [appearance changeTextFieldAppearance];
    
    _firstNameField.delegate = self;
    _lastNameField.delegate = self;
    _armSlotField.delegate = self;
    _fastballField.delegate = self;
    _curveballField.delegate = self;
    _sliderField.delegate = self;
    _changeupField.delegate = self;
    _otherField.delegate = self;
    _controlField.delegate = self;
    _movementField.delegate = self;
    _weightField.delegate = self;
}

-(void)showAction
{
    NSString *actionSheetTitle = @"Menu Options"; //Action Sheet Title
    NSString *addPlayer = @"Add Pitcher";
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
        if(chosenImage)
        {
            [self didAddPlayer];
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


#pragma mark - UIImagePicker Handling
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
    //UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil);
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/* UITextView Delegate method. This method is triggered when the user types a new character in the textView. */
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    /* Test if the entered text is a return. If it is we tell textView to dismiss the keyboard and then we stop the textView from entering in additional information as text. This is not a perfect solution because users cannot enter returns in their text and if they paste text with a return items after the return will not be added. For the functionality required in this project this solution works just fine. */
    if ([text isEqualToString:@"\n"]){
        [self.commentsView resignFirstResponder];
        return NO;
    }
    else return YES;
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

- (IBAction)addPitcher:(UIBarButtonItem *)sender {
    [self showAction];
}
@end
