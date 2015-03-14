//
//  SnatchFeed.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/11/14.
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
#import "DBManager.h"

@interface SnatchFeed(){
    NSMutableArray *Products;
}
@property(nonatomic,strong) NSArray *productslist;
@property (nonatomic,strong) DBManager *dbManager;

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
    UIButton *topProfileBtn;
    NSDictionary *dictionaryForEmails;
    NSData *friendCountJson;
    NSData *responseData ;
    NSDictionary *dictionaryForFriendsCountResponse;
    float viewSize;
    
    
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
    
    [self setViewLookAndFeel];
    SWRevealViewController *sw=self.revealViewController;
    sw.rearViewRevealWidth=self.view.frame.size.width-60.0f;
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestProducts)
                    forControlEvents:UIControlEventValueChanged];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"snoopTimes.sql"];
    
}
- (void)getLatestProducts
{
    USERID=user.userID;
    @try{
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@get-all-running-snachs/?customerId=%@",ec2maschineIP,user.userID]]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
               if (!error) {
            NSArray *latestProducts = [self fetchData:data];
            Products = [NSMutableArray arrayWithCapacity:10];
            
            if (latestProducts) {
                for (NSDictionary *prodDic in latestProducts) {
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
                    product.snooptime=[self getSnachTime:[product.snachId intValue]];
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

-(int)getSnachTime:(int)snachid{
    // Form the query.
    NSString *query = [NSString stringWithFormat:@"select snachtime from snachtimes where snachid=%d and userid=%@",snachid,USERID];
   
    NSArray *snachtime;
    int time=0;
    // Get the results.
    if (snachtime != nil) {
        snachtime = nil;
    }
    snachtime = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    if (snachtime!=nil) {
        @try{
            time=[[[snachtime objectAtIndex:0] objectAtIndex:0] integerValue];
        }
        @catch(NSException *e){
            
            time=30;
        }
    }
    else{
        time=30;
    }
     NSLog(@"Query in snach feed:%@  %@  %d",query,snachtime,time);
    return time;
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
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"Please pull down to fill the snachs";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
}
-(float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}
-(void)viewDidAppear:(BOOL)animated{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
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
        [self performSegueWithIdentifier:@"productDetails" sender:self];
        
    }
    //initializing user data
     user=[UserProfile sharedInstance];
    
    //setting up upper left profile pic here
    [self setupProfilePic];
    
   
   // [self getLatestProducts];
    [self requestContactBookAccess];
    viewSize = self.view.frame.size.width-93.0f;//for setting product scrollview size
  
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
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
{
    if (Products) {
        return [Products count];
    }
    return 0;
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
            NSLog(@"SSOUSING %@ Username %@ %@ ",SSOUsing,username,password);
            [self presentViewController:startscreen animated:YES completion:nil];
        
        }
    }

    


-(void)clearAllData{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
    NSLog(@"Cleared User Defaults");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath =  [documentsDirectory stringByAppendingPathComponent:@"snachit.sql"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    NSLog(@"Cleared Database");
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
        if(prod.friendCount==nil)
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if(!error)
            {
                dictionaryForFriendsCountResponse =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
                if([[dictionaryForFriendsCountResponse valueForKey:@"success"] isEqual:@"true"])
                {
                    NSLog(@"Friend count RESPONSE :%@",dictionaryForFriendsCountResponse);
                    prod.friendCount=[dictionaryForFriendsCountResponse valueForKey:@"count"] ;
                    if([prod.friendCount intValue]>0){
                        [cell.friendCount setHidden:NO];
                        cell.friendCount.layer.cornerRadius = 9.0f;
                        cell.friendCount.layer.borderWidth = 0.5;
                        cell.friendCount.layer.borderColor = [[UIColor whiteColor] CGColor];
                        [cell.friendCount setTitle:[NSString stringWithFormat:@"%@",prod.friendCount]forState:UIControlStateNormal];
                    }
                   
                }
                else{
                    prod.friendCount=0;
                }
            }
            else{
                prod.friendCount=0;
                NSLog(@"Response:%@",data);
            }
        }];
    }
    NSArray* subviews = [[NSArray alloc] initWithArray: cell.productImagesContainer.subviews];
        for (UIView* view in subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
    
   
    NSInteger productImages=[prod.productImages count];
    for(int index=0; index < productImages; index++)
    {
        CGFloat  xOffset = index*viewSize;
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset,10,viewSize, cell.productImagesContainer.frame.size.height)];
       
        [img setImageWithURL:[NSURL URLWithString:prod.productImages[index]] placeholderImage:nil];
        img.userInteractionEnabled = YES;
        [img setContentMode:UIViewContentModeScaleAspectFit];

        [cell.productImagesContainer addSubview:img];
     
        
    }
    cell.productImagesContainer.contentSize = CGSizeMake(viewSize*productImages,cell.productImagesContainer.frame.size.height);
    
    [cell.productName setTitle:[NSString stringWithFormat:@"%@ %@", prod.brandname, prod.productname] forState:UIControlStateNormal];
    cell.productName.titleLabel.adjustsFontSizeToFitWidth=YES;  //adjusting button font
    cell.productName.titleLabel.minimumScaleFactor=0.67;
    cell.productPrice.titleLabel.adjustsFontSizeToFitWidth=YES;  //adjusting button font
    cell.productPrice.titleLabel.minimumScaleFactor=0.67;
    [cell.productPrice setTitle: [NSString stringWithFormat:@"Retail:$%@",prod.price] forState:UIControlStateNormal];
    
    //Snoop button view setup
    [cell.snoop setTag:indexPath.row];
    
    ImageTapped *snoopTapped = [[ImageTapped alloc]
                                initWithTarget:self
                                action:@selector(snoopButtonClicked:) ];
    [snoopTapped setNumberOfTapsRequired:1];
    cell.snoop.userInteractionEnabled = YES;
    snoopTapped.productName=prod.productname;
    snoopTapped.brandName=[NSString stringWithFormat:@"%@", prod.brandname];
    [cell.brandImg setImageWithURL:[NSURL URLWithString:prod.brandimage] placeholderImage:nil];
    snoopTapped.Price=prod.price;
    
    snoopTapped.productId=prod.productId;
    snoopTapped.brandId=prod.brandId;
    snoopTapped.productSalesTax=prod.salesTax;
    snoopTapped.productShippingCost=prod.shippingPrice;
    snoopTapped.productSpeed=prod.speed;
    snoopTapped.snachId=prod.snachId;
    snoopTapped.productDescription=prod.productDescription;
    snoopTapped.productImageURL=[NSURL URLWithString:prod.productImage];
    snoopTapped.brandImageURL=[NSURL URLWithString:prod.brandimage];
    [cell.snoop addGestureRecognizer:snoopTapped];
    
    
    
    
    //Follow brand button view setup
    FollowStatusRecognizer *follow = [[FollowStatusRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(followButtonClicked:) ];
    
    
    [follow setNumberOfTapsRequired:1];
    cell.followStatus.userInteractionEnabled = YES;
    follow.brandId=prod.brandId;
    follow.followStatus=[prod.followStatus intValue];
    follow.index=indexPath.row;
    if([prod.followStatus intValue] ==1)
        [cell.followStatus setBackgroundColor:[UIColor colorWithRed:0.941 green:0.663 blue:0.059 alpha:1]];//Yellow color /*#f0a90f*/
    else
        [cell.followStatus setBackgroundColor:[UIColor colorWithRed:0.337 green:0.337 blue:0.333 alpha:1]];//Grey color /*#565655*/
    
    [cell.followStatus addGestureRecognizer:follow];
    
     return cell;
    }
    else{
    return nil;
    }
}



//on snoop button clicked
-(void)snoopButtonClicked:(UITapGestureRecognizer *)tapRecognizer {
    
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
    [self performSegueWithIdentifier:@"snoop" sender:self];
}

-(void)followButtonClicked:(UITapGestureRecognizer*)tapRecongnizer
{
    
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
    
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"snoop"]) {
        
        SnoopedProduct *product=[[SnoopedProduct
                                  sharedInstance]initWithProductId:snoopedProductId withBrandId:snoopedBrandId withSnachId:snoopedSnachId withProductName:snoopedProductName withBrandName:snoopedBrandName withProductImageURL:snoopedProductImageURL withBrandImageURL:snoopedBrandImageURL withProductPrice:snoopedProductPrice withProductDescription:snoopedProductDescription withProductSalesTax:snoopedSalesTax withProductShippingCost:snoopedShippingCost withProductShippingSpeed:snoopedSpeed];
    }
    else if ([segue.identifier isEqualToString:@"productDetails"]) {
        
        snooptTracking=0;
    }
    
}

