//
//  ChangePasswordViewController.h
//  SnachIt
//
//  Created by Jayesh Kitukale on 5/13/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *currentPasswordTXTF;

@property (weak, nonatomic) IBOutlet UITextField *PasswordTXTF;

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTXTF;
- (IBAction)saveAction:(id)sender;
- (IBAction)closeAction:(id)sender;
- (IBAction)visibilityAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *showBTN;
- (IBAction)forgotPassword:(id)sender;
@end
