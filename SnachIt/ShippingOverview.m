//
//  ShippingOverview.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/19/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "ShippingOverview.h"
#import "AddNewAddressForm.h"
#import "SnachCheckDetails.h"
#import "DBManager.h"
#import "ShippingOverviewAddressCell.h"
#import "SnoopedProduct.h"
#import "SnoopingUserDetails.h"
#import "UserProfile.h"
#import "global.h"
@interface ShippingOverview()
@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrAddressInfo;
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
}
@synthesize brandImg,productImg,productNameLbl,productPriceBtn,productDesc,checkedIndexPath;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
      self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"snachit.sql"];
    // Set the Label text with the selected recipe
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
    productDesc.text=product.productDescription;
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
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrAddressInfo.count;
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.

    ShippingOverviewAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell" forIndexPath:indexPath];
   
    NSInteger indexOfFullName = [self.dbManager.arrColumnNames indexOfObject:@"fullName"];
    NSInteger indexOfStreetAddress = [self.dbManager.arrColumnNames indexOfObject:@"streetAddress"];
    NSInteger indexOfCity = [self.dbManager.arrColumnNames indexOfObject:@"city"];
     NSInteger indexOfState = [self.dbManager.arrColumnNames indexOfObject:@"state"];
     NSInteger indexOfZip = [self.dbManager.arrColumnNames indexOfObject:@"zip"];
  
    // Set the loaded data to the appropriate cell labels.

    cell.nameLbl.text =  [NSString stringWithFormat:@"%@", [[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfFullName]];
    
    cell.streetNameLbl.text = [NSString stringWithFormat:@"%@", [[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfStreetAddress]];
    
    cell.cityStateZipLbl.text = [NSString stringWithFormat:@"%@,%@ %@", [[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCity],[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfState],[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfZip]];
    
    
    //for autoselect functionality
    int rowid=[[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    NSLog(@"Row %d %d",rowid,[[defaults valueForKey:DEFAULT_SHIPPING] intValue]);
    if(rowid==RECENTLY_ADDED_SHIPPING_INFO_TRACKER || rowid==[[defaults valueForKey:DEFAULT_SHIPPING] intValue] ){
          cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_mark.png"]];
          userDetails=[[SnoopingUserDetails sharedInstance] initWithUserId:user.userID withShipFullName:[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:1] withShipStreetName:[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:2] withShipCity:[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:3] withShipState:[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:4] withShipZipCode:[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:5] withShipPhoneNumber:[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:6]];
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

    // initializing address details
    userDetails=[[SnoopingUserDetails sharedInstance] initWithUserId:user.userID withShipFullName:[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:1] withShipStreetName:[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:2] withShipCity:[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:3] withShipState:[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:4] withShipZipCode:[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:5] withShipPhoneNumber:[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:6]];
    

}


- (IBAction)addNewAddressbtn:(id)sender {
    [self performSegueWithIdentifier:@"addnewaddressseague" sender:self];
    
}


- (IBAction)doneBtn:(id)sender {
    
    [self performSegueWithIdentifier:@"shippingoverviewseague" sender:self];

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
