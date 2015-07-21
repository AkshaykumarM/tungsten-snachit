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
#import "SVProgressHUD.h"
#import "ChangePasswordViewController.h"
#import "RegexValidator.h"

#define checkmark @"check"
#define uncheckmark @"cross"
@interface AccountSetting()<UITextFieldDelegate>

@end
@implementation AccountSetting
{
    NSData *userDetailsUpdate;
    NSDictionary *dictionaryForUpdate;
    UserProfile *user;
    NSString *appAlerts;
    NSString *emailAlerts;
   
    
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
    [super viewWillAppear:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    
    //    [self.view addSubview:navbar];
    
    [self setupAlerts];
    [super viewDidAppear:YES];
    
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
    return 660;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AccountSettingCell *cell = (AccountSettingCell *)[tableView dequeueReusableCellWithIdentifier:@"accountSettingCell" forIndexPath:indexPath];
    
    //setting profile pic look
    cell.profilePicImageView.layer.cornerRadius=RADIOUS;
    cell.profilePicImageView.clipsToBounds=YES;
   
    [cell.profilePicImageView setImageWithURL:user.profilePicUrl placeholderImage:[UIImage imageNamed:DEFAULTPLACEHOLDER]];
    
    //initializing the textfields
    if(![user.fullName isKindOfClass:[NSNull class]])
        cell.fullnameLbl.text=[[NSString stringWithFormat:@"%@",user.fullName] uppercaseString];
    
    cell.memberSinceLbl.text=[NSString stringWithFormat:@"%@%@",MEMBER_SINCE,[user.joiningDate substringFromIndex:[user.joiningDate length]-4]];
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
    //[cell.defaultBackImageView setImageWithURL:user.backgroundUrl placeholderImage:[UIImage imageNamed:DEFAULTBACKGROUNDIMG]];

    cell.fullnameLbl.adjustsFontSizeToFitWidth=YES;
    cell.fullnameLbl.minimumScaleFactor=0.5;
    
    cell.phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    
    SevenSwitch *appAllertSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-60,530, 50, 22)];
    [appAllertSwitch addTarget:self action:@selector(appAllertSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    appAllertSwitch.offImageView.image = [UIImage imageNamed:checkmark];
    appAllertSwitch.onImageView.image = [UIImage imageNamed:uncheckmark];
    
    appAllertSwitch.offImageView.contentMode=UIViewContentModeScaleAspectFit;
    appAllertSwitch.onImageView.contentMode=UIViewContentModeScaleAspectFit;
    appAllertSwitch.onTintColor = [UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] ;
    appAllertSwitch.inactiveColor=[UIColor colorWithRed:0.302 green:0.847 blue:0.396 alpha:1];
    appAllertSwitch.isRounded = NO;
    appAllertSwitch.shadowColor=[UIColor clearColor];
    appAllertSwitch.contentMode=UIViewContentModeScaleAspectFit;
    if(user.isappAlertsOn==1){
        appAllertSwitch.on=NO; appAlerts=@"True";appAllertSwitch.borderColor=[UIColor colorWithRed:0.302 green:0.847 blue:0.396 alpha:1];}
    else{
        appAllertSwitch.on=YES;appAlerts=@"False";appAllertSwitch.borderColor=[UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1];}
    
    [cell.contentView addSubview:appAllertSwitch];
    
    
    SevenSwitch *emailAllertSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-60,576, 50, 22)];
    [emailAllertSwitch addTarget:self action:@selector(emailAllertSwitchChanged:) forControlEvents:UIControlEventValueChanged];

    emailAllertSwitch.offImageView.image=[UIImage imageNamed:checkmark ];
    emailAllertSwitch.onImageView.image = [UIImage imageNamed:uncheckmark];

    emailAllertSwitch.onImageView.contentMode=UIViewContentModeScaleAspectFit;
    emailAllertSwitch.offImageView.contentMode=UIViewContentModeScaleAspectFit;
    emailAllertSwitch.onTintColor = [UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] ;
    emailAllertSwitch.inactiveColor=[UIColor colorWithRed:0.302 green:0.847 blue:0.396 alpha:1];
    emailAllertSwitch.isRounded = NO;
    emailAllertSwitch.shadowColor=[UIColor clearColor];
    
    if(user.isemailAlertsOn==1){
        emailAllertSwitch.on=NO; emailAlerts=@"True";emailAllertSwitch.borderColor=[UIColor colorWithRed:0.302 green:0.847 blue:0.396 alpha:1];
    }
    else{
        emailAllertSwitch.on=YES;emailAlerts=@"False"; emailAllertSwitch.borderColor=[UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1];}
    [cell.contentView addSubview:emailAllertSwitch];
    

    
    signOut = [[SevenSwitch alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-60,623, 50, 22)];
    [signOut addTarget:self action:@selector(signOut:) forControlEvents:UIControlEventValueChanged];
    signOut.offImage = [UIImage imageNamed:checkmark];
    signOut.onImage = [UIImage imageNamed:uncheckmark];
    signOut.onImageView.contentMode=UIViewContentModeScaleAspectFit;
    signOut.offImageView.contentMode=UIViewContentModeScaleAspectFit;
    signOut.onTintColor = [UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] ;
    signOut.inactiveColor=[UIColor colorWithRed:0.302 green:0.847 blue:0.396 alpha:1];
    signOut.borderColor=[UIColor colorWithRed:0.267 green:0.843 blue:0.369 alpha:1];
    signOut.isRounded = NO;
    signOut.on=NO;
    signOut.shadowColor=[UIColor clearColor];
    [cell.contentView addSubview:signOut];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   [[self.tableViewsetting superview] endEditing:YES];
}
-(void)setViewLookAndFeel{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [btn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [btn setImage:[UIImage imageNamed:BACKARROW] forState:UIControlStateNormal];
    btn.imageEdgeInsets=UIEdgeInsetsMake(2,2,2,2);
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
    [tableCell.nameTextField addRegx:REGEX_USERNAME withMsg:ERROR_USERNAME];
    [tableCell.emailTextField addRegx:REGEX_EMAIL withMsg:ERROR_EMAILID];
    [tableCell.phoneTextField addRegx:REGEX_PHONE_DEFAULT withMsg:ERROR_PHONE];
    tableCell.nameTextField.validateOnResign=NO;
    tableCell.nameTextField.isMandatory=YES;
    tableCell.emailTextField.isMandatory=YES;
    tableCell.phoneTextField.isMandatory=NO;
}


-(void)updateUserProfile{
     NSError *error;
    NSString *strurl=[NSString stringWithFormat:@"%@updateCustomerProfile/",ec2maschineIP];
    NSData *data=[NSJSONSerialization dataWithJSONObject:[self getProfileUpdateValues] options:NSJSONWritingPrettyPrinted error:&error];
    NSString *strpostlength=[NSString stringWithFormat:@"%lu",(unsigned long)[data length]];
    NSMutableURLRequest *urlrequest=[[NSMutableURLRequest alloc]init];
    [urlrequest setURL:[NSURL URLWithString:strurl]];
    [urlrequest setHTTPMethod:@"POST"];
    [urlrequest setValue:strpostlength forHTTPHeaderField:@"Content-Length"];
    [urlrequest setHTTPBody:data];
    
    [NSURLConnection sendAsynchronousRequest:urlrequest queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSError *error1;
         if(data !=nil){
             NSDictionary *res=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
             if(!error1){
                 NSLog(@"%@",res);
                 [self performSelectorOnMainThread:@selector(doneUpdate:) withObject:res waitUntilDone:NO];
             }
             else{
                 [SVProgressHUD showInfoWithStatus:error1.description];
             }
         }
         else{
             [global showAllertMsg:@"Alert" Message:NOTRESPONDING];
         }
         
     }];
}

