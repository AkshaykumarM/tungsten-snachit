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
    screenName=@"spd";
    // Set the Label text with the selected recipe
    
    userId=user.userID;
    snachId=[product.snachId intValue];
    SNACHID=product.snachId;
    USERID=user.userID;
    @try{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(subtractTime)
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    seconds=[[SnachItDB database] getSnachTime:[product.snachId intValue] UserId:user.userID SnoopTime:user.snoopTime];
    counter.titleLabel.adjustsFontSizeToFitWidth=YES;
    counter.titleLabel.minimumScaleFactor=0.44;
   [counter setTitle: [NSString stringWithFormat:@"%lu",(unsigned long)seconds] forState: UIControlStateNormal];
     }@catch(NSException *e){}
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
     CURRENTDB=SnoopTimeDBFile;
}

-(void)viewWillAppear:(BOOL)animated{
    @try{
    if([[SnachItDB database] getSnachTime:[product.snachId intValue] UserId:user.userID SnoopTime:user.snoopTime]>0){
    [self initializeOrder];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
        [global showAllertMsg:@"Alert" Message:@"Your snoop time for this deal is over.You can't snach this now."];
    }
         }@catch(NSException *e){}
    [super viewWillAppear:YES];
}
-(void)initializeView{
    @try{
    product=[SnoopedProduct sharedInstance];
    productName.text = [NSString stringWithFormat:@"%@",product.productName ];
  
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
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:@"USD"];
    [productPrice setTitle:[NSString stringWithFormat:@"%@",[numberFormatter stringFromNumber:[NSNumber numberWithDouble:[product.productPrice doubleValue]]]] forState: UIControlStateNormal];
    
    [productDescription loadHTMLString:[NSString stringWithFormat:@"<html>\n""<head>\n""<style type=\"text/css\">\n"" body{ font-size:%@; font-family:'Open Sans';}\n""</style>\n""</head>\n""<body>%@</body>\n""</html>",[NSNumber numberWithInt:14],product.productDescription ]  baseURL:nil];
    
        
     }@catch(NSException *e){}
   [self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
}

- (void)subtractTime {
    // 1
    @try{
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
    }@catch(NSException *e){}
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
    NSString *speed;
    int tempspeed;
    
    @try{
    tempst=([product.productSalesTax doubleValue]/100)*[product.productPrice doubleValue];
    shippingcost=[product.productShippingCost doubleValue];
    
        if([userdetails.shipState isEqual:@"UT"])
            salesTax=([product.productSalesTax doubleValue]/100)*[product.productPrice doubleValue];//calculating sales tax
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
    self.productImageData=nil;
    self.productimage=nil;
    productDescription=nil;
    productName=nil;
    productPrice=nil;
    productimage=nil;
    brandimag=nil;
    self.productPrice=nil;
    self.productDescription=nil;
    self.brandImageData=nil;
    self.productName=nil;
    for(UIView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
    [super viewDidDisappear:YES];
}
@end
