//
//  AddNewCardForm.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/22/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "AddNewCardForm.h"
#import "PaymentOverview.h"

NSString *const BACKTOPAYMENT_OVERVIEW_SEAGUE=@"backtoPaymentOverview";

@interface AddNewCardForm()

@end

@implementation AddNewCardForm
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

- (IBAction)doneBtn:(id)sender {
    [self performSegueWithIdentifier:BACKTOPAYMENT_OVERVIEW_SEAGUE sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:BACKTOPAYMENT_OVERVIEW_SEAGUE]) {
        
        PaymentOverview *destViewController = segue.destinationViewController;
        destViewController.productname = productname;
        destViewController.productimgname=productimgname;
        destViewController.productprice =productprice;
        destViewController.brandimgname = brandimgname;
        
        
    }
}


@end
