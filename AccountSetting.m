//
//  AccountSetting.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "AccountSetting.h"
#import "SWRevealViewController.h"


@implementation AccountSetting
@synthesize emailTextField=_emailTextField;
@synthesize nameTextField=_nameTextField;
@synthesize phoneNoTextField=_phoneNoTextField;
@synthesize appAlertsSwitch=_appAlertsSwitch;
@synthesize emailAlertsSwitch=_emailAlertsSwitch;
@synthesize smsAlertsSwitch=_smsAlertsSwitch;
- (void)viewDidLoad {
    [super viewDidLoad];
    [_scrollView setScrollEnabled:YES];
    [_scrollView setContentSize:CGSizeMake(320, 568)];
    [self setViewLookAndFeel];
    
    // Load the file content and read the data into arrays
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setViewLookAndFeel];
    // Release any retained subviews of the main view.
}


-(void)setViewLookAndFeel{
    UIColor *borderColor=[UIColor colorWithRed:0.792 green:0.792 blue:0.792 alpha:0.4];
  
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.profilePic.layer.cornerRadius= self.profilePic.frame.size.width/1.96;
    
    
    self.profilePic.clipsToBounds = YES;
    self.profilePic.layer.borderWidth = 5.0f;
    self.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    
   _accountSettingView=[[[NSBundle mainBundle]loadNibNamed:@"AccountSettingView" owner:self options:nil] objectAtIndex:0];
  
    _accountSettingView.frame=CGRectMake(0.0f,_profilePic.frame.origin.y+_profilePic.frame.size.height, _accountSettingView.frame.size.width, _accountSettingView.frame.size.height);
    
    [_uiView addSubview:_accountSettingView];
    
        
    
      CALayer *border1 = [CALayer layer];
      CALayer *border2  = [CALayer layer];
      CALayer *border3 = [CALayer layer];
    
     CGFloat borderWidth = 1;
     border1.borderColor =borderColor.CGColor;
     border1.frame = CGRectMake(0, self.emailTextField.frame.size.height - borderWidth, self.emailTextField.frame.size.width, self.emailTextField.frame.size.height);
        border1.borderWidth = borderWidth;
        [self.emailTextField.layer addSublayer:border1];
    self.emailTextField.layer.masksToBounds = YES;

   
        border2.borderColor =borderColor.CGColor;
   border2.frame = CGRectMake(0, self.nameTextField.frame.size.height - borderWidth, self.nameTextField.frame.size.width, self.nameTextField.frame.size.height);
    border2.borderWidth = borderWidth;
    [self.nameTextField.layer addSublayer:border2];
    self.nameTextField.layer.masksToBounds = YES;
    
    border3.borderColor =borderColor.CGColor;
    border3.frame = CGRectMake(0, self.phoneNoTextField.frame.size.height - borderWidth, self.phoneNoTextField.frame.size.width, self.phoneNoTextField.frame.size.height);
    border3.borderWidth = borderWidth;
    [self.phoneNoTextField.layer addSublayer:border3];
   self.phoneNoTextField.layer.masksToBounds = YES;
    
    
}
@end
