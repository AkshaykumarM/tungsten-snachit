//
//  ScanCard.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/26/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "ScanCard.h"
#import "CardIO.h"
int cloaseStatus;
@interface ScanCard () <CardIOPaymentViewControllerDelegate>


@end
@implementation ScanCard

-(void)viewDidLoad{
    [super viewDidLoad];
    cloaseStatus=0;
    }

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(cloaseStatus==0){
    [CardIOUtilities preload];
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:scanViewController animated:YES completion:nil];
    }
    else{
         [self dismissViewControllerAnimated:true completion:nil];
    }
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:YES completion:nil];
     cloaseStatus=1;
    NSLog(@"%@",[NSString stringWithFormat:@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.redactedCardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv]);
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    cloaseStatus=1;

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeBtn:(id)sender {
       [self dismissViewControllerAnimated:true completion:nil];
}

@end
