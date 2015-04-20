//
//  PaymentOverview.m
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/22/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "PaymentOverview.h"
#import "PaymentOverviewCell.h"
#import "AddNewCardForm.h"
#import "SnachCheckDetails.h"
#import "SnoopedProduct.h"
#import "SnoopingUserDetails.h"
#import "global.h"
#import "RegexValidator.h"
#import "SnachItDB.h"
#import "SnachItPaymentInfo.h"
#import "UserProfile.h"

#define STPSEAGUE @"backtoSTP"
#define ADDNEW @"addNewCardSeague"
#define EDIT @"editCardSeague"

@interface PaymentOverview()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int recordIDToEdit;
@end

@implementation PaymentOverview{
    SnoopedProduct *product;
    SnoopingUserDetails *userDetails;
    NSUserDefaults *defaults;
    NSArray *snachItPaymentInfo;
    int i;
    NSIndexPath *deletepath;
    UserProfile *user;
}
@synthesize brandImg,productImg,productPriceBtn,productDesc,productNameLbl,checkedIndexPath,lastchecked;

- (void)viewDidLoad
{
    [super viewDidLoad];

    defaults=[NSUserDefaults standardUserDefaults];
    screenName=@"po";
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self loadData];
    i=0;
    user=[UserProfile sharedInstance];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self initializeView];
    [super viewWillAppear:YES];
}

-(void)initializeView{
     self.navigationController.navigationBar.topItem.title = @"payment";
    @try{
    product=[SnoopedProduct sharedInstance];
    productNameLbl.text = [NSString stringWithFormat:@"%@",product.productName ];
    brandImg.image=[UIImage imageWithData:product.brandImageData];
    productImg.image=[UIImage imageWithData:product.productImageData];
    [productPriceBtn setTitle: product.productPrice forState: UIControlStateNormal];
    
    [productDesc loadHTMLString:[NSString stringWithFormat:@"<html>\n""<head>\n""<style type=\"text/css\">\n"" body{ font-size:%@;font-family:'Open Sans';}\n""</style>\n""</head>\n""<body>%@</body>\n""</html>",[NSNumber numberWithInt:14],product.productDescription ] baseURL:nil];
    }@catch(NSException *e){}
    //hiding the backbutton from top bar
    //[self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    btn.imageEdgeInsets=UIEdgeInsetsMake(5,5,4,5);
    UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = eng_btn;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect: self.subview.bounds];
   
    self.subview.layer.masksToBounds = NO;
    self.subview.layer.shadowColor = [UIColor blackColor].CGColor;
    self.subview.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);  /*Change value of X n Y as per your need of shadow to appear to like right bottom or left bottom or so on*/
    self.subview.layer.shadowOpacity = 0.8f;
    self.subview.layer.shadowRadius=2.5f;
    self.subview.layer.shadowPath = shadowPath.CGPath;

  }


-(void)back:(id)sender{
    [self performSegueWithIdentifier:STPSEAGUE sender:nil];
    
}
- (IBAction)addNewCardBtn:(id)sender{
    [self performSegueWithIdentifier:ADDNEW sender:self];
    
}
//- (IBAction)doneBtn:(id)sender {
//    [self performSegueWithIdentifier:STPSEAGUE sender:self];
//    
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [snachItPaymentInfo count];
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.

    PaymentOverviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paymentCell" forIndexPath:indexPath];

    SnachItPaymentInfo *info=[snachItPaymentInfo objectAtIndex:indexPath.row];
  
    cell.rightUtilityButtons=[self rightButtons];
    cell.delegate=self;
    // Set the loaded data to the appropriate cell labels.
    cell.cardImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[info.cardname stringByReplacingOccurrencesOfString:@" " withString:@""].lowercaseString]];
    cell.cardNameLbl.text = [NSString stringWithFormat:@"%@", info.cardname];
    
    
    //displaying last three digit of card number
    NSString *tempNumber=info.cardnumber;
    cell.cvvLbl.text =[NSString stringWithFormat:@"**** - %@",[tempNumber substringFromIndex:[tempNumber length]-3]];
    
    
   
    int rowid=info.uniqueId;
    cell.tag=rowid;
    //for auto selection
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    RECENTLY_ADDED_PAYMENT_INFO_TRACKER=[[def valueForKey:[NSString stringWithFormat:@"%@%@",DEFAULT_BILLING,user.userID]] intValue];
    
    if(rowid==RECENTLY_ADDED_PAYMENT_INFO_TRACKER ){
        @try{
            if(i==0){
        [tableView selectRowAtIndexPath:indexPath animated:TRUE scrollPosition:UITableViewScrollPositionNone];
        self.checkedIndexPath=indexPath;
        userDetails=[[SnoopingUserDetails sharedInstance] initWithPaymentCardName:info.cardname withPaymentCardNumber:info.cardnumber withpaymentCardExpDate:info.cardexpdate  withPaymentCardCvv:[NSString stringWithFormat:@"%d",info.cvv] withPaymentFullName:info.name withPaymentStreetName:info.street  withPaymentCity:info.city withPaymentState:info.state withPaymentZipCode:info.zip withPaymentPhoneNumber: info.phone];
                i++;
            }
        }
        @catch(NSException *e){
            
        }
        
    }else{
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryView=nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:self.checkedIndexPath animated:NO];
    UITableViewCell *tmp = [tableView cellForRowAtIndexPath:self.checkedIndexPath];
    tmp.accessoryView=nil;
  
    if(self.checkedIndexPath)
    {
        UITableViewCell* uncheckCell = [tableView
                                        cellForRowAtIndexPath:self.checkedIndexPath];
        uncheckCell.accessoryView=nil;
        [self clearPaymentDetails];
    }
    if([self.checkedIndexPath isEqual:indexPath])
    {
        self.checkedIndexPath = nil;
        [self clearPaymentDetails];
        RECENTLY_ADDED_PAYMENT_INFO_TRACKER=-1;
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        [def setObject:[NSString stringWithFormat:@"%d",RECENTLY_ADDED_PAYMENT_INFO_TRACKER] forKey:[NSString stringWithFormat:@"%@%@",DEFAULT_BILLING,user.userID]];

    }
    else
    {
        
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark1.png"]];
       [cell.accessoryView setFrame:CGRectMake(0, 0, 25, 25)];
         cell.accessoryView.contentMode=UIViewContentModeScaleAspectFit;
        checkedIndexPath=indexPath;
        SnachItPaymentInfo *info=[snachItPaymentInfo objectAtIndex:indexPath.row];
        // initializing address details
        userDetails=[[SnoopingUserDetails sharedInstance] initWithPaymentCardName:info.cardname withPaymentCardNumber:info.cardnumber withpaymentCardExpDate:info.cardexpdate withPaymentCardCvv:[NSString stringWithFormat:@"%d",info.cvv] withPaymentFullName: info.name withPaymentStreetName:info.street withPaymentCity:info.city withPaymentState:info.state withPaymentZipCode:info.zip withPaymentPhoneNumber:info.phone];

        RECENTLY_ADDED_PAYMENT_INFO_TRACKER=cell.tag;
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        [def setObject:[NSString stringWithFormat:@"%d",RECENTLY_ADDED_PAYMENT_INFO_TRACKER] forKey:[NSString stringWithFormat:@"%@%@",DEFAULT_BILLING,user.userID]];
    }

}

