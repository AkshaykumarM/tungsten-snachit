//
//  ShippingOverlay.m
//  SnachIt
//
//  Created by Jayesh Kitukale on 1/22/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "ShippingOverlay.h"
#import "shippingOverlayCell.h"
#import "OrderTotalOverview.h"
#import "SnoopedProduct.h"
NSString *const BACKTOORDEROVERVIEW=@"backToOrderOverview";
@interface ShippingOverlay()
@property (nonatomic,strong) NSArray *cellId;

@end

@implementation ShippingOverlay{
    SnoopedProduct *product;
}
@synthesize productImg,brandImg,productDesc,productNameLbl,productPriceBtn,cellId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellId = [NSArray arrayWithObjects: @"shippingCell",@"estDeliveryCell",@"speedCell", @"priceCell",nil];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self initializeView];
}
-(void)initializeView{
    
    product=[SnoopedProduct sharedInstance];
    productNameLbl.text = [NSString stringWithFormat:@"%@ %@",product.brandName,product.productName ];
    brandImg.image=[UIImage imageWithData:product.brandImageData];
    productImg.image=[UIImage imageWithData:product.productImageData];
    [productPriceBtn setTitle: product.productPrice forState: UIControlStateNormal];
    productDesc.text=product.productDescription;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *simpleTableIdentifier = [self.cellId objectAtIndex:indexPath.row];
    
    shippingOverlayCell *cell = (shippingOverlayCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    cell.estDeliveryLbl.text =@"2/2/015";
    cell.speedLbl.text=@"2 Day Delivery";
    cell.priceLbl.text=@"$0.0";
    return cell;
    
}


- (IBAction)doneBtn:(id)sender {
    [self performSegueWithIdentifier:BACKTOORDEROVERVIEW sender:self];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
   
    self.productImg=nil;
    self.brandImg=nil;
    productPriceBtn=nil;
    productNameLbl=nil;
    // Release any retained subviews of the main view.
}

@end
