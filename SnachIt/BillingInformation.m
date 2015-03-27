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

@interface BillingInformation()
@end
@implementation BillingInformation
{
    UserProfile *user;
    NSUserDefaults *defaults;
    NSArray *snachItPaymentInfo;
    int i;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   

    // Set the gesture
    
    [self setViewLookAndFeel];
    
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
    [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    btn.imageEdgeInsets=UIEdgeInsetsMake(5,5,4,5);
    UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = eng_btn;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.tableView1)
    {
        return 1;
    }
    else{
        return [snachItPaymentInfo  count];
    }
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
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   if(tableView==self.tableView1)
{
    BillingInfoCell *cell = (BillingInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"BillingInfoCell" forIndexPath:indexPath];
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
        cell.defBackImageView.image=[UIImage imageWithData:[defaults valueForKey:DEFAULT_BACK_IMG]];


    return cell;
}
else{
    BillingInformationCell *cell = (BillingInformationCell *)[tableView dequeueReusableCellWithIdentifier:@"BillingInformationCell" forIndexPath:indexPath];
    SnachItPaymentInfo *info=[snachItPaymentInfo objectAtIndex:indexPath.row];
    
    // Set the loaded data to the appropriate cell labels.
    NSString *cardname=info.cardname;
    cell.CardTypeLbl.text = [NSString stringWithFormat:@"%@", cardname];
    cell.cardImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[cardname stringByReplacingOccurrencesOfString:@" " withString:@""].lowercaseString]];
    
    //displaying last three digit of card number
    NSString *tempNumber=info.cardnumber;
    cell.cvvLbl.text =[NSString stringWithFormat:@"**** - %@",[tempNumber substringFromIndex:[tempNumber length]-3]];
    
    cell.tag=info.uniqueId;

    int rowid=info.uniqueId;
    
    if(rowid==RECENTLY_ADDED_PAYMENT_INFO_TRACKER){
        if(i==0){
            @try{
        self.checkedIndexPath=indexPath;
        [tableView selectRowAtIndexPath:indexPath animated:TRUE scrollPosition:UITableViewScrollPositionNone];
                
            }
            @catch(NSException *e){
                
            }
            i++;
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
    [tableView deselectRowAtIndexPath:self.checkedIndexPath animated:NO];
    if(tableView!=self.tableView1){
        
        UITableViewCell *tmp = [tableView cellForRowAtIndexPath:self.checkedIndexPath];
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
        RECENTLY_ADDED_PAYMENT_INFO_TRACKER=(int)indexPath.row;
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
        [def setObject:[NSString stringWithFormat:@"%lu",(unsigned long)RECENTLY_ADDED_PAYMENT_INFO_TRACKER] forKey:DEFAULT_BILLING];
        [def synchronize];
        [global showAllertMsg:@"Saved successfully"];
    }
    else{
        [global showAllertMsg:@"Please select atleast one billing address."];
    }

  
}


- (IBAction)addCard:(id)sender {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.35;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self performSegueWithIdentifier:@"addcardsegue" sender:nil];
   
}
-(void)loadData{
    // Form the query.
    CURRENTDB=SnachItDBFile;
    snachItPaymentInfo = [SnachItDB database].snachItPaymentInfo;

    UITableView *tbl = (UITableView *)[self.view viewWithTag:5];
    [tbl reloadData];
}
@end