-(void)clearPaymentDetails{
    userDetails=[[SnoopingUserDetails sharedInstance] initWithPaymentCardName:nil withPaymentCardNumber:nil withpaymentCardExpDate:nil withPaymentCardCvv:nil withPaymentFullName:nil withPaymentStreetName:nil withPaymentCity:nil withPaymentState:nil withPaymentZipCode:nil withPaymentPhoneNumber:nil];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (cell.isSelected) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark1.png"]]; // No reason to create a new one every time, right?
        [cell.accessoryView setFrame:CGRectMake(0, 0, 25, 25)];
         cell.accessoryView.contentMode=UIViewContentModeScaleAspectFit;
            }
    else {
        cell.accessoryView = nil;
    }
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     UITableView *tbl = (UITableView *)[self.view viewWithTag:5];
    if (buttonIndex == 1) { // Set buttonIndex == 0 to handel "Ok"/"Yes" button response
          @try{
       
        CURRENTDB=SnachItDBFile;
        BOOL status=[[SnachItDB database] deleteRecordFromPayment:(int)[[tbl cellForRowAtIndexPath:deletepath] tag] Userid:USERID];
        if(status){
            RECENTLY_ADDED_PAYMENT_INFO_TRACKER=-1;
            [self clearPaymentDetails];
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            [def setObject:[NSString stringWithFormat:@"%d",RECENTLY_ADDED_PAYMENT_INFO_TRACKER] forKey:[NSString stringWithFormat:@"%@%@",DEFAULT_BILLING,user.userID]];
            [self loadData];
            deletepath=nil;
        }
          }@catch(NSException *e){}
    }
    else{
        [tbl reloadRowsAtIndexPaths:[NSArray arrayWithObjects:deletepath, nil] withRowAnimation:YES];
        deletepath=nil;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            // Get the record ID of the selected name and set it to the recordIDToEdit property.
            
            self.recordIDToEdit = cell.tag;
            [self performSegueWithIdentifier:EDIT sender:nil];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
    if ([[segue identifier] isEqualToString:EDIT])
    {
        AddNewCardForm *editInfoViewController = [segue destinationViewController];
        editInfoViewController.delegate = self;
        editInfoViewController.recordIDToEdit = self.recordIDToEdit;
    }
    if([[segue identifier] isEqualToString:ADDNEW]){
        AddNewCardForm *editInfoViewController = [segue destinationViewController];
        editInfoViewController.delegate = self;
        editInfoViewController.recordIDToEdit = -1;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
   
    self.productImg=nil;
    self.brandImg=nil;
    productPriceBtn=nil;
    productNameLbl=nil;
    
    // Release any retained subviews of the main view.
}


-(void)loadData{
    // Form the query.
    CURRENTDB=SnachItDBFile;
    snachItPaymentInfo = [[SnachItDB database] snachItPaymentInfo:USERID];
    
    // Reload the table view.
    [self.tableView reloadData];
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

-(void)viewWillDisappear:(BOOL)animated{
    UITableView *tbl = (UITableView *)[self.view viewWithTag:5];
    [tbl reloadData];
    [super viewWillDisappear:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    self.productImg=nil;
    self.productDesc=nil;
    productDesc=nil;
    productNameLbl=nil;
    productDesc=nil;
    productImg=nil;
    brandImg=nil;
    self.productNameLbl=nil;
    self.productPriceBtn=nil;
    self.brandImg=nil;
    for(UIView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
    [super viewDidDisappear:YES];
}

#pragma mark - PaymentInfoControllerDelegate method implementation

-(void)editingInfoWasFinished{
    // Reload the data.
    [self loadData];
}
@end
