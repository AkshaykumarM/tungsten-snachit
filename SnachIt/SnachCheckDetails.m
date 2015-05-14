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
#import "PaymentDetails.h"
#import "AddressDetails.h"
#import "SnachItAddressInfo.h"
#import "SVProgressHUD.h"
#define PAYMENT_OVERVIEW_SEAGUE @"paymentOverviewSeague"
#define SHIPPING_OVERVIEW_SEAGUE @"shippingOverview"
#define ORDER_TOTAL_OVERVIEW_SEAGUE @"orderTotalOverviewSeague"
#define STP_SEGUE @"STPSegue"
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
    UserProfile *user;
    PaymentDetails *pinfo;
    AddressDetails *ainfo;
}
@synthesize productImg,brandImg,productDescription,description,productPrice,productName,cellId,prodPrice;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cellId = [NSArray arrayWithObjects: @"orderQuntityCell", @"shiptocell", @"paymentCell", @"orderTotalCell",nil];
    screenName=@"scd";
    user=[UserProfile sharedInstance];
    userdetails=[SnoopingUserDetails sharedInstance];
    product=[SnoopedProduct sharedInstance];
    order=[Order sharedInstance];
    price= [order.orderTotal doubleValue];
    prodPrice=order.orderTotal;
    tempQuntity=[order.orderQuantity intValue];
    [self initCheckoutDetails];
    CURRENTDB=SnoopTimeDBFile;
    
   
    
}
-(void)initCheckoutDetails{
    CURRENTDB=SnachItDBFile;
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    if([[df valueForKey:[NSString stringWithFormat:@"%@%@",DEFAULT_BILLING,user.userID]] intValue]!=-1){
    pinfo=[[SnachItDB database] snachItPaymentDetails:[[df valueForKey:[NSString stringWithFormat:@"%@%@",DEFAULT_BILLING,user.userID]] intValue] UserId:user.userID];
    userdetails=[[SnoopingUserDetails sharedInstance] initWithPaymentCardName:pinfo.cardname withPaymentCardNumber:pinfo.cardnumber withpaymentCardExpDate:pinfo.expdate  withPaymentCardCvv:[NSString stringWithFormat:@"%d",pinfo.cvv] withPaymentFullName:pinfo.name withPaymentStreetName:pinfo.address  withPaymentCity:pinfo.city withPaymentState:pinfo.state withPaymentZipCode:pinfo.zip withPaymentPhoneNumber: pinfo.phoneNumber];
    }
    if([[df valueForKey:[NSString stringWithFormat:@"%@%@",DEFAULT_SHIPPING,user.userID]] intValue]!=-1){
    ainfo=[[SnachItDB database] snachItAddressDetails:[[df valueForKey:[NSString stringWithFormat:@"%@%@",DEFAULT_SHIPPING,user.userID]] intValue] UserId:user.userID];
    userdetails=[[SnoopingUserDetails sharedInstance] initWithUserId:user.userID withShipFullName:ainfo.name withShipStreetName:ainfo.address withShipCity:ainfo.city withShipState:ainfo.state withShipZipCode:ainfo.zip withShipPhoneNumber:ainfo.phoneNumber];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [self setViewLookAndFeel];
    [super viewDidAppear:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [self initializeView];
    [super viewWillAppear:YES];
}
-(void)initializeView{
    @try{
        self.navigationController.navigationBar.topItem.title = @"confirm snach";
        productName.text = [NSString stringWithFormat:@"%@",product.productName ];
        brandImg.image=[UIImage imageWithData:product.brandImageData];
        productImg.image=[UIImage imageWithData:product.productImageData];
        [productPrice setTitle: product.productPrice forState: UIControlStateNormal];
        [productDescription loadHTMLString:[NSString stringWithFormat:@"<html>\n""<head>\n""<style type=\"text/css\">\n"" body{ font-size:%@;font-family:'Open Sans';}\n""</style>\n""</head>\n""<body>%@</body>\n""</html>",[NSNumber numberWithInt:14],product.productDescription ] baseURL:nil];
        
        //hiding the backbutton from top bar
        [self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSnach:)];
        [self initializeOrder];
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect: self.view.bounds];
        
        self.subview.layer.masksToBounds = NO;
        self.subview.layer.shadowColor = [UIColor blackColor].CGColor;
        self.subview.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);  /*Change value of X n Y as per your need of shadow to appear to like right bottom or left bottom or so on*/
        self.subview.layer.shadowOpacity = 0.8f;
        self.subview.layer.shadowRadius=2.5;
        self.subview.layer.shadowPath = shadowPath.CGPath;
    }@catch(NSException *e){}
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



