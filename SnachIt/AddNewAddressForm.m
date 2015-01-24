//
//  AddNewAddressForm.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/19/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "AddNewAddressForm.h"
#import "ShippingOverview.h"
#import "DBManager.h"

@interface AddNewAddressForm()
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation AddNewAddressForm
@synthesize brandImg,productname,productImg,productimgname,productNameLbl,brandimgname,productPriceBtn,productprice;

- (void)viewDidLoad
{
    [super viewDidLoad];
    

      self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"snachit.sql"];
    productNameLbl.text = productname;
    brandImg.image=[UIImage imageNamed: brandimgname];
    productImg.image=[UIImage imageNamed: productimgname];
    [productPriceBtn setTitle: productprice forState:UIControlStateNormal];
    
}


- (IBAction)doneBtn:(id)sender {
    
    NSString *query = [NSString stringWithFormat:@"insert into addressInfo values(null, '%@', '%@', '%@' ,'%@','%@','%@')", self.fullNameTextField.text, self.streetAddressTextField.text, self.cityTextField.text,self.stateTextField.text,self.zipTextField.text,self.phoneTextField.text];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
 [self performSegueWithIdentifier:@"addressaddedseague" sender:self];
//    [self dismissViewControllerAnimated:true completion:nil];

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addressaddedseague"]) {
        
         ShippingOverview *destViewController = segue.destinationViewController;
        destViewController.productname = productname;
        destViewController.productimgname=productimgname;
        destViewController.productprice =productprice;
        destViewController.brandimgname = brandimgname;
    }
}





@end
