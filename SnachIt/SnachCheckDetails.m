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

NSString *const PAYMENT_OVERVIEW_SEAGUE =@"paymentOverviewSeague";
NSString *const SHIPPING_OVERVIEW_SEAGUE =@"shippingOverview";
NSString *const ORDER_TOTAL_OVERVIEW_SEAGUE =@"orderTotalOverviewSeague";
NSString *const STP_SEGUE =@"STPSegue";
@interface SnachCheckDetails()

   @property (nonatomic, strong) NSArray *cellId;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation SnachCheckDetails
{
    NSInteger tempQuntity;
    float price;
}
@synthesize productImg,brandImg,prodName,brandImgName,prodDesc,productDescription,description,productPrice,prodPrice,productName,prodImgName,cellId;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cellId = [NSArray arrayWithObjects: @"orderQuntityCell", @"shiptocell", @"paymentCell", @"orderTotalCell",nil];

    // Set the Label text with the selected recipe
    productName.text = prodName;
    brandImg.image=[UIImage imageNamed:brandImgName];
    productImg.image=[UIImage imageNamed:prodImgName];
    [productPrice setTitle: prodPrice forState: UIControlStateNormal];
    tempQuntity=1;
    price=[[prodPrice stringByReplacingOccurrencesOfString:@"$" withString:@""] floatValue];
}

-(void)viewDidAppear:(BOOL)animated{
    [self setViewLookAndFeel];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *simpleTableIdentifier = [self.cellId objectAtIndex:indexPath.row];
    
    SnachConfirmCell *cell = (SnachConfirmCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
        cell.orderQuantity.text = [NSString stringWithFormat:@"%i",tempQuntity];
        cell.shiptoName.text=@"Diana Remirez";
        cell.paymentCard.text=@"Visa****1234";
        cell.orderTotal.text=[NSString stringWithFormat:@"%@",prodPrice];
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
    if(tempQuntity<5){
     tempQuntity++;
    prodPrice=[NSString stringWithFormat:@"%.02f",price*tempQuntity];
    [_tableView reloadData];
    }
    else{
        NSString *message = @"Sorry, stock not available";
        
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];
        
        int duration = 1; // duration in seconds
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
}

//this function substract the product qunatity
-(void)subQuntity
{
    if(tempQuntity>1){
    tempQuntity--;
    prodPrice=[NSString stringWithFormat:@"%.02f",price*tempQuntity];
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

    if ([segue.identifier isEqualToString:SHIPPING_OVERVIEW_SEAGUE]) {
        
        ShippingOverview *destViewController = segue.destinationViewController;
        destViewController.productname = prodName;
        destViewController.productprice=prodPrice;
        destViewController.productimgname =prodImgName;
        destViewController.brandimgname = brandImgName;
    }
    if ([segue.identifier isEqualToString:PAYMENT_OVERVIEW_SEAGUE]) {
        
        PaymentOverview *destViewController = segue.destinationViewController;
        destViewController.productname = prodName;
        destViewController.productprice=prodPrice;
        destViewController.productimgname =prodImgName;
        destViewController.brandimgname = brandImgName;
    }
    
    if ([segue.identifier isEqualToString:ORDER_TOTAL_OVERVIEW_SEAGUE]) {
        
        OrderTotalOverview *destViewController = segue.destinationViewController;
        destViewController.productname = prodName;
        destViewController.productprice=prodPrice;
        destViewController.productimgname =prodImgName;
        destViewController.brandimgname = brandImgName;
    }
    if ([segue.identifier isEqualToString:STP_SEGUE]) {
        
        ProductSnached *destViewController = segue.destinationViewController;
        destViewController.fullName = self.fullName;
        destViewController.streetAddress=self.streetAddress;
        destViewController.cityStateZip =self.cityStateZip;
        }


}
-(void)setViewLookAndFeel{
        if(self.fullName==nil){
       
        [self.swipeToPay setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
        [self.swipeToPay setEnabled:NO];
    }
    else{
        [self.swipeToPay setBackgroundColor:[UIColor colorWithRed:0.62 green:0.10 blue:0.47 alpha:1.0]];
        [self.swipeToPay setEnabled:YES];
    }
}

- (IBAction)swipeToSnach:(id)sender {
    
    
    [self performSegueWithIdentifier:STP_SEGUE sender:self];
    
}


@end
