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
#define REGEX_USERNAME @"[[A-Za-z]"
#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"
@interface AccountSetting()

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
}
@synthesize emailTextField=_emailTextField;
@synthesize nameTextField=_nameTextField;
@synthesize phoneNoTextField=_phoneNoTextField;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

CGFloat animatedDistance;
- (void)viewDidLoad {
    [super viewDidLoad];
    [_scrollView setScrollEnabled:YES];
    
    [self setupAlerts];
    
    
    
    [self setViewLookAndFeel];
    
    // Load the file content and read the data into arrays
}
-(void)viewWillAppear:(BOOL)animated{
    user =[UserProfile sharedInstance];
    
}
-(void)viewDidAppear:(BOOL)animated{
 self.navigationBar =  [[self navigationController] navigationBar];
//    //do something like background color, title, etc you self
//    [self.view addSubview:navbar];
    CGRect frame = [self.navigationBar frame];
    frame.size.height = 50.0f;
    [self.navigationBar setFrame:frame];
    [self initialLize];
}
-(void)initialLize{
    
    if(user.profilePicUrl!=nil){
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:user.profilePicUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            self.profilePic.image = [UIImage imageWithData:data];
        }];
    }
    if(![user.fullName isKindOfClass:[NSNull class]])
        self.fullNameLbl.text=[[NSString stringWithFormat:@"%@",user.fullName] uppercaseString];
    
    self.memberSinceLbl.text=[NSString stringWithFormat:@"Member since %@",[user.joiningDate substringFromIndex:[user.joiningDate length]-4]];
    if(![user.emailID isKindOfClass:[NSNull class]])
        [self.emailTextField setText:user.emailID];
    if(![user.fullName isKindOfClass:[NSNull class]])
        [self.nameTextField setText:user.fullName];
    if(![user.phoneNumber isKindOfClass:[NSNull class]])
        [self.phoneNoTextField setText:user.phoneNumber];
    self.fullNameLbl.adjustsFontSizeToFitWidth=YES;
    self.fullNameLbl.minimumScaleFactor=0.5;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setViewLookAndFeel];
    // Release any retained subviews of the main view.
}


