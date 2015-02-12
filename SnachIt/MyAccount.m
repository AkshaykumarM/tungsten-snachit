//
//  MyAccount.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/11/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "MyAccount.h"
#import "MyAccountOptions.h"
#import "SWRevealViewController.h"
#import "global.h"
#import "AFNetworking.h"
#import "UserProfile.h"
@interface MyAccount ()
@property(nonatomic,strong) NSArray *options,*icons;

@property (nonatomic, strong) NSArray *menuItems;
@end


@implementation MyAccount

{
    UserProfile *user;
    int  selectFlag;
}
@synthesize options ,icons,menuItems,userNameLbl;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewLookAndFeel];
    
    
    selectFlag= 0;
    options = [NSArray arrayWithObjects:@"My Account", @"Account Setting",@"Billing Information",@"Shipping Information",@"Snach History", nil];
    icons= [NSArray arrayWithObjects:@"myprofile.png",@"setting.png",@"billing.png",@"shpping_cart.png",@"snach_tag.png",nil];
    menuItems = [NSArray arrayWithObjects: @"myaccount", @"accountsetting", @"billing", @"shipping", @"snatchhistory",nil];
    
    
    // Load the file content and read the data into arrays
    }

-(void)setViewLookAndFeel{

    self.profilePic.layer.cornerRadius= RADIOUS;
    self.profilePic.clipsToBounds = YES;
    self.profilePic.layer.borderWidth = BORDERWIDTH;
    self.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initialLize];
}

-(void)viewWillAppear:(BOOL)animated{
    user=[UserProfile sharedInstance];
}
-(void)initialLize{
    
    if([global isValidUrl:user.profilePicUrl]){
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:user.profilePicUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        self.profilePic.image = [UIImage imageWithData:data];
    }];
    }
    if(![user.fullName isKindOfClass:[NSNull class]])
        self.userNameLbl.text=[[NSString stringWithFormat:@"%@",user.fullName] uppercaseString];

    self.memberSinceLbl.text=[NSString stringWithFormat:@"Member since %@",[user.joiningDate substringFromIndex:[user.joiningDate length]-4]];
    self.userNameLbl.adjustsFontSizeToFitWidth=YES;
    self.userNameLbl.minimumScaleFactor=0.5;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [options count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *simpleTableIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    
    MyAccountOptions *cell=(MyAccountOptions *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
   
    
    cell.option.text = [options objectAtIndex:indexPath.row];
    cell.icon.image = [UIImage imageNamed:[icons objectAtIndex:indexPath.row]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
        
    selectFlag= 1;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    selectFlag=0;
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

@end
