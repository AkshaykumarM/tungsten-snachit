//
//  SnachitSignup.h
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/26/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnachitSignup : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)signUpBtn:(id)sender;

- (IBAction)fbBtn:(id)sender;

- (IBAction)twBtn:(id)sender;

- (IBAction)gplusBtn:(id)sender;

- (IBAction)loginBtn:(id)sender;




- (IBAction)loginHereBtn:(id)sender;

-(NSInteger)getSignUp:(NSString*)firstName LastName:(NSString*)lastName FullName:(NSString*)fullName EmailId:(NSString*)emailid Username:(NSString*)username Password:(NSString*)password Profilepic:(NSString*)profile_pic PhoneNo:(NSString*)phoneNo APNSToken:(NSString*)apnsToken SignUpVia:(NSString*)signUpVia DOB:(NSString*)dob;

@end