-(void)viewDidUnload{
    
    [super viewDidUnload];
    [super viewDidUnload];
    if (self.isViewLoaded && !self.view.window) {
        self.view = nil;
    }

    self.productslist=nil;
    self.profilePic =nil;
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
    
    //here i am setting the frame of profile pic and assigning it to a button
    CGRect frameimg = CGRectMake(0, 0, 40, 40);
    topProfileBtn = [[UIButton alloc] initWithFrame:frameimg];
    
    //assigning the default background image
    [topProfileBtn setBackgroundImage:[UIImage imageNamed:@"userIcon.png"] forState:UIControlStateNormal];
    topProfileBtn.clipsToBounds=YES;
    [topProfileBtn setShowsTouchWhenHighlighted:YES];
    
    //setting up corner radious, border and border color width to make it circular
    topProfileBtn.layer.cornerRadius = 20.0f;
    topProfileBtn.layer.borderWidth = 2.0f;
    topProfileBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    // setting action to the button
    [topProfileBtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    //assigning button to top bar iterm
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:topProfileBtn];
    
    //adding bar item to left bar button item
    self.navigationItem.leftBarButtonItem=mailbutton;
    
    //checking if profile pic url is nil else download the image and assign it to imageview
    
   
    if([global isValidUrl:user.profilePicUrl]){
        
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:user.profilePicUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            [topProfileBtn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        }];}
    
}

@end
