//
//  MyProfile.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/12/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "MyProfile.h"
#import "SWRevealViewController.h"
#import "MyProfileFreindsCell.h"
#import "MyProfileBrandsCell.h"
#import "MyProfileSnachsCell.h"
#import "SnachProductDetails.h"
#import "SnatchFeed.h"
#import "UserProfile.h"
#import "SnoopedProduct.h"
#import "global.h"
#import "FriendSnachs.h"
#import "Products.h"
#import "Brand.h"
#import "SnachHistory.h"
#import "Product.h"
#import "Common.h"
NSString * const SNACH_CELL=@"snachsCell";
NSString * const FRIEND_CELL=@"friendsCell";
NSString * const BRAND_CELL=@"brandsCell";
NSString * const INFLIGHT=@"inflight";
NSString * const DELIVERED=@"delivered";
NSString * const ALL=@"all";
NSString * const PRODUCTNAME=@"productName";
NSString * const PRODUCTIMAGE=@"productImage";
NSString * const PRODUCTIMAGES=@"productImages";
NSString * const PRODUCTBRANDNAME=@"brandName";
NSString * const PRODUCTBRANDIMAGE=@"brandImage";
NSString * const FRIEND_IMAGE=@"freindImage";
NSString * const FRIEND_NAME=@"freindName";
NSString * const SNACHFEED=@"snachfeed";
NSString * const DATEORDERED=@"dateOrdered";
NSString * const DATEDELIVERED=@"deliveryDate";
@interface MyProfile ()
{
    NSMutableArray *friendsSnachs;
    NSMutableArray *snachs;
    NSMutableArray *followedBrand;
    NSMutableArray *brandProducts;
    NSMutableArray *myLetestALLSnachs;
    NSMutableArray *myLetestINFSnachs;
    NSMutableArray *myLetestDELSnachs;
    NSArray *singleProduct;
    NSDictionary *dictionaryForEmails;
     NSDictionary *dictionaryForFriendsCountResponse;
       NSData *friendCountJson;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong) NSArray *profileimg,*productimg,*brandimg,*followimg,*productName,*brandName,*productPrice;
@property(nonatomic,strong) NSArray *snachhistoryInflightList;
@property(nonatomic,strong) NSArray *snachhistoryDeliveredList;
@property(nonatomic,strong) NSArray *friendsnacheslist;
@property(nonatomic,strong) NSArray *brandproductslist;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;
@property (strong, nonatomic) UIImage *myImage;
@property (nonatomic, strong) NSString * tappedProductImage;
@property (nonatomic, strong) NSString * tappedProductName;
@property (nonatomic, strong) NSString * tappedProductPrice;
@end

@interface customTapGestureRecognizer : UITapGestureRecognizer

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
@interface FollowStatusRecognizer1 : UITapGestureRecognizer

@property (nonatomic, strong) NSString * brandId;
@property (nonatomic, assign) NSInteger followStatus;

@end
@implementation customTapGestureRecognizer

@end
@implementation FollowStatusRecognizer1


@end

@interface UnfollowButton : UITapGestureRecognizer

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation UnfollowButton


@end
@implementation MyProfile

{
    NSString *cellId,*subCellId;
    UserProfile *user;
    float viewHalfWidth;
    float viewQuarterWidth;
    float viewHalfHeight;
    float viewQuarterHeight;
    float startX;
    float startY;
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
    

}

