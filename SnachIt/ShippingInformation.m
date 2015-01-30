//
//  ShippingInformation.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "ShippingInformation.h"
#import "SWRevealViewController.h"
#import "SnatchFeed.h"
#import "UserProfile.h"

@interface ShippingInformation()

@end
@implementation ShippingInformation
{
    UserProfile *user;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewLookAndFeel];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    user=[UserProfile sharedInstance];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [self initialLize];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)setViewLookAndFeel{
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    self.profilePic.layer.cornerRadius= self.profilePic.frame.size.width/1.96;
    
    
    self.profilePic.clipsToBounds = YES;
    self.profilePic.layer.borderWidth = 3.0f;
    self.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
}
-(void)initialLize{
    
    if(user.profilePicUrl!=nil){
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:user.profilePicUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            self.profilePic.image = [UIImage imageWithData:data];
        }];
    }
    if(![user.fullName isKindOfClass:[NSNull class]])
        self.fullNameLbl.text=[[NSString stringWithFormat:@"%@",user.fullName] uppercaseString];
    
    self.memberSinceLbl.text=[NSString stringWithFormat:@"Member since %@",[user.joiningDate substringFromIndex:[user.joiningDate length]-4]];
    self.fullNameLbl.adjustsFontSizeToFitWidth=YES;
    self.fullNameLbl.minimumScaleFactor=0.5;
}

- (IBAction)backBtn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SnatchFeed *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"snachfeed"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [navController setViewControllers: @[rootViewController] animated: YES];
    
    [self.revealViewController pushFrontViewController:navController animated:YES];
    
}
@end
