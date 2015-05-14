//
//  MyProfile.m
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/12/14.
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
#import <SDWebImage/UIImageView+WebCache.h>

NSString * const SNACH_CELL=@"snachsCell";
NSString * const FRIEND_CELL=@"friendsCell";
NSString * const BRAND_CELL=@"brandsCell";
NSString * const SNACHFEED=@"snachfeed";
NSString * const DATEORDERED=@"dateOrdered";
NSString * const DATEDELIVERED=@"deliveryDate";


//this interface is for track me button
@interface TrackMeTapGestureRecognizer : UITapGestureRecognizer

@property (nonatomic, strong) NSString * trackingNo;
@property (nonatomic, strong) NSString * slug;
@end

@implementation TrackMeTapGestureRecognizer

@end
@interface MyProfile ()<UINavigationControllerDelegate>
{
    NSMutableArray *friendsSnachs;
    NSMutableArray *snachs;
    NSMutableArray *followedBrand;
    NSMutableArray *brandProducts;
    NSMutableArray *myLetestALLSnachs;
    NSMutableArray *myLetestINFSnachs;
    NSMutableArray *myLetestDELSnachs;
    NSArray *singleProduct;
     NSNumber *strikeSize;
    NSDictionary *dictionaryForFriendsCountResponse;
    int yfortable;
    NSString *slugname;
    NSString *trackingno;
    
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

@property (nonatomic, strong) NSString * snachId;


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
    NSDictionary *dictionaryForEmails;
    NSData *friendCountJson;
    
}

