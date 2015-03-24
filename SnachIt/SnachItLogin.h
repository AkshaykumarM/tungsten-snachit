//
//  SnachItLogin.h
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/24/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import "CMPopTipView.h"

@class GPPSignInButton;
@interface SnachItLogin : UIViewController<CMPopTipViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTfield;

- (IBAction)fbBtn:(id)sender;

- (IBAction)gPlusBtn:(id)sender;

- (IBAction)twBtn:(id)sender;

- (IBAction)signUpBtn:(id)sender;
- (IBAction)passwordHelpBtn:(id)sender;



- (IBAction)signInBtn:(id)sender;

- (IBAction)signUpHereBtn:(id)sender;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mySpinner;

-(void)googleSignIn;
-(int)performSignIn:(NSString*)username Password:(NSString*)password SSOUsing:(NSString*)ssoUsing;
-(int)getSignUpWithGooglePlus:(GTLPlusPerson*)person;
-(void)setuserInfo:(NSString*)userId withUserName:(NSString*)username withEmailId:(NSString*)emailId withProfilePicURL:(NSURL*)profilePicURL withPhoneNumber:(NSString*)phoneNumber withFirstName:(NSString*)firstName withLastName:(NSString*)lastName withFullName:(NSString*)fullName withDateOfBirth:(NSString*)dateOfBirth withJoiningDate:(NSString*)joiningDate withSnoopTime:(int)snoopTime;
@end
