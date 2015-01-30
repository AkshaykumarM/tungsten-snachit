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
#import "UserProfile.h"
#import "SnoopedProduct.h"
#import "SnachItLogin.h"
@interface SnatchFeed()


@property(nonatomic,strong) NSArray *productslist;
@property(nonatomic,strong) NSMutableArray *emailIds;//for storing mail ids

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

@end

@implementation ImageTapped

@end

@interface FollowStatusRecognizer : UITapGestureRecognizer

@property (nonatomic, strong) NSString * brandId;
@property (nonatomic, assign) NSInteger followStatus;

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
    UserProfile *user;
    UIButton *topProfileBtn;
    NSMutableDictionary *dictionaryForEmails;
    NSData *friendCountJson;
    NSData *responseData ;
    NSDictionary *dictionaryForFriendsCountResponse;
}



 - (void)viewDidLoad {
     
    [super viewDidLoad];
     
    
       [self setViewLookAndFeel];
     
    
  
  }
-(void)viewDidAppear:(BOOL)animated{
  

    // we will finally store the emails in an array so we create it here

    
    
     //    if(i==0){
//    SnachitStartScreen *startscreen = [[SnachitStartScreen alloc]
//                                  initWithNibName:@"StartScreen" bundle:nil];
//    [self presentViewController:startscreen animated:YES completion:nil];
//    }
//    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:userProfilePic]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        image3 = [UIImage imageWithData:data];
//    }];
//    i++;
     user=[UserProfile sharedInstance];
    if(user.profilePicUrl!=nil){
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:user.profilePicUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        CGRect frameimg = CGRectMake(0, 0, 40, 40);
        
        topProfileBtn = [[UIButton alloc] initWithFrame:frameimg];
        [topProfileBtn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        topProfileBtn.clipsToBounds=YES;
        [topProfileBtn setShowsTouchWhenHighlighted:YES];
        topProfileBtn.layer.cornerRadius = 20.0f;
        topProfileBtn.layer.borderWidth = 2.0f;
        topProfileBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        [topProfileBtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:topProfileBtn];
        
        self.navigationItem.leftBarButtonItem=mailbutton;
        
        
        
    }];}

    }
-(void)viewWillAppear:(BOOL)animated{
    [self trySilentLogin];
    [self requestContactBookAccess];
    [self makeProductRequest];
    [_tableView reloadData];
   
    
    
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
 
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.productslist count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 265;
}

