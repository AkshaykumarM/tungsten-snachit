//
//  SnatchFeed.m
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/11/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//
#import "SnachitStartScreen.h"
#import "SnatchFeed.h"
#import "SWRevealViewController.h"
#import "SnatchFeedCell.h"
#import "SnachProductDetails.h"
#import <FacebookSDK/FacebookSDK.h>
#import "global.h"
#import <AddressBook/AddressBook.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserProfile.h"
#import "SnoopedProduct.h"
#import "SnachItLogin.h"
#import "Product.h"
#import "Common.h"
#import "SnachItDB.h"
#import "SnoopingUserDetails.h"

#define PRODUCTDETAILSSEGUE @"productDetails"
#define SNOOPSEGUE @"snoop"
@interface SnatchFeed(){
    NSMutableArray *Products;
}



@end


@interface ImageTapped : UITapGestureRecognizer

@property (nonatomic, strong) NSString * productId;
@property (nonatomic, strong) NSString * brandId;
@property (nonatomic, strong) NSString * snachId;
@property (nonatomic, strong) NSString * productName;
@property (nonatomic, strong) NSString * brandName;
@property (nonatomic, strong) NSURL * brandImageURL;
@property (nonatomic, strong) NSURL * productImageURL;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * productDescription;
@property (nonatomic, strong) NSString * productSalesTax;
@property (nonatomic, strong) NSString * productShippingCost;
@property (nonatomic, strong) NSString * productSpeed;


@end

@implementation ImageTapped

@end

@interface FollowStatusRecognizer : UITapGestureRecognizer

@property (nonatomic, strong) NSString * brandId;
@property (nonatomic, assign) NSInteger followStatus;
@property (nonatomic, assign) NSInteger index;
@end

@implementation FollowStatusRecognizer


@end
@implementation SnatchFeed
{
    NSInteger imageIndex;
    NSUInteger productrowIdentifier;
    NSString *snoopedProductId;
    NSString *snoopedSnachId;
    NSString *snoopedBrandId;
    NSURL *snoopedProductImageURL;
    NSURL *snoopedBrandImageURL;
    NSString *snoopedProductName;
    NSString *snoopedProductBrandName;
    NSString *snoopedProductPrice;
    NSString *snoopedProductDescription;
    NSString *snoopedBrandName;
    NSString *snoopedSalesTax;
    NSString *snoopedShippingCost;
    NSString *snoopedSpeed;
    UserProfile *user;
    UIImageView *topProfileBtn;
    NSDictionary *dictionaryForEmails;
    NSData *friendCountJson;
    NSData *responseData ;
    NSDictionary *dictionaryForFriendsCountResponse;
    float viewSize;
    NSNumber *strikeSize;
    UIActivityIndicatorView *activity;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    CURRENTDB=SnoopTimeDBFile;
    [self setViewLookAndFeel];
    SWRevealViewController *sw=self.revealViewController;
    sw.rearViewRevealWidth=self.view.frame.size.width-60.0f;
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:0.616 green:0.102 blue:0.471 alpha:1];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestProducts)
                  forControlEvents:UIControlEventValueChanged];
    screenName=nil;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    strikeSize= [NSNumber numberWithInt:2];
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.transform=CGAffineTransformMakeScale(1.5f, 1.5f);
    activity.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-60);
    activity.hidesWhenStopped = YES;

    activity.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleWidth;
    [self.tableView addSubview:activity];
    [activity startAnimating];
    // Add an observer that will respond to loginComplete
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recievedNotification:)
                                                 name:@"recievedNotification" object:nil];
    

    
}