-(void)doneUpdate:(NSDictionary*)response{
    
    
    if([[response objectForKey:@"success"] isEqual:@"true"]){
        SnachItLogin *login=[[SnachItLogin alloc] init];
        [login setuserInfo:[response valueForKey:@"CustomerId"] withUserName:[response valueForKey:@"UserName"] withEmailId:[response valueForKey:@"EmailID"] withProfilePicURL:[NSURL URLWithString:[response valueForKey:@"ProfilePicUrl"]] withPhoneNumber:[response valueForKey:@"PhoneNumber"] withFirstName:[response valueForKey:@"FirstName"] withLastName:[response valueForKey:@"LastName"] withFullName:[response valueForKey:@"FullName"]  withJoiningDate:[response valueForKey:@"JoiningDate"] withSnoopTime:[[response valueForKey:@"snoop_time_limit"] intValue] withAppAlerts:[[response valueForKey:@"app_alerts"] intValue] withSMSAlerts:[[response valueForKey:@"sms_alerts"] intValue] withEmailAlerts:[[response valueForKey:@"email_alerts"] intValue] withBackgroundURL:nil];
        [SVProgressHUD dismiss];
    }
    else{
        [SVProgressHUD dismiss];
    }
}


- (void)appAllertSwitchChanged:(SevenSwitch *)sender {
    
    appAlerts=  sender.on ? @"False" : @"True";
    if([appAlerts isEqual:@"True"])
    {
        sender.borderColor=[UIColor colorWithRed:0.302 green:0.847 blue:0.396 alpha:1];
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
        sender.borderColor=[UIColor colorWithRed:0.302 green:0.847 blue:0.396 alpha:1];
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
    [dictionary setValue:@"0" forKey:@"SMSAlerts"];
    [dictionary setValue:[appAlerts isEqual:@"True"]?@"1":@"0" forKey:@"appAlerts"];
    [dictionary setValue:[emailAlerts isEqual:@"True"]?@"1":@"0" forKey:@"emailAlerts"];
    
    return dictionary;
    
}


-(void) getPhoto:(id) sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate=self;
    
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:nil];
}

//this function will end editing by dissmissing keyboard if user touches outside the textfields
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.tableViewsetting endEditing:YES];
}

- (IBAction)save:(id)sender {
    
    AccountSettingCell *tableCell = (AccountSettingCell*)[self.tableViewsetting cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    
    if([tableCell.nameTextField validate] & [tableCell.emailTextField validate]&[tableCell.phoneTextField validate]){
        [SVProgressHUD showWithStatus:@"Please Wait" maskType:SVProgressHUDMaskTypeBlack];
        [self updateUserProfile];
        
    }
    
}

//change password button
- (IBAction)changePassword:(id)sender {
    ChangePasswordViewController *changePassword = [[ChangePasswordViewController alloc]
                                  initWithNibName:@"ChangePassword" bundle:nil];
//    self.providesPresentationContextTransitionStyle = YES;
//    self.definesPresentationContext = YES;
//    [changePassword setModalPresentationStyle:UIModalPresentationOverCurrentContext];
//    self.modalPresentationStyle = UIModalPresentationFormSheet;
  
    [self.navigationController presentViewController:changePassword animated:YES completion:nil];
    
}

- (void)dismiss {
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    AccountSettingCell  *cell = (AccountSettingCell*)[self.tableViewsetting cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (textField==cell.phoneTextField) {
        if (range.location == 10) {
            return NO;
        }
        return YES;
    }

    return YES;
}


-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    
}
@end
