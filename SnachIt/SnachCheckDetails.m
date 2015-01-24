//
//  SnachCheckDetails.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/18/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "SnachCheckDetails.h"
#import "SnachConfirmCell.h"
#import "ShippingOverview.h"
#import "PaymentOverview.h"
#import "OrderTotalOverview.h"
#import "ProductSnached.h"
#import "SnoopedProduct.h"
#import "SnoopingUserDetails.h"
#import "Order.h"

NSString *const PAYMENT_OVERVIEW_SEAGUE =@"paymentOverviewSeague";
NSString *const SHIPPING_OVERVIEW_SEAGUE =@"shippingOverview";
NSString *const ORDER_TOTAL_OVERVIEW_SEAGUE =@"orderTotalOverviewSeague";
NSString *const STP_SEGUE =@"STPSegue";
double orderTotal;
@interface SnachCheckDetails()

   @property (nonatomic, strong) NSArray *cellId;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation SnachCheckDetails
{
    NSInteger tempQuntity;
    double price;
    SnoopedProduct *product;
    SnoopingUserDetails *userdetails;
    
    Order *order;
}
@synthesize productImg,brandImg,productDescription,description,productPrice,productName,cellId,prodPrice;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cellId = [NSArray arrayWithObjects: @"orderQuntityCell", @"shiptocell", @"paymentCell", @"orderTotalCell",nil];

    // Set the Label text with the selected recipe
    userdetails=[SnoopingUserDetails sharedInstance];
    product=[SnoopedProduct sharedInstance];
    order=[Order sharedInstance];
    price= [order.orderTotal doubleValue];
    prodPrice=order.orderTotal;
    tempQuntity=[order.orderQuantity intValue];
  

}

-(void)viewDidAppear:(BOOL)animated{
    [self setViewLookAndFeel];

    
       
}
-(void)viewWillAppear:(BOOL)animated{
    [self initializeView];
    
}
-(void)initializeView{

  
    productName.text = [NSString stringWithFormat:@"%@ %@",product.brandName,product.productName ];
    brandImg.image=[UIImage imageWithData:product.brandImageData];
    productImg.image=[UIImage imageWithData:product.productImageData];
    [productPrice setTitle: product.productPrice forState: UIControlStateNormal];
    productDescription.text=product.productDescription;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *simpleTableIdentifier = [self.cellId objectAtIndex:indexPath.row];
    
    SnachConfirmCell *cell = (SnachConfirmCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
        cell.orderQuantity.text = [NSString stringWithFormat:@"%i",tempQuntity];
        if(userdetails.shipFullName!=nil)
        cell.shiptoName.text=userdetails.shipFullName;
        if(userdetails.paymentCardName!=nil)
        cell.paymentCard.text=[NSString stringWithFormat:@"%@-%@",userdetails.paymentCardName,userdetails.paymentCardCVV];
        cell.orderTotal.text=[NSString stringWithFormat:@"$%@",prodPrice];
    
        [cell.orderAdd addTarget:self action:@selector(addQuntity) forControlEvents:UIControlEventTouchUpInside];
        [cell.orderSubstract addTarget:self action:@selector(subQuntity) forControlEvents:UIControlEventTouchUpInside];
    [cell.expandShipto addTarget:self action:@selector(exapndShippingOverview) forControlEvents:UIControlEventTouchUpInside];
      [cell.expandPayment addTarget:self action:@selector(exapndPaymentOverview) forControlEvents:UIControlEventTouchUpInside];
   
    [cell.expandOrderTotal addTarget:self action:@selector(exapndOrderTotalOverview) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
   }

//this function add the product qunatity
-(void)addQuntity
{
     tempQuntity++;
    [self calculateTotal];
    [_tableView reloadData];
  
}

//this function substract the product qunatity
-(void)subQuntity
{
    if(tempQuntity>1){
    tempQuntity--;
     [self calculateTotal];
    [_tableView reloadData];
    }
}
-(void)exapndShippingOverview
{
    NSLog(@"%@",SHIPPING_OVERVIEW_SEAGUE);
    [self performSegueWithIdentifier:SHIPPING_OVERVIEW_SEAGUE sender:self];
    
}
-(void)exapndPaymentOverview
{
    [self performSegueWithIdentifier:PAYMENT_OVERVIEW_SEAGUE sender:self];
}
-(void)exapndOrderTotalOverview
{
    [self performSegueWithIdentifier:ORDER_TOTAL_OVERVIEW_SEAGUE sender:self];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
    if ([segue.identifier isEqualToString:STP_SEGUE]) {
        
        ProductSnached *destViewController = segue.destinationViewController;
        destViewController.fullName = self.fullName;
        destViewController.streetAddress=self.streetAddress;
        destViewController.cityStateZip =self.cityStateZip;
        }


}
-(void)setViewLookAndFeel{
        if(userdetails.shipFullName==nil || userdetails.paymentFullName==nil){
       
        [self.swipeToPay setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
        [self.swipeToPay setEnabled:NO];
    }
    else{
        [self.swipeToPay setBackgroundColor:[UIColor colorWithRed:0.62 green:0.10 blue:0.47 alpha:1.0]];
        [self.swipeToPay setEnabled:YES];
    }
}

- (IBAction)swipeToSnach:(id)sender {

    NSLog(@"%@",userdetails.getUserShippingDetails);
  //  NSLog(@"%@",userdetails.getUserPaymentDetails);
    //NSLog(@"%@",userdetails.getUserCreditCardDetails);
    
//  self.emailIds= [NSMutableArray array];
//    [self.emailIds addObjectsFromArray:[self getallEmailIdsInAddressBook:addressBook]];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:order.userId forKey:@"userId"];
    [dictionary setObject:userdetails.getUserShippingDetails forKey:@"shippingAddress"];
    [dictionary setObject:userdetails.getUserBillingDetails forKey:@"billingAddress"];
   [dictionary setObject:userdetails.getUserCreditCardDetails forKey:@"creditCardDetails"];
  NSError *error;
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
   NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    NSLog(@"jsonData as string:\n%@", jsonString);
    
    
    [self performSegueWithIdentifier:STP_SEGUE sender:self];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    productPrice=nil;
    productName=nil;
    productImg=nil;
    brandImg=nil;
    
    // Release any retained subviews of the main view.
}
-(void)calculateTotal{
    prodPrice=[NSString stringWithFormat:@"%.02f",price*tempQuntity];
    order.orderQuantity=[NSString stringWithFormat:@"%d",tempQuntity];
    order.subTotal=prodPrice;
    orderTotal=0;
    orderTotal=[order.subTotal doubleValue]+[order.salesTax doubleValue]+[order.shippingCost doubleValue];
    order.orderTotal=[NSString stringWithFormat:@"%f",orderTotal];
}

@end
