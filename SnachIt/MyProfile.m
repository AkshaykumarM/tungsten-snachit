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

@interface MyProfile ()

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
@synthesize menuItems,profileimg,productimg,brandimg,followimg,brandName,productName,productPrice;
UIView* backView ;
- (void)viewDidLoad {
    [super viewDidLoad];

   [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.profilePic.layer.cornerRadius= RADIOUS;
    self.profilePic.clipsToBounds = YES;
    self.profilePic.layer.borderWidth = BORDERWIDTH;
    self.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    
    cellId=@"friendsCell";
    subCellId=@"all";
    
    
    productimg=[NSArray arrayWithObjects:@"staked-cup.png",@"product.png",@"mixer.png",@"staked-cup.png",@"staked-cup.png",@"staked-cup.png", nil];

    brandimg=[NSArray arrayWithObjects:@"outer-box.png",@"nike.png",@"outer-box.png",@"nike.png",@"nike.png", @"outer-box.png",nil];
    brandName = [NSArray arrayWithObjects:@"Breville", @"Mikasa",@"Nike",@"Outer-Box",@"Breville", @"Mikasa", nil];

    productName=[NSArray arrayWithObjects:@"Stainless steel blender",@"3.25 Quart pitcher",@"Stainless steel blender",@"3.25 Quart pitcher",@"Stainless steel blender",@"3.25 Quart pitcher", nil];
    followimg=[NSArray arrayWithObjects:@"star-5-24.png",@"star-5-24.png",@"star-5-24.png",@"star-5-24.png",@"star-5-24.png", @"star-5-24.png",nil];
    productPrice=[NSArray arrayWithObjects:@"$129.99",@"$60.99",@"$129.99",@"$60.99",@"$129.99",@"$60.99", nil];
     [_subTabSelect setHidden:YES];//hiding the sub tab
    [_lastLine setHidden:YES];
    self.myImage = [UIImage imageNamed:@"profile.png"];
    viewHalfWidth=self.view.frame.size.width/2.0f;
    viewQuarterWidth=viewHalfWidth/2.0f;
    viewHalfHeight=self.view.frame.size.height/2.0f;
    viewQuarterHeight=viewHalfHeight/2.0f;
    startX=viewQuarterWidth/2.0f;
    startY=viewQuarterHeight;
   }

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    user=[UserProfile sharedInstance];
}
-(void)viewDidAppear:(BOOL)animated{
    [self initialLize];
    [self makeSnachHistoryRequest];
    [self makeFriendsSnachesRequest];
    [self makeBrandProductsRequest];
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
    if([cellId isEqual:@"friendsCell"]){
        
        count=(int)[self.friendsnacheslist count];
    }
    else if([cellId isEqual:@"brandsCell"]){
        count=(int)[self.brandproductslist count];
    }
    else if ([cellId isEqual:@"snachsCell"]){
        
        if([subCellId isEqual:@"inFlight"]){
          count=(int)[self.snachhistoryInflightList count];
        }
        else if([subCellId isEqual:@"delivered"])
        {
          count=(int)[self.snachhistoryDeliveredList count];
        }
        else if([subCellId isEqual:@"all"])
        {
            count=(int)[self.snachhistoryInflightList count]+(int)[self.snachhistoryDeliveredList count];
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
    
    if([cellId isEqual:@"friendsCell"]){
   
        NSString *friendName;
        NSString *freindProfilePic;
        NSArray *snachedProducts;
        NSString *defaultProfile=@"userIcon.png";
        NSDictionary *friendSnaches;
        
        friendSnaches=[self.friendsnacheslist objectAtIndex:indexPath.row];
        friendName=[friendSnaches valueForKey:@"freindName"];
        freindProfilePic=[friendSnaches valueForKey:@"freindImage"];
        snachedProducts=[friendSnaches valueForKey:@"productImages"];
       
    MyProfileFreindsCell *cell = (MyProfileFreindsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:freindProfilePic]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
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
    
    cell.friendPic.layer.cornerRadius= cell.friendPic.frame.size.width/1.96;
        

    cell.friendPic.clipsToBounds = YES;
    cell.friendPic.layer.borderWidth = 5.0f;
    cell.friendPic.layer.borderColor = [UIColor whiteColor].CGColor;
        
   
    cell.scrollview.scrollEnabled = YES;
    int scrollWidth = 100;
            
        cell.scrollview.backgroundColor=[UIColor whiteColor];
        
        
        int xOffset = 0;
        if([snachedProducts count]!=0){
        for(int index=0; index < [snachedProducts count]; index++)
        {
            //[aButton addTarget:self action:@selector(whatever:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset,10,70, 70)];
            [img setContentMode:UIViewContentModeScaleAspectFit];
         
             customTapGestureRecognizer *customTap = [[customTapGestureRecognizer alloc]
                                                 initWithTarget:self
                                                   action:@selector(myAction:) ];
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:snachedProducts[index]]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if(!error)
                {
                    img.image = [UIImage imageWithData:data];
                }
            }];
            
            [customTap setNumberOfTapsRequired:1];
            img.userInteractionEnabled = YES;
            
            customTap.productImageURL=[NSURL URLWithString:@"http://192.168.0.120/Products/product.png"];
            customTap.productName=[NSString stringWithFormat:@"%@ %@", brandName[index], productName[index]];
            customTap.price=productPrice[index];
            customTap.productId=@"101";
            customTap.brandId=@"2015114173316";
            customTap.brandName=@"Breville";
            customTap.brandImageURL= [NSURL URLWithString:@"http://192.168.0.120/Products/breviele.png"];
            customTap.snachId=@"1";
         
            [img addGestureRecognizer:customTap];
            
            [cell.scrollview addSubview:img];
            xOffset+=70;
            
        }
        cell.scrollview.contentSize = CGSizeMake(scrollWidth+xOffset,70);
        snachedProducts=nil;
            snachedProducts=nil;
        }
        else{
            [cell.scrollview setHidden:YES];
            [cell.noSnachsYet setHidden:NO];
        }
          return cell;
    }

    
    if([cellId isEqual:@"brandsCell"]){
        MyProfileBrandsCell *cell = (MyProfileBrandsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        
        NSDictionary *brandProducts;
         NSArray *products;
        brandProducts=[self.brandproductslist objectAtIndex:indexPath.row];
        
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[brandProducts valueForKey:@"brandImage"]]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if(!error)
            {
                 cell.brandName.image=[UIImage imageWithData:data];
                
                
            }
        }];
       
        products=[brandProducts valueForKey:@"productImages"];
        cell.productImageConatainer.scrollEnabled = YES;
        int scrollWidth = 100;
        
        cell.productImageConatainer.backgroundColor=[UIColor whiteColor];
        
        
        
        int xOffset = 0;
              for(int index=0; index < [products count]; index++)
        {
            //[aButton addTarget:self action:@selector(whatever:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset,10,70, 70)];
            [img setContentMode:UIViewContentModeScaleAspectFit];
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:products[index]]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if(!error)
                {
                    img.image=[UIImage imageWithData:data];
                    
                    
                }
            }];
            
            customTapGestureRecognizer *customTap = [[customTapGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(myAction:) ];
            [customTap setNumberOfTapsRequired:1];
            img.userInteractionEnabled = YES;
            customTap.productImageURL=[NSURL URLWithString:@"http://192.168.0.120/Products/product.png"];
            customTap.productName=[NSString stringWithFormat:@"%@ %@", brandName[index], productName[index]];
            customTap.price=productPrice[index];
            customTap.productId=@"101";
            customTap.brandId=@"2015114173316";
            customTap.brandName=@"Breville";
            customTap.brandImageURL= [NSURL URLWithString:@"http://192.168.0.120/Products/breviele.png"];
            customTap.snachId=@"1";

            [img addGestureRecognizer:customTap];
            
            
            [cell.productImageConatainer addSubview:img];
            xOffset+=70;
            
        }
        cell.productImageConatainer.contentSize = CGSizeMake(scrollWidth+xOffset,70);
        NSLog(@"Content: %f",cell.productImageConatainer.contentSize.width);
        cell.followStatus.image = [UIImage imageNamed:[followimg objectAtIndex:indexPath.row]];
        products=nil;
      
        return cell;
    }
    if([cellId isEqual:@"snachsCell"])
    {
        NSString *productImageUrl;
        NSString *productname;
        NSString *orderedDate;
        NSString *deliveryDate;
        NSDictionary *snachhistory;
        NSString *statusImg;
        if([subCellId isEqual:@"inFlight"]){
            snachhistory=[self.snachhistoryInflightList objectAtIndex:indexPath.row];
            productImageUrl=[snachhistory valueForKey:@"productImage"];
            productname=[NSString stringWithFormat:@"%@ %@",[snachhistory valueForKey:@"brandName"],[snachhistory valueForKey:@"productName"]];
            orderedDate=[snachhistory valueForKey:@"dateOrdered"];
            deliveryDate=[snachhistory valueForKey:@"deliveryDate"];
            statusImg=@"inflightIcon.png";
        }
        else if([subCellId isEqual:@"delivered"]){
            snachhistory=[self.snachhistoryDeliveredList objectAtIndex:indexPath.row];
            productImageUrl=[snachhistory valueForKey:@"productImage"];
            productname=[NSString stringWithFormat:@"%@ %@",[snachhistory valueForKey:@"brandName"],[snachhistory valueForKey:@"productName"]];
            orderedDate=[snachhistory valueForKey:@"dateOrdered"];
            deliveryDate=[snachhistory valueForKey:@"deliveryDate"];
             statusImg=@"deliveredIcon.png";
        }
        else if([subCellId isEqual:@"all"]){
            if(indexPath.row <[self.snachhistoryInflightList count]){
            snachhistory=[self.snachhistoryInflightList objectAtIndex:indexPath.row];
            productImageUrl=[snachhistory valueForKey:@"productImage"];
            productname=[NSString stringWithFormat:@"%@ %@",[snachhistory valueForKey:@"brandName"],[snachhistory valueForKey:@"productName"]];
            orderedDate=[snachhistory valueForKey:@"dateOrdered"];
            deliveryDate=[snachhistory valueForKey:@"deliveryDate"];
            statusImg=@"inflightIcon.png";
            }
            else {
                snachhistory=[self.snachhistoryDeliveredList objectAtIndex:[self.snachhistoryInflightList count]-indexPath.row+1];
                productImageUrl=[snachhistory valueForKey:@"productImage"];
                productname=[NSString stringWithFormat:@"%@ %@",[snachhistory valueForKey:@"brandName"],[snachhistory valueForKey:@"productName"]];
                orderedDate=[snachhistory valueForKey:@"dateOrdered"];
                deliveryDate=[snachhistory valueForKey:@"deliveryDate"];
                statusImg=@"deliveredIcon.png";
            }
        }
        MyProfileSnachsCell *cell = (MyProfileSnachsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:productImageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if(!error)
            {
            cell.productImg.image= [UIImage imageWithData:data];
            
            }
        }];
        [cell.productImg.layer setBorderColor: [[UIColor grayColor] CGColor]];
        [cell.productImg.layer setBorderWidth: 1.0];
        cell.productName.text = productname;
        cell.orderDate.text = orderedDate;
        cell.deliveryDate.text=deliveryDate;
        cell.statusImg.image=[UIImage imageNamed:statusImg];
        return cell;
    }


    else{
    return 0;
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
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:tap.productImageURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        _productImg.image=[UIImage imageWithData:data];
    }];
   
    [_productNameLbl setTitle:tap.productName forState:UIControlStateNormal];
    [_productPriceLbl setTitle:tap.price forState:UIControlStateNormal];
  
    [backView addSubview:_freindsPopupView];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
 
    
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
            cellId=@"friendsCell";
            NSLog(@"%@",cellId);
            [_subTabSelect setHidden:YES];
             [_lastLine setHidden:YES];
            [_tableView reloadData];
            break;
        case 1:
            cellId=@"brandsCell";
            NSLog(@"%@",cellId);
            [_subTabSelect setHidden:YES];
              [_lastLine setHidden:YES];
            [_tableView reloadData];
            break;
        case 2:
            cellId=@"snachsCell";
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
    subCellId=@"all";
    NSLog(@"%@",subCellId);
    [_tableView reloadData];
        break;
