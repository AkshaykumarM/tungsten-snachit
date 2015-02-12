//
//  AddNewCardForm.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/22/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "AddNewCardForm.h"
#import "PaymentOverview.h"
#import "SnoopedProduct.h"
#import "DBManager.h"
#import "global.h"
NSString *const BACKTOPAYMENT_OVERVIEW_SEAGUE=@"backtoPaymentOverview";

@interface AddNewCardForm()
@property (nonatomic,strong) DBManager *dbManager;
@end

@implementation AddNewCardForm{
    SnoopedProduct *product;
}
@synthesize brandImg,productImg,productNameLbl,productPriceBtn,productDesc;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"snachit.sql"];
    // Set the Label text with the selected recipe
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self initializeView];
}
-(void)viewWillAppear:(BOOL)animated{
   
    
}
-(void)initializeView{
    
    product=[SnoopedProduct sharedInstance];
    productNameLbl.text = [NSString stringWithFormat:@"%@ %@",product.brandName,product.productName ];
    brandImg.image=[UIImage imageWithData:product.brandImageData];
    productImg.image=[UIImage imageWithData:product.productImageData];
    [productPriceBtn setTitle: product.productPrice forState: UIControlStateNormal];
    productDesc.text=product.productDescription;
    
}

-(NSString*)getCardType:(NSString*)number{
    NSString *type;
    NSPredicate* visa = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VISA];
    NSPredicate* mastercard = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MASTERCARD];
    NSPredicate* dinnersclub = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", DINNERSCLUB];
    NSPredicate* discover = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", DISCOVER];
    NSPredicate* amex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", AMEX];
    
    if ([visa evaluateWithObject:number])
    {
        type=@"Visa";
    }
    else if ([mastercard evaluateWithObject:number])
    {
        type=@"Mastercard";
    }
    else if ([dinnersclub evaluateWithObject:number])
    {
        type=@"Diners Club";
    }
    else if ([discover evaluateWithObject:number])
    {
        type=@"Discover";
    }
    else if ([amex evaluateWithObject:number])
    {
        type=@"American Express";
    }
    else{
        type=@"none";
    }
    return type;
}


- (IBAction)doneBtn:(id)sender {
    if([self.cardNumber hasText]&&[self.expDateTxtField hasText]&&[self.cvvTextField hasText]&&[self.fullNameTextField hasText] &&[self.streetTextField hasText]&& [self.stateTextField hasText]&&[self.cityTextField hasText]&&[self.stateTextField hasText]&&[self.zipTextField hasText]&&[self.phoneTextField hasText]){
        NSString *query = [NSString stringWithFormat:@"insert into payment values(null, '%@', '%@', '%@' ,'%@','%@','%@','%@','%@','%@','%@')",[self getCardType:self.cardNumber.text],self.cardNumber.text,self.expDateTxtField.text,self.cvvTextField.text, self.fullNameTextField.text, self.streetTextField.text, self.cityTextField.text,self.stateTextField.text,self.zipTextField.text,self.phoneTextField.text];
        
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

    [self performSegueWithIdentifier:BACKTOPAYMENT_OVERVIEW_SEAGUE sender:self];
}






@end
