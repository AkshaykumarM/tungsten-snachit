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

@property(nonatomic,strong) NSArray *brandName,*profileimg,*productimg,*statusimg,*brandimg,*followimg,*productName,*productPrice;

@end

@implementation SnatchFeed
{
    NSInteger imageIndex;
    NSUInteger productrowIdentifier;
}

@synthesize brandName,productimg,statusimg,brandimg,followimg,productName,productPrice;

 - (void)viewDidLoad {
     
    [super viewDidLoad];
    
     UIImage *image = [UIImage imageNamed:@"profile.png"];
     CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
     
     UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
     //[button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
     [button setImage:image forState:UIControlStateNormal];
     
     _sidebarButton= [[UIBarButtonItem alloc] initWithCustomView:button];
     
        // Set the side bar button action. When it's tapped, it'll show up the sidebar.
     
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
     
     
    brandName = [NSArray arrayWithObjects:@"Breville", @"Mikasa",@"Nike",@"Outer-Box",@"Breville", @"Mikasa", nil];
      productimg=[NSArray arrayWithObjects:@"product.png",@"product2.png",@"mixer.png",@"staked-cup.png",@"staked-cup.png",@"mixer.png", nil];
    statusimg=[NSArray arrayWithObjects:@"helicopter-24.png",@"empty-flag-24.png",@"empty-flag-24.png",@"empty-flag-24.png",@"empty-flag-24.png",@"helicopter-24.png", nil];
    
    brandimg=[NSArray arrayWithObjects:@"breviele.png",@"mikasa.png",@"nike.png",@"outer-box.png",@"breviele.png",@"mikasa.png",nil];
    followimg=[NSArray arrayWithObjects:@"star-5-24.png",@"star-5-24.png",@"star-5-24.png",@"star-5-24.png",@"star-5-24.png", @"star-5-24.png",nil];
    productName=[NSArray arrayWithObjects:@"Stainless steel blender",@"3.25 Quart pitcher",@"Stainless steel blender",@"3.25 Quart pitcher",@"Stainless steel blender",@"3.25 Quart pitcher", nil];
    productPrice=[NSArray arrayWithObjects:@"$129.99",@"$60.99",@"$129.99",@"$60.99",@"$129.99",@"$60.99", nil];

     
     [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
         if (error) {
             // Handle error
         }
         
         else {
             userName = [[FBuser name] uppercaseString];
             userProfilePic = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [FBuser objectID]];
         }
     }];
     
  }
-(void)viewDidAppear:(BOOL)animated{
    
    if(i==0){
    SnachitStartScreen *startscreen = [[SnachitStartScreen alloc]
                                  initWithNibName:@"StartScreen" bundle:nil];
    [self presentViewController:startscreen animated:YES completion:nil];
    }
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
    return [brandName count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 265;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier =@"snachproduct";
    SnatchFeedCell *cell = (SnatchFeedCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    cell.brandImg.image = [UIImage imageNamed:[brandimg objectAtIndex:indexPath.row]];
    cell.productImg.image= [UIImage imageNamed:[productimg objectAtIndex:indexPath.row]];
   
    [cell.productName setTitle:[NSString stringWithFormat:@"%@ %@", [brandName objectAtIndex:indexPath.row], [productName objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    [cell.productPrice setTitle:[productPrice objectAtIndex:indexPath.row] forState:UIControlStateNormal];
  
    
    [cell.followStatus addTarget:self action:@selector(followButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.snoop setTag:indexPath.row];
    [cell.snoop addTarget:self action:@selector(snoopButtonClicked:event:) forControlEvents:UIControlEventTouchUpInside];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandle:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandle:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
   
    // Adding the swipe gesture on image view
    [cell.productImg addGestureRecognizer:swipeLeft];
    [cell.productImg addGestureRecognizer:swipeRight];
    imageIndex=[productimg count];
    
    
      return cell;
}
- (void)swipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    
    UIImageView *selectedImageView=(UIImageView*)[gestureRecognizer view];
   
    
    UISwipeGestureRecognizerDirection direction=[(UISwipeGestureRecognizer *)gestureRecognizer direction];
    
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            imageIndex--;
            break;
            
        case UISwipeGestureRecognizerDirectionRight:
            imageIndex++;
            break;
        default:
            break;
    }
    imageIndex=(imageIndex<0)?([productimg count]-1) :imageIndex%[productimg count];
    selectedImageView.image=[UIImage imageNamed:[productimg objectAtIndex:imageIndex]];
    
    
}
//on snoop button clicked
-(void)snoopButtonClicked:(UIButton*)button event:(UIEvent*)event
{
    NSIndexPath *indexPath=[_tableView indexPathForRowAtPoint:[[[event touchesForView:button]anyObject]locationInView:_tableView]];
    NSLog(@"%d",indexPath.row);
    productrowIdentifier=(int)indexPath.row;
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
        destViewController.prodName = [productName objectAtIndex:(int)productrowIdentifier];
        destViewController.prodPrice = [productPrice objectAtIndex:(int)productrowIdentifier];
         destViewController.prodImgName = [productimg objectAtIndex:(int)productrowIdentifier];
         destViewController.brandImgName = [brandimg objectAtIndex:(int)productrowIdentifier];
        
    }
}

@end
