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
NSString *const BACKSTPSEAGUE=@"backtoSTPSeague";
@interface OrderTotalOverview()
@property (nonatomic,strong) NSArray *cellId;

@end

@implementation OrderTotalOverview
@synthesize brandImg,productname,productImg,productimgname,productNameLbl,brandimgname,productPriceBtn,productprice,cellId,totalLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellId = [NSArray arrayWithObjects: @"orderTotalCell",@"subtotalCell", @"shippingCell", @"salesTaxCell",nil];
    // Set the Label text with the selected recipe
    productNameLbl.text = productname;
    
    brandImg.image=[UIImage imageNamed: brandimgname];
    productImg.image=[UIImage imageNamed: productimgname];
    [productPriceBtn setTitle: productprice forState:UIControlStateNormal];
    totalLabel.text=[NSString stringWithFormat:@"%@",productprice];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *simpleTableIdentifier = [self.cellId objectAtIndex:indexPath.row];
    
    OrderTotalCell *cell = (OrderTotalCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    cell.subtotalLabel.text = [NSString stringWithFormat:@"%@",productprice];
    cell.shippingAndhandlingLabel.text=@"Free Shipping";
    cell.salesTaxLabel.text=@"$0.0";
    return cell;
    
}


- (IBAction)doneBtn:(id)sender {
    [self performSegueWithIdentifier:BACKSTPSEAGUE sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:BACKSTPSEAGUE]) {
        
        SnachCheckDetails *destViewController = segue.destinationViewController;
        destViewController.prodName = productname;
        destViewController.prodImgName=productimgname;
        destViewController.prodPrice =productprice;
        destViewController.brandImgName = brandimgname;
        
        
    }
}


@end