- (void)getLatestProducts
{
    USERID=user.userID;
    if([global isConnected]){
        @try{
            [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@get-all-running-snachs/?customerId=%@",ec2maschineIP,user.userID]]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
               
                if (!error) {
                    NSArray *latestProduct = [self fetchData:data];
                    
                  NSSortDescriptor  *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"snachId"
                                                                                  ascending:NO selector:@selector(localizedStandardCompare:)];
                      NSArray *latestProductArray = [latestProduct sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                    
                    
                    
                    
                    Products = [NSMutableArray arrayWithCapacity:10];
                    
                    
                    if (latestProductArray) {
                        for (NSDictionary *prodDic in latestProductArray) {
                            Product *product = [[Product alloc] init];
                            product.productImages=[prodDic objectForKey:PRODUCT_IMAGES];
                            product.productname=[prodDic objectForKey:PRODUCT_NAME];
                            product.brandname =[prodDic objectForKey:PRODUCT_BRAND_NAME];
                            product.price =[prodDic objectForKey:PRODUCT_PRICE];
                            product.brandimage =[prodDic objectForKey:PRODUCT_BRAND_IMAGE];
                            product.productImage =[prodDic objectForKey:PRODUCT_IMAGE];
                            product.brandId =[prodDic objectForKey:PRODUCT_BRAND_ID];
                            product.productId =[prodDic objectForKey:PRODUCT_ID];
                            product.salesTax=[prodDic objectForKey:PRODUCT_SALESTAX];
                            product.speed=[prodDic objectForKey:PRODUCT_SHIPPINGSPEED];
                            product.shippingPrice=[prodDic objectForKey:PRODUCT_SHIPPINGCOST];
                            product.snachId =[prodDic objectForKey:PRODUCT_SNACH_ID];
                            product.productDescription =[prodDic objectForKey:PRODUCT_DESCRIPTION];
                            product.followStatus =[prodDic objectForKey:PRODUCT_FOLLOW_STATUS];
                            product.snooptime=[[SnachItDB database] getSnachTime:[product.snachId intValue] UserId:user.userID SnoopTime:user.snoopTime];
                            if(product.snooptime>0){
                                
                                [Products addObject:product];
                                                                                    }
                        }
                    }
                    
                 
                    
                    // As this block of code is run in a background thread, we need to ensure the GUI
                    // update is executed in the main thread
                    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                    
                }
                else{
                    NSLog(@"Error: %@", error.description);
                }
                
            }];
        }
        @catch(NSException *e){
            NSLog(@"Exception: %@",e);
        }
    }
    
}


-(void)recievedNotification:(NSNotification *)note {
    [self updateAPNSTokenIfChanged];
}





- (NSArray *)fetchData:(NSData *)response
{
    NSError *error = nil;
    NSArray* latestProducts = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error: &error];
    
    if (error != nil) {
        NSLog(@"Error: %@", error.description);
        return nil;
    }
    
    
    
    return latestProducts;
}
- (void)reloadData
{
    // Reload table data
    
    [self.tableView reloadData];
    [activity stopAnimating];
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
      [self.refreshControl endRefreshing];
    }
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{ self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // Return the number of sections.
    if (Products) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
    }
    else{
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}
-(void)viewDidAppear:(BOOL)animated{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //initializing user data
    user=[UserProfile sharedInstance];

    if([[defaults stringForKey:LOGGEDIN] isEqual:@"1"]){
        if(!isAllreadyTried){
            [self trySilentLogin];
        }
    }
    else{
        
        [self clearAllData];
        
        [NSThread sleepForTimeInterval:2];
        SnachitStartScreen *startscreen = [[SnachitStartScreen alloc]initWithNibName:@"StartScreen" bundle:nil];
        [self presentViewController:startscreen animated:YES completion:nil];
        
        
    }
    
    //checking from where the user tapped the snoop button
    if(snooptTracking==1)
    {
        [self performSegueWithIdentifier:PRODUCTDETAILSSEGUE sender:self];
        
    }
    
    //setting up upper left profile pic here
    [self setupProfilePic];
    
    
    [self getLatestProducts];
    [self requestContactBookAccess];
    viewSize = self.view.frame.size.width-93;//for setting product scrollview size
    [super viewDidAppear:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    user=[UserProfile sharedInstance];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window) {
        self.view = nil;
    }
    NSLog(@"Recieved memmory warning in snachfeed");
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{int count=0;
    @try{
        count=(int)[Products count];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, self.view.bounds.size.height)];
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"OpenSans-Regular" size:20];
        [messageLabel sizeToFit];
        
        if(count<=0)
        {
            messageLabel.textColor=[UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
            messageLabel.text = @"Pull down to check for new snachs";
            self.tableView.backgroundView = messageLabel;
            
        }
        else{
                
                self.tableView.backgroundView=nil;
        }
    }@catch(NSException *e){}
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 280;
}

