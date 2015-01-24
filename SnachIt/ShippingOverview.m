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
@interface ShippingOverview()
@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrAddressInfo;
@property (nonatomic, strong) NSString *selectedFirstName;
@property (nonatomic, strong) NSString *selectedStreetAddress;
@property (nonatomic, strong) NSString *selectedCityStateZip;


-(void)loadData;

@end

@implementation ShippingOverview
@synthesize brandImg,productname,productImg,productimgname,productNameLbl,brandimgname,productPriceBtn,productprice;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
      self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"snachit.sql"];
    // Set the Label text with the selected recipe
    productNameLbl.text = productname;
    
    brandImg.image=[UIImage imageNamed: brandimgname];
    productImg.image=[UIImage imageNamed: productimgname];
    [productPriceBtn setTitle: productprice forState:UIControlStateNormal];
    [self loadData];
   
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrAddressInfo.count;
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
    cell.nameLbl.text = [NSString stringWithFormat:@"%@", [[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfFullName]];
    
    cell.streetNameLbl.text = [NSString stringWithFormat:@"%@", [[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfStreetAddress]];
    
    cell.cityStateZipLbl.text = [NSString stringWithFormat:@"%@,%@ %@", [[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCity],[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfState],[[self.arrAddressInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfZip]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",indexPath);
    ShippingOverviewAddressCell *selectedCell=(ShippingOverviewAddressCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    // perform required operation
    self.selectedFirstName =selectedCell.nameLbl.text;
    self.selectedStreetAddress=selectedCell.streetNameLbl.text;
    self.selectedCityStateZip=selectedCell.cityStateZipLbl.text;
   
   
}


- (IBAction)addNewAddressbtn:(id)sender {
    [self performSegueWithIdentifier:@"addnewaddressseague" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addnewaddressseague"]) {
        
        AddNewAddressForm *destViewController = segue.destinationViewController;
        destViewController.productname = productname;
        destViewController.productimgname=productimgname;
        destViewController.productprice =productprice;
        destViewController.brandimgname = brandimgname;
    }
    if ([segue.identifier isEqualToString:@"shippingoverviewseague"]) {
        
        SnachCheckDetails *destViewController = segue.destinationViewController;
        destViewController.prodName = productname;
        destViewController.prodImgName=productimgname;
        destViewController.prodPrice =productprice;
        destViewController.brandImgName = brandimgname;
        destViewController.fullName=self.selectedFirstName;
        destViewController.streetAddress=self.selectedStreetAddress;
        destViewController.cityStateZip=self.selectedCityStateZip;
        
    }
    
}
- (IBAction)doneBtn:(id)sender {
    
    [self performSegueWithIdentifier:@"shippingoverviewseague" sender:self];

}
-(void)loadData{
    // Form the query.
    NSString *query = @"select * from addressInfo";
    
    // Get the results.
    if (self.arrAddressInfo != nil) {
        self.arrAddressInfo = nil;
    }
    self.arrAddressInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.addressTableView reloadData];
}

@end