@synthesize tabSelect=_tabSelect;
@synthesize subTabSelect=_subTabSelect;
@synthesize menuItems;
UIRefreshControl *refreshControl;
UIView* backView ;
- (void)viewDidLoad {
    [super viewDidLoad];

   [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.profilePic.layer.cornerRadius= RADIOUS;
    self.profilePic.clipsToBounds = YES;
    self.profilePic.layer.borderWidth = BORDERWIDTH;
    self.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.backButton setTarget:self.revealViewController];
   [self.backButton setAction:@selector(revealToggle:)];
    cellId=FRIEND_CELL;
    subCellId=ALL;
    
    
   
     [_subTabSelect setHidden:YES];//hiding the sub tab
    [_lastLine setHidden:YES];
    self.myImage = [UIImage imageNamed:@"profile.png"];
    viewHalfWidth=self.view.frame.size.width/2.0f;
    viewQuarterWidth=viewHalfWidth/2.0f;
    viewHalfHeight=self.view.frame.size.height/2.0f;
    viewQuarterHeight=viewHalfHeight/2.0f;
    startX=viewQuarterWidth/2.0f;
    startY=viewQuarterHeight;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getPhoto:)];
    singleTap.numberOfTapsRequired = 2;
    [self.defaultbackImg setUserInteractionEnabled:YES];
    [self.defaultbackImg  addGestureRecognizer:singleTap];
    
    refreshControl= [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(getLatestFriendsSnachs) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
   }

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    user=[UserProfile sharedInstance];
}
-(void)viewDidAppear:(BOOL)animated{
    [self initialLize];
    [self getMYLatestSnachs];
    [self getLatestFriendsSnachs];
    [self getLatestFollowedBrandsProducts];
    [_tableView reloadData];
    
}

