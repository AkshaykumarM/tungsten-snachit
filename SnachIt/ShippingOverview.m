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
#import "SnachItPaymentInfo.h"
@interface ShippingOverview()

@property (nonatomic, strong) NSString *selectedFirstName;
@property (nonatomic, strong) NSString *selectedStreetAddress;
@property (nonatomic, strong) NSString *selectedCityStateZip;


-(void)loadData;

@end

@implementation ShippingOverview{
    SnoopedProduct *product;
    SnoopingUserDetails *userDetails;
    UserProfile *user;
    NSUserDefaults *defaults;
    NSArray *snachItPaymentInfo;
}
@synthesize brandImg,productImg,productNameLbl,productPriceBtn,productDesc,checkedIndexPath;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CURRENTDB=SnachItDBFile;
    [self loadData];
    
    user =[UserProfile sharedInstance];
    defaults=[NSUserDefaults standardUserDefaults];
}
-(void)viewDidAppear:(BOOL)animated{
   
    [super viewDidAppear:YES];
    
    [self initializeView];
 
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
  
}

-(void)initializeView{
     self.navigationController.navigationBar.topItem.title = @"ship to";
    
    
    product=[SnoopedProduct sharedInstance];
    productNameLbl.text = [NSString stringWithFormat:@"%@ %@",product.brandName,product.productName ];
    brandImg.image=[UIImage imageWithData:product.brandImageData];
    productImg.image=[UIImage imageWithData:product.productImageData];
    [productPriceBtn setTitle: product.productPrice forState: UIControlStateNormal];

     productDesc.attributedText=[[NSAttributedString alloc] initWithData:[product.productDescription dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    //hiding the backbutton from top bar
    //[self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    btn.imageEdgeInsets=UIEdgeInsetsMake(5,5,4,5);
    UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = eng_btn;
}

-(void)back:(id)sender{
    [self performSegueWithIdentifier:@"shippingoverviewseague" sender:nil];
    
}
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

    ShippingOverviewAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell" forIndexPath:indexPath];
   SnachItPaymentInfo *info=[snachItPaymentInfo objectAtIndex:indexPath.row];
   cell.accessoryView=nil;
    // Set the loaded data to the appropriate cell labels.

    cell.nameLbl.text =  [NSString stringWithFormat:@"%@",info.name];
    
    cell.streetNameLbl.text = [NSString stringWithFormat:@"%@", info.street];
    
    cell.cityStateZipLbl.text = [NSString stringWithFormat:@"%@,%@ %d",info.city,info.state,info.zip];
    
    
    //for autoselect functionality
    int rowid=info.uniqueId;
    NSLog(@"Row %d %d",rowid,[[defaults valueForKey:DEFAULT_SHIPPING] intValue]);
    if(rowid==RECENTLY_ADDED_SHIPPING_INFO_TRACKER || rowid==[[defaults valueForKey:DEFAULT_SHIPPING] intValue] ){
          cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_mark.png"]];
        userDetails=[[SnoopingUserDetails sharedInstance] initWithUserId:user.userID withShipFullName:info.name withShipStreetName:info.street withShipCity:info.city withShipState:info.state withShipZipCode:[NSString stringWithFormat:@"%d",info.zip] withShipPhoneNumber:info.phone];
    }
    else{
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryView=nil;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *tmp = [tableView cellForRowAtIndexPath:self.checkedIndexPath];
    tmp.accessoryView=nil;
    if(self.checkedIndexPath)
    {
        UITableViewCell* uncheckCell = [tableView
                                        cellForRowAtIndexPath:self.checkedIndexPath];
        uncheckCell.accessoryView=nil;
        userDetails=[[SnoopingUserDetails sharedInstance] initWithUserId:nil withShipFullName:nil withShipStreetName:nil withShipCity:nil withShipState:nil withShipZipCode:nil withShipPhoneNumber:nil];

    }
    if([self.checkedIndexPath isEqual:indexPath])
    {
        self.checkedIndexPath = nil;
         userDetails=[[SnoopingUserDetails sharedInstance] initWithUserId:nil withShipFullName:nil withShipStreetName:nil withShipCity:nil withShipState:nil withShipZipCode:nil withShipPhoneNumber:nil];
    }
    else
    {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_mark.png"]];
        
        self.checkedIndexPath = indexPath;
    }
    SnachItPaymentInfo *info=[snachItPaymentInfo objectAtIndex:indexPath.row];
    // initializing address details
    userDetails=[[SnoopingUserDetails sharedInstance] initWithUserId:user.userID withShipFullName:info.name withShipStreetName:info.street withShipCity:info.city withShipState:info.state withShipZipCode:[NSString stringWithFormat:@"%d",info.zip] withShipPhoneNumber:info.phone];
    
}


- (IBAction)addNewAddressbtn:(id)sender {
    [self performSegueWithIdentifier:@"addnewaddressseague" sender:self];
    
}


- (IBAction)doneBtn:(id)sender {
    
    [self performSegueWithIdentifier:@"shippingoverviewseague" sender:self];

}

-(void)loadData{
    // Form the query.
    snachItPaymentInfo = [SnachItDB database].snachItAddressInfo;
    
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

@end