-(double)getOrderTotal{
    if([userdetails.shipState isEqual:@"UT"])
    {
        order.salesTax=[NSString stringWithFormat:@"%f",([product.productSalesTax doubleValue]/100)*[order.subTotal doubleValue]];
    }
    else{
        order.salesTax=[NSString stringWithFormat:@"%f",(0/100)*[product.productPrice doubleValue]];
    }
    return  [order.subTotal doubleValue]+[order.shippingCost doubleValue]+[order.salesTax doubleValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *simpleTableIdentifier = [self.cellId objectAtIndex:indexPath.row];
    
    SnachConfirmCell *cell = (SnachConfirmCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    @try{
        cell.orderQuantity.text = [NSString stringWithFormat:@"%li",(long)tempQuntity];
        if(userdetails.shipFullName!=nil)
            cell.shiptoName.text=userdetails.shipFullName;
        if(userdetails.paymentCardName!=nil)
            cell.paymentCard.text=[NSString stringWithFormat:@"%@-%@",userdetails.paymentCardName,[userdetails.paymentCardNumber substringFromIndex:[userdetails.paymentCardNumber length]-3]];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        [numberFormatter setCurrencyCode:@"USD"];
        cell.orderTotal.text=[NSString stringWithFormat:@"%@",[numberFormatter stringFromNumber:[NSNumber numberWithDouble:[self getOrderTotal]]]];
        
        
        //[cell.orderAdd addTarget:self action:@selector(addQuntity) forControlEvents:UIControlEventTouchUpInside];
        //[cell.orderSubstract addTarget:self action:@selector(subQuntity) forControlEvents:UIControlEventTouchUpInside];
        [cell.expandShipto addTarget:self action:@selector(exapndShippingOverview) forControlEvents:UIControlEventTouchUpInside];
        [cell.expandPayment addTarget:self action:@selector(exapndPaymentOverview) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.expandOrderTotal addTarget:self action:@selector(exapndOrderTotalOverview) forControlEvents:UIControlEventTouchUpInside];
    }@catch(NSException *e){}
    
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
 
    [SVProgressHUD showWithStatus:@"Processing"];
    [self.view setUserInteractionEnabled:NO];
    if([global isConnected]){
        @try{
            if([self snachProduct]==1){
                [SVProgressHUD dismiss];
                [[SnachItDB database] updatetime:USERID SnachId:[product.snachId intValue] SnachTime:0];
                product.productImageData=nil;
                product.brandImageData=nil;
                product.brandId=nil;
                product.brandImageURL=nil;
                product.brandName=nil;
                product.snachId=nil;
                product.productId=nil;product.productImageURL=nil;product.productName=nil;product.productSalesTax=nil;product.productShippingSpeed=nil;product.productShippingSpeed=nil;
                [self performSegueWithIdentifier:STP_SEGUE sender:self];
                
            }
            else{
                [SVProgressHUD dismiss];
                [self.view setUserInteractionEnabled:YES];
            }
        }@catch(NSException *e){
            [self.view setUserInteractionEnabled:YES];
        }
    }
    else{
        [SVProgressHUD dismiss];
        [self.view setUserInteractionEnabled:YES];
        
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
                [global showAllertMsg:@"Alert" Message:[response objectForKey:@"error_message"]];
                status=0;
            }
            @catch(NSException *e){
                NSLog(@"Error %@",e);
            }
        }
    }
    
    return status;
}



-(void)initializeOrder{
    double shippingcost;
    double salesTax;
    double tempst;
    NSString *speed;
    int tempspeed;
    
    @try{
        tempst=([product.productSalesTax doubleValue]/100)*[product.productPrice doubleValue];
        shippingcost=[product.productShippingCost doubleValue];
        
        if([userdetails.shipState isEqual:@"UT"])
            salesTax=([product.productSalesTax doubleValue]/100)*[product.productPrice doubleValue];
        else{
            salesTax=(0/100)*[product.productPrice doubleValue];
        }
        
        if([global stringIsNumeric:product.productShippingSpeed])
        {
            tempspeed=[product.productShippingSpeed intValue];
            speed=product.productShippingSpeed;
        }
        else{
            @try{
                speed=product.productShippingSpeed;
                NSRange equalRange = [speed rangeOfString:@"-" options:NSBackwardsSearch];
                if (equalRange.location != NSNotFound) {
                    NSString *result = [speed substringFromIndex:equalRange.location + equalRange.length];
                    tempspeed= [result intValue] ;
                    
                } else {
                    tempspeed=[product.productShippingSpeed intValue];
                }
            }
            @catch(NSException *e){
                tempspeed=[product.productShippingSpeed intValue];
            }
        }
    }
    @catch(NSException *e){
        shippingcost=0;
        salesTax=0;
        speed=0;
    }
    
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = [global getWeekDaysCalc:tempspeed];
    NSDate *currentdate=[NSDate date];
    NSDate *deliverydate = [[NSCalendar currentCalendar]dateByAddingComponents:dateComponents
                                                                        toDate: currentdate
                                                                       options:0];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    
    order=[[Order sharedInstance] initWithUserId:user.userID withProductId:product.productId withSnachId:product.snachId withEmailId:user.emailID withOrderQuantity:@"1" withSubTotal:product.productPrice withOrderTotal:[NSString stringWithFormat:@"%f",[self getOrderTotal]] withShippingCost:[NSString stringWithFormat:@"%f",shippingcost] withFreeShipping:@"Free Shipping" withSalesTax:[NSString stringWithFormat:@"%f",salesTax] withSpeed:[NSString stringWithFormat:@"%@",speed] withOrderDate:[df stringFromDate:currentdate]  withDeliveryDate:[df stringFromDate:deliverydate] withFixedSt:[NSString stringWithFormat:@"%f",tempst]];
}


-(void)viewDidDisappear:(BOOL)animated{
    self.productImg=nil;
    self.productDescription=nil;
    productDescription=nil;
    productName=nil;
    productPrice=nil;
    productImg=nil;
    brandImg=nil;
    self.productName=nil;
    self.productPrice=nil;
    self.brandImg=nil;
    for(UIView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
    [super viewDidDisappear:YES];
}
@end
