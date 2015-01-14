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
@interface MyProfile ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong) NSArray *options,*profileimg,*productimg,*statusimg,*brandimg,*followimg,*productName,*brandName,*productPrice;

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;
@property (strong, nonatomic) UIImage *myImage;
@property (nonatomic, strong) NSString * tappedProductImage;
@property (nonatomic, strong) NSString * tappedProductName;
@property (nonatomic, strong) NSString * tappedProductPrice;
@end

@interface customTapGestureRecognizer : UITapGestureRecognizer

@property (nonatomic, strong) NSString * productImage;
@property (nonatomic, strong) NSString * productName;
@property (nonatomic, strong) NSString * productPrice;

@end

@implementation customTapGestureRecognizer

@end

@implementation MyProfile

{
    NSString *cellId,*subCellId;
    
}

@synthesize tabSelect=_tabSelect;
@synthesize subTabSelect=_subTabSelect;
@synthesize options,menuItems,profileimg,productimg,statusimg,brandimg,followimg,brandName,productName,productPrice;
UIView* backView ;
- (void)viewDidLoad {
    [super viewDidLoad];
//    _sidebarButton.target = self.revealViewController;
//    _sidebarButton.action = @selector(revealToggle:);
//    
//    // Set the gesture
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.profilePic.layer.cornerRadius= self.profilePic.frame.size.width/1.96;
    
    
    self.profilePic.clipsToBounds = YES;
    self.profilePic.layer.borderWidth = 5.0f;
    self.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    
    cellId=@"friendsCell";
    subCellId=@"all";
    options = [NSArray arrayWithObjects:@"Diana Remirez", @"Aishwarya Kulkarni",@"Pooja Prajapati",@"Darshana Alone",@"Ankita Lahoti",@"Bhudevi Deshpande", nil];
    profileimg= [NSArray arrayWithObjects:@"userIcon.png",@"userIcon.png",@"userIcon.png",@"userIcon.png",@"userIcon.png",@"userIcon.png",nil];
    productimg=[NSArray arrayWithObjects:@"staked-cup.png",@"product.png",@"mixer.png",@"staked-cup.png",@"staked-cup.png",@"staked-cup.png", nil];
    statusimg=[NSArray arrayWithObjects:@"inflightIcon.png",@"deliveredIcon.png",@"deliveredIcon.png",@"deliveredIcon.png",@"deliveredIcon.png",@"inflightIcon.png", nil];
    menuItems = [NSArray arrayWithObjects: @"myaccount", @"accountsetting", @"billing", @"shipping", @"snatchhistory",nil];
    brandimg=[NSArray arrayWithObjects:@"outer-box.png",@"nike.png",@"outer-box.png",@"nike.png",@"nike.png", @"outer-box.png",nil];
    brandName = [NSArray arrayWithObjects:@"Breville", @"Mikasa",@"Nike",@"Outer-Box",@"Breville", @"Mikasa", nil];

    productName=[NSArray arrayWithObjects:@"Stainless steel blender",@"3.25 Quart pitcher",@"Stainless steel blender",@"3.25 Quart pitcher",@"Stainless steel blender",@"3.25 Quart pitcher", nil];
    followimg=[NSArray arrayWithObjects:@"star-5-24.png",@"star-5-24.png",@"star-5-24.png",@"star-5-24.png",@"star-5-24.png", @"star-5-24.png",nil];
    productPrice=[NSArray arrayWithObjects:@"$129.99",@"$60.99",@"$129.99",@"$60.99",@"$129.99",@"$60.99", nil];
     [_subTabSelect setHidden:YES];//hiding the sub tab
    [_lastLine setHidden:YES];
    self.myImage = [UIImage imageNamed:@"profile.png"];
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
    return [options count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier =cellId;
    
    if([cellId isEqual:@"friendsCell"]){
   
    MyProfileFreindsCell *cell = (MyProfileFreindsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    cell.friendPic.image = [UIImage imageNamed:[profileimg objectAtIndex:indexPath.row]];
    cell.friendName.text = [options objectAtIndex:indexPath.row];
    
      cell.friendPic.layer.cornerRadius= cell.friendPic.frame.size.width/1.96;
        

    cell.friendPic.clipsToBounds = YES;
    cell.friendPic.layer.borderWidth = 5.0f;
    cell.friendPic.layer.borderColor = [UIColor whiteColor].CGColor;
        
   
    cell.scrollview.scrollEnabled = YES;
    int scrollWidth = 100;
            
        cell.scrollview.backgroundColor=[UIColor whiteColor];
        
        
        
        
        int xOffset = 0;
        
        for(int index=0; index < [productimg count]; index++)
        {
            //[aButton addTarget:self action:@selector(whatever:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset,10,70, 70)];
            [img setContentMode:UIViewContentModeScaleAspectFit];
            [img setImage: [UIImage imageNamed:[NSString stringWithFormat:@"%@", productimg[index]]]];
             customTapGestureRecognizer *customTap = [[customTapGestureRecognizer alloc]
                                                 initWithTarget:self
                                                   action:@selector(myAction:) ];
            [customTap setNumberOfTapsRequired:1];
            img.userInteractionEnabled = YES;
            customTap.productImage=productimg[index];
            customTap.productName=[NSString stringWithFormat:@"%@ %@", brandName[index], productName[index]];
            customTap.productPrice=productPrice[index];
            [img addGestureRecognizer:customTap];
          
            
            [cell.scrollview addSubview:img];
            xOffset+=70;
            
        }
        cell.scrollview.contentSize = CGSizeMake(scrollWidth+xOffset,70);
        
          return cell;
    }

    
    if([cellId isEqual:@"brandsCell"]){
        MyProfileBrandsCell *cell = (MyProfileBrandsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        
        
        cell.brandName.image = [UIImage imageNamed:[brandimg objectAtIndex:indexPath.row]];
        cell.productImg.image = [UIImage imageNamed:[productimg objectAtIndex:indexPath.row]];
        
        cell.followStatus.image = [UIImage imageNamed:[followimg objectAtIndex:indexPath.row]];
        
        return cell;
    }
    if([cellId isEqual:@"snachsCell"])
    {
        MyProfileSnachsCell *cell = (MyProfileSnachsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        
        
        cell.productImg.image = [UIImage imageNamed:[productimg objectAtIndex:indexPath.row]];
        cell.productName.text = [options objectAtIndex:indexPath.row];
        
        cell.orderDate.text = [options objectAtIndex:indexPath.row];
        cell.deliveryDate.text=[options objectAtIndex:indexPath.row];
        cell.statusImg.image=[UIImage imageNamed:[statusimg objectAtIndex:indexPath.row]];
        return cell;
    }


    else{
    return 0;
    }
}
-(void)myAction:(UITapGestureRecognizer *)tapRecognizer {
   
    
    customTapGestureRecognizer *tap = (customTapGestureRecognizer *)tapRecognizer;
 
    backView = [[UIView alloc] initWithFrame:self.view.frame];
    backView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:backView];

    _freindsPopupView=[[[NSBundle mainBundle] loadNibNamed:@"ProfileFreindsPopup" owner:self options:nil]objectAtIndex:0];
    _freindsPopupView.frame=CGRectMake(self.view.frame.size.width-285, self.view.frame.size.height/3.0f, 250, 250);
    _productImg.image=[UIImage imageNamed:tap.productImage];
    [_productNameLbl setTitle:tap.productName forState:UIControlStateNormal];
    [_productPriceLbl setTitle:tap.productPrice forState:UIControlStateNormal];
    [self setCurrentProductData:tap.productImage productName:tap.productName productPrice:tap.productPrice];
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
    switch (self.tabSelect.selectedSegmentIndex)
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
    NSLog(@"Akshay");
    SnachProductDetails *tempView = [[SnachProductDetails alloc] init];
    tempView.prodImgName=self.tappedProductImage;
    tempView.prodName=self.tappedProductName;
    tempView.prodPrice=self.tappedProductPrice;
    
}

- (IBAction)barButtonItem:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SnatchFeed *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"snachfeed"];

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [navController setViewControllers: @[rootViewController] animated: YES];
    
    [self.revealViewController pushFrontViewController:navController animated:YES];
    
}
@end
