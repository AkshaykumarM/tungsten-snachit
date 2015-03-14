//
//  ShippingInformation.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "ShippingInformation.h"
#import "ShippingInfoCell.h"
#import "ShippingInfoTableCellcell.h"
#import "SWRevealViewController.h"
#import "SnatchFeed.h"
#import "UserProfile.h"
#import "global.h"
#import "DBManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ShippingInformation()
@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrAddressInfo;
@end
@implementation ShippingInformation
{
    UserProfile *user;
    NSUserDefaults *defaults;
}
@synthesize checkedIndexPath;
- (void)viewDidLoad {
    [super viewDidLoad];
        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"snachit.sql"];
    // Set the Label text with the selected recipe
    
    [self loadData];
   
    [self.backButton setTarget:self.revealViewController];
    [self.backButton setAction:@selector(revealToggle:)];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    defaults=[NSUserDefaults standardUserDefaults];
    if(RECENTLY_ADDED_SHIPPING_INFO_TRACKER==-1)
    {
        if([[defaults valueForKey:DEFAULT_SHIPPING] intValue]>=1)
        RECENTLY_ADDED_SHIPPING_INFO_TRACKER= [[defaults valueForKey:DEFAULT_SHIPPING] intValue];
        else
        RECENTLY_ADDED_SHIPPING_INFO_TRACKER=-1;

    }
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    user=[UserProfile sharedInstance];
    [self viewDidLoad];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.tableView1 reloadData];
  }

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(tableView==self.tableView1)
    {
    return 1;
    }
    else{
        return self.arrAddressInfo.count;
    }
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.tableView1)
    {
        return 600;
    }
    else{
   
        return 80;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.tableView1)
    {

    ShippingInfoCell *cell = (ShippingInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"ShippingInfoCell" forIndexPath:indexPath];
        if (self.arrAddressInfo==nil) {
            tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        }
    cell.profilePicImg.layer.cornerRadius=RADIOUS;
    cell.profilePicImg.clipsToBounds=YES;
    cell.profilePicImg.layer.borderWidth=BORDERWIDTH;
    cell.profilePicImg.layer.borderColor=[UIColor whiteColor].CGColor;
    if(![user.fullName isKindOfClass:[NSNull class]])
        cell.fullnameLbl.text=[[NSString stringWithFormat:@"%@",user.fullName] uppercaseString];
    
    cell.memberSinceLbl.text=[NSString stringWithFormat:@"Member since %@",[user.joiningDate substringFromIndex:[user.joiningDate length]-4]];
    
    
    [cell.profilePicImg setImageWithURL:user.profilePicUrl placeholderImage:[UIImage imageNamed:@"userIcon.png"]];
    
    cell.fullnameLbl.adjustsFontSizeToFitWidth=YES;
    cell.fullnameLbl.minimumScaleFactor=0.5;
    //setting background img
    
    if([defaults valueForKey:DEFAULT_BACK_IMG])
        cell.backImageView.image=[UIImage imageWithData:[defaults valueForKey:DEFAULT_BACK_IMG]];

    
    return cell;
    }
    else{
        ShippingInfoTableCellcell *cell = (ShippingInfoTableCellcell *)[tableView dequeueReusableCellWithIdentifier:@"ShippingInfoTableCellcell" forIndexPath:indexPath];
        NSInteger indexOfFullName = [self.dbManager.arrColumnNames indexOfObject:@"fullName"];
        NSInteger indexOfStreetAddress = [self.dbManager.arrColumnNames indexOfObject:@"streetAddress"];
        NSInteger indexOfCity = [self.dbManager.arrColumnNames indexOfObject:@"city"];
        NSInteger indexOfState = [self.dbManager.arrColumnNames indexOfObject:@"state"];
        NSInteger indexOfZip = [self.dbManager.arrColumnNames indexOfObject:@"zip"];
        
        // Set the loaded data to the appropriate cell labels.
        
        cell.nameLbl.text = [NSString stringWithFormat:@"%@", [[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfFullName]];
        
        cell.streetNameLbl.text = [NSString stringWithFormat:@"%@", [[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfStreetAddress]];
        
        cell.addressLbl.text = [NSString stringWithFormat:@"%@,%@ %@", [[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCity],[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfState],[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfZip]];
        int rowid=[[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        cell.tag=rowid;
        
        if(rowid==RECENTLY_ADDED_SHIPPING_INFO_TRACKER){
            cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_mark.png"]];
        }
        
        else{
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.accessoryView=nil;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if(tableView!=self.tableView1){
    UITableViewCell *tmp = [tableView cellForRowAtIndexPath:checkedIndexPath];
        tmp.accessoryView=nil;
    self.checkedIndexPath = nil;
    if(self.checkedIndexPath)
    {
        UITableViewCell* uncheckCell = [tableView
                                        cellForRowAtIndexPath:self.checkedIndexPath];
        uncheckCell.accessoryView=nil;
    }
    if([self.checkedIndexPath isEqual:indexPath])
    {
        self.checkedIndexPath = nil;
    }
    else
    {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_mark.png"]];
        self.checkedIndexPath = indexPath;
        
        RECENTLY_ADDED_SHIPPING_INFO_TRACKER=cell.tag;
    }
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView!=self.tableView1)
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}



-(void)loadData{
    // Form the query.
    NSString *query = @"select * from address";
    
    // Get the results.
    if (self.arrAddressInfo != nil) {
        self.arrAddressInfo = nil;
    }
    self.arrAddressInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tableView1 reloadData];
}



-(void) getPhoto:(id) sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
     ShippingInfoCell *cell = (ShippingInfoCell*)[self.tableView1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [picker dismissViewControllerAnimated:YES completion:nil];
    cell.backImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}

- (IBAction)doneBtn:(id)sender {
    
    if(RECENTLY_ADDED_SHIPPING_INFO_TRACKER>0){
        
        [defaults setObject:[NSString stringWithFormat:@"%d",RECENTLY_ADDED_SHIPPING_INFO_TRACKER] forKey:DEFAULT_SHIPPING];
        [defaults synchronize];
        [global showAllertMsg:@"Saved successfully"];
    }
    else{
        [global showAllertMsg:@"Please select atleast one shipping address."];
    }

}


@end