-(void)trySilentLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *SSOUsing = [defaults stringForKey:@"SSOUsing"];
    NSString *username = [defaults stringForKey:@"Username"];
    NSString *password = [defaults stringForKey:@"Password"];
    int signedUp = (int)[defaults integerForKey:@"signedUp"];
    NSLog(@"%@ %@ %@ %d",SSOUsing,username,password,signedUp);
    
    SnachitStartScreen *startscreen = [[SnachitStartScreen alloc]initWithNibName:@"StartScreen" bundle:nil];
    if(SSOUsing!=nil&& signedUp!=0&& username!=nil && password!=nil){
        NSLog(@"%@ %@ %@ %d",SSOUsing,username,password,signedUp);
        SnachItLogin *login =[[SnachItLogin alloc] init];
    int status=[login performSignIn:username Password:password SSOUsing:SSOUsing];
        NSLog(@"%d",status);
        if(status==0)
            [self presentViewController:startscreen animated:YES completion:nil];
        
    }
    else{
        [self presentViewController:startscreen animated:YES completion:nil];
        
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier =@"snachproduct";
    SnatchFeedCell *cell = (SnatchFeedCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    //single product info
    NSDictionary *product=[self.productslist objectAtIndex:indexPath.row];
    NSArray *productImages=[product objectForKey:@"productImages"];
    NSString *productname=[product objectForKey:@"productName"];
    NSString *brandname =[product objectForKey:@"brandName"];
    NSString *price =[product objectForKey:@"productPrice"];
    NSString *brandimage =[product objectForKey:@"brandImage"];
    NSString *productImage =[product objectForKey:@"productImage"];
    NSString *brandId =[product objectForKey:@"brandId"];
    NSString *productId =[product objectForKey:@"productId"];
    NSString *snachId =[product objectForKey:@"snachId"];
    NSString *productDescription =[product objectForKey:@"productDescription"];
    NSInteger followStatus =[[product objectForKey:@"followStatus"] integerValue] ;
    __block NSInteger friendCount ;
    
    //setting up product image carousel
    cell.productImagesContainer.scrollEnabled = YES;
    int scrollWidth = 0;
    cell.productImagesContainer.backgroundColor=[UIColor whiteColor];
    int xOffset = 0;
    NSError *error;
    [dictionaryForEmails setObject:productId forKey:@"productId"];
    friendCountJson = [NSJSONSerialization dataWithJSONObject:dictionaryForEmails options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:friendCountJson encoding:NSUTF8StringEncoding];
    NSLog(@"jsonData as string:\n%@", jsonString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@getFriendsCount/",maschineIP]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [friendCountJson length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:friendCountJson];
    
  
    error = [[NSError alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(!error)
        {
            dictionaryForFriendsCountResponse =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
            if([[dictionaryForFriendsCountResponse valueForKey:@"success"] isEqual:@"true"])
            {
                friendCount=[[dictionaryForFriendsCountResponse valueForKey:@"count"] integerValue];
                NSLog(@"Friend Count : %@",[dictionaryForFriendsCountResponse valueForKey:@"success"] );
            }
        }
        else{
            NSLog(@"Response:%@",data);
        }
    }];

    
    
       for(int index=0; index < [productImages count]; index++)
    {
       
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset,10,cell.productImagesContainer.frame.size.width, cell.productImagesContainer.frame.size.height)];
        [img setContentMode:UIViewContentModeScaleAspectFit];
        //[img setImage: [UIImage imageNamed:[NSString stringWithFormat:@"%@", productImages[index]]]];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:productImages[index]]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            [img setImage: [UIImage imageWithData:data]];
        }];
        
        img.userInteractionEnabled = YES;
        
        [cell.productImagesContainer addSubview:img];
        xOffset+=cell.productImagesContainer.frame.size.width;
        
    }
    cell.productImagesContainer.contentSize = CGSizeMake(scrollWidth+xOffset,cell.productImagesContainer.frame.size.width);
    
    
    [cell.productName setTitle:[NSString stringWithFormat:@"%@ %@", brandname, productname] forState:UIControlStateNormal];
    
    [cell.productPrice setTitle: [NSString stringWithFormat:@"$%@",price] forState:UIControlStateNormal];
   
    //Snoop button view setup
    [cell.snoop setTag:indexPath.row];
    
    ImageTapped *snoopTapped = [[ImageTapped alloc]
                                             initWithTarget:self
                                action:@selector(snoopButtonClicked:) ];
    [snoopTapped setNumberOfTapsRequired:1];
    cell.snoop.userInteractionEnabled = YES;
    snoopTapped.productName=productname;
    snoopTapped.brandName=[NSString stringWithFormat:@"%@", brandname];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:brandimage]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        cell.brandImg.image =[UIImage imageWithData:data];
    
    }];
    
    snoopTapped.Price=price;
   
    snoopTapped.productId=productId;
    snoopTapped.brandId=brandId;
    snoopTapped.snachId=snachId;
    snoopTapped.productDescription=productDescription;
    snoopTapped.productImageURL=[NSURL URLWithString:productImage];
    snoopTapped.brandImageURL=[NSURL URLWithString:brandimage];
    [cell.snoop addGestureRecognizer:snoopTapped];
    
    
    
    
    //Follow brand button view setup
    FollowStatusRecognizer *follow = [[FollowStatusRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(followButtonClicked:) ];
    
    
    [follow setNumberOfTapsRequired:1];
    cell.followStatus.userInteractionEnabled = YES;
    follow.brandId=brandId;
    follow.followStatus=followStatus;
    
    if(followStatus ==1)
        [cell.followStatus setBackgroundColor:[UIColor colorWithRed:0.941 green:0.663 blue:0.059 alpha:1]];//Yellow color /*#f0a90f*/
    else
        [cell.followStatus setBackgroundColor:[UIColor colorWithRed:0.337 green:0.337 blue:0.333 alpha:1]];//Grey color /*#565655*/

    [cell.followStatus addGestureRecognizer:follow];
    
    
    //setting freind count

    if(friendCount>0){
        NSLog(@"sdfsdfdfsdfd%ld",(long)friendCount);
    cell.friendCount.layer.cornerRadius = 11.0f;
    cell.friendCount.layer.borderWidth = 1.0;
    cell.friendCount.layer.borderColor = [[UIColor whiteColor] CGColor];
        [cell.friendCount setTitle:[NSString stringWithFormat:@"%d",friendCount] forState:UIControlStateNormal];
    [cell.friendCount setHidden:NO];
//        }
//    else if(friendCount>20){
//            cell.friendCount.layer.cornerRadius = 11.0f;
//            cell.friendCount.layer.borderWidth = 1.0;
//            cell.friendCount.layer.borderColor = [[UIColor whiteColor] CGColor];
//        [cell.friendCount setTitle:@"20+" forState:UIControlStateNormal];
//            [cell.friendCount setHidden:NO];
//        
//        }
    }
    if(friendCount<1){
         [cell.friendCount setHidden:YES];
    }

    return cell;
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
    [self performSegueWithIdentifier:@"snoop" sender:self];
}

