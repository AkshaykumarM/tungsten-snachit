//
//  ShippingOverview.m
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/19/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "ShippingOverview.h"
#import "AddNewAddressForm.h"
#import "SnachCheckDetails.h"
#import "SnachItDB.h"
#import "ShippingOverviewAddressCell.h"
#import "SnoopedProduct.h"
#import "SnoopingUserDetails.h"
#import "UserProfile.h"
#import "global.h"
#import "SnachItAddressInfo.h"
#define EDITINFO @"editShippingInfo"
#define ADDNEW @"addnewaddressseague"
#define SHIPPING_OVERVIEW @"shippingoverviewseague"
@interface ShippingOverview()

@property (nonatomic, strong) NSString *selectedFirstName;
@property (nonatomic, strong) NSString *selectedStreetAddress;
@property (nonatomic, strong) NSString *selectedCityStateZip;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int recordIDToEdit;
-(void)loadData;

@end

@implementation ShippingOverview{
    SnoopedProduct *product;
    SnoopingUserDetails *userDetails;
    UserProfile *user;
    NSUserDefaults *defaults;
    NSMutableArray *snachItAddressInfo;
    int i;
    NSIndexPath *deletepath;
    BOOL hasAccessoryview;
}
@synthesize brandImg,productImg,productNameLbl,productPriceBtn,productDesc,checkedIndexPath,lastcheckeckedcelltag;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    hasAccessoryview=false;
    screenName=@"so";
    user =[UserProfile sharedInstance];
    defaults=[NSUserDefaults standardUserDefaults];
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    i=0;
    [self initializeView];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}

-(void)initializeView{
    self.navigationController.navigationBar.topItem.title = @"ship to";
    
    
    product=[SnoopedProduct sharedInstance];
    productNameLbl.text = [NSString stringWithFormat:@"%@",product.productName ];
    brandImg.image=[UIImage imageWithData:product.brandImageData];
    productImg.image=[UIImage imageWithData:product.productImageData];
    [productPriceBtn setTitle: product.productPrice forState: UIControlStateNormal];
    
    [productDesc loadHTMLString:[NSString stringWithFormat:@"<html>\n""<head>\n""<style type=\"text/css\">\n"" body{ font-size:%@;font-family:'Open Sans';\n""</style>\n""</head>\n""<body>%@</body>\n""</html>",[NSNumber numberWithInt:14],product.productDescription ] baseURL:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:BACKARROW] forState:UIControlStateNormal];
    btn.imageEdgeInsets=UIEdgeInsetsMake(2,2,2,2);
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
   
     
    [self performSegueWithIdentifier:SHIPPING_OVERVIEW sender:nil];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [snachItAddressInfo count];
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
    
    ShippingOverviewAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell" forIndexPath:indexPath];
    SnachItAddressInfo *info=[snachItAddressInfo objectAtIndex:indexPath.row];
    cell.accessoryView=nil;
    cell.rightUtilityButtons=[self rightButtons];
    cell.delegate=self;
    // Set the loaded data to the appropriate cell labels.
    
    cell.nameLbl.text =  [NSString stringWithFormat:@"%@",info.name];
    
    cell.streetNameLbl.text = [NSString stringWithFormat:@"%@", info.street];
    
    cell.cityStateZipLbl.text = [NSString stringWithFormat:@"%@,%@, %@",info.city,info.state,info.zip];
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    RECENTLY_ADDED_SHIPPING_INFO_TRACKER=[[def valueForKey:[NSString stringWithFormat:@"%@%@",DEFAULT_SHIPPING,user.userID]] intValue];
    
    //for autoselect functionality
    int rowid=info.uniqueId;
    cell.tag=rowid;
    if(rowid==RECENTLY_ADDED_SHIPPING_INFO_TRACKER ){
        @try{
            [cell.checkmarkImgView setHighlighted:YES];
                self.checkedIndexPath=indexPath;
               lastcheckeckedcelltag=cell.tag;
            userDetails=[[SnoopingUserDetails sharedInstance] initWithUserId:user.userID withShipFullName:info.name withShipStreetName:info.street withShipCity:info.city withShipState:info.state withShipZipCode:info.zip withShipPhoneNumber:info.phone];
                
           
        }
        @catch(NSException *e){
            
        }
    }
    else{
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.checkmarkImgView setHighlighted:NO];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ShippingOverviewAddressCell *scell = (ShippingOverviewAddressCell*)[tableView cellForRowAtIndexPath:self.checkedIndexPath];
    [scell.checkmarkImgView setHighlighted:NO];
    
    ShippingOverviewAddressCell *cell = (ShippingOverviewAddressCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.checkmarkImgView setHighlighted:!cell.checkmarkImgView.isHighlighted];
    SnachItAddressInfo *obj=[snachItAddressInfo objectAtIndex:indexPath.row];
    obj.selected=!obj.selected;
     self.lastcheckeckedcelltag=cell.tag;
    self.checkedIndexPath=indexPath;
    RECENTLY_ADDED_SHIPPING_INFO_TRACKER=cell.tag;
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:[NSString stringWithFormat:@"%d",RECENTLY_ADDED_SHIPPING_INFO_TRACKER] forKey:[NSString stringWithFormat:@"%@%@",DEFAULT_SHIPPING,user.userID]];
    
    
}

-(void)clearAddressDetails{
    userDetails=[[SnoopingUserDetails sharedInstance] initWithUserId:nil withShipFullName:nil withShipStreetName:nil withShipCity:nil withShipState:nil withShipZipCode:nil withShipPhoneNumber:nil];
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITableView *tbl = (UITableView *)[self.view viewWithTag:5];
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) { // Set buttonIndex == 0 to handel "Ok"/"Yes" button response
        @try{
        
        CURRENTDB =SnachItDBFile;
        
        BOOL status=[[SnachItDB database] deleteRecordFromAddress:(int)[tbl cellForRowAtIndexPath:deletepath].tag Userid:user.userID];
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

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            // Get the record ID of the selected name and set it to the recordIDToEdit property.
            
            self.recordIDToEdit = (int)cell.tag;
            [self performSegueWithIdentifier:EDITINFO sender:nil];
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
                //RECENTLY_ADDED_SHIPPING_INFO_TRACKER=-1;
            }else{
                hasAccessoryview=false;
            }
            break;
        default:
            break;
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  
    if ([[segue identifier] isEqualToString:EDITINFO])
    {
        AddNewAddressForm *editInfoViewController = [segue destinationViewController];
        editInfoViewController.delegate=self;
        editInfoViewController.recordIDToEdit = self.recordIDToEdit;
        editInfoViewController.lastCheckedRecord=lastcheckeckedcelltag;
    }
    if([[segue identifier] isEqualToString:ADDNEW]){
        AddNewAddressForm *editInfoViewController = [segue destinationViewController];
        editInfoViewController.delegate=self;
        editInfoViewController.recordIDToEdit = -1;
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


- (IBAction)addNewAddressbtn:(id)sender {
    [self performSegueWithIdentifier:ADDNEW sender:self];
    
}




-(void)loadData{
    // Form the query.
    CURRENTDB=SnachItDBFile;
    snachItAddressInfo = [[[SnachItDB database] snachItAddressInfo:user.userID] mutableCopy];
    
    // Reload the table view.
    [self.addressTableView reloadData];
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
       RECENTLY_ADDED_SHIPPING_INFO_TRACKER=self.checkedIndexPath.row;
}

#pragma mark - PaymentInfoControllerDelegate method implementation

-(void)editingInfoWasFinished{
    // Reload the data.
    [self.tableView reloadData];
}
@end
