//
//  ScanCard.m
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/26/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "ScanCard.h"
#import "CardIO.h"
#import "global.h"
int cloaseStatus;
@interface ScanCard () <CardIOPaymentViewControllerDelegate>


@end
@implementation ScanCard

-(void)viewDidLoad{
    [super viewDidLoad];
    cloaseStatus=0;
    cardNumber=@"";
    cardExp=@"";
    cardCVV=@"";
    
    }

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(cloaseStatus==0){
    [CardIOUtilities preload];
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
        scanViewController.hideCardIOLogo=true;
        
         scanViewController.view.frame = self.scanView.bounds;
    [self.scanView addSubview:scanViewController.view];
    [self addChildViewController:scanViewController];
    [scanViewController didMoveToParentViewController:self];
    
    }
    else{
         [self dismissViewControllerAnimated:true completion:nil];
    }
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:YES completion:nil];
     cloaseStatus=1;
    
    cardNumber=[NSString stringWithFormat:@"%@",info.cardNumber];
    cardExp=[NSString stringWithFormat:@"%02lu/%lu",(unsigned long)info.expiryMonth,(unsigned long)info.expiryYear];
    cardCVV=[NSString stringWithFormat:@"%@",info.cvv];
    
    
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    
    cardNumber=@"";
    cardExp=@"";
    cardCVV=@"";

    cloaseStatus=1;

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeBtn:(id)sender {
    cardNumber=@"";
    cardExp=@"";
    cardCVV=@"";
    [self dismissViewControllerAnimated:true completion:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    for(UIView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
    [super viewDidDisappear:YES];
    
}
@end
