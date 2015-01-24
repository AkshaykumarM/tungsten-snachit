//
//  SnachItLogin.h
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/24/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
@class GPPSignInButton;
@interface SnachItLogin : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTfield;

- (IBAction)fbBtn:(id)sender;

- (IBAction)gPlusBtn:(id)sender;

- (IBAction)twBtn:(id)sender;




- (IBAction)signInBtn:(id)sender;

- (IBAction)signUpHereBtn:(id)sender;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mySpinner;
-(void)checkSessionIFActive;
-(void)googleSignIn;
@end
