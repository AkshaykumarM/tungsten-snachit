//
//  ShippingInfoOverview.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/27/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "ShippingInfoOverview.h"
#import "ShippingInfoAddCell.h"
#import "UserProfile.h"
#import "global.h"
#import "DBManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RegexValidator.h"
@interface ShippingInfoOverview()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) DBManager *dbManager;
@property (strong,nonatomic) NSArray *states;
@property (strong,nonatomic) NSArray *statesAbv;
@end
@implementation ShippingInfoOverview
{
    UserProfile *user;
    UIPickerView *statepicker;
    CGFloat viewSize;
    CGFloat viewCenter;
}
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
CGFloat animatedDistance;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the Label text with the selected recipe

    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"snachit.sql"];
    statepicker = [[UIPickerView alloc] init];
    statepicker.dataSource = self;
    statepicker.delegate = self;
    statepicker.backgroundColor=[UIColor whiteColor];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"states-info" ofType:@"plist"]];
    
    self.states = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"icons"]];
    self.statesAbv = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"Abb"]];
   }
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    viewSize=self.view.frame.size.width;
    viewCenter=self.view.center.x-50;
    [self setupAlerts];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    user=[UserProfile sharedInstance];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField){
        [textField resignFirstResponder];
    }
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 670;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShippingInfoAddCell *cell = (ShippingInfoAddCell *)[tableView dequeueReusableCellWithIdentifier:@"shippingInfoAddCell" forIndexPath:indexPath];
    cell.profilePicImg.layer.cornerRadius=RADIOUS;
    cell.profilePicImg.clipsToBounds=YES;
    cell.profilePicImg.layer.borderWidth=BORDERWIDTH;
    cell.profilePicImg.layer.borderColor=[UIColor whiteColor].CGColor;
    if(![user.fullName isKindOfClass:[NSNull class]])
        cell.fullnameLbl.text=[[NSString stringWithFormat:@"%@",user.fullName] uppercaseString];
    
    cell.memberSinceLbl.text=[NSString stringWithFormat:@"Member since %@",[user.joiningDate substringFromIndex:[user.joiningDate length]-4]];
    
    
    [cell.profilePicImg setImageWithURL:user.profilePicUrl placeholderImage:[UIImage imageNamed:@"userIcon.png"]];
  
    cell.fullnameLbl.adjustsFontSizeToFitWidth=YES;
    cell.fullnameLbl.minimumScaleFactor=0.5;
    cell.stateTextField.inputView = statepicker;
    
    [global setTextFieldInsets:cell.firstNameTextField];
    [global setTextFieldInsets:cell.lastNameTextField];
    [global setTextFieldInsets:cell.cityTextField];
    [global setTextFieldInsets:cell.stateTextField];
    [global setTextFieldInsets:cell.addressTextField];
    [global setTextFieldInsets:cell.phoneTextField];
    [global setTextFieldInsets:cell.postalCodeTextField];
    
    cell.phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    cell.postalCodeTextField.keyboardType=UIKeyboardTypeNumberPad;
    cell.addressTextField.keyboardType=UIKeyboardTypeAlphabet;
    cell.cityTextField.keyboardType=UIKeyboardTypeAlphabet;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if([defaults valueForKey:DEFAULT_BACK_IMG])
        cell.defBackImg.image=[UIImage imageWithData:[defaults valueForKey:DEFAULT_BACK_IMG]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self.tableView superview] endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textfield{
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


- (IBAction)backBtn:(id)sender {
    NSLog(@"back");
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void) getPhoto:(id) sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    ShippingInfoAddCell *cell = (ShippingInfoAddCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [picker dismissViewControllerAnimated:YES completion:nil];
    cell.defBackImg.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}


//this function will end editing by dissmissing keyboard if user touches outside the textfields
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.tableView endEditing:YES];
}



//setting picker view to select states

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.states.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.states[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    ShippingInfoAddCell *cell = (ShippingInfoAddCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.stateTextField.text = self.statesAbv[row];
    
}



/*ends here*/

#pragma mark - Credit card Number Field Formatting


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
     ShippingInfoAddCell *cell = (ShippingInfoAddCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (textField==cell.phoneTextField) {
        if (range.location == 10) {
            return NO;
        }
        return YES;
        
    }
    
    return YES;
}

-(void)setupAlerts{
    ShippingInfoAddCell *cell = (ShippingInfoAddCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.firstNameTextField addRegx:REGEX_USERNAME withMsg:@"Please enter valid first name"];
    [cell.lastNameTextField addRegx:REGEX_USERNAME withMsg:@"Please enter valid last name"];
    [cell.postalCodeTextField addRegx:REGEX_ZIP_CODE withMsg:@"Please enter valid zip code"];
    [cell.cityTextField addRegx:REGEX_USERNAME withMsg:@"Please enter valid city"];
    [cell.phoneTextField addRegx:REGEX_PHONE_DEFAULT withMsg:@"Please enter valid phone no"];
    
    cell.firstNameTextField.validateOnResign=YES;
    cell.lastNameTextField.isMandatory=YES;
    cell.cityTextField.isMandatory=YES;
    cell.stateTextField.isMandatory=YES;
    cell.postalCodeTextField.isMandatory=YES;
    cell.phoneTextField.isMandatory=YES;
}

- (IBAction)saveBtn:(id)sender {
    
    ShippingInfoAddCell *cell = (ShippingInfoAddCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if([cell.firstNameTextField validate] &[cell.lastNameTextField validate]& [cell.stateTextField validate]&[cell.cityTextField validate]&[cell.addressTextField validate]&[cell.postalCodeTextField validate]&[cell.phoneTextField validate]){
        
        
        NSString *query = [NSString stringWithFormat:@"insert into address values(null, '%@', '%@', '%@' ,'%@','%@','%@')", [NSString stringWithFormat:@"%@ %@",cell.firstNameTextField.text,cell.lastNameTextField.text], cell.addressTextField.text, cell.cityTextField.text,cell.stateTextField.text,cell.postalCodeTextField.text,cell.phoneTextField.text];
        
        // Execute the query.
        
        [self.dbManager executeQuery:query];
        
        // If the query was successfully executed then pop the view controller.
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            RECENTLY_ADDED_SHIPPING_INFO_TRACKER=(int)self.dbManager.lastInsertedRowID;
            // Pop the view controller.
            [self dismissViewControllerAnimated:true completion:nil];
        }
        else{
            RECENTLY_ADDED_SHIPPING_INFO_TRACKER=-1;
            NSLog(@"Could not execute the query.");
        }
    }
        

}
@end