-(void)followButtonClicked:(UITapGestureRecognizer*)tapRecongnizer
{
    FollowStatusRecognizer *tap = (FollowStatusRecognizer*)tapRecongnizer;
    UIButton *button= (UIButton*)tapRecongnizer.view;
    if(tap.followStatus ==1){
    [button setBackgroundColor:[UIColor colorWithRed:0.337 green:0.337 blue:0.333 alpha:1]];//Grey color /*#565655*/
        tap.followStatus=0;
    }
    else{
        [button setBackgroundColor:[UIColor colorWithRed:0.941 green:0.663 blue:0.059 alpha:1]];//Yellow color /*#f0a90f*/
        tap.followStatus= 1;

    }
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"snoop"]) {
        
        SnoopedProduct *product=[[SnoopedProduct
                               sharedInstance]initWithProductId:snoopedProductId withBrandId:snoopedBrandId withSnachId:snoopedSnachId withProductName:snoopedProductName withBrandName:snoopedBrandName withProductImageURL:snoopedProductImageURL withBrandImageURL:snoopedBrandImageURL withProductPrice:snoopedProductPrice withProductDescription:snoopedProductDescription];
    }
}
-(void)makeProductRequest{
    NSData *jasonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://192.168.0.120/product.json"]];
      if (jasonData) {
        NSError *e = nil;
        self.productslist = [NSJSONSerialization JSONObjectWithData:jasonData options:NSJSONReadingMutableContainers error: &e];
    }
}
-(void)viewDidUnload{
    [super viewDidUnload];
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
           self.emailIds= [NSMutableArray array];
           [self.emailIds addObjectsFromArray:[self getallEmailIdsInAddressBook:addressBook]];
            
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        
            [dictionaryForEmails setObject:self.emailIds forKey:@"emailIds"];
            NSError *error;
            NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
            NSLog(@"jsonData as string:\n%@", jsonString);
            dictionaryForEmails = [[NSMutableDictionary alloc] init];
            if(user.userID!=nil){
            [dictionaryForEmails setObject:self.emailIds forKey:@"contactList"];
            [dictionaryForEmails setObject:user.userID forKey:@"userId"];
            [dictionaryForEmails setObject:user.emailID forKey:@"userEmail"];
            }
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


/***
This function will return all the email id's from the phoonebook in an Array.
**/
- (NSMutableArray*)getallEmailIdsInAddressBook:(ABAddressBookRef)addressBook
{
    NSMutableArray *emails= [NSMutableArray array];
    NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSInteger numberOfPeople = [allPeople count];
    
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
        ABMultiValueRef emailIds = ABRecordCopyValue(person, kABPersonEmailProperty);
        CFIndex numberOfEmailIds = ABMultiValueGetCount(emailIds);
        for (CFIndex i = 0; i < numberOfEmailIds; i++) {
            NSString *email = CFBridgingRelease(ABMultiValueCopyValueAtIndex(emailIds, i));
            [emails addObject:email];
            
        }
        CFRelease(emailIds);
        
    }
 
    return emails;
}

-(void)setViewLookAndFeel{
  
    
        self.navigationItem.leftBarButtonItem.target=self.revealViewController;
    self.navigationItem.leftBarButtonItem.action=@selector(revealToggle:);
}


-(void)getFriendCountForProduct:(NSString*)productId{
   
}
@end
