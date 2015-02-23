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
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
CGFloat animatedDistance;
- (void)viewDidLoad
{
    [super viewDidLoad];
    cardNumber=@"";
    cardExp=@"";
    cardCVV=@"";
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"snachit.sql"];
    // Set the Label text with the selected recipe
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self initializeView];
}
-(void)viewWillAppear:(BOOL)animated{
   
    
}
-(void)initializeView{
    self.navigationController.navigationBar.topItem.title = @"snach details";
    product=[SnoopedProduct sharedInstance];
    productNameLbl.text = [NSString stringWithFormat:@"%@ %@",product.brandName,product.productName ];
    brandImg.image=[UIImage imageWithData:product.brandImageData];
    productImg.image=[UIImage imageWithData:product.productImageData];
    [productPriceBtn setTitle: product.productPrice forState: UIControlStateNormal];
    productDesc.text=product.productDescription;
    //hiding the backbutton from top bar
    [self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
    
    //seting textfield look and feel
    [global setTextFieldInsets:self.cardNumber];
    [global setTextFieldInsets:self.expDateTxtField];
    [global setTextFieldInsets:self.cvvTextField];
    [global setTextFieldInsets:self.fullNameTextField];
    [global setTextFieldInsets:self.streetTextField];
    [global setTextFieldInsets:self.cityTextField];
    [global setTextFieldInsets:self.stateTextField];
    [global setTextFieldInsets:self.zipTextField];
    [global setTextFieldInsets:self.phoneTextField];
    
    [self.cardNumber setText:cardNumber];
    [self.expDateTxtField setText:cardExp];
    [self.cvvTextField setText:cardCVV];
    //adding action to camera icon
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraIconAction)];
    singleTap.numberOfTapsRequired = 1;
    [self.cameraBtn setUserInteractionEnabled:YES];
    [self.cameraBtn  addGestureRecognizer:singleTap];
    
}



- (IBAction)doneBtn:(id)sender {
    if([self.cardNumber hasText]&&[self.expDateTxtField hasText]&&[self.cvvTextField hasText]&&[self.fullNameTextField hasText] &&[self.streetTextField hasText]&& [self.stateTextField hasText]&&[self.cityTextField hasText]&&[self.stateTextField hasText]&&[self.zipTextField hasText]&&[self.phoneTextField hasText]){
        NSString *query = [NSString stringWithFormat:@"insert into payment values(null, '%@', '%@', '%@' ,'%@','%@','%@','%@','%@','%@','%@')",[global getCardType:self.cardNumber.text],self.cardNumber.text,self.expDateTxtField.text,self.cvvTextField.text, self.fullNameTextField.text, self.streetTextField.text, self.cityTextField.text,self.stateTextField.text,self.zipTextField.text,self.phoneTextField.text];
        
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



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField){
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textfield{
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(void)cameraIconAction{
    [self performSegueWithIdentifier:@"scanCard" sender:nil];
}

@end