-(void)initialLize{
    
    if([global isValidUrl:user.profilePicUrl]){
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:user.profilePicUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            self.profilePic.image = [UIImage imageWithData:data];
        }];
    }
    if(![user.fullName isKindOfClass:[NSNull class]])
        self.fullNameLbl.text=[[NSString stringWithFormat:@"%@",user.fullName] uppercaseString];
    
    self.memberSinceLbl.text=[NSString stringWithFormat:@"Member since %@",[user.joiningDate substringFromIndex:[user.joiningDate length]-4]];
    self.fullNameLbl.adjustsFontSizeToFitWidth=YES;
    self.fullNameLbl.minimumScaleFactor=0.5;
    //setting background img
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if([defaults valueForKey:DEFAULT_BACK_IMG])
        self.defaultbackImg.image=[UIImage imageWithData:[defaults valueForKey:DEFAULT_BACK_IMG]];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count=0;
    if([cellId isEqual:FRIEND_CELL]){
        
        count=(int)[friendsSnachs count];
        [refreshControl addTarget:self action:@selector(getLatestFriendsSnachs) forControlEvents:UIControlEventValueChanged];
    }
    else if([cellId isEqual:BRAND_CELL]){
        count=(int)[followedBrand count];
        [refreshControl addTarget:self action:@selector(getLatestFollowedBrandsProducts) forControlEvents:UIControlEventValueChanged];

    }
    else if ([cellId isEqual:SNACH_CELL]){
        [refreshControl addTarget:self action:@selector(getMYLatestSnachs) forControlEvents:UIControlEventValueChanged];

        if([subCellId isEqual:INFLIGHT]){
          count=(int)[myLetestINFSnachs count];
        }
        else if([subCellId isEqual:DELIVERED])
        {
          count=(int)[myLetestDELSnachs count];;
        }
        else if([subCellId isEqual:ALL])
        {
            count=(int)[myLetestALLSnachs count];
        }
    }
        
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier =cellId;
    
    
    if([cellId isEqual:FRIEND_CELL]){
   
        
        
        NSString *friendName;
        NSString *friendProfilePic;
        NSArray *snachedProducts;
        NSString *defaultProfile=@"userIcon.png";
        
        
        FriendSnachs *snaches=[friendsSnachs objectAtIndex:indexPath.row];
        
        friendName=snaches.friendName;
        friendProfilePic=snaches.freindProfilePic;
        snachedProducts=snaches.snachedProducts;
        
        MyProfileFreindsCell *cell = (MyProfileFreindsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        cell.tag = indexPath.row;
         
        if (cell==nil) {
            cell = [[MyProfileFreindsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
        }
        
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:friendProfilePic]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if(!error)
            {
                cell.friendPic.image=[UIImage imageNamed:defaultProfile];
                //cell.friendPic.image = [UIImage imageWithData:data];
                
            }
            else{
                cell.friendPic.image=[UIImage imageNamed:defaultProfile];
            }
        }];
        
        cell.friendName.text = friendName;
        
        int scrollWidth = 100;
        int snachedProductCount=[snachedProducts count];
        if(snachedProductCount==0){
            
            cell.noSnachsYet.text=@"No Snachs Yet";
            NSArray* subviews = [[NSArray alloc] initWithArray: cell.scrollview.subviews];
            for (UIView* view in subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    [view removeFromSuperview];
                }
            }
            
        }
        else{
              cell.noSnachsYet.text=@"";
            int xOffset = 0;
            for(int index=0; index < [snachedProducts count]; index++)
                            {
                                Products *snProducts=[snachedProducts objectAtIndex:index];
                                //[aButton addTarget:self action:@selector(whatever:) forControlEvents:UIControlEventTouchUpInside];
                
                                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset,10,70, 70)];
                                [img setContentMode:UIViewContentModeScaleAspectFit];
                
                                customTapGestureRecognizer *customTap = [[customTapGestureRecognizer alloc]
                                                                         initWithTarget:self
                                                                         action:@selector(myAction:) ];
                                UIImageView *image = (UIImageView*)[cell.contentView viewWithTag:index+10];
                                if (image != nil) {
                                    [image removeFromSuperview];
                                }
                
                                [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:snProducts.productImage]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                    if(!error)
                                    {
                                        img.tag=index+10;
                                        [cell.scrollview addSubview:img];
                                        img.image = [UIImage imageWithData:data];
                                    }
                                }];
                                [customTap setNumberOfTapsRequired:1];
                                img.userInteractionEnabled = YES;
                
                                customTap.productImageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@Products/product.png",tempmaschineIP]];
                                customTap.productName=[NSString stringWithFormat:@"%@ %@", @"Mikasa",@"Mixer"];
                                customTap.price=@"100";
                                customTap.productId=snProducts.productId;
                                customTap.brandId=@"2015114173316";
                                customTap.brandName=@"Breville";
                                customTap.brandImageURL= [NSURL URLWithString:[NSString stringWithFormat:@"%@Products/breviele.png",tempmaschineIP]];
                                customTap.snachId=@"1";
                                
                                [img addGestureRecognizer:customTap];
                                
                                xOffset+=70;
                                
                            }
                            cell.scrollview.contentSize = CGSizeMake(scrollWidth+xOffset,70);
            
        }
    
    
        return cell;
    }

    
    else if([cellId isEqual:BRAND_CELL]){
        MyProfileBrandsCell *cell = (MyProfileBrandsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
         cell.tag = indexPath.row;

         NSArray *products;
        Brand *brand=[followedBrand objectAtIndex:indexPath.row];
        if(brand){
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:brand.brandImg]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if(!error)
            {
                if(cell.tag==indexPath.row){
                 cell.brandName.image=[UIImage imageWithData:data];
                }
                
            }
        }];
      
        products=brand.products;
        cell.productImageConatainer.scrollEnabled = YES;
        int scrollWidth = 100;
        
        cell.productImageConatainer.backgroundColor=[UIColor whiteColor];
        
        int xOffset = 0;
        
        if([products count]>0){
        for(int index=0; index < [products count]; index++)
        {
            Products *prod= [products objectAtIndex:index];
            
            //[aButton addTarget:self action:@selector(whatever:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset,10,70, 70)];
            [img setContentMode:UIViewContentModeScaleAspectFit];
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:prod.productImage]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if(!error)
                {if(cell.tag==indexPath.row){
                    img.image=[UIImage imageWithData:data];
                    [cell.productImageConatainer addSubview:img];
                }
                    
                }
            }];
            
            customTapGestureRecognizer *customTap = [[customTapGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(myAction:) ];
            [customTap setNumberOfTapsRequired:1];
            img.userInteractionEnabled = YES;
            customTap.productImageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@Products/product.png",tempmaschineIP]];
            customTap.productName=[NSString stringWithFormat:@"%@ %@", @"Nike", @"Shoes"];
            customTap.price=@"299";
            customTap.productId=prod.productId;
            customTap.brandId=@"2015114173316";
            customTap.brandName=@"Breville";
            customTap.brandImageURL= [NSURL URLWithString:[NSString stringWithFormat:@"%@Products/breviele.png",tempmaschineIP]];
            customTap.snachId=@"1";

            [img addGestureRecognizer:customTap];
            
            
       
            xOffset+=70;
            
        }
            }
        else if([products count]<1){
            NSArray* subviews = [[NSArray alloc] initWithArray: cell.productImageConatainer.subviews];
            for (UIView* view in subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    [view removeFromSuperview];
                }
            }

        }
        cell.productImageConatainer.contentSize = CGSizeMake(scrollWidth+xOffset,70);
            
       
            cell.followStatus.tag=indexPath.row+100;
        UnfollowButton *unfollowBtn = [[UnfollowButton alloc]
                                                     initWithTarget:self
                                                     action:@selector(unfollowBrand:) ];
            [unfollowBtn setNumberOfTapsRequired:1];
            unfollowBtn.indexPath=indexPath;
            [cell.followStatus addGestureRecognizer:unfollowBtn];
            
        }
        return cell;
    }
   else if([cellId isEqual:SNACH_CELL])
    {
        NSString *productImageUrl;
        NSString *productname;
        NSString *orderedDate;
        NSString *deliveryDate;
        SnachHistory *snachhistory;
        NSString *statusImg;
        
            if([subCellId isEqual:INFLIGHT]){
            snachhistory=[myLetestINFSnachs objectAtIndex:indexPath.row];
         
            productImageUrl=snachhistory.productImageUrl;
            productname=[NSString stringWithFormat:@"%@ %@",snachhistory.productBrandName,snachhistory.productName];
            orderedDate=snachhistory.productOrderedDate;
            statusImg=snachhistory.statusIcon;
                
        }
        else if([subCellId isEqual:DELIVERED]){
            snachhistory=[myLetestDELSnachs objectAtIndex:indexPath.row];
          
                productImageUrl=snachhistory.productImageUrl;
                productname=[NSString stringWithFormat:@"%@ %@",snachhistory.productBrandName,snachhistory.productName];
                orderedDate=snachhistory.productOrderedDate;
                deliveryDate=snachhistory.productDeliveryDate;
                statusImg=snachhistory.statusIcon;
            
        }
        else if([subCellId isEqual:ALL]){
            snachhistory=[myLetestALLSnachs objectAtIndex:indexPath.row];
            productImageUrl=snachhistory.productImageUrl;
            productname=[NSString stringWithFormat:@"%@ %@",snachhistory.productBrandName,snachhistory.productName];
            orderedDate=snachhistory.productOrderedDate;
            deliveryDate=snachhistory.productDeliveryDate;
          
            statusImg=snachhistory.statusIcon;
            
        }
        MyProfileSnachsCell *cell = (MyProfileSnachsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
         cell.tag = indexPath.row;
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:productImageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if(!error)
            {
            cell.productImg.image= [UIImage imageWithData:data];
            
            }
        }];
        [cell.productImg.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [cell.productImg.layer setBorderWidth: 1.0];
        cell.productName.text = productname;
        cell.orderDate.text = orderedDate;
        cell.deliveryDate.text=deliveryDate;
        if([statusImg isEqual:@"inflightIcon.png"]){
            [cell.deliverydateLbl setHidden:YES];}
        else
            [cell.deliverydateLbl setHidden:NO];
        
        cell.statusImg.image=[UIImage imageNamed:statusImg];
        return cell;
    }


    else{
    return nil;
    }
}
-(void)myAction:(UITapGestureRecognizer *)tapRecognizer {
   
    
    customTapGestureRecognizer *tap = (customTapGestureRecognizer *)tapRecognizer;
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

   
    backView = [[UIView alloc] initWithFrame:self.view.frame];
    backView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:backView];
    
    
    _freindsPopupView=[[[NSBundle mainBundle] loadNibNamed:@"ProfileFreindsPopup" owner:self options:nil]objectAtIndex:0];
    _freindsPopupView.frame=CGRectMake(startX, startY, 250, 250);
  
    [backView addSubview:_freindsPopupView];
    _productImg.image=nil;
    [_freindsPopupView setNeedsDisplay];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    // Add a task to the group
    dispatch_group_async(group, queue, ^{
       
         [self getproductForSnachId:tap.snachId];
        
    });
    
  
    
    // Add a handler function for when the entire group completes
    // It's possible that this will happen immediately if the other methods have already finished
    dispatch_group_notify(group, queue, ^{
        if(singleProduct){
            
             Product *prod=[singleProduct objectAtIndex:0];
            
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:prod.productImage]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if(!error)
                _productImg.image=[UIImage imageWithData:data];
            }];
            
            [_productNameLbl setTitle:[NSString stringWithFormat:@"%@ %@",prod.brandname,prod.productname] forState:UIControlStateNormal];
            [_productPriceLbl setTitle:[NSString stringWithFormat:@"$Retail:%@",prod.price] forState:UIControlStateNormal];
            NSError *error;
            dictionaryForEmails=[Common getDictionaryForFriendCount:@"20150210112535" SnachId:@"2" EmailId:@"akshay@gmail.com"];
            NSLog(@"dictionaryForEmails:%@",dictionaryForEmails);
            if(dictionaryForEmails!=nil){
                
                friendCountJson = [NSJSONSerialization dataWithJSONObject:dictionaryForEmails options:NSJSONWritingPrettyPrinted error:&error];
                NSLog(@"DIctionary %@",dictionaryForEmails);
                
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
                                    [_friendCount setHidden:NO];
                                    _friendCount.layer.cornerRadius = 9.0f;
                                    _friendCount.layer.borderWidth = 0.5;
                                    _friendCount.layer.borderColor = [[UIColor whiteColor] CGColor];
                                    [_friendCount setTitle:[NSString stringWithFormat:@"%@",prod.friendCount]forState:UIControlStateNormal];
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

            }
        
    });
    }
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
 
    
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}


