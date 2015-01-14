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
   
  //  [self performSegueWithIdentifier: @"signInScreenSegue" sender:self];
    SnachItLogin *startscreen = [[SnachItLogin alloc]
                                 initWithNibName:@"LoginScreen" bundle:nil];
    [self presentViewController:startscreen animated:YES completion:nil];

}
- (IBAction)loginHereBtn:(id)sender {
    SnachItLogin *startscreen = [[SnachItLogin alloc]
                                  initWithNibName:@"LoginScreen" bundle:nil];
    [self presentViewController:startscreen animated:YES completion:nil];
}
@end