-(void)trySilentLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *SSOUsing = [defaults stringForKey:SSOUSING];
    NSString *username = [defaults stringForKey:USERNAME];
    NSString *password = [defaults stringForKey:PASSWORD];
    
    
    
    SnachitStartScreen *startscreen = [[SnachitStartScreen alloc]initWithNibName:@"StartScreen" bundle:nil];
    if(SSOUsing!=nil&& username!=nil && password!=nil){
        SnachItLogin *login =[[SnachItLogin alloc] init];
        int status=[login performSignIn:username Password:password SSOUsing:SSOUsing];
        
        if(status==0){
            
            [self presentViewController:startscreen animated:YES completion:nil];
        }
    }
    else{
     
        [self presentViewController:startscreen animated:YES completion:nil];
        
    }
}




-(void)clearAllData{
    @try{
        NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
        NSDictionary * dict = [defs dictionaryRepresentation];
        NSString *billing=[NSString stringWithFormat:@"%@%@",DEFAULT_BILLING,user.userID];
        NSString *shipping=[NSString stringWithFormat:@"%@%@",DEFAULT_SHIPPING,user.userID];
        [SnachItLogin signOut];
        for (id key in dict) {
            if([key string]!=shipping&& [key string]!=billing&& ![[key string] isEqual:SSOUSING])
            [defs removeObjectForKey:key];
        }
        [defs synchronize];
       

        SnoopingUserDetails *sn=[[SnoopingUserDetails sharedInstance] initWithPaymentCardName:nil withPaymentCardNumber:nil withpaymentCardExpDate:nil withPaymentCardCvv:nil withPaymentFullName:nil withPaymentStreetName:nil withPaymentCity:nil withPaymentState:nil withPaymentZipCode:nil withPaymentPhoneNumber:nil];
        sn=[[SnoopingUserDetails sharedInstance] initWithUserId:nil withShipFullName:nil withShipStreetName:nil withShipCity:nil withShipState:nil withShipZipCode:nil withShipPhoneNumber:nil];
        
    }@catch(NSException *e){}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier =@"snachproduct";
    SnatchFeedCell *cell = (SnatchFeedCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (!cell) {
        NSArray* topLevelObjects = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (SnatchFeedCell *)currentObject;
                break;
            }
        }
    }
    
    Product *prod = [Products objectAtIndex:indexPath.row];
    if(prod.snooptime>0){
        
        cell.tag = indexPath.row;
        //setting up product image carousel
        cell.productImagesContainer.scrollEnabled = YES;
        [cell.followStatus.imageView setContentMode:UIViewContentModeScaleAspectFit];
        cell.productImagesContainer.backgroundColor=[UIColor whiteColor];
        NSError *error;
        dictionaryForEmails=[Common getDictionaryForFriendCount:prod.productId SnachId:prod.snachId EmailId:user.emailID];
        // NSLog(@"dictionaryForEmails:%@",dictionaryForEmails);
        if(dictionaryForEmails!=nil){
            
            friendCountJson = [NSJSONSerialization dataWithJSONObject:dictionaryForEmails options:NSJSONWritingPrettyPrinted error:&error];
            
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@getFriendsCount/",ec2maschineIP]]];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[friendCountJson length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody:friendCountJson];
            
            
            error = [[NSError alloc] init];
            if (!tableView.isDragging && !tableView.isDecelerating){
            @try{
                if(prod.friendCount==nil)
                    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                        if(!error)
                        {
                            dictionaryForFriendsCountResponse =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
                            if([[dictionaryForFriendsCountResponse valueForKey:@"success"] isEqual:@"true"])
                            {
                                NSLog(@"Friend count RESPONSE :%@",dictionaryForFriendsCountResponse);
                                prod.friendCount=[NSString stringWithFormat:@"%d",[[dictionaryForFriendsCountResponse valueForKey:@"count"] intValue]] ;
                                if([prod.friendCount intValue]>0){
                                    [cell.friendCount setHidden:NO];
                                    cell.friendCount.layer.cornerRadius = 9.0f;
                                    cell.friendCount.layer.borderWidth = 0.5;
                                    cell.friendCount.layer.borderColor = [[UIColor whiteColor] CGColor];
                                    [cell.friendCount setTitle:[NSString stringWithFormat:@"%@",prod.friendCount]forState:UIControlStateNormal];
                                    
                                }
                                else{
                                    [cell.friendCount setHidden:YES];
                                     prod.friendCount=0;
                                }
                                
                            }
                            else{
                                 prod.friendCount=0;
                                 [cell.friendCount setHidden:YES];
                            }
                        }
                        else{
                            prod.friendCount=0;
                             [cell.friendCount setHidden:YES];
                        }
                    }];
            }@catch(NSException *e){}
            }
    }
    
    
        NSArray* subviews = [[NSArray alloc] initWithArray: cell.productImagesContainer.subviews];
        for (UIView* view in subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
       
        @try{
            NSInteger productImages=[prod.productImages count];
            if(productImages>0){
                for(int index=0; index < productImages; index++)
                {
                    CGFloat  xOffset = index*viewSize+10;
                    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset,10,viewSize-10, cell.productImagesContainer.frame.size.height)];
                    
                    [img setImageWithURL:[NSURL URLWithString:prod.productImages[index]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    img.userInteractionEnabled = YES;
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    
                    [cell.productImagesContainer addSubview:img];
                }
                cell.productImagesContainer.contentSize = CGSizeMake(viewSize*productImages+10,cell.productImagesContainer.frame.size.height);
            }
            else{
                CGFloat  xOffset = 0;
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset,10,viewSize-10, cell.productImagesContainer.frame.size.height)];
                
                img.image=[UIImage imageNamed:@"placeholder.png"];
                img.userInteractionEnabled = YES;
                [img setContentMode:UIViewContentModeScaleAspectFit];
                [cell.productImagesContainer addSubview:img];
                cell.productImagesContainer.contentSize = CGSizeMake(viewSize+10,cell.productImagesContainer.frame.size.height);
            }
        }
        @catch(NSException *e){}
        
        
        @try{
            [cell.productName setTitle:[NSString stringWithFormat:@"%@", prod.productname] forState:UIControlStateNormal];
            cell.productName.titleLabel.adjustsFontSizeToFitWidth=YES;  //adjusting button font
            cell.productName.titleLabel.minimumScaleFactor=0.67;
            cell.productPrice.titleLabel.adjustsFontSizeToFitWidth=YES;  //adjusting button font
            cell.productPrice.titleLabel.minimumScaleFactor=0.67;
            cell.followStatus.imageView.contentMode=UIViewContentModeScaleAspectFit;
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
            [numberFormatter setCurrencyCode:@"USD"];
            
            NSDictionary *strikeThroughAttribute = [NSDictionary dictionaryWithObject:strikeSize
                                                                               forKey:NSStrikethroughStyleAttributeName];
            
            NSAttributedString* strikeThroughText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Retail: %@",[numberFormatter stringFromNumber:[NSNumber numberWithDouble:[prod.price doubleValue]]]] attributes:strikeThroughAttribute];

            [cell.productPrice setAttributedTitle:strikeThroughText forState:UIControlStateNormal];
        }@catch(NSException *e){}
        
        //Snoop button view setup
        @try{
            [cell.snoopBtn setTag:indexPath.row];
            
            ImageTapped *snoopTapped = [[ImageTapped alloc]
                                        initWithTarget:self
                                        action:@selector(snoopButtonClicked:) ];
            [snoopTapped setNumberOfTapsRequired:1];
            cell.snoopBtn.userInteractionEnabled = YES;
            snoopTapped.productName=prod.productname;
            snoopTapped.brandName=[NSString stringWithFormat:@"%@", prod.brandname];
            [cell.brandImg setImageWithURL:[NSURL URLWithString:prod.brandimage] placeholderImage:nil];
            snoopTapped.price=prod.price;
            
            snoopTapped.productId=prod.productId;
            snoopTapped.brandId=prod.brandId;
            snoopTapped.productSalesTax=prod.salesTax;
            snoopTapped.productShippingCost=prod.shippingPrice;
            snoopTapped.productSpeed=prod.speed;
            snoopTapped.snachId=prod.snachId;
            snoopTapped.productDescription=prod.productDescription;
            snoopTapped.productImageURL=[NSURL URLWithString:prod.productImage];
            snoopTapped.brandImageURL=[NSURL URLWithString:prod.brandimage];
            [cell.snoopBtn addGestureRecognizer:snoopTapped];
            
        }@catch(NSException *e){}
        
        
        //Follow brand button view setup
        @try{
            FollowStatusRecognizer *follow = [[FollowStatusRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(followButtonClicked:) ];
            
            
            [follow setNumberOfTapsRequired:1];
            cell.followStatus.userInteractionEnabled = YES;
            follow.brandId=prod.brandId;
            cell.followStatus.tag=[prod.brandId intValue];
            follow.followStatus=[prod.followStatus intValue];
            follow.index=indexPath.row;
            if([prod.followStatus intValue] ==1)
                [cell.followStatus setBackgroundColor:[UIColor colorWithRed:0.941 green:0.663 blue:0.059 alpha:1]];//Yellow color /*#f0a90f*/
            else
                [cell.followStatus setBackgroundColor:[UIColor colorWithRed:0.337 green:0.337 blue:0.333 alpha:1]];//Grey color /*#565655*/
            
            [cell.followStatus addGestureRecognizer:follow];
        }@catch(NSException *e){}
        return cell;
    }
    else{
        return nil;
    }
}