/*
 This method sets the current data on the basis of product image tapped
 */

-(void)setCurrentProductData:(NSString*)productImage productName:(NSString*)productNa productPrice:(NSString*)productPr{
    self.tappedProductImage=productImage;
    self.tappedProductName=productNa;
    self.tappedProductPrice=productPr;
    
}
- (IBAction)indexChanged:(id)sender {
    
    switch (self.tabSelect.selectedSegmentIndex)
    {
        case 0:
            cellId=FRIEND_CELL;
            NSLog(@"%@",cellId);
            [_subTabSelect setHidden:YES];
             [_lastLine setHidden:YES];
            [_tableView reloadData];
            break;
        case 1:
            cellId=BRAND_CELL;
            NSLog(@"%@",cellId);
            [_subTabSelect setHidden:YES];
              [_lastLine setHidden:YES];
            [_tableView reloadData];
            break;
        case 2:
            cellId=SNACH_CELL;
            NSLog(@"%@",cellId);
            [_subTabSelect setHidden:NO];
            [_lastLine setHidden:NO];
            [_tableView reloadData];
           
            break;
    }
}
- (IBAction)subTabIndexChanged:(id)sender {
    NSLog(@"Changed");
    switch (self.subTabSelect.selectedSegmentIndex)
    {
case 0:
    subCellId=ALL;
    NSLog(@"%@",subCellId);
    [_tableView reloadData];
        break;
case 1:
    subCellId=INFLIGHT;
    NSLog(@"%@",subCellId);
    [_tableView reloadData];

    
    break;
case 2:
    subCellId=DELIVERED;
    NSLog(@"%@",subCellId);
    [_tableView reloadData];
      break;
    }

}


