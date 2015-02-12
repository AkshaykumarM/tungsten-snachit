//
//  AccountSetting.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//



#import "AccountSetting.h"
#import "SWRevealViewController.h"
#import "SnachIt-Swift.h"
#import "global.h"
#import "UserProfile.h"
#import "SnachItLogin.h"
#import "AccountSettingCell.h"
#define REGEX_USERNAME @"[a-zA-Z\\s]*"
#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[789][0-9]{9}"
@interface AccountSetting()<UITextFieldDelegate>

@end
@implementation AccountSetting
{
    NSData *userDetailsUpdate;
    NSDictionary *dictionaryForUpdate;
    UserProfile *user;
    NSString *appAlerts;
    NSString *emailAlerts;
    NSString *smsAlerts;
    UIActivityIndicatorView *activitySpinner;
    UIView *backView;
    int viewWidth;
}
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

CGFloat animatedDistance;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    [self setViewLookAndFeel];
    
    // Load the file content and read the data into arrays
}
-(void)viewWillAppear:(BOOL)animated{
    user =[UserProfile sharedInstance];
    
}
-(void)viewDidAppear:(BOOL)animated{
 self.navigationBar =  [[self navigationController] navigationBar];
    
//    [self.view addSubview:navbar];
    CGRect frame = [self.navigationBar frame];
    frame.size.height = 50.0f;
    [self.navigationBar setFrame:frame];
    [self setupAlerts];
  
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setViewLookAndFeel];
    // Release any retained subviews of the main view.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 650;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
        AccountSettingCell *cell = (AccountSettingCell *)[tableView dequeueReusableCellWithIdentifier:@"accountSettingCell" forIndexPath:indexPath];

    //setting profile pic look
    cell.profilePicImageView.layer.cornerRadius=RADIOUS;
    cell.profilePicImageView.clipsToBounds=YES;
    cell.profilePicImageView.layer.borderWidth=BORDERWIDTH;
    cell.profilePicImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    
    
    //initializing the textfields
    if([global isValidUrl:user.profilePicUrl]){
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:user.profilePicUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            cell.profilePicImageView.image = [UIImage imageWithData:data];
        }];
    }
    if(![user.fullName isKindOfClass:[NSNull class]])
        cell.fullnameLbl.text=[[NSString stringWithFormat:@"%@",user.fullName] uppercaseString];
    
    cell.memberSinceLbl.text=[NSString stringWithFormat:@"Member since %@",[user.joiningDate substringFromIndex:[user.joiningDate length]-4]];
    if(![user.emailID isKindOfClass:[NSNull class]])
        [cell.emailTextField setText:user.emailID];
    if(![user.fullName isKindOfClass:[NSNull class]])
        [cell.nameTextField setText:user.fullName];
    if(![user.phoneNumber isKindOfClass:[NSNull class]])
        [cell.phoneTextField setText:user.phoneNumber];
    cell.fullnameLbl.adjustsFontSizeToFitWidth=YES;
    cell.fullnameLbl.minimumScaleFactor=0.5;
    SevenSwitch *appAllertSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-100,462, 80, 40)];
    [appAllertSwitch addTarget:self action:@selector(appAllertSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    appAllertSwitch.offImage = [UIImage imageNamed:@"check.png"];
    appAllertSwitch.onImage = [UIImage imageNamed:@"multiply.png"];
    appAllertSwitch.onTintColor = [UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] ;
    appAllertSwitch.inactiveColor=[UIColor colorWithRed:0.267 green:0.843 blue:0.369 alpha:1];
    appAllertSwitch.isRounded = NO;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if([[defaults stringForKey:APPALLERTS] isEqual:@"True"]){
        appAllertSwitch.on=NO; appAlerts=@"True";}
    else{
        appAllertSwitch.on=YES;appAlerts=@"False";}
    
    [cell.contentView addSubview:appAllertSwitch];
    
    
    SevenSwitch *emailAllertSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-100,508, 80, 40)];
    [emailAllertSwitch addTarget:self action:@selector(emailAllertSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    emailAllertSwitch.offImage = [UIImage imageNamed:@"check.png"];
    emailAllertSwitch.onImage = [UIImage imageNamed:@"multiply.png"];
    emailAllertSwitch.onTintColor = [UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] ;
    emailAllertSwitch.inactiveColor=[UIColor colorWithRed:0.267 green:0.843 blue:0.369 alpha:1];
    emailAllertSwitch.isRounded = NO;
    
    if([[defaults stringForKey:EMAILALLERTS] isEqual:@"True"]){
        emailAllertSwitch.on=NO; emailAlerts=@"True";}
    else{
        emailAllertSwitch.on=YES;emailAlerts=@"False";}
        [cell.contentView addSubview:emailAllertSwitch];

    SevenSwitch *smsAllertSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-100,554, 80, 40)];
    [smsAllertSwitch addTarget:self action:@selector(smsAllertSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    smsAllertSwitch.offImage = [UIImage imageNamed:@"check.png"];
    smsAllertSwitch.onImage = [UIImage imageNamed:@"multiply.png"];
    smsAllertSwitch.onTintColor = [UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] ;
    smsAllertSwitch.inactiveColor=[UIColor colorWithRed:0.267 green:0.843 blue:0.369 alpha:1];
    smsAllertSwitch.isRounded = NO;
    
    if([[defaults stringForKey:SMSALLERTS] isEqual:@"True"]){
        smsAllertSwitch.on=NO; smsAlerts=@"True";}
    else{
        smsAllertSwitch.on=YES;smsAlerts=@"False";}
    
    [cell.contentView addSubview:smsAllertSwitch];
    
    [cell.saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
-(void)setViewLookAndFeel{
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
 
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField){
        [textField resignFirstResponder];
    }
    return NO;
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
-(void)setupAlerts{
    AccountSettingCell *tableCell = (AccountSettingCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [tableCell.nameTextField addRegx:REGEX_USERNAME withMsg:@"Please enter valid name"];
    [tableCell.emailTextField addRegx:REGEX_EMAIL withMsg:@"Please enter valid email"];
    [tableCell.phoneTextField addRegx:REGEX_PHONE_DEFAULT withMsg:@"Please enter valid phone no"];
    tableCell.nameTextField.validateOnResign=NO;
    tableCell.nameTextField.isMandatory=NO;
    tableCell.emailTextField.isMandatory=NO;
    tableCell.phoneTextField.isMandatory=NO;
}

- (void)save {
    
    AccountSettingCell *tableCell = (AccountSettingCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
  
   
    if([tableCell.nameTextField validate] & [tableCell.emailTextField validate]&[tableCell.phoneTextField validate]){
        [self startProcessing];
    int status=[self updateUserProfile];
    
    if(status==1){
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setValue:appAlerts forKey:APPALLERTS];
         [defaults setValue:emailAlerts forKey:EMAILALLERTS];
         [defaults setValue:smsAlerts forKey:SMSALLERTS];
        [self.tableView reloadData];
        NSLog(@"Profile updated successfully");
        [self stopProcessing];
    }
    else{
        [self stopProcessing];
        NSLog(@"Error occureed while updating profile");
    }
    }
    [self stopProcessing];

}
-(int)updateUserProfile{
    NSError *error;
    NSLog(@"%@",[self getProfileUpdateValues]);
        NSData *orderJson = [NSJSONSerialization dataWithJSONObject:[self getProfileUpdateValues] options:NSJSONWritingPrettyPrinted error:&error];
    int status=0;
    NSData *responseData=[global makePostRequest:orderJson requestURL:@"updateCustomerProfile/" ];
 
    if (responseData) {
        NSDictionary *response= [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error: &error];
        NSLog(@"UPDATE PROFILE RESPONSEL:%@",response);
        if([[response objectForKey:@"success"] isEqual:@"true"]){
            SnachItLogin *login=[[SnachItLogin alloc] init];
            [login setuserInfo:[response valueForKey:@"CustomerId"] withUserName:[response valueForKey:@"UserName"] withEmailId:[response valueForKey:@"EmailID"] withProfilePicURL:[NSURL URLWithString:[response valueForKey:@"ProfilePicUrl"]] withPhoneNumber:[response valueForKey:@"PhoneNumber"] withFirstName:[response valueForKey:@"FirstName"] withLastName:[response valueForKey:@"LastName"] withFullName:[response valueForKey:@"FullName"] withDateOfBirth:[response valueForKey:@"DateOfBirth"] withJoiningDate:[response valueForKey:@"JoiningDate"]];
            status=1;
        }
        else
            status=0;
    }
    return status;
}
- (void)appAllertSwitchChanged:(SevenSwitch *)sender {
    
    appAlerts=  sender.on ? @"False" : @"True";
   
}
- (void)emailAllertSwitchChanged:(SevenSwitch *)sender {
       emailAlerts=  sender.on ? @"False" : @"True";
}
- (void)smsAllertSwitchChanged:(SevenSwitch *)sender {
       smsAlerts=   sender.on ? @"False" : @"True";
}
-(NSDictionary*)getProfileUpdateValues{
    AccountSettingCell *tableCell = (AccountSettingCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:user.userID forKey:@"customerId"];
    [dictionary setValue:tableCell.nameTextField.text forKey:@"fullName"];
    [dictionary setValue:tableCell.emailTextField.text forKey:@"emailId"];
    [dictionary setValue:tableCell.phoneTextField.text forKey:@"phoneNumber"];
    [dictionary setValue:tableCell.phoneTextField.text forKey:@"phoneNumber"];
    [dictionary setValue:appAlerts forKey:@"appAlerts"];
    [dictionary setValue:emailAlerts forKey:@"emailAlerts"];
    [dictionary setValue:smsAlerts forKey:@"SMSAlerts"];
    return dictionary;
    
}
-(void)startProcessing{
    AccountSettingCell *tableCell = (AccountSettingCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    backView = [[UIView alloc] initWithFrame:tableCell.frame];
    backView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.3];

    activitySpinner=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [backView addSubview:activitySpinner];
    activitySpinner.center = CGPointMake(tableCell.center.x, tableCell.center.y);
    activitySpinner.hidesWhenStopped = YES;
    [activitySpinner startAnimating];
    [tableCell addSubview:backView];
}


-(void)stopProcessing{


    [activitySpinner stopAnimating];
    [backView removeFromSuperview];
}
@end