//on snoop button clicked
-(void)snoopButtonClicked:(UITapGestureRecognizer *)tapRecognizer {
    @try{
        ImageTapped *tap = (ImageTapped *)tapRecognizer;
        snoopedProductId=tap.productId;
        snoopedBrandId=tap.brandId;
        snoopedProductName=tap.productName;
        snoopedProductImageURL=tap.productImageURL;
        snoopedBrandImageURL=tap.brandImageURL;
        snoopedProductName=tap.productName;
        snoopedProductPrice=tap.price;
        snoopedProductDescription=tap.productDescription;
        snoopedBrandName=tap.brandName;
        snoopedSnachId=tap.snachId;
        snoopedShippingCost=tap.productShippingCost;
        snoopedSalesTax=tap.productSalesTax;
        snoopedSpeed=tap.productSpeed;
        [self performSegueWithIdentifier:SNOOPSEGUE sender:self];
    }@catch(NSException *e){}
}

-(void)followButtonClicked:(UITapGestureRecognizer*)tapRecongnizer
{
    if([global isConnected]){
        
        @try{
            
            FollowStatusRecognizer *tap = (FollowStatusRecognizer*)tapRecongnizer;
            UIButton *button= (UIButton*)tapRecongnizer.view;
            
            Product *prod = [Products objectAtIndex:tap.index];
           
            if(tap.followStatus ==1){
                tap.followStatus=0;
                if([Common updateFollowStatus:tap.brandId FollowStatus:[NSString stringWithFormat:@"%ld",(long)tap.followStatus] ForUserId:user.userID]==1)
                {
                    
                    [button setBackgroundColor:[UIColor colorWithRed:0.337 green:0.337 blue:0.333 alpha:1]];//Grey color /*#565655*/
                    
                    prod.followStatus=@"0";
                }
                else{tap.followStatus=1;
                    
                }
            }
            else{
                
                tap.followStatus= 1;
                if([Common updateFollowStatus:tap.brandId FollowStatus:[NSString stringWithFormat:@"%ld",(long)tap.followStatus] ForUserId:user.userID]==1)
                {
                    [button setBackgroundColor:[UIColor colorWithRed:0.941 green:0.663 blue:0.059 alpha:1]];//Yellow color /*#f0a90f*/
                    
                    prod.followStatus=@"1";
                    
                }
                else{
                    tap.followStatus=0;
                }
            }
        }@catch(NSException *e){}
    }
    
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([global isConnected]){
        @try{
            if ([segue.identifier isEqualToString:@"snoop"]) {
                
                SnoopedProduct *product=[[SnoopedProduct
                                          sharedInstance]initWithProductId:snoopedProductId withBrandId:snoopedBrandId withSnachId:snoopedSnachId withProductName:snoopedProductName withBrandName:snoopedBrandName withProductImageURL:snoopedProductImageURL withBrandImageURL:snoopedBrandImageURL withProductPrice:snoopedProductPrice withProductDescription:snoopedProductDescription withProductSalesTax:snoopedSalesTax withProductShippingCost:snoopedShippingCost withProductShippingSpeed:snoopedSpeed];
            }
            else if ([segue.identifier isEqualToString:@"productDetails"]) {
                
                snooptTracking=0;
            }
        }@catch(NSException *e){}
    }
    
}

