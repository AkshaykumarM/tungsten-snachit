//
//  OrderTotalOverview.m
//  SnachIt
//
//  Created by Jayesh Kitukale on 12/31/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "OrderTotalOverview.h"
#import "OrderTotalCell.h"
#import "SnachCheckDetails.h"
#import "ShippingOverlay.h"
#import "SnoopedProduct.h"
#import "Order.h"
NSString *const BACKSTPSEAGUE=@"backtoSTPSeague";
NSString *const SHIPPINGANDHANDLING=@"shippingAndHandlingSegue";

@interface OrderTotalOverview()
@property (nonatomic,strong) NSArray *cellId;


@end

@implementation OrderTotalOverview{
    SnoopedProduct *product;
    Order *order;
    
}
@synthesize brandImg,productImg,productNameLbl,productPriceBtn,cellId,productDesc,totalLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellId = [NSArray arrayWithObjects: @"orderTotalCell",@"subtotalCell", @"shippingCell", @"salesTaxCell",nil];
    // Set the Label text with the selected recipe
    order=[Order sharedInstance];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self initializeView];
}

-(void)initializeView{
    
    product=[SnoopedProduct sharedInstance];
    productNameLbl.text = [NSString stringWithFormat:@"%@ %@",product.brandName,product.productName ];
    brandImg.image=[UIImage imageWithData:product.brandImageData];
    productImg.image=[UIImage imageWithData:product.productImageData];
    [productPriceBtn setTitle: product.productPrice forState: UIControlStateNormal];
    productDesc.text=product.productDescription;
    
    totalLabel.text=[NSString stringWithFormat:@"$%@",order.orderTotal];
    
  
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *simpleTableIdentifier = [self.cellId objectAtIndex:indexPath.row];
    
    OrderTotalCell *cell = (OrderTotalCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    cell.subtotalLabel.text = [NSString stringWithFormat:@"$%@",order.subTotal];
    cell.shippingAndhandlingLabel.text=order.shippingAndHandling;
    cell.salesTaxLabel.text=[NSString stringWithFormat:@"$%@",order.salesTax];
    return cell;
    
}


- (IBAction)doneBtn:(id)sender {
    [self performSegueWithIdentifier:BACKSTPSEAGUE sender:self];
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
