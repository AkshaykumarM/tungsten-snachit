//
//  BillingInformation.m
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "BillingInformation.h"
#import "BillingInfoOverview.h"
#import "SWRevealViewController.h"
#import "SnatchFeed.h"
#import "UserProfile.h"
#import "global.h"
#import "BillingInfoCell.h"
#import "BillingInformationCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RegexValidator.h"
#import "SnachItDB.h"
#import "SnachItPaymentInfo.h"
#define ADDSEGUE @"addcardsegue"
#define EDITSEGUE @"editcardsegue"
@interface BillingInformation()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int recordIDToEdit;
@end
@implementation BillingInformation
{
    UserProfile *user;
    NSUserDefaults *defaults;
    NSMutableArray *snachItPaymentInfo;
    int i;
    NSIndexPath *deletepath;
    BOOL hasAccessoryview;
}
@synthesize lastcheckeckedcelltag;
- (void)viewDidLoad {
    [super viewDidLoad];
   

    // Set the gesture
    
    [self setViewLookAndFeel];
    hasAccessoryview=false;
        defaults=[NSUserDefaults standardUserDefaults];


   
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
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==1)
    {
        return 1;
    }
    else{
        return [snachItPaymentInfo  count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==1)
    {
        return 600;
    }
    else{
        return 80;
    }
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   if(tableView.tag==1)
{
    BillingInfoCell *cell = (BillingInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"BillingInfoCell" forIndexPath:indexPath];
    cell.profilePicImg.layer.cornerRadius=RADIOUS;
    cell.profilePicImg.clipsToBounds=YES;
    if(![user.fullName isKindOfClass:[NSNull class]])
        cell.fullnameLbl.text=[[NSString stringWithFormat:@"%@",user.fullName] uppercaseString];
    
    cell.memberSinceLbl.text=[NSString stringWithFormat:@"%@%@",MEMBER_SINCE,[user.joiningDate substringFromIndex:[user.joiningDate length]-4]];
    
    
    [cell.profilePicImg setImageWithURL:user.profilePicUrl placeholderImage:[UIImage imageNamed:DEFAULTPLACEHOLDER]];
    
    cell.fullnameLbl.adjustsFontSizeToFitWidth=YES;
    cell.fullnameLbl.minimumScaleFactor=0.5;
    //setting background img
   
    //[cell.defBackImageView setImageWithURL:user.backgroundUrl placeholderImage:[UIImage imageNamed:DEFAULTBACKGROUNDIMG]];


    return cell;
}
else{
    BillingInformationCell *cell = (BillingInformationCell *)[tableView dequeueReusableCellWithIdentifier:@"BillingInformationCell" forIndexPath:indexPath];
    SnachItPaymentInfo *info=[snachItPaymentInfo objectAtIndex:indexPath.row];
    
    // Set the loaded data to the appropriate cell labels.
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    NSString *cardname=info.cardname;
    cell.CardTypeLbl.text = [NSString stringWithFormat:@"%@", cardname];
    cell.cardImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[cardname stringByReplacingOccurrencesOfString:@" " withString:@""].lowercaseString]];
    
    //displaying last three digit of card number
    NSString *tempNumber=info.cardnumber;
    cell.cvvLbl.text =[NSString stringWithFormat:@"**** - %@",[tempNumber substringFromIndex:[tempNumber length]-3]];
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    RECENTLY_ADDED_PAYMENT_INFO_TRACKER=(int)[[def valueForKey:[NSString stringWithFormat:@"%@%@",DEFAULT_BILLING,user.userID]] integerValue];
    
    int rowid=info.uniqueId;
    cell.tag=rowid;
    
    if(rowid==RECENTLY_ADDED_PAYMENT_INFO_TRACKER){
        cell.checkmarkImgView.tag=indexPath.row;
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
        
        BillingInformationCell *scell = (BillingInformationCell*)[tableView cellForRowAtIndexPath:self.checkedIndexPath];
        [scell.checkmarkImgView setHighlighted:NO];
        
        BillingInformationCell *cell = (BillingInformationCell*)[tableView cellForRowAtIndexPath:indexPath];
        [cell.checkmarkImgView setHighlighted:!cell.checkmarkImgView.isHighlighted];
        SnachItPaymentInfo *obj=[snachItPaymentInfo objectAtIndex:indexPath.row];
        obj.selected=!obj.selected;
        lastcheckeckedcelltag=cell.tag;
             self.checkedIndexPath=indexPath;        RECENTLY_ADDED_PAYMENT_INFO_TRACKER=cell.tag;
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        [def setObject:[NSString stringWithFormat:@"%d",RECENTLY_ADDED_PAYMENT_INFO_TRACKER] forKey:[NSString stringWithFormat:@"%@%@",DEFAULT_BILLING,user.userID]];
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag!=1){
    return YES;
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag!=1){
        return YES;
    }
    return NO;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITableView *tbl = (UITableView *)[self.view viewWithTag:5];
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) { // Set buttonIndex == 0 to handel "Ok"/"Yes" button response
        @try{
        BOOL status=[[SnachItDB database] deleteRecordFromPayment:[[tbl cellForRowAtIndexPath:deletepath] tag] Userid:user.userID];
        if(status){
            RECENTLY_ADDED_PAYMENT_INFO_TRACKER=-1;
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            [tbl beginUpdates];
            @try{
            [snachItPaymentInfo removeObjectAtIndex: deletepath.row];
            }
            @catch(NSException *e){
            }
            [tbl deleteRowsAtIndexPaths:@[deletepath] withRowAnimation:UITableViewRowAnimationFade];
            [tbl endUpdates];
            [def setObject:[NSString stringWithFormat:@"%d",RECENTLY_ADDED_PAYMENT_INFO_TRACKER] forKey:[NSString stringWithFormat:@"%@%@",DEFAULT_BILLING,user.userID]];
            
            deletepath=nil;
        }
        }@catch(NSException *e){}
    }
    else{
        [tbl reloadRowsAtIndexPaths:[NSArray arrayWithObjects:deletepath, nil] withRowAnimation:YES];
         deletepath=nil;
    }
}