-(void)viewDidUnload{
    
    [super viewDidUnload];
    
}



/**
 This function will request to access phonebook
 **/
-(void)requestContactBookAccess{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    if (status == kABAuthorizationStatusDenied || status == kABAuthorizationStatusRestricted) {
        // if you got here, user had previously denied/revoked permission for your
        // app to access the contacts, and all you can do is handle this gracefully,
        // perhaps telling the user that they have to go to settings to grant access
        // to contacts
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (!addressBook) {
        NSLog(@"ABAddressBookCreateWithOptions error: %@", CFBridgingRelease(error));
        return;
    }
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (error) {
            NSLog(@"ABAddressBookRequestAccessWithCompletion error: %@", CFBridgingRelease(error));
        }
        
        if (granted) {
            // if they gave you permission, then just carry on
            emailIds= [NSMutableArray array];
            if(emailIds)
                [emailIds addObjectsFromArray:[Common getallEmailIdsInAddressBook:addressBook]];
            
            
            //            [dictionaryForEmails setObject:emailIds forKey:@"emailIds"];
            //            NSError *error;
            //            NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
            //            NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
            //            NSLog(@"jsonData as string:\n%@", jsonString);
            //            dictionaryForEmails = [[NSMutableDictionary alloc] init];
            //            if(user.userID!=nil){
            //                [dictionaryForEmails setObject:emailIds forKey:@"contactList"];
            //
            //                [dictionaryForEmails setObject:user.emailID forKey:@"userEmail"];
            //            }
        } else {
            // however, if they didn't give you permission, handle it gracefully, for example...
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // BTW, this is not on the main thread, so dispatch UI updates back to the main queue
                
                [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            });
        }
        
        CFRelease(addressBook);
    });
}



