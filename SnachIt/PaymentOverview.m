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

#import "DBManager.h"
NSString *const STPSEAGUE=@"backtoSTP";
@interface PaymentOverview()
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrPaymentInfo;
@end

@implementation PaymentOverview{
    SnoopedProduct *product;
}
@synthesize brandImg,productImg,productPriceBtn,productDesc,productNameLbl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"snach.sql"];
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
    NSInteger indexOfCardNumber = [self.dbManager.arrColumnNames indexOfObject:@"cardNumber"];
    NSInteger indexOfExpDate = [self.dbManager.arrColumnNames indexOfObject:@"expDate"];
    NSInteger indexOfCVV = [self.dbManager.arrColumnNames indexOfObject:@"cvv"];
    NSInteger indexOfFullName = [self.dbManager.arrColumnNames indexOfObject:@"fullName"];
    NSInteger indexOfStreetAddress = [self.dbManager.arrColumnNames indexOfObject:@"streetAddress"];
    NSInteger indexOfCity = [self.dbManager.arrColumnNames indexOfObject:@"city"];
    NSInteger indexOfState = [self.dbManager.arrColumnNames indexOfObject:@"state"];
    NSInteger indexOfZip = [self.dbManager.arrColumnNames indexOfObject:@"zip"];
    NSInteger indexOfPhone = [self.dbManager.arrColumnNames indexOfObject:@"phone"];
    // Set the loaded data to the appropriate cell labels.
    cell.cardImage.image = [UIImage imageNamed:@"amex.png"];
    cell.cardNameLbl.text = [NSString stringWithFormat:@"%@", [[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCardName]];
    
    cell.cvvLbl.text = [NSString stringWithFormat:@"%@", [[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCVV]];
    
 
    
    return cell;
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
    NSString *query = @"select * from paymentInfo ";
    
    // Get the results.
    if (self.arrPaymentInfo != nil) {
        self.arrPaymentInfo = nil;
    }
    self.arrPaymentInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.paymentTableView reloadData];
}

@end
