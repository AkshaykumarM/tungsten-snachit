//
//  AccountSetting.h
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountSetting : UIViewController



@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIView *accountSettingView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *uiView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNoTextField;
@property (weak, nonatomic) IBOutlet UIImageView *appsTopBar;
@property (weak, nonatomic) IBOutlet UIImageView *emailTopBar;
@property (weak, nonatomic) IBOutlet UIImageView *SMSTopBar;

@end
