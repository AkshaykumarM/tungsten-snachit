//
//  SnachitSignup.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/26/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "SnachitSignup.h"
#import "SnachItLogin.h"
#import "SWRevealViewController.h"
#import "SnatchFeed.h"
#import "global.h"
#import "AFNetworking.h"
@implementation SnachitSignup
@synthesize emailTextField=_emailTextField;
@synthesize passwordTextField=_passwordTfield;

@synthesize fbBtn=_fbBtn;
@synthesize twBtn=_twBtn;
@synthesize gPlusBtn=_gPlusBtn;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
NSInteger status=0;
CGFloat animatedDistance;
- (void)viewDidLoad
{
    [self setViewLookAndFeel];
    [super viewDidLoad];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    screenName=@"signup";
    
}
-(void)setViewLookAndFeel{
    
    
    UIColor *color = [UIColor whiteColor];
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"email" attributes:@{NSForegroundColorAttributeName: color}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName: color}];
    CALayer *emailborder = [CALayer layer];
    CALayer *passborder  = [CALayer layer];
    CGFloat borderWidth = 1;
    
    //setting bottom border to email filed
    emailborder.borderColor =[UIColor colorWithRed:1 green:1 blue:1 alpha:0.4].CGColor;
    emailborder.frame = CGRectMake(0, self.emailTextField.frame.size.height - borderWidth, self.emailTextField.frame.size.width, self.emailTextField.frame.size.height);
    emailborder.borderWidth = borderWidth;
    [self.emailTextField.layer addSublayer:emailborder];
    self.emailTextField.layer.masksToBounds = YES;
    
    
    //setting bottom border to password filed
    passborder.borderColor =[UIColor colorWithRed:1 green:1 blue:1 alpha:0.4].CGColor;
    passborder.frame = CGRectMake(0, self.passwordTextField.frame.size.height - borderWidth, self.passwordTextField.frame.size.width, self.passwordTextField.frame.size.height);
    passborder.borderWidth = borderWidth;
    [self.passwordTextField.layer addSublayer:passborder];
    self.passwordTextField.layer.masksToBounds = YES;
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


- (IBAction)signUpBtn:(id)sender {
    [self.activityIndicator startAnimating];
  //  [self performSegueWithIdentifier: @"signInScreenSegue" sender:self];
    if([self.emailTextField hasText] &&[self.passwordTextField hasText])
    {
        [self.errorLbl setHidden:YES];
        NSString *username= self.emailTextField.text;
        NSString *password= self.passwordTextField.text;
        NSString *APNSToken=@"sdfdfs";
    
        if([self IsEmailValid:username] && [password length]>=6)
        {
            [self.errorLbl setHidden:YES];
            NSInteger status=[self getSignUp:@"" LastName:@"" EmailId:username Username:username Password:password Profilepic:@"" PhoneNo:@"" APNSToken:APNSToken SignUpVia:@"SnachIt" DOB:@""];
            
            NSLog(@"status%d",status);
            if(status==1){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setInteger:1 forKey:@"signedUp"];
                [defaults setObject:userName forKey:@"Username"];
                [defaults setObject:password forKey:@"Password"];
                SnachItLogin *startscreen = [[SnachItLogin alloc]
                                 initWithNibName:@"LoginScreen" bundle:nil];
                [self presentViewController:startscreen animated:YES completion:nil];
            }
        }
        
    }else{
        self.errorLbl.text=@"Please enter username & password";
         [self.errorLbl setHidden:NO];
    }
     [self.activityIndicator stopAnimating];
}
- (IBAction)loginHereBtn:(id)sender {
    SnachItLogin *startscreen = [[SnachItLogin alloc]
                                  initWithNibName:@"LoginScreen" bundle:nil];
    [self presentViewController:startscreen animated:YES completion:nil];
}



//this function will let signup the user and will provide 1 if success and 0 else


-(NSInteger)getSignUp:(NSString*)firstName LastName:(NSString*)lastName EmailId:(NSString*)emailid Username:(NSString*)username Password:(NSString*)password Profilepic:(NSString*)profile_pic PhoneNo:(NSString*)phoneNo APNSToken:(NSString*)apnsToken SignUpVia:(NSString*)signUpVia DOB:(NSString*)dob{
    
    NSLog(@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@",firstName,lastName,emailid,username,password,profile_pic,phoneNo,apnsToken,signUpVia,dob);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *response;
    
    NSString *url;
    if(![signUpVia isEqual:@"SnachIt"]){
        url=[NSString stringWithFormat:@"http://192.168.0.121:8000/signUpFromMobile/?firstName=%@&lastName=%@&emailid=%@&username=%@&password=%@&profile_pic=%@&phoneNo=%@&apnsToken=%@&signUpVia=%@&dob=%@",firstName,lastName,emailid,username,password,profile_pic,phoneNo,apnsToken,signUpVia,dob];
    }else{
        url=[NSString stringWithFormat:@"http://192.168.0.121:8000/signUpFromMobile/?firstName=%@&lastName=%@&emailid=%@&username=%@&password=%@&profile_pic=%@&phoneNo=%@&apnsToken=%@&signUpVia=%@",firstName,lastName,emailid,username,password,profile_pic,phoneNo,apnsToken,signUpVia];

    }
    
    NSData *jasonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (jasonData) {
        NSError *e = nil;
        response = [NSJSONSerialization JSONObjectWithData:jasonData options:NSJSONReadingMutableContainers error: &e];
        NSLog(@"%@",url);
        if([[response valueForKey:@"success"] isEqual:@"true"])
        {
            //caching userid for sso
            status=1;
        }
        else{
            status=0;
        }
    }
    else{
        status=0;
    }
    return status;
    
}

-(void)clearUserDefault{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setNilValueForKey:@"signedUp"];
    [defaults setNilValueForKey:@"Username"];
    [defaults setNilValueForKey:@"Password"];
}

-(BOOL)IsEmailValid:(NSString *)checkString
{
   
        BOOL stricterFilter = NO;
        NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
        NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
        NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:checkString];
    
}


@end
