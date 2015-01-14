//
//  SnachitStartScreen.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/24/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//
#import "SnachItLogin.h"
#import "SnachitSignup.h"
#import "SnachitStartScreen.h"
#import <FacebookSDK/FacebookSDK.h>
NSString *const LOGINSEGUE=@"logInSegue";
@interface SnachitStartScreen()



@end
@implementation SnachitStartScreen
@synthesize signUpBtn,logInBtn;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setViewLookAndFeel];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkSessionIFActive];
}

-(void)checkSessionIFActive{
         if(FBSession.activeSession.isOpen){
        //[self performSegueWithIdentifier:LOGINSEGUE sender:self];
}

}
-(void) setViewLookAndFeel{
    
    self.signUpBtn.layer.borderWidth = 2.0f;
    self.logInBtn.layer.borderWidth = 2.0f;
    
    self.signUpBtn.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4].CGColor;
    self.logInBtn.layer.borderColor =[UIColor colorWithRed:1 green:1 blue:1 alpha:0.4].CGColor;
    
    
}
- (IBAction)logInBtn:(id)sender {
   SnachItLogin *startscreen = [[SnachItLogin alloc]
                                       initWithNibName:@"LoginScreen" bundle:nil];
    [self presentViewController:startscreen animated:YES completion:nil];

}
- (IBAction)signUpBtn:(id)sender {
    SnachitSignup *startscreen = [[SnachitSignup alloc]
                                 initWithNibName:@"SignUpScreen" bundle:nil];
    [self presentViewController:startscreen animated:YES completion:nil];
}
@end