-(void)setViewLookAndFeel{
    
    
    self.navigationItem.leftBarButtonItem.target=self.revealViewController;
    self.navigationItem.leftBarButtonItem.action=@selector(revealToggle:);
    [self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
}


-(void)getFriendCountForProduct:(NSString*)productId{
    
}

-(void)setupProfilePic{
    /*Upper left profile pic work starts here*/
    @try{
        //here i am setting the frame of profile pic and assigning it to a button
        CGRect frameimg = CGRectMake(0, 0, 40, 40);
        topProfileBtn = [[UIImageView alloc] initWithFrame:frameimg];
        UIButton *temp=[[UIButton alloc]initWithFrame:frameimg];
        //assigning the default background image
        [topProfileBtn setImageWithURL:user.profilePicUrl placeholderImage:[UIImage imageNamed:DEFAULTPLACEHOLDER]];
        topProfileBtn.clipsToBounds=YES;
        [temp setShowsTouchWhenHighlighted:YES];
        
        //setting up corner radious, border and border color width to make it circular
        topProfileBtn.layer.cornerRadius = 20.0f;
        topProfileBtn.layer.borderWidth = 2.0f;
        topProfileBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
        topProfileBtn.layer.shadowColor=[[UIColor whiteColor] CGColor];
        [topProfileBtn setContentMode:UIViewContentModeScaleAspectFill];
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self.revealViewController action:@selector(revealToggle:)];
        tapped.numberOfTapsRequired = 1;
        [topProfileBtn addGestureRecognizer:tapped];
        
      
        
        //assigning button to top bar iterm
        UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:topProfileBtn];
        
        //adding bar item to left bar button item
        self.navigationItem.leftBarButtonItem=mailbutton;

    }@catch(NSException *e){}
}





/*this method will update the APNS token on the server
 if it has been changed*/
-(void)updateAPNSTokenIfChanged{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if(![[defaults valueForKey:TOKEN] isEqualToString:APNSTOKEN])
    {
        NSLog(@"TOKEN : %@",APNSTOKEN);
        [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@update-apns-tocken/?user_id=%@&apns_token=%@",ec2maschineIP,USERID,APNSTOKEN]]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (!error) {
                [defaults setObject:APNSTOKEN forKey:TOKEN];
            }
        }];
    }
}

- (NSDictionary *)fetchDataforAPNS:(NSData *)response
{
    NSError *error = nil;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error: &error];
    
    if (error != nil) {
        NSLog(@"Error: %@", error.description);
        return nil;
    }
    return data;
}




-(void)viewDidDisappear:(BOOL)animated{
    
    
    self.profilePic =nil;
    [Products removeAllObjects];
    [super viewDidDisappear:YES];
}
@end
