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

@property (weak, nonatomic) IBOutlet UIButton *gPlusBtn;

- (IBAction)loginHereBtn:(id)sender;

@end
