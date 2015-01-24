//
//  PaymentOverview.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/22/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "PaymentOverview.h"
#import "AddNewCardForm.h"
#import "SnachCheckDetails.h"

NSString *const STPSEAGUE=@"backtoSTP";
@interface PaymentOverview()

@end

@implementation PaymentOverview


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
- (IBAction)addNewCardBtn:(id)sender{
    [self performSegueWithIdentifier:@"addNewCardSeague" sender:self];
    
}
- (IBAction)doneBtn:(id)sender {
    [self performSegueWithIdentifier:STPSEAGUE sender:self];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addNewCardSeague"]) {
        
        AddNewCardForm *destViewController = segue.destinationViewController;
        destViewController.productname = productname;
        destViewController.productimgname=productimgname;
        destViewController.productprice =productprice;
        destViewController.brandimgname = brandimgname;
    }
    if ([segue.identifier isEqualToString:STPSEAGUE]) {
        
        SnachCheckDetails *destViewController = segue.destinationViewController;
        destViewController.prodName = productname;
        destViewController.prodImgName=productimgname;
        destViewController.prodPrice =productprice;
        destViewController.brandImgName = brandimgname;
    }
    
}


@end
