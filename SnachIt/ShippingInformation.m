//
//  ShippingInformation.m
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "ShippingInformation.h"
#import "ShippingInfoCell.h"
#import "ShippingInfoTableCellcell.h"
#import "SWRevealViewController.h"
#import "SnatchFeed.h"
#import "UserProfile.h"
#import "global.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "SnachItDB.h"
#import "SnachItAddressInfo.h"
@interface ShippingInformation()

@end
@implementation ShippingInformation
{
    UserProfile *user;
    NSUserDefaults *defaults;
    NSArray *snachItAddressInfo;
    int i;
}
@synthesize checkedIndexPath;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewLookAndFeel];
    UITableView *tb2=(UITableView *)[self.view viewWithTag:5];
  
    tb2.rowHeight = UITableViewAutomaticDimension;
    UITableView *tb1=(UITableView *)[self.view viewWithTag:1];
    tb1.estimatedRowHeight = 600; // for example. Set your average height
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    user=[UserProfile sharedInstance];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
     [self loadData];
    i=0;
    
  }
-(void)setViewLookAndFeel{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [btn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    btn.imageEdgeInsets=UIEdgeInsetsMake(5,5,4,5);
    UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = eng_btn;
    
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
        return [snachItAddressInfo count];
    }
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(tableView==self.tableView1)
//    {
//        return 600;
//    }
//    else{
//        
//        return 80;
//    }
//
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.tableView1)
    {

    ShippingInfoCell *cell = (ShippingInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"ShippingInfoCell" forIndexPath:indexPath];
        if (snachItAddressInfo==nil) {
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
        
        SnachItAddressInfo *info=[snachItAddressInfo objectAtIndex:indexPath.row];
        // Set the loaded data to the appropriate cell labels.
        
        cell.nameLbl.text = [NSString stringWithFormat:@"%@",info.name];
        
        cell.streetNameLbl.text = [NSString stringWithFormat:@"%@",info.street];
        
        cell.addressLbl.text = [NSString stringWithFormat:@"%@,%@ %@", info.city,info.state,[NSString stringWithFormat:@"%d",info.zip ]];
        int rowid=info.uniqueId;
        cell.tag=rowid;
        if(rowid==RECENTLY_ADDED_SHIPPING_INFO_TRACKER){
            @try{
            if(i==0){
            [tableView selectRowAtIndexPath:indexPath animated:TRUE scrollPosition:UITableViewScrollPositionNone];
            self.checkedIndexPath=indexPath;
                i++;
            }}
            @catch(NSException *e){
                
            }
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
        [tableView deselectRowAtIndexPath:self.checkedIndexPath animated:NO];
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
        RECENTLY_ADDED_SHIPPING_INFO_TRACKER=indexPath.row;
    }
    }
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
      if(tableView!=self.tableView1){
    if (cell.isSelected) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_mark.png"]]; // No reason to create a new one every time, right?
    }
    else {
        cell.accessoryView = nil;
    }
      }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
      RECENTLY_ADDED_SHIPPING_INFO_TRACKER=self.checkedIndexPath.row;
}
-(void)loadData{
    // Form the query.
     CURRENTDB=SnachItDBFile;
    snachItAddressInfo = [SnachItDB database].snachItAddressInfo;
    
    // Reload the table view.
     UITableView *tbl = (UITableView *)[self.view viewWithTag:5];
    [tbl reloadData];
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
        
        [defaults setObject:[NSString stringWithFormat:@"%lu",(unsigned long)RECENTLY_ADDED_SHIPPING_INFO_TRACKER] forKey:DEFAULT_SHIPPING];
        [defaults synchronize];
        [global showAllertMsg:@"Saved successfully"];
    }
    else{
        [global showAllertMsg:@"Please select atleast one shipping address."];
    }

}



- (IBAction)addAddress:(id)sender {
    
    [self performSegueWithIdentifier:@"addaddressSegue" sender:nil];
}
@end
