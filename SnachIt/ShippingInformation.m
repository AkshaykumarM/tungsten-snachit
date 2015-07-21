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
#import "ShippingInfoOverview.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SnachItDB.h"
#import "SnachItAddressInfo.h"
#define ADDSEGUE @"addaddressSegue"
#define EDITSEGUE @"editAddressSegue"
@interface ShippingInformation()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int recordIDToEdit;
@end
@implementation ShippingInformation
{
    UserProfile *user;
    NSUserDefaults *defaults;
    NSMutableArray *snachItAddressInfo;
    int i;
    NSIndexPath *deletepath;
    BOOL hasAccessoryview;
    }
@synthesize checkedIndexPath,lastcheckeckedcelltag;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewLookAndFeel];
    UITableView *tb2=(UITableView *)[self.view viewWithTag:5];
  
    tb2.rowHeight = UITableViewAutomaticDimension;
    UITableView *tb1=(UITableView *)[self.view viewWithTag:1];
    tb1.estimatedRowHeight = 600; // for example. Set your average height
    defaults=[NSUserDefaults standardUserDefaults];
    hasAccessoryview=false;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    user=[UserProfile sharedInstance];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    i=0;
     [self loadData];
    
    
  }
-(void)setViewLookAndFeel{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [btn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [btn setImage:[UIImage imageNamed:BACKARROW] forState:UIControlStateNormal];
    btn.imageEdgeInsets=UIEdgeInsetsMake(2,2,2,2);
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
    
    if(tableView.tag==1)
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
    if(tableView.tag==1)
    {

    ShippingInfoCell *cell = (ShippingInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"ShippingInfoCell" forIndexPath:indexPath];
        if (snachItAddressInfo==nil) {
            tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        }
  
    cell.profilePicImg.layer.cornerRadius=RADIOUS;
    cell.profilePicImg.clipsToBounds=YES;
    
    if(![user.fullName isKindOfClass:[NSNull class]])
        cell.fullnameLbl.text=[[NSString stringWithFormat:@"%@",user.fullName] uppercaseString];
    
    cell.memberSinceLbl.text=[NSString stringWithFormat:@"%@%@",MEMBER_SINCE,[user.joiningDate substringFromIndex:[user.joiningDate length]-4]];
    
    
    [cell.profilePicImg setImageWithURL:user.profilePicUrl placeholderImage:[UIImage imageNamed:DEFAULTPLACEHOLDER]];
    
    cell.fullnameLbl.adjustsFontSizeToFitWidth=YES;
    cell.fullnameLbl.minimumScaleFactor=0.5;
    //setting background img
       // [cell.backImageView setImageWithURL:user.backgroundUrl placeholderImage:[UIImage imageNamed:DEFAULTBACKGROUNDIMG]];

    
    return cell;
    }
    else{
        ShippingInfoTableCellcell *cell = (ShippingInfoTableCellcell *)[tableView dequeueReusableCellWithIdentifier:@"ShippingInfoTableCellcell" forIndexPath:indexPath];
        
        SnachItAddressInfo *info=[snachItAddressInfo objectAtIndex:indexPath.row];
        // Set the loaded data to the appropriate cell labels.
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        cell.nameLbl.text = [NSString stringWithFormat:@"%@",info.name];
        
        cell.streetNameLbl.text = [NSString stringWithFormat:@"%@",info.street];
        
        cell.addressLbl.text = [NSString stringWithFormat:@"%@,%@, %@", info.city,info.state,info.zip ];
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        RECENTLY_ADDED_SHIPPING_INFO_TRACKER=[[def valueForKey:[NSString stringWithFormat:@"%@%@",DEFAULT_SHIPPING,user.userID]] integerValue];
        int rowid=info.uniqueId;
        cell.tag=rowid;
        
        if(rowid==RECENTLY_ADDED_SHIPPING_INFO_TRACKER){
            
                [cell.checkmarkImgView setHighlighted:YES];
                self.checkedIndexPath=indexPath;
                lastcheckeckedcelltag=cell.tag;
        }
    
        else{
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell.checkmarkImgView setHighlighted:NO];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if(tableView.tag!=1){
       
       ShippingInfoTableCellcell *scell = (ShippingInfoTableCellcell*)[tableView cellForRowAtIndexPath:self.checkedIndexPath];
        [scell.checkmarkImgView setHighlighted:NO];
        
        ShippingInfoTableCellcell *cell = (ShippingInfoTableCellcell*)[tableView cellForRowAtIndexPath:indexPath];
        [cell.checkmarkImgView setHighlighted:!cell.checkmarkImgView.isHighlighted];
        SnachItAddressInfo *obj=[snachItAddressInfo objectAtIndex:indexPath.row];
        obj.selected=!obj.selected;
        lastcheckeckedcelltag=cell.tag;
        self.checkedIndexPath=indexPath;
        RECENTLY_ADDED_SHIPPING_INFO_TRACKER=cell.tag;
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        [def setObject:[NSString stringWithFormat:@"%d",RECENTLY_ADDED_SHIPPING_INFO_TRACKER] forKey:[NSString stringWithFormat:@"%@%@",DEFAULT_SHIPPING,user.userID]];
 
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     UITableView *tbl = (UITableView *)[self.view viewWithTag:5];
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) { // Set buttonIndex == 0 to handel "Ok"/"Yes" button response
         @try{
       BOOL status=[[SnachItDB database] deleteRecordFromAddress:[[tbl cellForRowAtIndexPath:deletepath] tag] Userid:user.userID];
        if(status){
            RECENTLY_ADDED_SHIPPING_INFO_TRACKER=-1;
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            [tbl beginUpdates];
            @try{
                [snachItAddressInfo removeObjectAtIndex: deletepath.row];
            }
            @catch(NSException *e){
            }
            [tbl deleteRowsAtIndexPaths:@[deletepath] withRowAnimation:UITableViewRowAnimationFade];
            [tbl endUpdates];
            [def setObject:[NSString stringWithFormat:@"%d",RECENTLY_ADDED_SHIPPING_INFO_TRACKER] forKey:[NSString stringWithFormat:@"%@%@",DEFAULT_SHIPPING,user.userID]];
            
            deletepath=nil;
        }
         }@catch(NSException *e){}
        
    }
    else{
        [tbl reloadRowsAtIndexPaths:[NSArray arrayWithObjects:deletepath, nil] withRowAnimation:YES];
         deletepath=nil;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    
      RECENTLY_ADDED_SHIPPING_INFO_TRACKER=self.checkedIndexPath.row;
    
   }
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
   
        // Do your stuff here
        UITableView *tbl = (UITableView *)[self.view viewWithTag:5];
    [tbl reloadData];
}
-(void)loadData{
    // Form the query.
     CURRENTDB=SnachItDBFile;
    snachItAddressInfo = [[[SnachItDB database] snachItAddressInfo:user.userID] mutableCopy];
    
    // Reload the table view.
     UITableView *tbl = (UITableView *)[self.view viewWithTag:5];
    
    
    [tbl reloadData];
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            // Get the record ID of the selected name and set it to the recordIDToEdit property.
         
           self.recordIDToEdit = cell.tag;
           [self performSegueWithIdentifier:EDITSEGUE sender:nil];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            UITableView *tbl = (UITableView *)[self.view viewWithTag:5];
            NSIndexPath *cellIndexPath = [tbl indexPathForCell:cell];
                deletepath=cellIndexPath;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure you want to delete this information?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
                [alert show];
            
            break;
        }
        default:
            break;
    }
}



- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            if(hasAccessoryview){
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CHECKMARK_ICON]]; // No reason to create a new one every time, right?
                [cell.accessoryView setFrame:CGRectMake(0, 0, 24, 24)];
                cell.accessoryView.contentMode=UIViewContentModeScaleAspectFit;
            }
            break;
        case 1:
           
            break;
        case 2:
            if(cell.accessoryView!=nil)
            {
                hasAccessoryview=true;
                cell.accessoryView=nil;
               // RECENTLY_ADDED_SHIPPING_INFO_TRACKER=-1;
            }
            else{
                hasAccessoryview=false;
            }
            break;
        default:
            break;
    }
}
//-(void) getPhoto:(id) sender {
//    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    
//    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    
//    [self presentViewController:picker animated:YES completion:nil];
//}
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//     ShippingInfoCell *cell = (ShippingInfoCell*)[self.tableView1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    cell.backImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//}




- (IBAction)doneBtn:(id)sender {
    
    if(RECENTLY_ADDED_SHIPPING_INFO_TRACKER>0){
        
        [defaults setObject:[NSString stringWithFormat:@"%lu",(unsigned long)RECENTLY_ADDED_SHIPPING_INFO_TRACKER] forKey:[NSString stringWithFormat:@"%@%@",DEFAULT_SHIPPING,user.userID]];
        [defaults synchronize];
        [global showAllertMsg:@"Alert" Message:@"Saved successfully"];
    }
    else{
        [global showAllertMsg:@"Alert" Message:@"Please select atleast one shipping address."];
    }

}

//This method returns more and delete buttons
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Edit"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ShippingInfoOverview *editInfoViewController = [segue destinationViewController];
    editInfoViewController.delegate = self;
    if ([[segue identifier] isEqualToString:EDITSEGUE])
    {
    editInfoViewController.recordIDToEdit = self.recordIDToEdit;
    editInfoViewController.lastCheckedRecord=lastcheckeckedcelltag;
    }
    else{
        editInfoViewController.recordIDToEdit = -1;
    }
}

- (IBAction)addAddress:(id)sender {
    
    [self performSegueWithIdentifier:ADDSEGUE sender:nil];
}


#pragma mark - ShippingInfoControllerDelegate method implementation

-(void)editingInfoWasFinished{
    // Reload the data.
    [self loadData];
}

@end
