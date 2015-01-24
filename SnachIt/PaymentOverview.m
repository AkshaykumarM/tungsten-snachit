//
//  PaymentOverview.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/22/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "PaymentOverview.h"
#import "PaymentOverviewCell.h"
#import "AddNewCardForm.h"
#import "SnachCheckDetails.h"
#import "SnoopedProduct.h"
#import "SnoopingUserDetails.h"
#import "DBManager.h"
NSString *const STPSEAGUE=@"backtoSTP";
@interface PaymentOverview()
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrPaymentInfo;
@end

@implementation PaymentOverview{
    SnoopedProduct *product;
    SnoopingUserDetails *userDetails;
}
@synthesize brandImg,productImg,productPriceBtn,productDesc,productNameLbl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"snachit.sql"];
    // Set the Label text with the selected recipe
    
    [self loadData];
}

-(void)viewDidAppear:(BOOL)animated{

    }

-(void)viewWillAppear:(BOOL)animated{
    [self initializeView];

}
-(void)initializeView{
    
    product=[SnoopedProduct sharedInstance];
    productNameLbl.text = [NSString stringWithFormat:@"%@ %@",product.brandName,product.productName ];
    brandImg.image=[UIImage imageWithData:product.brandImageData];
    productImg.image=[UIImage imageWithData:product.productImageData];
    [productPriceBtn setTitle: product.productPrice forState: UIControlStateNormal];
    productDesc.text=product.productDescription;
    
}

- (IBAction)addNewCardBtn:(id)sender{
    [self performSegueWithIdentifier:@"addNewCardSeague" sender:self];
    
}
- (IBAction)doneBtn:(id)sender {
    [self performSegueWithIdentifier:STPSEAGUE sender:self];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrPaymentInfo.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    PaymentOverviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paymentCell" forIndexPath:indexPath];
    NSInteger indexOfCardName = [self.dbManager.arrColumnNames indexOfObject:@"cardName"];
    NSInteger indexOfCVV = [self.dbManager.arrColumnNames indexOfObject:@"cvv"];
   
    // Set the loaded data to the appropriate cell labels.
    cell.cardImage.image = [UIImage imageNamed:@"amex.png"];
    cell.cardNameLbl.text = [NSString stringWithFormat:@"%@", [[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCardName]];
    
    cell.cvvLbl.text = @"Akshay";[NSString stringWithFormat:@"%@", [[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCVV]];
    
    NSLog(@"cvv%@",[NSString stringWithFormat:@"%@", [[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCVV]]);
 
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)indexPath.row);
    //  ShippingOverviewAddressCell *selectedCell=(ShippingOverviewAddressCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    // initializing address details
    userDetails=[[SnoopingUserDetails sharedInstance] initWithPaymentCardName:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:1] withPaymentCardNumber:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:2] withpaymentCardExpDate:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:3] withPaymentCardCvv:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:4] withPaymentFullName:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:5] withPaymentStreetName:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:6] withPaymentCity:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:7] withPaymentState:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:8] withPaymentZipCode:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:9] withPaymentPhoneNumber:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:10]];
    
    
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
    NSString *query = @"select * from payment";
    
    // Get the results.
    if (self.arrPaymentInfo != nil) {
        self.arrPaymentInfo = nil;
    }
    self.arrPaymentInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.paymentTableView reloadData];
}

@end
