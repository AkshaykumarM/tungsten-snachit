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
#import "SnoopedProduct.h"

@interface AddNewAddressForm()
@property (nonatomic, strong) DBManager *dbManager;


@end

@implementation AddNewAddressForm{
    SnoopedProduct *product;
}
@synthesize brandImg,productImg,productNameLbl,productPriceBtn,productDesc;

- (void)viewDidLoad
{
    [super viewDidLoad];
    

      self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"snachit.sql"];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
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

- (IBAction)doneBtn:(id)sender {
    
    if([self.fullNameTextField hasText] &&[self.streetAddressTextField hasText]&& [self.stateTextField hasText]&&[self.cityTextField hasText]&&[self.stateTextField hasText]&&[self.zipTextField hasText]&&[self.phoneTextField hasText]){
        
       //NSString *query=@"create table if not exists address(id integer primary key,fullName text,streetAddress text,city text,state text,zip text,phone text)";
    NSString *query = [NSString stringWithFormat:@"insert into address values(null, '%@', '%@', '%@' ,'%@','%@','%@')", self.fullNameTextField.text, self.streetAddressTextField.text, self.cityTextField.text,self.stateTextField.text,self.zipTextField.text,self.phoneTextField.text];
    
    // Execute the query.
       
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Pop the view controller.
        
    }
    else{
        NSLog(@"Could not execute the query.");
    }
    }
 [self performSegueWithIdentifier:@"addressaddedseague" sender:self];
//    [self dismissViewControllerAnimated:true completion:nil];
    
}





@end
