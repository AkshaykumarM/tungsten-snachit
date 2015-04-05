//
//  AccountSetting.m
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//



#import "AccountSetting.h"
#import "SWRevealViewController.h"
#import "SnachIt-Swift.h"
#import "global.h"
#import "UserProfile.h"
#import "SnachItLogin.h"
#import "AccountSettingCell.h"
#import "SnatchFeed.h"
#import "SnachitStartScreen.h"
#import <SDWebImage/UIImageView+WebCache.h>
#define REGEX_USERNAME @"[a-zA-Z\\s]*"
#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"([1-9][0-9]{9})||([1-9][0-9]{11})"
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
    UIToolbar* toolbar;
}
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
SevenSwitch *signOut;
CGFloat animatedDistance;
- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self setViewLookAndFeel];
    
    toolbar = [[UIToolbar alloc] init];
    toolbar.frame=CGRectMake(0,0,self.view.frame.size.width,44);
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked:)];
    toolbar.barTintColor=[UIColor colorWithRed:0.8 green:0.816 blue:0.839 alpha:1];
    
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    // Load the file content and read the data into arrays
}
-(void)doneClicked:(id)sender{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    user =[UserProfile sharedInstance];
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    //    [self.view addSubview:navbar];
    
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
    return 640;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AccountSettingCell *cell = (AccountSettingCell *)[tableView dequeueReusableCellWithIdentifier:@"accountSettingCell" forIndexPath:indexPath];
    
    //setting profile pic look
    cell.profilePicImageView.layer.cornerRadius=RADIOUS;
    cell.profilePicImageView.clipsToBounds=YES;
    cell.profilePicImageView.layer.borderWidth=BORDERWIDTH;
    cell.profilePicImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    [cell.profilePicImageView setImageWithURL:user.profilePicUrl placeholderImage:[UIImage imageNamed:@"userIcon.png"]];
    
    //initializing the textfields
    if(![user.fullName isKindOfClass:[NSNull class]])
        cell.fullnameLbl.text=[[NSString stringWithFormat:@"%@",user.fullName] uppercaseString];
    
    cell.memberSinceLbl.text=[NSString stringWithFormat:@"Member since %@",[user.joiningDate substringFromIndex:[user.joiningDate length]-4]];
    if(![user.emailID isKindOfClass:[NSNull class]])
        [cell.emailTextField setText:user.emailID];
    if(![user.fullName isKindOfClass:[NSNull class]])
        [cell.nameTextField setText:user.fullName];
    if(![user.phoneNumber isKindOfClass:[NSNull class]])
        [cell.phoneTextField setText:user.phoneNumber];
    
    [global setTextFieldInsets:cell.emailTextField];
    [global setTextFieldInsets:cell.nameTextField];
    [global setTextFieldInsets:cell.phoneTextField];
    cell.phoneTextField.inputAccessoryView=toolbar;
    //setting background img
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if([defaults valueForKey:DEFAULT_BACK_IMG])
        cell.defaultBackImageView.image=[UIImage imageWithData:[defaults valueForKey:DEFAULT_BACK_IMG]];

    cell.fullnameLbl.adjustsFontSizeToFitWidth=YES;
    cell.fullnameLbl.minimumScaleFactor=0.5;
    
    cell.phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    
    SevenSwitch *appAllertSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-60,473, 50, 25)];
    [appAllertSwitch addTarget:self action:@selector(appAllertSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    appAllertSwitch.offImage = [UIImage imageNamed:@"check.png"];
    appAllertSwitch.onImage = [UIImage imageNamed:@"multiply.png"];
    appAllertSwitch.onTintColor = [UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] ;
    appAllertSwitch.inactiveColor=[UIColor colorWithRed:0.267 green:0.843 blue:0.369 alpha:1];
    appAllertSwitch.isRounded = NO;
    
   
    if(user.isappAlertsOn==1){
        appAllertSwitch.on=NO; appAlerts=@"True";}
    else{
        appAllertSwitch.on=YES;appAlerts=@"False";}
    
    [cell.contentView addSubview:appAllertSwitch];
    
    
    SevenSwitch *emailAllertSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-60,518, 50, 25)];
    [emailAllertSwitch addTarget:self action:@selector(emailAllertSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    emailAllertSwitch.offImage = [UIImage imageNamed:@"check.png"];
    emailAllertSwitch.onImage = [UIImage imageNamed:@"multiply.png"];
    emailAllertSwitch.onTintColor = [UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] ;
    emailAllertSwitch.inactiveColor=[UIColor colorWithRed:0.267 green:0.843 blue:0.369 alpha:1];
    emailAllertSwitch.isRounded = NO;
    
    if(user.isemailAlertsOn==1){
        emailAllertSwitch.on=NO; emailAlerts=@"True";emailAllertSwitch.borderColor=[UIColor colorWithRed:0.267 green:0.843 blue:0.369 alpha:1];
    }
    else{
        emailAllertSwitch.on=YES;emailAlerts=@"False"; emailAllertSwitch.borderColor=[UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1];}
    [cell.contentView addSubview:emailAllertSwitch];
    
    SevenSwitch *smsAllertSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-60,563, 50, 25)];
    [smsAllertSwitch addTarget:self action:@selector(smsAllertSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    smsAllertSwitch.offImage = [UIImage imageNamed:@"check.png"];
    smsAllertSwitch.onImage = [UIImage imageNamed:@"multiply.png"];
    smsAllertSwitch.onTintColor = [UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] ;
    smsAllertSwitch.inactiveColor=[UIColor colorWithRed:0.267 green:0.843 blue:0.369 alpha:1];
    smsAllertSwitch.isRounded = NO;
    
    if(user.issmsAlertsOn==1){
        smsAllertSwitch.on=NO; smsAlerts=@"True";}
    else{
        smsAllertSwitch.on=YES;smsAlerts=@"False";}
    
    [cell.contentView addSubview:smsAllertSwitch];
    
    signOut = [[SevenSwitch alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-60,608, 50, 25)];
    [signOut addTarget:self action:@selector(signOut:) forControlEvents:UIControlEventValueChanged];
    signOut.offImage = [UIImage imageNamed:@"check.png"];
    signOut.onImage = [UIImage imageNamed:@"multiply.png"];
    signOut.onTintColor = [UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] ;
    signOut.inactiveColor=[UIColor colorWithRed:0.267 green:0.843 blue:0.369 alpha:1];
    signOut.isRounded = NO;
    signOut.on=NO;
    [cell.contentView addSubview:signOut];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   [[self.tableViewsetting superview] endEditing:YES];
}
-(void)setViewLookAndFeel{
    // Set the gesture
//    [self.backButton setTarget:self.revealViewController];
//    [self.backButton setAction:@selector(revealToggle:)];
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [btn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    btn.imageEdgeInsets=UIEdgeInsetsMake(5,5,4,5);
    UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = eng_btn;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:textField.tag + 1];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
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
    AccountSettingCell *tableCell = (AccountSettingCell*)[self.tableViewsetting cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [tableCell.nameTextField addRegx:REGEX_USERNAME withMsg:@"Please enter valid name"];
    [tableCell.emailTextField addRegx:REGEX_EMAIL withMsg:@"Please enter valid email"];
    [tableCell.phoneTextField addRegx:REGEX_PHONE_DEFAULT withMsg:@"Please enter valid phone no"];
    tableCell.nameTextField.validateOnResign=NO;
    tableCell.nameTextField.isMandatory=NO;
    tableCell.emailTextField.isMandatory=NO;
    tableCell.phoneTextField.isMandatory=NO;
}


-(int)updateUserProfile{
    NSError *error;
    
    NSData *orderJson = [NSJSONSerialization dataWithJSONObject:[self getProfileUpdateValues] options:NSJSONWritingPrettyPrinted error:&error];
    int status=0;
    NSData *responseData=[global makePostRequest:orderJson requestURL:@"updateCustomerProfile/" ];
    
    if (responseData) {
        NSDictionary *response= [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error: &error];
        NSLog(@"UPDATE PROFILE RESPONSE:%@",response);
        if([[response objectForKey:@"success"] isEqual:@"true"]){
            SnachItLogin *login=[[SnachItLogin alloc] init];
            [login setuserInfo:[response valueForKey:@"CustomerId"] withUserName:[response valueForKey:@"UserName"] withEmailId:[response valueForKey:@"EmailID"] withProfilePicURL:[NSURL URLWithString:[response valueForKey:@"ProfilePicUrl"]] withPhoneNumber:[response valueForKey:@"PhoneNumber"] withFirstName:[response valueForKey:@"FirstName"] withLastName:[response valueForKey:@"LastName"] withFullName:[response valueForKey:@"FullName"]  withJoiningDate:[response valueForKey:@"JoiningDate"] withSnoopTime:[[response valueForKey:@"snoop_time_limit"] intValue] withAppAlerts:[[response valueForKey:@"app_alerts"] intValue] withSMSAlerts:[[response valueForKey:@"sms_alerts"] intValue] withEmailAlerts:[[response valueForKey:@"email_alerts"] intValue]];
            status=1;
        }
        else
            status=0;
    }
    return status;
}
- (void)appAllertSwitchChanged:(SevenSwitch *)sender {
    
    appAlerts=  sender.on ? @"False" : @"True";
    if([appAlerts isEqual:@"True"])
    {
        sender.borderColor=[UIColor colorWithRed:0.267 green:0.843 blue:0.369 alpha:1];
    }
    else{
       sender.borderColor= [UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1];
    }
}

- (void)signOut:(SevenSwitch *)sender {
    if([(sender.on ? @"False" : @"True" ) isEqual:@"False"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure, you want to signout?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil]; [alert show];}
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) { // Set buttonIndex == 0 to handel "Ok"/"Yes" button response
        
        signOut.on=NO;
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:@"0" forKey:LOGGEDIN];
    
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SnatchFeed *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"snachfeed"];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        [navController setViewControllers: @[rootViewController] animated: YES];
        
        [self.revealViewController pushFrontViewController:navController animated:YES];
        
        
    }
    else{
        signOut.on=NO;
    }
}
- (void)emailAllertSwitchChanged:(SevenSwitch *)sender {
    emailAlerts=  sender.on ? @"False" : @"True";
    if([emailAlerts isEqual:@"True"])
    {
        sender.borderColor=[UIColor colorWithRed:0.267 green:0.843 blue:0.369 alpha:1];
    }
    else{
        sender.borderColor= [UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1];
    }
}
- (void)smsAllertSwitchChanged:(SevenSwitch *)sender {
    smsAlerts=   sender.on ? @"False" : @"True";
    if([smsAlerts isEqual:@"True"])
    {
        sender.borderColor=[UIColor colorWithRed:0.267 green:0.843 blue:0.369 alpha:1];
    }
    else{
        sender.borderColor= [UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1];
    }

}
-(NSDictionary*)getProfileUpdateValues{
    AccountSettingCell *tableCell = (AccountSettingCell*)[self.tableViewsetting cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:user.userID forKey:@"customerId"];
    [dictionary setValue:tableCell.nameTextField.text forKey:@"fullName"];
    [dictionary setValue:tableCell.emailTextField.text forKey:@"emailId"];
    [dictionary setValue:tableCell.phoneTextField.text forKey:@"phoneNumber"];
    [dictionary setValue:tableCell.phoneTextField.text forKey:@"phoneNumber"];
    [dictionary setValue:[appAlerts isEqual:@"True"]?@"1":@"0" forKey:@"appAlerts"];
    [dictionary setValue:[emailAlerts isEqual:@"True"]?@"1":@"0" forKey:@"emailAlerts"];
    [dictionary setValue:[smsAlerts isEqual:@"True"]?@"1":@"0" forKey:@"SMSAlerts"];
    return dictionary;
    
}
-(void)startProcessing{
    AccountSettingCell *tableCell = (AccountSettingCell*)[self.tableViewsetting cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
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


-(void) getPhoto:(id) sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate=self;
    
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
     AccountSettingCell *cell = (AccountSettingCell*)[self.tableViewsetting cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [[picker presentingViewController ] dismissViewControllerAnimated:YES completion:nil];
    cell.defaultBackImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}

//this function will end editing by dissmissing keyboard if user touches outside the textfields
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.tableViewsetting endEditing:YES];
}

- (IBAction)save:(id)sender {
    
    AccountSettingCell *tableCell = (AccountSettingCell*)[self.tableViewsetting cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    
    if([tableCell.nameTextField validate] & [tableCell.emailTextField validate]&[tableCell.phoneTextField validate]){
        [self startProcessing];
        int status=[self updateUserProfile];
        
        if(status==1){
//            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//            [defaults setValue:appAlerts forKey:appAlerts];
//            [defaults setValue:emailAlerts forKey:emailAlerts];
//            [defaults setValue:smsAlerts forKey:smsAlerts];
            [self.tableViewsetting reloadData];
            [global showAllertMsg:@"Profile updated successfully"];
            
           
        }
        else{
           
            [global showAllertMsg:@"Error occureed while updating profile"];
            
        }
    }
    [self stopProcessing];
}
@end
