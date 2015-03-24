//
//  TwitterEmailIdView.m
//  SnachIt
//
//  Created by Akshay Maldhure on 2/6/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "TwitterEmailIdView.h"
#import "SnachitSignup.h"
#import "SnachItLogin.h"
#import "UserProfile.h"
#import "global.h"
#import "RegexValidator.h"

@implementation TwitterEmailIdView
{
        SnachItLogin *signin;
    
}
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
CGFloat animatedDistance;

-(void)viewDidLoad{
    UIColor *color = [UIColor whiteColor];
    self.emailIdTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"email" attributes:@{NSForegroundColorAttributeName: color}];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
   }

- (IBAction)logInButton:(id)sender {
    NSLog(@"APNS TOKEN WHILE TWITTER LOGIN: %@",APNSTOKEN);
   NSPredicate* email = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL_REGEX];
    if([self.emailIdTextField hasText]&& [email evaluateWithObject:self.emailIdTextField.text]){
        SnachitSignup *signUp=[[SnachitSignup alloc]init];
        NSInteger status=[signUp getSignUp:@"" LastName:@"" FullName:twFullname EmailId:self.emailIdTextField.text Username:self.emailIdTextField.text Password:twUserId Profilepic:[NSString stringWithFormat:@"%@",twProfilePic] PhoneNo:@"" APNSToken:APNSTOKEN SignUpVia:@"TW" DOB:@""];
        if(status==1){
            signin=[[SnachItLogin alloc] init];
            int signinStatus=[signin performSignIn:self.emailIdTextField.text Password:twUserId SSOUsing:@"TW"];
            if(signinStatus==1)
            {
              [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
            }
            else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"You may already have an account on snach.it"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            }
        }
    
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Please, enter valid email id."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
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


@end
