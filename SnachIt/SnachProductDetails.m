//
//  SnachProductDetails.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/15/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "SnachProductDetails.h"
#import "SnachCheckDetails.h"
#import <QuartzCore/QuartzCore.h>
#import "SnoopedProduct.h"
#import "Order.h"
#import "UserProfile.h"
#import "DBManager.h"
@interface SnachProductDetails()

@property (nonatomic,strong) DBManager *dbManager;

@end

@implementation SnachProductDetails
{
    NSInteger seconds;
    NSTimer *timer;
    SnoopedProduct *product;
    Order *order;
    UserProfile *user;
    NSString *userId;
    int snachId;
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
    // Set the Label text with the selected recipe
    userId=user.userID;
    
    snachId=[product.snachId integerValue];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(subtractTime)
                                           userInfo:nil
                                            repeats:YES];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"snoopTimes.sql"];
    
    seconds=[self getSnachTime:snachId];
   [counter setTitle: [NSString stringWithFormat:@"%i",seconds] forState: UIControlStateNormal];
    
    
}

-(int)getSnachTime:(int)snachid{
    // Form the query.
    NSString *query = [NSString stringWithFormat:@"select snachtime from snachtimes where snachid=%d and userid=%@ ",snachid,userId];
    NSArray *snachtime;
    int time=0;
    // Get the results.
    if (snachtime != nil) {
        snachtime = nil;
    }
    snachtime = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    if (snachtime!=nil) {
        @try{
        time=(int)[[[snachtime objectAtIndex:0] objectAtIndex:0] integerValue];
        }
        @catch(NSException *e){
        
           time=30;
        }
    }
    else{
        time=30;
    }
   NSLog(@"Time :%@ %@",snachtime,query);
    return time;
}

-(void)viewWillAppear:(BOOL)animated{

   
    [self initializeOrder];

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

    [productPrice setTitle:[NSString stringWithFormat:@"$%@",product.productPrice] forState: UIControlStateNormal];
    productDescription.text=product.productDescription;
   [self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
}

- (void)subtractTime {
    // 1
    seconds--;
    [counter setTitle: [NSString stringWithFormat:@"%i",seconds] forState: UIControlStateNormal];

    // 2
    if (seconds == 0 || seconds<0) {
        [timer invalidate];
        [self logtime:userId SnachId:snachId SnachTime:0];
        [self performSegueWithIdentifier:@"timeup" sender:self];
    }
}

- (IBAction)snachit:(id)sender {
      [timer invalidate];
      [self logtime:userId SnachId:snachId SnachTime:seconds];
      [self performSegueWithIdentifier:@"snachit" sender:self];
    
}

-(void)logtime:(NSString*)userid SnachId:(int)snachid SnachTime:(int)time{
    NSString *query = [NSString stringWithFormat:@"insert into snachtimes values(null,%d, %@, %d)",snachid,userid,time];
    
    // Execute the query.
    
    [self.dbManager executeQuery:query];
    
    NSLog(@"Query in snach product details %@",query);
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
    }
    else{
        query = [NSString stringWithFormat:@"update snachtimes set snachtime=%d where snachid=%d and userid=%@",time,snachid,userid];
         [self.dbManager executeQuery:query];
         if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            
          
         }
        
    }
    
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
    
    
    // Release any retained subviews of the main view.
}
-(float)getOrderTotal{
    
    return  [product.productPrice floatValue]+[product.productShippingCost floatValue]+[product.    productSalesTax floatValue];
}



-(void)initializeOrder{
    double shippingcost;
    double salesTax;
    int speed;
    @try{
    shippingcost=[product.productShippingCost doubleValue];
    salesTax=[product.productSalesTax doubleValue];
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
    
    order=[[Order sharedInstance] initWithUserId:user.userID withProductId:product.productId withSnachId:product.snachId withEmailId:user.emailID withOrderQuantity:@"1" withSubTotal:product.productPrice withOrderTotal:[NSString stringWithFormat:@"%f",[self getOrderTotal]] withShippingCost:[NSString stringWithFormat:@"%f",shippingcost] withFreeShipping:@"Free Shipping" withSalesTax:[NSString stringWithFormat:@"%f",salesTax] withSpeed:[NSString stringWithFormat:@"%d",speed] withOrderDate:[df stringFromDate:currentdate]  withDeliveryDate:[df stringFromDate:deliverydate]];
}
@end