-(NSString*)getCardType:(NSString*)number{
    NSString *type;
    NSPredicate* visa = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VISA];
    NSPredicate* mastercard = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MASTERCARD];
    NSPredicate* dinnersclub = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", DINNERSCLUB];
    NSPredicate* discover = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", DISCOVER];
    NSPredicate* amex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", AMEX];
    
    if ([visa evaluateWithObject:number])
    {
        type=@"visa";
    }
    else if ([mastercard evaluateWithObject:number])
    {
        type=@"mastercard";
    }
    else if ([dinnersclub evaluateWithObject:number])
    {
        type=@"dinersclub";
    }
    else if ([discover evaluateWithObject:number])
    {
        type=@"discover";
    }
    else if ([amex evaluateWithObject:number])
    {
        type=@"americanexpress";
    }
    else{
        type=@"none";
    }
    return type;
}


- (IBAction)saveBtn:(id)sender {
    if(RECENTLY_ADDED_PAYMENT_INFO_TRACKER>0){
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        [def setObject:[NSString stringWithFormat:@"%lu",(unsigned long)RECENTLY_ADDED_PAYMENT_INFO_TRACKER] forKey:[NSString stringWithFormat:@"%@%@",DEFAULT_BILLING,user.userID]];
        [def synchronize];
        [global showAllertMsg:@"Alert" Message:@"Saved successfully"];
    }
    else{
        [global showAllertMsg:@"Alert" Message:@"Please select atleast one billing address."];
    }

  
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
                cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:CHECKMARK_ICON]];
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
               //RECENTLY_ADDED_PAYMENT_INFO_TRACKER=-1;
            }
            else{
                hasAccessoryview=false;
            }
            
            break;
        default:
            break;
    }
}

- (IBAction)addCard:(id)sender {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.35;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self performSegueWithIdentifier:ADDSEGUE sender:nil];
   
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
    // Do your stuff here
    UITableView *tbl = (UITableView *)[self.view viewWithTag:5];
    [tbl reloadData];
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
    BillingInfoOverview *editInfoViewController = [segue destinationViewController];
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
-(void)loadData{
    // Form the query.
    CURRENTDB=SnachItDBFile;
    snachItPaymentInfo = [[[SnachItDB database] snachItPaymentInfo:user.userID] mutableCopy];

    UITableView *tbl = (UITableView *)[self.view viewWithTag:5];
    [tbl reloadData];
}

#pragma mark - BillingInfoControllerDelegate method implementation

-(void)editingInfoWasFinished{
    // Reload the data.
    [self loadData];
}


@end