-(void)setViewLookAndFeel{
    UIColor *borderColor=[UIColor colorWithRed:0.792 green:0.792 blue:0.792 alpha:0.4];
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.profilePic.layer.cornerRadius= 35.0f;
    
    
    self.profilePic.clipsToBounds = YES;
    self.profilePic.layer.borderWidth = 3.0f;
    self.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    _accountSettingView=[[[NSBundle mainBundle]loadNibNamed:@"AccountSettingView" owner:self options:nil] objectAtIndex:0];
   
    _accountSettingView.frame=CGRectMake(0.0f,_profilePic.frame.origin.y+_profilePic.frame.size.height, _accountSettingView.frame.size.width, _accountSettingView.frame.size.height);
    [_uiView addSubview:_accountSettingView];
   
    CALayer *border1 = [CALayer layer];
    CALayer *border2  = [CALayer layer];
    CALayer *border3 = [CALayer layer];
    
    CGFloat borderWidth = 1;
    border1.borderColor =borderColor.CGColor;
    border1.frame = CGRectMake(0, self.emailTextField.frame.size.height - borderWidth, self.emailTextField.frame.size.width, self.emailTextField.frame.size.height);
    border1.borderWidth = borderWidth;
    [self.emailTextField.layer addSublayer:border1];
    self.emailTextField.layer.masksToBounds = YES;
    
    
    border2.borderColor =borderColor.CGColor;
    border2.frame = CGRectMake(0, self.nameTextField.frame.size.height - borderWidth, self.nameTextField.frame.size.width, self.nameTextField.frame.size.height);
    border2.borderWidth = borderWidth;
    [self.nameTextField.layer addSublayer:border2];
    self.nameTextField.layer.masksToBounds = YES;
    
    border3.borderColor =borderColor.CGColor;
    border3.frame = CGRectMake(0, self.phoneNoTextField.frame.size.height - borderWidth, self.phoneNoTextField.frame.size.width, self.phoneNoTextField.frame.size.height);
    border3.borderWidth = borderWidth;
    [self.phoneNoTextField.layer addSublayer:border3];
    self.phoneNoTextField.layer.masksToBounds = YES;
    SevenSwitch *appAllertSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(self.appsTopBar.frame.size.width-100, self.appsTopBar.frame.origin.y+3, 80, 40)];
    
    [appAllertSwitch addTarget:self action:@selector(appAllertSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    appAllertSwitch.offImage = [UIImage imageNamed:@"check.png"];
    appAllertSwitch.onImage = [UIImage imageNamed:@"multiply.png"];
    appAllertSwitch.onTintColor = [UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] ;
    appAllertSwitch.inactiveColor=[UIColor colorWithRed:0.267 green:0.843 blue:0.369 alpha:1];
    appAllertSwitch.isRounded = NO;
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if([[defaults stringForKey:APPALLERTS] isEqual:@"True"])
    {
    appAllertSwitch.on=NO;appAlerts=@"True";}
    else{
        appAllertSwitch.on=YES;appAlerts=@"False";}
    [self.accountSettingView addSubview:appAllertSwitch];

    SevenSwitch *emailAllertSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(self.emailTopBar.frame.size.width-100, self.emailTopBar.frame.origin.y+3, 80, 40)];
    
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
    [self.accountSettingView addSubview:emailAllertSwitch];
    
    SevenSwitch *smsAllertSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(self.SMSTopBar.frame.size.width-100, self.SMSTopBar.frame.origin.y+3, 80, 40)];
    
    [smsAllertSwitch addTarget:self action:@selector(smsAllertSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    smsAllertSwitch.offImage = [UIImage imageNamed:@"check.png"];
    smsAllertSwitch.onImage = [UIImage imageNamed:@"multiply.png"];
    smsAllertSwitch.onTintColor = [UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] ;
    smsAllertSwitch.inactiveColor=[UIColor colorWithRed:0.267 green:0.843 blue:0.369 alpha:1];
    smsAllertSwitch.isRounded = NO;
    if([[defaults stringForKey:SMSALLERTS] isEqual:@"True"]){
        smsAllertSwitch.on=NO;smsAlerts=@"True";}
    else{
        smsAllertSwitch.on=YES;smsAlerts=@"False";}
    [self.accountSettingView addSubview:smsAllertSwitch];
  
    
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
    [self.nameTextField addRegx:REGEX_USERNAME withMsg:@"Please enter valid name"];
    self.nameTextField.isMandatory=NO;
    self.nameTextField.isMandatory=NO;
}

- (IBAction)doneBtn:(id)sender {
    [self startProcessing];
    if([self.nameTextField validate]){
    int status=[self updateUserProfile];
    
    if(status==1){
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setValue:appAlerts forKey:APPALLERTS];
         [defaults setValue:emailAlerts forKey:EMAILALLERTS];
         [defaults setValue:smsAlerts forKey:SMSALLERTS];
        [self viewDidLoad];
        [self viewWillAppear:YES];
        [self viewDidAppear:YES];
        NSLog(@"Profile updated successfully");
        [self stopProcessing];
    }
    else{
        [self stopProcessing];
        NSLog(@"Error occureed while updating profile");
    }
    }
}


-(int)updateUserProfile{
    NSError *error;
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
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:user.userID forKey:@"customerId"];
    [dictionary setValue:self.nameTextField.text forKey:@"fullName"];
    [dictionary setValue:self.emailTextField.text forKey:@"emailId"];
    [dictionary setValue:self.phoneNoTextField.text forKey:@"phoneNumber"];
    [dictionary setValue:appAlerts forKey:@"appAlerts"];
    [dictionary setValue:emailAlerts forKey:@"emailAlerts"];
    [dictionary setValue:smsAlerts forKey:@"SMSAlerts"];
    return dictionary;
    
}
-(void)startProcessing{
    
    backView = [[UIView alloc] initWithFrame:self.scrollView.frame];
    backView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.3];
    [self.scrollView addSubview:backView];
    activitySpinner=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [backView addSubview:activitySpinner];
    activitySpinner.center = CGPointMake(160, 240);
    activitySpinner.hidesWhenStopped = YES;
    [activitySpinner startAnimating];
    
}
-(void)stopProcessing{
    
    [activitySpinner stopAnimating];
    [backView removeFromSuperview];
}
@end
