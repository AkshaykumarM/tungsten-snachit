//
//  SnachitSignup.h
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/26/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnachitSignup : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)signUpBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *fbBtn;
@property (weak, nonatomic) IBOutlet UIButton *twBtn;
@property (weak, nonatomic) IBOutlet UILabel *errorLbl;

@property (weak, nonatomic) IBOutlet UIButton *gPlusBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)loginHereBtn:(id)sender;

-(int)getSignUp:(NSString*)firstName LastName:(NSString*)lastName FullName:(NSString*)fullName EmailId:(NSString*)emailid Username:(NSString*)username Password:(NSString*)password Profilepic:(NSString*)profile_pic PhoneNo:(NSString*)phoneNo APNSToken:(NSString*)apnsToken SignUpVia:(NSString*)signUpVia DOB:(NSString*)dob;

@end