case 1:
    subCellId=@"inFlight";
    NSLog(@"%@",subCellId);
    [_tableView reloadData];
    
    break;
case 2:
    subCellId=@"delivered";
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
        SnatchFeed *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"snachfeed"];
    
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        [navController setViewControllers: @[rootViewController] animated: YES];
    
        [self.revealViewController pushFrontViewController:navController animated:YES];

        
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
        
    
}

- (IBAction)barButtonItem:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SnatchFeed *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"snachfeed"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [navController setViewControllers: @[rootViewController] animated: YES];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.35;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self.revealViewController pushFrontViewController:navController animated:NO];
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
-(void)makeSnachHistoryRequest{
    NSData *jasonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://192.168.0.120/snachhistory.json"]];
    NSDictionary *temp;
    if (jasonData) {
        NSError *e = nil;
        temp = [NSJSONSerialization JSONObjectWithData:jasonData options:NSJSONReadingMutableContainers error: &e];
        
        self.snachhistoryInflightList=[temp objectForKey:@"inflight"];
        self.snachhistoryDeliveredList=[temp objectForKey:@"delivered"];
        
        
    }
  
}

-(void)makeFriendsSnachesRequest{
    NSData *jasonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://192.168.0.120/freindsSnaches.json"]];
    NSDictionary *temp;
    if (jasonData) {
        NSError *e = nil;
        temp = [NSJSONSerialization JSONObjectWithData:jasonData options:NSJSONReadingMutableContainers error: &e];
        self.friendsnacheslist=[temp objectForKey:@"data"];
    }
}
-(void)makeBrandProductsRequest{
    NSData *jasonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://192.168.0.120/brandProducts.json"]];
    NSDictionary *temp;
    if (jasonData) {
        NSError *e = nil;
        temp = [NSJSONSerialization JSONObjectWithData:jasonData options:NSJSONReadingMutableContainers error: &e];
        self.brandproductslist=[temp objectForKey:@"data"];
        NSLog(@"%@",self.brandproductslist);
    }   
}


@end
