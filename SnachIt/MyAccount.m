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
@interface MyAccount ()
@property(nonatomic,strong) NSArray *options,*icons;

@property (nonatomic, strong) NSArray *menuItems;
@end


@implementation MyAccount

{
   
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

    self.profilePic.layer.cornerRadius= self.profilePic.frame.size.width/1.96;
    self.profilePic.clipsToBounds = YES;
    self.profilePic.layer.borderWidth = 5.0f;
    self.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initialLize];
}

-(void)initialLize{
    
    NSString *imageUrl = userProfilePic;
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        self.profilePic.image = [UIImage imageWithData:data];
    }];
    self.userNameLbl.text=userName;
    
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