- (IBAction)closeBtn:(id)sender {
    
    [_freindsPopupView removeFromSuperview];
    [backView removeFromSuperview];
}
- (IBAction)snoopButton:(id)sender {
    
        SnoopedProduct *product=[[SnoopedProduct
                              sharedInstance]initWithProductId:snoopedProductId withBrandId:snoopedBrandId withSnachId:snoopedSnachId withProductName:snoopedProductName withBrandName:snoopedBrandName withProductImageURL:snoopedProductImageURL withBrandImageURL:snoopedBrandImageURL withProductPrice:snoopedProductPrice withProductDescription:snoopedProductDescription];
    snooptTracking=1;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SnatchFeed *rootViewController = [storyboard instantiateViewControllerWithIdentifier:SNACHFEED];
    
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        [navController setViewControllers: @[rootViewController] animated: YES];
    
        [self.revealViewController pushFrontViewController:navController animated:YES];

        
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
        
    
}



-(void)followButtonClicked:(UITapGestureRecognizer*)tapRecongnizer
 {
    
    FollowStatusRecognizer1 *follow = (FollowStatusRecognizer1*)tapRecongnizer;
    UIButton *button= (UIButton*)tapRecongnizer.view;
    if(follow.followStatus ==1){
        [button setBackgroundColor:[UIColor colorWithRed:0.337 green:0.337 blue:0.333 alpha:1]];//Grey color /*#565655*/
        follow.followStatus=0;
    }
    else{
        [button setBackgroundColor:[UIColor colorWithRed:0.941 green:0.663 blue:0.059 alpha:1]];//Yellow color /*#f0a90f*/
        follow.followStatus= 1;
        
    }
    
}
- (void)getLatestFriendsSnachs
{
    NSLog(@"Get latest friends");
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@freindsSnaches.json",tempmaschineIP]]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (!error) {
            NSArray *latestFriendSnachs = [self makeRequest:data];
            friendsSnachs = [NSMutableArray arrayWithCapacity:10];
            
            if (latestFriendSnachs) {
                for (NSDictionary *tempDic in latestFriendSnachs) {
                    FriendSnachs *fSnachs = [[FriendSnachs alloc] init];
                    fSnachs.friendName=[tempDic objectForKey:FRIEND_NAME];
                    fSnachs.freindProfilePic=[tempDic objectForKey:FRIEND_IMAGE];
                    NSArray *latestFriendSnachs2 = [tempDic objectForKey:@"snachs"];
                    snachs = [NSMutableArray arrayWithCapacity:10];
                      if (latestFriendSnachs2)
                      {
                           for (NSDictionary *tempSnachDic in latestFriendSnachs2) {
                               Products *snached= [[Products alloc] init];
                               snached.productId=[tempSnachDic objectForKey:@"productId"];
                               snached.productImage=[tempSnachDic objectForKey:@"productImg"];
                               [snachs addObject:snached];
                           }
                      }
                    fSnachs.snachedProducts=snachs;
                    [friendsSnachs addObject:fSnachs];
                }
            }
           // As this block of code is run in a background thread, we need to ensure the GUI
            // update is executed in the main thread
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }];
}
- (void)getLatestFollowedBrandsProducts
{
      NSLog(@"Get followed brand products");
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@brandProducts.json",tempmaschineIP]]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (!error) {
            NSArray *latestFollowedBrands = [self makeRequest:data];
            followedBrand = [NSMutableArray arrayWithCapacity:10];
            
            if (latestFollowedBrands) {
                for (NSDictionary *tempDic in latestFollowedBrands) {
                    Brand *fBrand = [[Brand alloc] init];
                    fBrand.brandId=[tempDic objectForKey:@"brandId"];
                    fBrand.brandName=[tempDic objectForKey:@"brandName"];
                    fBrand.brandImg=[tempDic objectForKey:@"brandImage"];
                    NSArray *latestFriendSnachs2 = [tempDic objectForKey:@"products"];
                    brandProducts = [NSMutableArray arrayWithCapacity:10];
                    if (latestFriendSnachs2)
                    {
                        for (NSDictionary *tempFollowDic in latestFriendSnachs2) {
                            Products *followed= [[Products alloc] init];
                            followed.productId=[tempFollowDic objectForKey:@"productId"];
                            followed.productImage=[tempFollowDic objectForKey:@"productImg"];
                            [brandProducts addObject:followed];
                        }
                    }
                    fBrand.products=brandProducts;
                    [followedBrand addObject:fBrand];
                }
            }
            // As this block of code is run in a background thread, we need to ensure the GUI
            // update is executed in the main thread
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }];
}
- (void)getMYLatestSnachs
{
      NSLog(@"Get my snachs");
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@get-user-snach-history/?customerId=%@",ec2maschineIP,user.userID]]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
       
        if (!error) {
            NSDictionary *latestSnachs = [self makeHistoryRequest:data];
            myLetestALLSnachs = [NSMutableArray arrayWithCapacity:10];
            myLetestDELSnachs = [NSMutableArray arrayWithCapacity:10];
            myLetestINFSnachs = [NSMutableArray arrayWithCapacity:10];
            if (latestSnachs) {
             
               

                for (NSDictionary *tempDic in [latestSnachs objectForKey:@"data"]) {
                    SnachHistory *snachhistory = [[SnachHistory alloc] init];
                    snachhistory.productName=[tempDic objectForKey:@"productName"];
                    snachhistory.productBrandName=[tempDic objectForKey:@"brandName"];
                    snachhistory.productImageUrl=[tempDic objectForKey:@"productImage"];
                    snachhistory.productOrderedDate=[tempDic objectForKey:@"dateOrdered"];
                    snachhistory.productDeliveryDate=[tempDic objectForKey:@"deliveryDate"];
                    snachhistory.productstatus=[tempDic objectForKey:@"status"];
                    if([[tempDic valueForKey:@"status"] isEqual:INFLIGHT])
                    {snachhistory.statusIcon=@"inflightIcon.png"; [myLetestINFSnachs addObject:snachhistory];}
                    else if([[tempDic valueForKey:@"status"] isEqual:DELIVERED])
                    {snachhistory.statusIcon=@"deliveredIcon.png";[myLetestDELSnachs addObject:snachhistory];}
                    
                    [myLetestALLSnachs addObject:snachhistory];
                }
            }
            // As this block of code is run in a background thread, we need to ensure the GUI
            // update is executed in the main thread
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }];
}

