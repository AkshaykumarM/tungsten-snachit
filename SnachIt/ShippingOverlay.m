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
#import "Order.h"
NSString *const BACKTOORDEROVERVIEW=@"backToOrderOverview";
@interface ShippingOverlay()
@property (nonatomic,strong) NSArray *cellId;

@end

@implementation ShippingOverlay{
    SnoopedProduct *product;
    Order *order;
}
@synthesize productImg,brandImg,productDesc,productNameLbl,productPriceBtn,cellId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellId = [NSArray arrayWithObjects: @"shippingCell",@"estDeliveryCell",@"speedCell", @"priceCell",nil];
    
    order=[Order sharedInstance];
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
    
    cell.estDeliveryLbl.text =order.deliveryDate;
    cell.speedLbl.text=[NSString stringWithFormat:@"%@ day delivery",order.speed];
    cell.priceLbl.text=[NSString stringWithFormat:@"$%@",order.shippingCost];
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