@synthesize tabSelect=_tabSelect;
@synthesize subTabSelect=_subTabSelect;
@synthesize menuItems;
UIRefreshControl *refreshControl;
UIView* backView ;
- (void)viewDidLoad {
    [super viewDidLoad];
   
    yfortable=320;
    self.profilePic.layer.cornerRadius= RADIOUS;
    self.profilePic.clipsToBounds = YES;
    //self.profilePic.layer.borderWidth = BORDERWIDTH;
    //self.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
  
    cellId=FRIEND_CELL;
    subCellId=HISTORY_ALL;
    
    
    
    [_subTabSelect setHidden:YES];//hiding the sub tab
    [_lastLine setHidden:YES];
    self.myImage = [UIImage imageNamed:@"profile.png"];
    
   
    
    refreshControl= [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(getLatestFriendsSnachs) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [btn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    btn.imageEdgeInsets=UIEdgeInsetsMake(5,5,4,5);
    UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = eng_btn;
    
      strikeSize= [NSNumber numberWithInt:2];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
   
    
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
    [self.tableView reloadData];
    [self.tabSelect setSelectedSegmentIndex:0];
    
    [super viewDidAppear:YES];
    
    
}
-(void)viewDidLayoutSubviews{
    self.tableView.frame=CGRectMake(0, yfortable, self.view.frame.size.width, self.view.frame.size.height-yfortable);
    [super viewDidLayoutSubviews];
}
-(void)initialLize{
    
    [self.profilePic setImageWithURL:user.profilePicUrl placeholderImage:[UIImage imageNamed:DEFAULTPLACEHOLDER]];
    
    
    if(![user.fullName isKindOfClass:[NSNull class]])
        self.fullNameLbl.text=[[NSString stringWithFormat:@"%@",user.fullName] uppercaseString];
    
    self.memberSinceLbl.text=[NSString stringWithFormat:@"%@%@",MEMBER_SINCE,[user.joiningDate substringFromIndex:[user.joiningDate length]-4]];
    
    //setting user snoop time
    self.snoopTime.titleLabel.adjustsFontSizeToFitWidth=YES;
    self.snoopTime.titleLabel.minimumScaleFactor=0.44;
    [self.snoopTime setTitle:[NSString stringWithFormat:@"%d",(user.snoopTime==0)?30:user.snoopTime] forState:UIControlStateNormal];
    
    
    //setting background img
    //[self.defaultbackImg setImageWithURL:user.backgroundUrl placeholderImage:[UIImage imageNamed:DEFAULTBACKGROUNDIMG]];
    
    self.tableView.contentInset=UIEdgeInsetsZero;
    
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
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"OpenSans-Regular" size:20];
    [messageLabel sizeToFit];
    
    if([cellId isEqual:FRIEND_CELL]){
        
        count=(int)[friendsSnachs count];
        [refreshControl addTarget:self action:@selector(getLatestFriendsSnachs) forControlEvents:UIControlEventValueChanged];
        if(count<=0)
        {
            messageLabel.text = @"No friends found!";
            messageLabel.textColor=[UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
            self.tableView.backgroundView = messageLabel;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        else{
            self.tableView.backgroundView=nil;
        }
        
    }
    else if([cellId isEqual:BRAND_CELL]){
        count=(int)[followedBrand count];
        [refreshControl addTarget:self action:@selector(getLatestFollowedBrandsProducts) forControlEvents:UIControlEventValueChanged];
        
        if(count<=0)
        {
            messageLabel.text = @"No brand followed yet!";
            messageLabel.textColor=[UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
            self.tableView.backgroundView = messageLabel;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        else{
            self.tableView.backgroundView=nil;
        }
        
    }
    else if ([cellId isEqual:SNACH_CELL]){
        [refreshControl addTarget:self action:@selector(getMYLatestSnachs) forControlEvents:UIControlEventValueChanged];
        
        if([subCellId isEqual:HISTORY_INFLIGHT]){
            count=(int)[myLetestINFSnachs count];
        }
        else if([subCellId isEqual:HISTORY_DELIVERED])
        {
            count=(int)[myLetestDELSnachs count];;
        }
        else if([subCellId isEqual:HISTORY_ALL])
        {
            count=(int)[myLetestALLSnachs count];
        }
        
        if(count<=0)
        {
            messageLabel.text = @"No snachs yet!";
            messageLabel.textColor=[UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
            self.tableView.backgroundView = messageLabel;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        else{
            self.tableView.backgroundView=nil;
        }
        
    }
    if(count>0){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
        
        NSArray *snachedProducts;
        
        
        
        FriendSnachs *snaches=[friendsSnachs objectAtIndex:indexPath.row];
        
        friendName=snaches.friendName;
        
        snachedProducts=snaches.snachedProducts;
        
        MyProfileFreindsCell *cell = (MyProfileFreindsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        cell.tag = indexPath.row;
        
        if (cell==nil) {
            cell = [[MyProfileFreindsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
        }
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        [cell.friendPic setImageWithURL:[NSURL URLWithString:snaches.freindProfilePic] placeholderImage:[UIImage imageNamed:DEFAULTPLACEHOLDER]];
        cell.friendPic.layer.cornerRadius= 35.0f;
        cell.friendPic.clipsToBounds = YES;
        cell.friendPic.layer.borderWidth = BORDERWIDTH;
        cell.friendPic.layer.borderColor = [UIColor whiteColor].CGColor;
        [cell.friendPic setContentMode:UIViewContentModeScaleToFill];
        cell.friendName.text = friendName;
        
        int scrollWidth = 100;
        @try{
        int snachedProductCount=(int)[snachedProducts count];
        if(snachedProductCount==0){
            
            cell.noSnachsYet.text=@"No snachs yet";
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
                img.tag=index+10;
                
                [cell.scrollview addSubview:img];
                
                if(snProducts.snachStatus){
                    [img setImageWithURL:[NSURL URLWithString:snProducts.productImage] placeholderImage:nil];
                }
                else{
                  
                        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:snProducts.productImage]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                            UIImage *image = [UIImage imageWithData:data];
                            if (image) {
                                img.image = [self convertImageToGrayScale:image];
                            }
                        }];
                }
                
                [customTap setNumberOfTapsRequired:1];
                img.userInteractionEnabled = YES;
                
                customTap.snachId=snProducts.snachId;
                
                [img addGestureRecognizer:customTap];
                
                xOffset+=80;
                
            }
            cell.scrollview.contentSize = CGSizeMake(scrollWidth+xOffset,80);
            
        }}
        @catch(NSException *e){}
        
        
        return cell;
    }
    
    
    else if([cellId isEqual:BRAND_CELL]){
        MyProfileBrandsCell *cell = (MyProfileBrandsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        cell.tag = indexPath.row;
        
        NSArray *products;
        Brand *brand=[followedBrand objectAtIndex:indexPath.row];
        @try{
        if(brand){
            
            [cell.brandName setImageWithURL:[NSURL URLWithString:brand.brandImg] placeholderImage:nil];
            cell.followStatus.imageView.contentMode=UIViewContentModeScaleAspectFit;
            products=brand.products;
            cell.productImageConatainer.scrollEnabled = YES;
            int scrollWidth = 100;
            
            cell.productImageConatainer.backgroundColor=[UIColor whiteColor];
            
            int xOffset = 0;
            
            if([products count]>0){
                NSArray* subviews = [[NSArray alloc] initWithArray: cell.productImageConatainer.subviews];
                for (UIView* view in subviews) {
                    if ([view isKindOfClass:[UIImageView class]]) {
                        [view removeFromSuperview];
                    }
                }
                for(int index=0; index < [products count]; index++)
                {
                    Products *prod= [products objectAtIndex:index];
                    
                    //[aButton addTarget:self action:@selector(whatever:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset,10,70, 70)];
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    if(cell.tag==indexPath.row){
                        [img setImageWithURL:[NSURL URLWithString:prod.productImage] placeholderImage:nil];
                        [cell.productImageConatainer addSubview:img];
                        
                    }
                    
                    customTapGestureRecognizer *customTap = [[customTapGestureRecognizer alloc]
                                                             initWithTarget:self
                                                             action:@selector(myAction:) ];
                    [customTap setNumberOfTapsRequired:1];
                    img.userInteractionEnabled = YES;
                    customTap.snachId=prod.snachId;
                    
                    [img addGestureRecognizer:customTap];
                    
                    xOffset+=80;
                    
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
            [cell.followStatus  setBackgroundColor:[UIColor colorWithRed:0.941 green:0.663 blue:0.059 alpha:1]];
            cell.productImageConatainer.contentSize = CGSizeMake(scrollWidth+xOffset,80);
            
            
            cell.followStatus.tag=indexPath.row+100;
            UnfollowButton *unfollowBtn = [[UnfollowButton alloc]
                                           initWithTarget:self
                                           action:@selector(unfollowBrand:) ];
            [unfollowBtn setNumberOfTapsRequired:1];
            unfollowBtn.indexPath=indexPath;
            [cell.followStatus addGestureRecognizer:unfollowBtn];
            
        }}@catch(NSException *e){}
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
        NSString *trackingNo;
        NSString *slug;
        @try{
        if([subCellId isEqual:HISTORY_INFLIGHT]){
            snachhistory=[myLetestINFSnachs objectAtIndex:indexPath.row];
            
            productImageUrl=snachhistory.productImageUrl;
            productname=[NSString stringWithFormat:@"%@",snachhistory.productName];
            orderedDate=snachhistory.productOrderedDate;
            deliveryDate=snachhistory.productDeliveryDate;
            statusImg=snachhistory.statusIcon;
            trackingNo=snachhistory.trackingNo;
            slug=snachhistory.slug;
        }
        else if([subCellId isEqual:HISTORY_DELIVERED]){
            snachhistory=[myLetestDELSnachs objectAtIndex:indexPath.row];
            
            productImageUrl=snachhistory.productImageUrl;
            productname=[NSString stringWithFormat:@"%@",snachhistory.productName];
            orderedDate=snachhistory.productOrderedDate;
            deliveryDate=snachhistory.productDeliveryDate;
            statusImg=snachhistory.statusIcon;
            trackingNo=snachhistory.trackingNo;
            slug=snachhistory.slug;
        }
        else if([subCellId isEqual:HISTORY_ALL]){
            snachhistory=[myLetestALLSnachs objectAtIndex:indexPath.row];
            productImageUrl=snachhistory.productImageUrl;
            productname=[NSString stringWithFormat:@"%@",snachhistory.productName];
            orderedDate=snachhistory.productOrderedDate;
            deliveryDate=snachhistory.productDeliveryDate;
            statusImg=snachhistory.statusIcon;
            trackingNo=snachhistory.trackingNo;
            slug=snachhistory.slug;
        }
        MyProfileSnachsCell *cell = (MyProfileSnachsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        cell.tag = indexPath.row;
        [cell.productImg setImageWithURL:[NSURL URLWithString:productImageUrl] placeholderImage:nil];
        [cell.productImg.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [cell.productImg.layer setBorderWidth: 1.0];
        cell.productName.text = productname;
        cell.orderDate.text = orderedDate;
        cell.deliveryDate.text=deliveryDate;
            
            if([trackingNo isKindOfClass:[NSNull class]] || trackingNo==nil)
            {[cell.trackMeBTN setHidden:YES];
                
                
            }
            else{
                TrackMeTapGestureRecognizer *trackMeTap = [[TrackMeTapGestureRecognizer alloc]
                                                           initWithTarget:self
                                                           action:@selector(trackMe:) ];
                [trackMeTap setNumberOfTapsRequired:1];
                cell.trackMeBTN.userInteractionEnabled = YES;
                trackMeTap.trackingNo=trackingNo;
                trackMeTap.slug=slug;
                [cell.trackMeBTN addGestureRecognizer:trackMeTap];
                [cell.trackMeBTN setHidden:NO];
            }

        if([deliveryDate isEqual:@""]){
            cell.deliverydateLbl.text =@"";
        }
        else
            cell.deliverydateLbl.text=@"Est. Delivery Date:";
        
        cell.statusImg.image=[UIImage imageNamed:statusImg];
            deliveryDate=nil;
        return cell;
    }@catch(NSException *e){}
    }
    
    
    else{
        return nil;
    }
}

//this is for track me action
-(IBAction)trackMe:(UITapGestureRecognizer*)sender{
    TrackMeTapGestureRecognizer *tap=(TrackMeTapGestureRecognizer *)sender;
    slugname=tap.slug;
    trackingno=tap.trackingNo;
    [self performSegueWithIdentifier:@"trackme" sender:nil];
}

//sending slugname and tracking no before segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    AftershipTracker *aftershipTracker = [segue destinationViewController];
    aftershipTracker.delegate=self;
    aftershipTracker.slugname = slugname;
    aftershipTracker.trackingNo=trackingno;
}


-(void)myAction:(UITapGestureRecognizer *)tapRecognizer {
    
    
    customTapGestureRecognizer *tap = (customTapGestureRecognizer *)tapRecognizer;
    snoopedSnachId=tap.snachId;
    
    
    backView = [[UIView alloc] initWithFrame:self.view.frame];
    backView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:backView];
    
    
    _freindsPopupView=[[[NSBundle mainBundle] loadNibNamed:@"ProfileFreindsPopup" owner:self options:nil]objectAtIndex:0];
    _freindsPopupView.frame=CGRectMake(0, 0 , 250, 250);
    _freindsPopupView.center=CGPointMake( CGRectGetMidX(self.view.bounds ), CGRectGetMidY( self.view.bounds ) );
    
    [backView addSubview:_freindsPopupView];
    _productImg.image=nil;
    [_snoopBtn setEnabled:NO];
    [_followStatus setEnabled:NO];
    [_freindsPopupView setNeedsDisplay];
    
    
    [self getproductForSnachId:tap.snachId];
    
    
    
    
    
    // Add a handler function for when the entire group completes
    // It's possible that this will happen immediately if the other methods have already finished
    
    if(singleProduct!=nil){
        @try{
            Product *prod=[singleProduct objectAtIndex:0];
            snoopedProductId=prod.productId;
            snoopedBrandId=prod.brandId;
            snoopedProductName=prod.productname;
            snoopedProductImageURL=[NSURL URLWithString:prod.productImage];
            snoopedBrandImageURL=[NSURL URLWithString:prod.brandimage];
            snoopedProductPrice=prod.price;
            snoopedProductDescription=prod.productDescription;
            snoopedBrandName=prod.brandname;
            snoopedSnachId=prod.snachId;
            
            
            [_snoopBtn setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];//greyscale
            [_productNameLbl setTitle:[NSString stringWithFormat:@"%@",prod.productname] forState:UIControlStateNormal];
            _followStatus.imageView.contentMode=UIViewContentModeScaleAspectFit;
            _productNameLbl.titleLabel.numberOfLines = 1;
            _productNameLbl.titleLabel.adjustsFontSizeToFitWidth = YES;
            _productNameLbl.titleLabel.minimumScaleFactor=0.62;
            _productPriceLbl.titleLabel.adjustsFontSizeToFitWidth=YES;  //adjusting button font
            _productPriceLbl.titleLabel.minimumScaleFactor=0.67;
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
            [numberFormatter setCurrencyCode:@"USD"];
            NSDictionary *strikeThroughAttribute = [NSDictionary dictionaryWithObject:strikeSize
                                                                               forKey:NSStrikethroughStyleAttributeName];
            NSAttributedString* strikeThroughText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Retail: %@",[numberFormatter stringFromNumber:[NSNumber numberWithDouble:[prod.price doubleValue]]]] attributes:strikeThroughAttribute];
            [_productPriceLbl setAttributedTitle:strikeThroughText forState:UIControlStateNormal];
            if(prod.status==0 || prod.status==1)
                 [_followStatus setEnabled:YES];
            if(![_productNameLbl.titleLabel.text isEqual:@""] && _productNameLbl.titleLabel.text!=nil  && ![_productPriceLbl.titleLabel.text isEqual:@""]&& _productPriceLbl.titleLabel.text!=nil  && ![snoopedSnachId isEqual:@""] && snoopedSnachId!=nil && prod.status)
            {
                [_snoopBtn setEnabled:YES];
                [_followStatus setEnabled:YES];
                [_productImg setImageWithURL:[NSURL URLWithString:prod.productImage] placeholderImage:nil];
                [_snoopBtn setBackgroundColor:[UIColor colorWithRed:0.62 green:0.10 blue:0.47 alpha:1.0]];//purple color
            }
            else{
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                    NSData *imgData= [NSData dataWithContentsOfURL:[NSURL URLWithString:prod.productImage]];
                    if (imgData) {
                        
                        dispatch_sync(dispatch_get_main_queue(), ^(void) {
                            UIImage *image =[UIImage imageWithData:imgData];
                            if (image) {
                                
                                _productImg.image = [self convertImageToGrayScale:image];
                            }
                        });
                    }});
            }
            NSError *error;
            dictionaryForEmails=[Common getDictionaryForFriendCount:snoopedProductId SnachId:snoopedSnachId EmailId:user.emailID];
            //NSLog(@"dictionaryForEmails:%@",dictionaryForEmails);
            if(dictionaryForEmails!=nil){
                
                friendCountJson = [NSJSONSerialization dataWithJSONObject:dictionaryForEmails options:NSJSONWritingPrettyPrinted error:&error];
                // NSLog(@"DIctionary %@",dictionaryForEmails);
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@getFriendsCount/",ec2maschineIP]]];
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[friendCountJson length]] forHTTPHeaderField:@"Content-Length"];
                [request setHTTPBody:friendCountJson];
                
                
                error = [[NSError alloc] init];
                @try{
                if(prod.friendCount==nil)
                    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                        if(!error)
                        {
                            dictionaryForFriendsCountResponse =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
                            
                            if([[dictionaryForFriendsCountResponse valueForKey:@"success"] isEqual:@"true"])
                            {
                                //NSLog(@"Friend count RESPONSE :%@",dictionaryForFriendsCountResponse);
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
                }@catch(NSException *e){}

            }}@catch(NSException *e){ [global showAllertMsg:@"Alert" Message:@"Something happened wrong"];}
        
        
    }
    
    
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    @try{
    switch (self.tabSelect.selectedSegmentIndex)
    {
        case 0:
            cellId=FRIEND_CELL;
            [_subTabSelect setHidden:YES];
            [_lastLine setHidden:YES];
            yfortable=320;
            [self viewDidLayoutSubviews];
             [_tableView reloadData];
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:0 animated:YES];
           
            break;
        case 1:
            cellId=BRAND_CELL;
            [_subTabSelect setHidden:YES];
            [_lastLine setHidden:YES];
             yfortable=320;
              [self viewDidLayoutSubviews];
             [_tableView reloadData];
             [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:0 animated:YES];
            
            break;
        case 2:
            cellId=SNACH_CELL;
            [_subTabSelect setHidden:NO];
            [_lastLine setHidden:NO];
             yfortable=354;
            [self viewDidLayoutSubviews];
            [_tableView reloadData];
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:0 animated:YES];
            break;
    }
    }
    @catch(NSException *e){}
}



- (IBAction)subTabIndexChanged:(id)sender {
   
    switch (self.subTabSelect.selectedSegmentIndex)
    {
        case 0:
            subCellId=HISTORY_ALL;
            
            [_tableView reloadData];
            break;
        case 1:
            subCellId=HISTORY_INFLIGHT;
            [_tableView reloadData];
            break;
        case 2:
            subCellId=HISTORY_DELIVERED;

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
                              sharedInstance]initWithProductId:snoopedProductId withBrandId:snoopedBrandId withSnachId:snoopedSnachId withProductName:snoopedProductName withBrandName:snoopedBrandName withProductImageURL:snoopedProductImageURL withBrandImageURL:snoopedBrandImageURL withProductPrice:snoopedProductPrice withProductDescription:snoopedProductDescription withProductSalesTax:snoopedSalesTax withProductShippingCost:snoopedShippingCost withProductShippingSpeed:snoopedSpeed];
    snooptTracking=1;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SnatchFeed *rootViewController = [storyboard instantiateViewControllerWithIdentifier:SNACHFEED];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [navController setViewControllers: @[rootViewController] animated: YES];
    
    [self.revealViewController pushFrontViewController:navController animated:YES];
    
    
}




-(void)followButtonClicked:(UITapGestureRecognizer*)tapRecongnizer
{
    if([global isConnected]){
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
    
}

//this function will return all the friends and their snachs
- (void)getLatestFriendsSnachs
{
    if([global isConnected]){
        NSError *err = [[NSError alloc] init];
        dictionaryForEmails=[Common getEmailDictionary:user.emailID];
        if(dictionaryForEmails!=nil){
            
            friendCountJson = [NSJSONSerialization dataWithJSONObject:dictionaryForEmails options:NSJSONWritingPrettyPrinted error:&err];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@get-friend-snach-list/",ec2maschineIP]]];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[friendCountJson length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody:friendCountJson];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                
                if (!error) {
                    NSArray *latestFriendSnachs = [self makeRequest:data];
                    friendsSnachs = [NSMutableArray arrayWithCapacity:10];
                    
                    if (latestFriendSnachs) {
                        for (NSDictionary *tempDic in latestFriendSnachs) {
                            FriendSnachs *fSnachs = [[FriendSnachs alloc] init];
                            fSnachs.friendName=[tempDic objectForKey:FRIEND_NAME];
                            fSnachs.freindProfilePic=[tempDic objectForKey:FRIEND_IMAGE];
                            NSArray *latestFriendSnachs2 = [tempDic objectForKey:FRIEND_SNACHS];
                            snachs = [NSMutableArray arrayWithCapacity:10];
                            if (latestFriendSnachs2)
                            {
                                for (NSDictionary *tempSnachDic in latestFriendSnachs2) {
                                    Products *snached= [[Products alloc] init];
                                    snached.snachId=[NSString stringWithFormat:@"%@",[tempSnachDic objectForKey:PRODUCTS_SNACHID]];
                                    snached.productImage=[tempSnachDic objectForKey:PRODUCTS_IMAGE];
                                    snached.snachStatus=[[tempSnachDic objectForKey:PRODUCTS_SNACHSTATUS] intValue];
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
    }
    
}

//this function will return all brands and their running snachs
- (void)getLatestFollowedBrandsProducts
{
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@get-users-followed-brands/?customerId=%@",ec2maschineIP,user.userID]]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (!error) {
            NSArray *latestFollowedBrands = [self makeRequest:data];
            followedBrand = [NSMutableArray arrayWithCapacity:10];
            
            if (latestFollowedBrands) {
                for (NSDictionary *tempDic in latestFollowedBrands) {
                    Brand *fBrand = [[Brand alloc] init];
                    fBrand.brandId=[tempDic objectForKey:BRAND_BRANDID];
                    fBrand.brandName=[tempDic objectForKey:BRAND_BRANDNAME];
                    fBrand.brandImg=[tempDic objectForKey:BRAND_BRANDIMAGE];
                    NSArray *latestFriendSnachs2 = [tempDic objectForKey:BRAND_BRANDPRODUCTS];
                    brandProducts = [NSMutableArray arrayWithCapacity:10];
                    if (latestFriendSnachs2)
                    {
                        for (NSDictionary *tempFollowDic in latestFriendSnachs2) {
                            Products *followed= [[Products alloc] init];
                            followed.productId=[tempFollowDic objectForKey:PRODUCTS_ID];
                            followed.snachId=[NSString stringWithFormat:@"%@",[tempFollowDic objectForKey:PRODUCTS_SNACHID] ];
                            followed.productImage=[tempFollowDic objectForKey:PRODUCTS_IMAGE];
                            followed.snachStatus=1;
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

//this function will return all snached snachs
- (void)getMYLatestSnachs
{
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@get-user-snach-history/?customerId=%@",ec2maschineIP,user.userID]]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (!error) {
            NSDictionary *latestSnachs = [self makeHistoryRequest:data];
            myLetestALLSnachs = [NSMutableArray arrayWithCapacity:10];
            myLetestDELSnachs = [NSMutableArray arrayWithCapacity:10];
            myLetestINFSnachs = [NSMutableArray arrayWithCapacity:10];
            if (latestSnachs) {
                
                
                
                for (NSDictionary *tempDic in [latestSnachs objectForKey:@"data"]) {
                    SnachHistory *snachhistory = [[SnachHistory alloc] init];
                    snachhistory.productName=[tempDic objectForKey:HISTORY_PRODUCT_NAME];
                    snachhistory.productBrandName=[tempDic objectForKey:HISTORY_PRODUCT_BRAND_NAME];
                    snachhistory.productImageUrl=[tempDic objectForKey:HISTORY_PRODUCT_IMAGE];
                    snachhistory.productOrderedDate=[tempDic objectForKey:HISTORY_PRODUCT_ORDERDATE];
                    snachhistory.productDeliveryDate=[tempDic objectForKey:HISTORY_PRODUCT_DELIVERYDATE];
                    snachhistory.productstatus=[tempDic objectForKey:HISTORY_PRODUCT_STATUS];
                    snachhistory.trackingNo=[tempDic objectForKey:HISTORY_TRACKING_NO];
                    snachhistory.slug=[tempDic objectForKey:HISTORY_SLUG];
                    if([[tempDic valueForKey:HISTORY_PRODUCT_STATUS] isEqual:HISTORY_INFLIGHT])
                    {snachhistory.statusIcon=@"inflightIcon.png"; [myLetestINFSnachs addObject:snachhistory];}
                    else if([[tempDic valueForKey:HISTORY_PRODUCT_STATUS] isEqual:HISTORY_DELIVERED])
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
   
    if (error != nil) {
        NSLog(@"Error: %@", error.description);
        return nil;
    }
    
    NSDictionary *latestFriendSnachs = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error: &error];
    
    
    return [latestFriendSnachs objectForKey:@"data"];
}
-(NSDictionary*)makeHistoryRequest:(NSData *)response{
    NSError *error = nil;
    
    if (error != nil) {
        NSLog(@"Error: %@", error.description);
        return nil;
    }
    
    NSDictionary *latestFriendSnachs = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error: &error];
   
    return latestFriendSnachs;
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
        NSLog(@"Response: %@",response);
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
                prod.status= [[prodDic objectForKey:PRODUCT_SNACH_STATUS] intValue];
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
    if([global isConnected]){
        UnfollowButton *tap = (UnfollowButton *)tapRecognizer;
        UIButton *button= (UIButton*)tap.view;
        button.backgroundColor =[UIColor colorWithRed:0.337 green:0.337 blue:0.333 alpha:1];
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
    
    
}


- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIImage *newImage=nil;
    @try{
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
     newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    }
    @catch(NSException *e){}
    // Return the new grayscale image
    return newImage;
}

-(void)viewDidDisappear:(BOOL)animated{
    
    snoopedProductId=nil;
    snoopedSnachId=nil;
    snoopedBrandId=nil;
    snoopedProductImageURL=nil;
    snoopedBrandImageURL=nil;
    snoopedProductName=nil;
    snoopedProductBrandName=nil;
    snoopedProductPrice=nil;
    snoopedProductDescription=nil;
    snoopedBrandName=nil;
    snoopedSalesTax=nil;
    snoopedShippingCost=nil;
    snoopedSpeed=nil;
    dictionaryForEmails=nil;
    //self.defaultbackImg=nil;
    self.profilePic=nil;
    dictionaryForFriendsCountResponse=nil;
    
    friendCountJson=nil;
    [friendsSnachs removeAllObjects];
    [brandProducts removeAllObjects];
    [myLetestALLSnachs removeAllObjects];
    [myLetestDELSnachs removeAllObjects];
    [myLetestINFSnachs removeAllObjects];
    [super viewDidDisappear:YES];
}


@end
