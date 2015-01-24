//
//  AccountSetting.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//



#import "AccountSetting.h"
#import "SWRevealViewController.h"
#import "SnachIt-Swift.h"

@implementation AccountSetting
@synthesize emailTextField=_emailTextField;
@synthesize nameTextField=_nameTextField;
@synthesize phoneNoTextField=_phoneNoTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    [_scrollView setScrollEnabled:YES];
    
    
    //    appAlertsSwitch= [[SevenSwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    //    appAlertsSwitch.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5 - 80);
    //    [appAlertsSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    //    appAlertsSwitch.offImage = [UIImage imageNamed:@"cross.png"];
    //    appAlertsSwitch.onImage = [UIImage imageNamed:@"check.png"];
    //    appAlertsSwitch.onTintColor = [UIColor colorWithHue:0.08f saturation:0.74f brightness:1.00f alpha:1.00f];
    //    appAlertsSwitch.isRounded = NO;
    
    
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
    self.profilePic.layer.cornerRadius= 35.0f;
    
    
    self.profilePic.clipsToBounds = YES;
    self.profilePic.layer.borderWidth = 3.0f;
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
    SevenSwitch *appAllertSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(self.appsTopBar.frame.size.width-100, self.appsTopBar.frame.origin.y+3, 80, 40)];
    
    
    appAllertSwitch.offImage = [UIImage imageNamed:@"check.png"];
    appAllertSwitch.onImage = [UIImage imageNamed:@"multiply.png"];
    appAllertSwitch.onTintColor = [UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] ;
    appAllertSwitch.inactiveColor=[UIColor colorWithRed:0.267 green:0.843 blue:0.369 alpha:1];
    appAllertSwitch.isRounded = NO;
    [self.accountSettingView addSubview:appAllertSwitch];

    SevenSwitch *emailAllertSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(self.emailTopBar.frame.size.width-100, self.emailTopBar.frame.origin.y+3, 80, 40)];
    
    
    emailAllertSwitch.offImage = [UIImage imageNamed:@"check.png"];
    emailAllertSwitch.onImage = [UIImage imageNamed:@"multiply.png"];
    emailAllertSwitch.onTintColor = [UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] ;
    emailAllertSwitch.inactiveColor=[UIColor colorWithRed:0.267 green:0.843 blue:0.369 alpha:1];
    emailAllertSwitch.isRounded = NO;
    [self.accountSettingView addSubview:emailAllertSwitch];
    
    SevenSwitch *smsAllertSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(self.SMSTopBar.frame.size.width-100, self.SMSTopBar.frame.origin.y+3, 80, 40)];
    
    
    smsAllertSwitch.offImage = [UIImage imageNamed:@"check.png"];
    smsAllertSwitch.onImage = [UIImage imageNamed:@"multiply.png"];
    smsAllertSwitch.onTintColor = [UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] ;
    smsAllertSwitch.inactiveColor=[UIColor colorWithRed:0.267 green:0.843 blue:0.369 alpha:1];
    smsAllertSwitch.isRounded = NO;
    [self.accountSettingView addSubview:smsAllertSwitch];
  
    
}
@end
