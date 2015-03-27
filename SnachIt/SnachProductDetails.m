//
//  SnachProductDetails.m
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/15/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "SnachProductDetails.h"
#import "SnachCheckDetails.h"
#import <QuartzCore/QuartzCore.h>
#import "SnoopedProduct.h"
#import "Order.h"
#import "UserProfile.h"
#import "SnachItDB.h"
#import "global.h"
#import "SnoopingUserDetails.h"
@interface SnachProductDetails()



@end

@implementation SnachProductDetails
{
    
    NSUInteger seconds;
    NSTimer *timer;
    SnoopedProduct *product;
    Order *order;
    UserProfile *user;
    NSString *userId;
    int snachId;
    SnoopingUserDetails *userdetails;
    
}
@synthesize productName,productimage,brandimag,productPrice,productDescription,counter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeView];
     user=[UserProfile sharedInstance];
    userdetails=[SnoopingUserDetails sharedInstance];
    
    // Set the Label text with the selected recipe
    userId=user.userID;
    snachId=[product.snachId intValue];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(subtractTime)
                                           userInfo:nil
                                            repeats:YES];
   
    
    seconds=[[SnachItDB database] getSnachTime:[product.snachId intValue] UserId:user.userID SnoopTime:user.snoopTime];
    counter.titleLabel.adjustsFontSizeToFitWidth=YES;
    counter.titleLabel.minimumScaleFactor=0.44;
   [counter setTitle: [NSString stringWithFormat:@"%lu",(unsigned long)seconds] forState: UIControlStateNormal];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
     CURRENTDB=SnoopTimeDBFile;
}

-(void)viewWillAppear:(BOOL)animated{

    if([[SnachItDB database] getSnachTime:[product.snachId intValue] UserId:user.userID SnoopTime:user.snoopTime]>0){
    [self initializeOrder];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
        [global showAllertMsg:@"Your snoop time for this deal is over.You can't snach this now."];
    }
}
-(void)initializeView{
   
    product=[SnoopedProduct sharedInstance];
    productName.text = [NSString stringWithFormat:@"%@ %@",product.brandName,product.productName ];
  
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:product.brandImageURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        brandimag.image=[UIImage imageWithData:data];
        product.brandImageData=data;
    }];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:product.productImageURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        productimage.image=[UIImage imageWithData:data];
        product.productImageData=data;
    }];

    productPrice.titleLabel.adjustsFontSizeToFitWidth=YES;
    productPrice.titleLabel.minimumScaleFactor=0.32;
    [productPrice setTitle:[NSString stringWithFormat:@"$%@",product.productPrice] forState: UIControlStateNormal];
    
    productDescription.attributedText=[[NSAttributedString alloc] initWithData:[product.productDescription dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
   [self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
}

- (void)subtractTime {
    // 1
    seconds--;
    [counter setTitle: [NSString stringWithFormat:@"%li",(long)seconds] forState: UIControlStateNormal];

    // 2
    if (seconds == 0 || (int)seconds<0) {
        [timer invalidate];
        if(![[SnachItDB database] logtime:user.userID SnachId:[product.snachId intValue] SnachTime:0])
        {
            [[SnachItDB database]updatetime:user.userID SnachId:[product.snachId intValue] SnachTime:0];
        }
        [self performSegueWithIdentifier:@"timeup" sender:self];
    }
}

- (IBAction)snachit:(id)sender {
      [timer invalidate];
    if(![[SnachItDB database] logtime:user.userID SnachId:[product.snachId intValue] SnachTime:(int)seconds])
    {
        [[SnachItDB database]updatetime:user.userID SnachId:[product.snachId intValue] SnachTime:(int)seconds];
    }
      [self performSegueWithIdentifier:@"snachit" sender:self];
    
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    
    static NSString *identifier = @"Cell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    return cell;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.productimage=nil;
    self.brandimag=nil;
    productPrice=nil;
    productName=nil;
    productDescription=nil;
    
    
    // Release any retained subviews of the main view.
}
-(float)getOrderTotal{
    
    return  [product.productPrice floatValue]+[product.productShippingCost floatValue]+[product.    productSalesTax floatValue];
}



-(void)initializeOrder{
    double shippingcost;
    double salesTax;
    double tempst;
    int speed;
    @try{
    tempst=([product.productSalesTax doubleValue]/100)*[product.productPrice doubleValue];
    shippingcost=[product.productShippingCost doubleValue];
    
        if([userdetails.shipState isEqual:@"UT"])
            salesTax=(6.85/100)*[product.productPrice doubleValue];
        else
            salesTax=(tempst/100)*[product.productPrice doubleValue];
    speed=[product.productShippingSpeed intValue];
    }
    @catch(NSException *e){
        shippingcost=0;
        salesTax=0;
        speed=0;
    }
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = speed;
    NSDate *currentdate=[NSDate date];
    NSDate *deliverydate = [[NSCalendar currentCalendar]dateByAddingComponents:dateComponents
                                                                   toDate: currentdate
                                                                  options:0];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yy"];
    
    
    order=[[Order sharedInstance] initWithUserId:user.userID withProductId:product.productId withSnachId:product.snachId withEmailId:user.emailID withOrderQuantity:@"1" withSubTotal:product.productPrice withOrderTotal:[NSString stringWithFormat:@"%f",[self getOrderTotal]] withShippingCost:[NSString stringWithFormat:@"%f",shippingcost] withFreeShipping:@"Free Shipping" withSalesTax:[NSString stringWithFormat:@"%f",salesTax] withSpeed:[NSString stringWithFormat:@"%d",speed] withOrderDate:[df stringFromDate:currentdate]  withDeliveryDate:[df stringFromDate:deliverydate] withFixedSt:[NSString stringWithFormat:@"%f",tempst]];
}
@end
