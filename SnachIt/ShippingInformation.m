//
//  ShippingInformation.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "ShippingInformation.h"
#import "ShippingInfoCell.h"
#import "SWRevealViewController.h"
#import "SnatchFeed.h"
#import "UserProfile.h"
#import "global.h"
@interface ShippingInformation()

@end
@implementation ShippingInformation
{
    UserProfile *user;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    user=[UserProfile sharedInstance];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
  }

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 600;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShippingInfoCell *cell = (ShippingInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"ShippingInfoCell" forIndexPath:indexPath];
    cell.profilePicImg.layer.cornerRadius=RADIOUS;
    cell.profilePicImg.clipsToBounds=YES;
    cell.profilePicImg.layer.borderWidth=BORDERWIDTH;
    cell.profilePicImg.layer.borderColor=[UIColor whiteColor].CGColor;
    if(![user.fullName isKindOfClass:[NSNull class]])
        cell.fullnameLbl.text=[[NSString stringWithFormat:@"%@",user.fullName] uppercaseString];
    
    cell.memberSinceLbl.text=[NSString stringWithFormat:@"Member since %@",[user.joiningDate substringFromIndex:[user.joiningDate length]-4]];
    
    
    if([global isValidUrl:user.profilePicUrl]){
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:user.profilePicUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            cell.profilePicImg.image = [UIImage imageWithData:data];
        }];
    }
    cell.fullnameLbl.adjustsFontSizeToFitWidth=YES;
    cell.fullnameLbl.minimumScaleFactor=0.5;

    
    return cell;
}



- (IBAction)backBtn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SnatchFeed *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"snachfeed"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [navController setViewControllers: @[rootViewController] animated: YES];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.35;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.view.window.layer addAnimation:transition forKey:nil];
 
    [self.revealViewController pushFrontViewController:navController animated:NO];
    
}
@end