- (void)reloadData
{
    // Reload table data
    [self.tableView reloadData];
    
    if (refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        refreshControl.attributedTitle = attributedTitle;
        
        [refreshControl endRefreshing];
    }
}


-(NSArray*)makeRequest:(NSData *)response{
    NSError *error = nil;
   // NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
//    NSLog(@"parsed data: %@",parsedData);
    if (error != nil) {
        NSLog(@"Error: %@", error.description);
        return nil;
    }
    
    NSDictionary *latestFriendSnachs = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error: &error];
       return [latestFriendSnachs objectForKey:@"data"];
}
-(NSDictionary*)makeHistoryRequest:(NSData *)response{
    NSError *error = nil;
    // NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
    //    NSLog(@"parsed data: %@",parsedData);
    if (error != nil) {
        NSLog(@"Error: %@", error.description);
        return nil;
    }
    
    NSDictionary *latestFriendSnachs = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error: &error];
    return latestFriendSnachs;
}

-(void) getPhoto:(id) sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentModalViewController:picker animated:YES];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:YES];
    self.defaultbackImg.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}

-(void)getproductForSnachId:(NSString*)snachid{
    NSString *url;
    
    url=[NSString stringWithFormat:@"%@get-snach-deal/?snach_id=%@",ec2maschineIP,snachid];
    NSURL *webURL = [[NSURL alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:webURL];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    //getting the data
    NSData *jasonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
    if (jasonData) {
        NSDictionary *response= [NSJSONSerialization JSONObjectWithData:jasonData options:NSJSONReadingMutableContainers error: &error];
        
        if (!error) {
            NSDictionary *prodDic = response;
            
           
          
            if (prodDic) {
                
                    Product *prod = [[Product alloc] init];
                    prod.productImages=[prodDic objectForKey:PRODUCT_IMAGES];
                    prod.productname=[prodDic objectForKey:PRODUCT_NAME];
                    prod.brandname =[prodDic objectForKey:PRODUCT_BRAND_NAME];
                    prod.price =[prodDic objectForKey:PRODUCT_PRICE];
                    prod.brandimage =[prodDic objectForKey:PRODUCT_BRAND_IMAGE];
                    prod.productImage =[prodDic objectForKey:PRODUCT_IMAGE];
                    prod.brandId =[prodDic objectForKey:PRODUCT_BRAND_ID];
                    prod.productId =[prodDic objectForKey:PRODUCT_ID];
                    prod.snachId =[prodDic objectForKey:PRODUCT_SNACH_ID];
                    prod.productDescription =[prodDic objectForKey:PRODUCT_DESCRIPTION];
                    prod.followStatus =[prodDic objectForKey:PRODUCT_FOLLOW_STATUS];
                    
                singleProduct=[[NSArray alloc] initWithObjects:prod, nil];
                
            }
            
            // As this block of code is run in a background thread, we need to ensure the GUI
            // update is executed in the main thread
           
            
        }
        else{
            NSLog(@"ERROR :%@",error);
        }
    }
    
}

- (IBAction)followBrand:(id)sender {
    Product *prod=[singleProduct objectAtIndex:0];

    if([prod.followStatus intValue] ==1){
       
        if([Common updateFollowStatus:prod.brandId FollowStatus:[NSString stringWithFormat:@"%@",prod.followStatus ] ForUserId:user.userID]==1)
        {
            
            [_followStatus setBackgroundColor:[UIColor colorWithRed:0.337 green:0.337 blue:0.333 alpha:1]];//Grey color /*#565655*/
            prod.followStatus=@"0";
        }
    }
    
    else{
        
        
        if([Common updateFollowStatus:prod.brandId FollowStatus:[NSString stringWithFormat:@"%@",prod.followStatus] ForUserId:user.userID]==1)
        {
            [_followStatus setBackgroundColor:[UIColor colorWithRed:0.941 green:0.663 blue:0.059 alpha:1]];//Yellow color /*#f0a90f*/
            prod.followStatus=@"1";
            
        }
    }

}

-(void)unfollowBrand:(UITapGestureRecognizer*)tapRecognizer{
    UnfollowButton *tap = (UnfollowButton *)tapRecognizer;
  Brand *brand=[followedBrand objectAtIndex:tap.indexPath.row];
   
    if([Common updateFollowStatus:brand.brandId FollowStatus:@"0" ForUserId:user.userID]==1)
        {
          
           [self.tableView reloadData];
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if(tap.indexPath.row<[followedBrand count]){
                [followedBrand removeObjectAtIndex:tap.indexPath.row];
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:tap.indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
                [self.tableView reloadData];
                }
                
            });
            
            
        }
    
    
   
}



@end
