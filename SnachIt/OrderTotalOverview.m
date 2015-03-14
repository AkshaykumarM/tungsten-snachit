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
     self.navigationController.navigationBar.topItem.title = @"order total";
    product=[SnoopedProduct sharedInstance];
    productNameLbl.text = [NSString stringWithFormat:@"%@ %@",product.brandName,product.productName ];
    brandImg.image=[UIImage imageWithData:product.brandImageData];
     productImg.image=[UIImage imageWithData:product.productImageData];
    [productPriceBtn setTitle: product.productPrice forState: UIControlStateNormal];
    productDesc.text=product.productDescription;
    
    totalLabel.text=[NSString stringWithFormat:@"$%.2f",[self getOrderTotal]];
    
    //hiding the backbutton from top bar
    [self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *simpleTableIdentifier = [self.cellId objectAtIndex:indexPath.row];
    
    OrderTotalCell *cell = (OrderTotalCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    cell.subtotalLabel.text = [NSString stringWithFormat:@"$%.2f",[order.subTotal floatValue]];
    
    //checking whether shipping cost is zero if zero "Free shipping" msg will be shown
    if([order.shippingCost floatValue]<=0){
    cell.shippingAndhandlingLabel.text=order.freeshipping;
    }
    else{
        cell.shippingAndhandlingLabel.text=[NSString stringWithFormat:@"$%.2f",[order.shippingCost floatValue]];
    }
    cell.salesTaxLabel.text=[NSString stringWithFormat:@"$%.2f",[order.salesTax floatValue]];

    //adding single tap gesture recognizer for
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shippingAndHandling)];
    singleTap.numberOfTapsRequired = 1;
    [cell.shippingandHandling setUserInteractionEnabled:YES];
    [cell.shippingandHandling  addGestureRecognizer:singleTap];
    return cell;
    
}
-(float)getOrderTotal{
  
    return  [order.subTotal floatValue]+[order.shippingCost floatValue]+[order.salesTax floatValue];;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //hiding the last cell separator
    if (cell && indexPath.row == 3 && indexPath.section == 0) {
        
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.0f);
    }
}


- (IBAction)doneBtn:(id)sender {
    [self performSegueWithIdentifier:BACKSTPSEAGUE sender:self];
}

-(void)shippingAndHandling{
    [self performSegueWithIdentifier:SHIPPINGANDHANDLING sender:self];
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
