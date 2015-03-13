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
#import "global.h"
#import "RegexValidator.h"


@interface AddNewAddressForm()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) DBManager *dbManager;

@property (strong,nonatomic) NSArray *states;
@property (strong,nonatomic) NSArray *statesAbv;
@end

@implementation AddNewAddressForm{
    SnoopedProduct *product;
    CGFloat viewSize;
    CGFloat viewCenter;

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
    

      self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"snachit.sql"];
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    picker.backgroundColor=[UIColor whiteColor];
    self.stateTextField.inputView = picker;
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"states-info" ofType:@"plist"]];
   
    self.states = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"icons"]];
    self.statesAbv = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"Abb"]];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self initializeView];
    viewSize=self.view.frame.size.width;
    viewCenter=self.view.center.x-50;
    [self setupAlerts];
}
-(void)initializeView{
     self.navigationController.navigationBar.topItem.title = @"ship to";
    product=[SnoopedProduct sharedInstance];
    productNameLbl.text = [NSString stringWithFormat:@"%@ %@",product.brandName,product.productName ];
    brandImg.image=[UIImage imageWithData:product.brandImageData];
    productImg.image=[UIImage imageWithData:product.productImageData];
    [productPriceBtn setTitle: product.productPrice forState: UIControlStateNormal];
    productDesc.text=product.productDescription;
    //hiding the backbutton from top bar
    //[self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
    
    //set textfield look and fill
    [global setTextFieldInsets:self.fullNameTextField];
    [global setTextFieldInsets:self.streetAddressTextField];
    [global setTextFieldInsets:self.cityTextField];
    [global setTextFieldInsets:self.stateTextField];
    [global setTextFieldInsets:self.zipTextField];
    [global setTextFieldInsets:self.phoneTextField];

    self.zipTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.streetAddressTextField.keyboardType=UIKeyboardTypeAlphabet;
    self.cityTextField.keyboardType=UIKeyboardTypeAlphabet;
}


-(void)viewWillAppear:(BOOL)animated{
   }

- (IBAction)doneBtn:(id)sender {
    
    if([self.fullNameTextField validate] &[self.streetAddressTextField validate]& [self.stateTextField validate]&[self.cityTextField validate]&[self.stateTextField validate]&[self.zipTextField validate]&[self.phoneTextField validate]){
        
       //NSString *query=@"create table if not exists address(id integer primary key,fullName text,streetAddress text,city text,state text,zip text,phone text)";
    NSString *query = [NSString stringWithFormat:@"insert into address values(null, '%@', '%@', '%@' ,'%@','%@','%@')", self.fullNameTextField.text, self.streetAddressTextField.text, self.cityTextField.text,self.stateTextField.text,self.zipTextField.text,self.phoneTextField.text];
    
    // Execute the query.
       
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        
      
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        RECENTLY_ADDED_SHIPPING_INFO_TRACKER=(int)self.dbManager.lastInsertedRowID;
        // Pop the view controller.
         [self performSegueWithIdentifier:@"addressaddedseague" sender:self];
    }
    else{
        NSLog(@"Could not execute the query.");
        RECENTLY_ADDED_SHIPPING_INFO_TRACKER=-1;
    }
    }
    
    
//    [self dismissViewControllerAnimated:true completion:nil];
    
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if(![touch.view isMemberOfClass:[UITextField class]]) {
        [touch.view endEditing:YES];
    }
}


//setting picker view to select states

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.states.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.states[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.stateTextField.text = self.statesAbv[row];
   
}


/*ends here*/

-(void)setupAlerts{
    
    [self.fullNameTextField addRegx:REGEX_USERNAME withMsg:@"Please enter valid name"];
    [self.cityTextField addRegx:REGEX_USERNAME withMsg:@"Please enter valid city"];
    [self.zipTextField addRegx:REGEX_ZIP_CODE withMsg:@"Please enter valid zip code"];
    [self.phoneTextField addRegx:REGEX_PHONE_DEFAULT withMsg:@"Please enter valid phone no"];
    self.fullNameTextField.validateOnResign=YES;
    self.streetAddressTextField.isMandatory=YES;
    self.cityTextField.isMandatory=YES;
    self.stateTextField.isMandatory=YES;
    self.zipTextField.isMandatory=YES;
    self.phoneTextField.isMandatory=YES;
}



@end
