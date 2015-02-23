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
#import "global.h"
NSString *const STPSEAGUE=@"backtoSTP";
@interface PaymentOverview()
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrPaymentInfo;
@end

@implementation PaymentOverview{
    SnoopedProduct *product;
    SnoopingUserDetails *userDetails;
}
@synthesize brandImg,productImg,productPriceBtn,productDesc,productNameLbl,checkedIndexPath;

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
     self.navigationController.navigationBar.topItem.title = @"snach details";
    product=[SnoopedProduct sharedInstance];
    productNameLbl.text = [NSString stringWithFormat:@"%@ %@",product.brandName,product.productName ];
    brandImg.image=[UIImage imageWithData:product.brandImageData];
    productImg.image=[UIImage imageWithData:product.productImageData];
    [productPriceBtn setTitle: product.productPrice forState: UIControlStateNormal];
    productDesc.text=product.productDescription;
    //hiding the backbutton from top bar
    [self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
    
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
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    NSLog(@"kldksdhkds %@",self.arrPaymentInfo);
    PaymentOverviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paymentCell" forIndexPath:indexPath];
    NSInteger indexOfCardName = [self.dbManager.arrColumnNames indexOfObject:@"cardName"];
    NSInteger indexOfCardNumber=[self.dbManager.arrColumnNames indexOfObject:@"cardNumber"];
    NSInteger indexOfCVV = [self.dbManager.arrColumnNames indexOfObject:@"cvv"];
  
    // Set the loaded data to the appropriate cell labels.
    cell.cardImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[self getCardType:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCardNumber]]]];
    cell.cardNameLbl.text = [NSString stringWithFormat:@"%@", [[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCardName]];
    
    cell.cvvLbl.text = 
    [NSString stringWithFormat:@"%@", [[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCVV]];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    return cell;
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
        type=@"amex";
    }
    else{
        type=@"unknown";
    }
    return type;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)indexPath.row);
    //  ShippingOverviewAddressCell *selectedCell=(ShippingOverviewAddressCell*)[tableView cellForRowAtIndexPath:indexPath];
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
        userDetails=[[SnoopingUserDetails sharedInstance] initWithPaymentCardName:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:1] withPaymentCardNumber:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:2] withpaymentCardExpDate:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:3] withPaymentCardCvv:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:4] withPaymentFullName:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:5] withPaymentStreetName:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:6] withPaymentCity:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:7] withPaymentState:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:8] withPaymentZipCode:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:9] withPaymentPhoneNumber:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:10]];
    }

    // initializing address details
    

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
