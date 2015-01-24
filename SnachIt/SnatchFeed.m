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
@interface SnatchFeed()

@property(nonatomic,strong) NSArray *followimg;
@property(nonatomic,strong) NSArray *productslist;
@end


@interface ImageTapped : UITapGestureRecognizer

@property (nonatomic, strong) NSString * productName;
@property (nonatomic, strong) NSString * brandName;
@property (nonatomic, strong) NSData * brandImageData;
@property (nonatomic, strong) NSData * productImageData;
@property (nonatomic, strong) NSString * price;

@end

@implementation ImageTapped

@end
@implementation SnatchFeed
{
    NSInteger imageIndex;
    NSUInteger productrowIdentifier;
    NSString *snoopedProductName;
    NSData *snoopedProductImageData;
    NSString *snoopedProductBrandName;
    NSData *snoopedProductBrandImageData;
    NSString *snoopedProductPrice;
    UIImage *image3;
}

@synthesize followimg;

 - (void)viewDidLoad {
     
    [super viewDidLoad];
     [self makeProductRequest];
     
    
      followimg=[NSArray arrayWithObjects:@"star-5-24.png",@"star-5-24.png",@"star-5-24.png",@"star-5-24.png",@"star-5-24.png", @"star-5-24.png",nil];
     
     [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
         if (error) {
             // Handle error
         }
         
         else {
             userName = [[FBuser name] uppercaseString];
             userProfilePic = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [FBuser objectID]];
         }
     }];
   
     NSLog(@"User profile pic %@",userProfilePic);
     
       CGRect frameimg = CGRectMake(0, 0, 40, 40);
     UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
     someButton.layer.cornerRadius = someButton.bounds.size.width/2;
     someButton.layer.borderWidth = 2.0f;
     someButton.layer.borderColor = [[UIColor whiteColor] CGColor];
     [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
         [someButton setShowsTouchWhenHighlighted:YES];
     
     [someButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
     self.navigationItem.leftBarButtonItem=mailbutton;
     self.navigationItem.leftBarButtonItem.target=self.revealViewController;
     self.navigationItem.leftBarButtonItem.action=@selector(revealToggle:);
  
  }
-(void)viewDidAppear:(BOOL)animated{
    
    if(i==0){
    SnachitStartScreen *startscreen = [[SnachitStartScreen alloc]
                                  initWithNibName:@"StartScreen" bundle:nil];
    [self presentViewController:startscreen animated:YES completion:nil];
    }
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:userProfilePic]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        image3 = [UIImage imageWithData:data];
    }];
    i++;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier =@"snachproduct";
    SnatchFeedCell *cell = (SnatchFeedCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    //single product info
    NSDictionary *product=[self.productslist objectAtIndex:indexPath.row];
    NSArray *productImages=[product objectForKey:@"productImages"];
    NSString *name=[product objectForKey:@"productName"];
    NSString *brandname =[product objectForKey:@"brandName"];
    NSString *price =[product objectForKey:@"productPrice"];
    NSString *brandimage =[product objectForKey:@"brandImage"];
    NSString *productImage =[product objectForKey:@"productImage"];
    //setting up product image carousel
    cell.productImagesContainer.scrollEnabled = YES;
    int scrollWidth = 0;
    cell.productImagesContainer.backgroundColor=[UIColor whiteColor];
    int xOffset = 0;
   

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
    
    
    [cell.productName setTitle:[NSString stringWithFormat:@"%@ %@", brandname, name] forState:UIControlStateNormal];
    
    [cell.productPrice setTitle: price forState:UIControlStateNormal];
  
    
    [cell.followStatus addTarget:self action:@selector(followButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.snoop setTag:indexPath.row];
    ImageTapped *snoopTapped = [[ImageTapped alloc]
                                             initWithTarget:self
                                action:@selector(snoopButtonClicked:) ];
    [snoopTapped setNumberOfTapsRequired:1];
    cell.snoop.userInteractionEnabled = YES;
    snoopTapped.productName=name;
    snoopTapped.brandName=[NSString stringWithFormat:@"%@", brandname];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:brandimage]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        cell.brandImg.image =[UIImage imageWithData:data];
        snoopTapped.BrandImageData=data;
    }];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:productImage]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        snoopTapped.ProductImageData=data;
    }];
    snoopTapped.Price=price;
   
    
    [cell.snoop addGestureRecognizer:snoopTapped];
    
    // Setting the swipe direction.
    
    // Adding the swipe gesture on image view
    
    
      return cell;
}

//on snoop button clicked
-(void)snoopButtonClicked:(UITapGestureRecognizer *)tapRecognizer {
    
    
    ImageTapped *tap = (ImageTapped *)tapRecognizer;
    snoopedProductName=tap.productName;
    snoopedProductImageData=tap.productImageData;
    snoopedProductBrandImageData=tap.brandImageData;
    snoopedProductName=tap.brandName;
    snoopedProductPrice=tap.price;
    
    [self performSegueWithIdentifier:@"snoop" sender:self];
}

-(void)followButtonClicked:(id)sender
{
    NSLog(@"%@",@"Akshay");
}


- (IBAction)followStatus:(id)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"snoop"]) {
        
        SnachProductDetails *destViewController = segue.destinationViewController;
        destViewController.prodName = snoopedProductName;
        destViewController.prodPrice = snoopedProductPrice;
         destViewController.productImageData = snoopedProductImageData;
         destViewController.brandImageData = snoopedProductBrandImageData;
    }
}
-(void)makeProductRequest{
    NSData *jasonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://192.168.0.120/product.json"]];
      if (jasonData) {
        NSError *e = nil;
        self.productslist = [NSJSONSerialization JSONObjectWithData:jasonData options:NSJSONReadingMutableContainers error: &e];
    }    NSLog(@"Fetched data: %@",self.productslist);
}

@end
