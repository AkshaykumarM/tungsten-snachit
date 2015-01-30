//
//  AccountSetting.h
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator.h"
@interface AccountSetting : UIViewController



@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIView *accountSettingView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *uiView;
@property (weak, nonatomic) IBOutlet TextFieldValidator *emailTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *nameTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *phoneNoTextField;
@property (weak, nonatomic) IBOutlet UIImageView *appsTopBar;
@property (weak, nonatomic) IBOutlet UIImageView *emailTopBar;
@property (weak, nonatomic) IBOutlet UIImageView *SMSTopBar;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *memberSinceLbl;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

- (IBAction)doneBtn:(id)sender;
-(int)updateUserProfile;
-(NSDictionary*)getProfileUpdateValues;
@end
