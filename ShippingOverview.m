//
//  ShippingOverview.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/19/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "ShippingOverview.h"
#import "AddNewAddressForm.h"
#import "SnachCheckDetails.h"

@interface ShippingOverview()

@end

@implementation ShippingOverview
@synthesize brandImg,productname,productImg,productimgname,productNameLbl,brandimgname,productPriceBtn,productprice;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the Label text with the selected recipe
    productNameLbl.text = productname;
    
    brandImg.image=[UIImage imageNamed: brandimgname];
    productImg.image=[UIImage imageNamed: productimgname];
    [productPriceBtn setTitle: productprice forState:UIControlStateNormal];
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    
  
    return cell;
}



//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
//   
//    //cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"check-mark.png"]];
//    
//    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//}
//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//
//   // cell.accessoryView= nil;
//    
//  }
- (IBAction)addNewAddressbtn:(id)sender {
    [self performSegueWithIdentifier:@"addnewaddressseague" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addnewaddressseague"]) {
        
        AddNewAddressForm *destViewController = segue.destinationViewController;
        destViewController.productname = productname;
        destViewController.productimgname=productimgname;
        destViewController.productprice =productprice;
        destViewController.brandimgname = brandimgname;
    }
    if ([segue.identifier isEqualToString:@"shippingoverviewseague"]) {
        
        SnachCheckDetails *destViewController = segue.destinationViewController;
        destViewController.prodName = productname;
        destViewController.prodImgName=productimgname;
        destViewController.prodPrice =productprice;
        destViewController.brandImgName = brandimgname;
    }
    
}
- (IBAction)doneBtn:(id)sender {
    
    [self performSegueWithIdentifier:@"shippingoverviewseague" sender:self];

}


@end
