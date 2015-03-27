//
//  SnachCheckDetails.m
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/18/14.
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
#import "global.h"
#import "SnachItDB.h"
#import "UserProfile.h"
NSString *const PAYMENT_OVERVIEW_SEAGUE =@"paymentOverviewSeague";
NSString *const SHIPPING_OVERVIEW_SEAGUE =@"shippingOverview";
NSString *const ORDER_TOTAL_OVERVIEW_SEAGUE =@"orderTotalOverviewSeague";
NSString *const STP_SEGUE =@"STPSegue";
double orderTotal;
@interface SnachCheckDetails()

@property (nonatomic, strong) NSArray *cellId;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
UIView *backView;
UIActivityIndicatorView *activitySpinner;
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
    CURRENTDB=SnoopTimeDBFile;

}

-(void)viewDidAppear:(BOOL)animated{
    [self setViewLookAndFeel];
    
    
       
}
-(void)viewWillAppear:(BOOL)animated{
    [self initializeView];
    
}
-(void)initializeView{

    self.navigationController.navigationBar.topItem.title = @"confirm snach";
    productName.text = [NSString stringWithFormat:@"%@ %@",product.brandName,product.productName ];
    brandImg.image=[UIImage imageWithData:product.brandImageData];
    productImg.image=[UIImage imageWithData:product.productImageData];
    [productPrice setTitle: product.productPrice forState: UIControlStateNormal];
    productDescription.attributedText=[[NSAttributedString alloc] initWithData:[product.productDescription dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

    //hiding the backbutton from top bar
    [self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSnach:)];
}

-(void)cancelSnach:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are You For Real?" message:@"If you cancel, you won’t see it again. Are you sure you want to cancel this amazing snach?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil]; [alert show];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) { // Set buttonIndex == 0 to handel "Ok"/"Yes" button response
       
        if(![[SnachItDB database] logtime:USERID SnachId:[product.snachId intValue] SnachTime:0])
        {
            [[SnachItDB database] updatetime:USERID SnachId:[product.snachId intValue] SnachTime:0];
        }
        [self dismissViewControllerAnimated:NO completion:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}



-(float)getOrderTotal{
    if([userdetails.shipState isEqual:@"UT"])
    {
        order.salesTax=[NSString stringWithFormat:@"%f",(6.85/100)*[order.subTotal doubleValue]];
    }
    else{
        order.salesTax=[NSString stringWithFormat:@"%f",([order.st doubleValue]/1000)*[order.subTotal doubleValue]];
    }
    return  [order.subTotal doubleValue]+[order.shippingCost doubleValue]+[order.salesTax doubleValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *simpleTableIdentifier = [self.cellId objectAtIndex:indexPath.row];
    
    SnachConfirmCell *cell = (SnachConfirmCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
        cell.orderQuantity.text = [NSString stringWithFormat:@"%li",(long)tempQuntity];
        if(userdetails.shipFullName!=nil)
        cell.shiptoName.text=userdetails.shipFullName;
        if(userdetails.paymentCardName!=nil)
        cell.paymentCard.text=[NSString stringWithFormat:@"%@-%@",userdetails.paymentCardName,[userdetails.paymentCardNumber substringFromIndex:[userdetails.paymentCardNumber length]-3]];
        cell.orderTotal.text=[NSString stringWithFormat:@"$%.2f",[self getOrderTotal]];
    
    
    
            
        //[cell.orderAdd addTarget:self action:@selector(addQuntity) forControlEvents:UIControlEventTouchUpInside];
        //[cell.orderSubstract addTarget:self action:@selector(subQuntity) forControlEvents:UIControlEventTouchUpInside];
        [cell.expandShipto addTarget:self action:@selector(exapndShippingOverview) forControlEvents:UIControlEventTouchUpInside];
        [cell.expandPayment addTarget:self action:@selector(exapndPaymentOverview) forControlEvents:UIControlEventTouchUpInside];
   
        [cell.expandOrderTotal addTarget:self action:@selector(exapndOrderTotalOverview) forControlEvents:UIControlEventTouchUpInside];
    

    return cell;
    
   }


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   //hiding the last cell separator
    if (cell && indexPath.row == 3 && indexPath.section == 0) {
        
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.0f);
    }
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
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(snachIt:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
        if(userdetails.shipFullName==nil || userdetails.paymentFullName==nil){
       
        [self.swipeToPay setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
        [self.swipeToPay removeGestureRecognizer:swipe];
    }
    else{
        [self.swipeToPay setBackgroundColor:[UIColor colorWithRed:0.62 green:0.10 blue:0.47 alpha:1.0]];
        [self.swipeToPay addGestureRecognizer:swipe];
    }
    
    
    
    
}

- (void)snachIt:(id)sender {
    [self startProcessing];
       if([self snachProduct]==1){
           [self stopProcessing];
           [[SnachItDB database] updatetime:USERID SnachId:[product.snachId intValue] SnachTime:0];
    [self performSegueWithIdentifier:STP_SEGUE sender:self];
           
    }
       else{
           [self stopProcessing];
           [global showAllertMsg:@"Opps! not able to snach.it, please fill your details correctly"];
       }
    
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
    order.orderQuantity=[NSString stringWithFormat:@"%ld",(long)tempQuntity];
    order.subTotal=prodPrice;
    orderTotal=0;
    orderTotal=[order.subTotal doubleValue]+[order.salesTax doubleValue]+[order.shippingCost doubleValue];
    order.orderTotal=[NSString stringWithFormat:@"%.2f",orderTotal];
}



/*
 This method will return all info related to current order(The product selected by user)
 */
-(NSDictionary*)getOrderDetails{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:order.userId forKey:@"userId"];
    [dictionary setObject:order.getOrderDetails forKey:@"orderDetails"];
    [dictionary setObject:userdetails.getUserShippingDetails forKey:@"shippingAddress"];
    [dictionary setObject:userdetails.getUserBillingDetails forKey:@"billingAddress"];
    [dictionary setObject:userdetails.getUserCreditCardDetails forKey:@"creditCardDetails"];
    return dictionary;
}


/*
 This method will snach the current product(The product selected by user)
 */
-(int)snachProduct{
    NSError *error;
    int status=0;
    NSData *orderJson = [NSJSONSerialization dataWithJSONObject:[self getOrderDetails] options:NSJSONWritingPrettyPrinted error:&error];
    NSData *responseData=[global makePostRequest:orderJson requestURL:@"getPlacedOrderByCustomer/" ];
    if (responseData) {
                NSDictionary *response= [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error: &error];
        
                if([[response objectForKey:@"success"] isEqual:@"true"])
                    status=1;
                else
                {
                    @try{
                    [global showAllertMsg:[response objectForKey:@"error_message"]];
                    status=0;
                    }
                    @catch(NSException *e){
                        NSLog(@"Error %@",e);
                    }
                }
            }

      return status;
}
-(void)startProcessing{
   
    backView = [[UIView alloc] initWithFrame:self.mainview.frame];
    backView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.3];
    [self.tableView addSubview:backView];
    activitySpinner=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [backView addSubview:activitySpinner];
    activitySpinner.center = CGPointMake(self.view.center.x, self.view.center.y);
    activitySpinner.hidesWhenStopped = YES;
    [activitySpinner startAnimating];
    
}
-(void)stopProcessing{
    
    [activitySpinner stopAnimating];
    [backView removeFromSuperview];
}


@end
