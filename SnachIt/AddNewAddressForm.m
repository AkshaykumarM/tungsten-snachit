//
//  AddNewAddressForm.m
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/19/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "AddNewAddressForm.h"
#import "ShippingOverview.h"
#import "SnachItDB.h"
#import "SnoopedProduct.h"
#import "global.h"
#import "RegexValidator.h"
#import "UserProfile.h"
#import "AddressDetails.h"
#define ADDRESS_ADDED @"addressaddedseague"
@interface AddNewAddressForm()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>

@property (strong,nonatomic) NSArray *states;
@property (strong,nonatomic) NSArray *statesAbv;
@end

@implementation AddNewAddressForm{
    SnoopedProduct *product;
    CGFloat viewSize;
    CGFloat viewCenter;
    UIToolbar* toolbar;
    UserProfile *user;
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
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    picker.backgroundColor=[UIColor whiteColor];
    self.stateTextField.inputView = picker;
    screenName=@"ada";
    user=[UserProfile sharedInstance];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"states-info" ofType:@"plist"]];
   
    self.states = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"icons"]];
    self.statesAbv = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"Abb"]];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self initializeView];
    viewSize=self.view.frame.size.width;
    viewCenter=self.view.center.x-50;
    if(self.recordIDToEdit!=-1){
        AddressDetails *info=[[SnachItDB database] snachItAddressDetails:self.recordIDToEdit UserId:user.userID];
        
        self.fullNameTextField.text=info.name;
        self.streetAddressTextField.text=info.address;
        self.cityTextField.text=info.city;
        self.stateTextField.text=info.state;
        self.zipTextField.text=info.zip;
        self.phoneTextField.text=info.phoneNumber;
       
        
    }

    [self setupAlerts];
    CURRENTDB=SnachItDBFile;
    
}
-(void)doneClicked:(id)sender{
    [self.view endEditing:YES];
}
-(void)initializeView{
    
     self.navigationController.navigationBar.topItem.title = @"ship to";
    product=[SnoopedProduct sharedInstance];
    toolbar = [[UIToolbar alloc] init];
    toolbar.frame=CGRectMake(0,0,self.view.frame.size.width,44);
    toolbar.barStyle = UIBarStyleBlackTranslucent;

    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked:)];
    toolbar.barTintColor=[UIColor colorWithRed:0.8 green:0.816 blue:0.839 alpha:1];
    
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    productNameLbl.text = [NSString stringWithFormat:@"%@",product.productName ];
    brandImg.image=[UIImage imageWithData:product.brandImageData];
    productImg.image=[UIImage imageWithData:product.productImageData];
    [productPriceBtn setTitle: product.productPrice forState: UIControlStateNormal];
    [productDesc loadHTMLString:[NSString stringWithFormat:@"<html>\n""<head>\n""<style type=\"text/css\">\n"" body{ font-size:%@;font-family:'Open Sans';}\n""</style>\n""</head>\n""<body>%@</body>\n""</html>",[NSNumber numberWithInt:14],product.productDescription ] baseURL:nil];

    //hiding the backbutton from top bar
    //[self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:BACKARROW] forState:UIControlStateNormal];
    btn.imageEdgeInsets=UIEdgeInsetsMake(2,2,2,2);
    UIBarButtonItem *nav_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = nav_btn;
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
    self.fullNameTextField.keyboardType=UIKeyboardTypeAlphabet;
    self.zipTextField.inputAccessoryView=toolbar;
    self.phoneTextField.inputAccessoryView=toolbar;
    self.stateTextField.inputAccessoryView=toolbar;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect: self.subview.bounds];
    self.subview.layer.masksToBounds = NO;
    self.subview.layer.shadowColor = [UIColor blackColor].CGColor;
    self.subview.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);  /*Change value of X n Y as per your need of shadow to appear to like right bottom or left bottom or so on*/
    self.subview.layer.shadowOpacity = 0.8f;
    self.subview.layer.shadowRadius=2.5f;
    self.subview.layer.shadowPath = shadowPath.CGPath;
}
-(void)back:(id)sender{
        [self performSegueWithIdentifier:ADDRESS_ADDED sender:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
   }

- (IBAction)doneBtn:(id)sender {
    
    if([self.fullNameTextField validate] &[self.streetAddressTextField validate]& [self.stateTextField validate]&[self.cityTextField validate]&[self.stateTextField validate]&[self.zipTextField validate]&[self.phoneTextField validate]){
        
        
        NSDictionary *info;
        if(self.recordIDToEdit==-1){
        info=[[SnachItDB database] addAddress:self.fullNameTextField.text Street:self.streetAddressTextField.text City:self.cityTextField.text State:self.stateTextField.text Zip:self.zipTextField.text Phone:self.phoneTextField.text UserId:user.userID];
        }
        else{
            info=[[SnachItDB database] updateAddress:self.fullNameTextField.text Street:self.streetAddressTextField.text City:self.cityTextField.text State:self.stateTextField.text Zip:self.zipTextField.text Phone:self.phoneTextField.text UserId:user.userID RecordId:[NSString stringWithFormat:@"%d",self.recordIDToEdit]];
            
        }
    
    // Execute the query.
       

    
    // If the query was successfully executed then pop the view controller.
    if ([info objectForKey:@"status"] != 0) {
         if(self.recordIDToEdit==-1){
        RECENTLY_ADDED_SHIPPING_INFO_TRACKER=[[info objectForKey:@"lastrow"] intValue];
         }
         else{
              RECENTLY_ADDED_SHIPPING_INFO_TRACKER=self.lastCheckedRecord;
         }
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        [def setObject:[NSString stringWithFormat:@"%d",RECENTLY_ADDED_SHIPPING_INFO_TRACKER] forKey:[NSString stringWithFormat:@"%@%@",DEFAULT_SHIPPING,user.userID]];

        // Pop the view controller.
         [self performSegueWithIdentifier:ADDRESS_ADDED sender:self];
    }
    else{
        RECENTLY_ADDED_SHIPPING_INFO_TRACKER=-1;
    }
    }
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:textField.tag + 1];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==self.phoneTextField) {
        if (range.location == 10) {
            return NO;
        }
        return YES;
    }
    if (textField==self.zipTextField) {
        if (range.location == 5) {
            return NO;
        }
        return YES;
    }
    return YES;
}

/*ends here*/

-(void)setupAlerts{
    
    [self.fullNameTextField addRegx:REGEX_USERNAME withMsg:ERROR_USERNAME];
    [self.cityTextField addRegx:REGEX_USERNAME withMsg:ERROR_CITY];
    [self.zipTextField addRegx:REGEX_ZIP_CODE withMsg:ERROR_ZIPCODE];
    [self.phoneTextField addRegx:REGEX_PHONE_DEFAULT withMsg:ERROR_PHONE];
    [self.stateTextField addRegx:REGEX_STATE withMsg:ERROR_STATE];
    [self.streetAddressTextField addRegx:REGEX_ADDRESS withMsg:EROOR_ADDRESS];
    
    self.fullNameTextField.validateOnResign=YES;
    self.streetAddressTextField.isMandatory=YES;
    self.cityTextField.isMandatory=YES;
    self.stateTextField.isMandatory=YES;
    self.zipTextField.isMandatory=YES;
    self.phoneTextField.isMandatory=YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    self.productImg=nil;
    self.productDesc=nil;
    productDesc=nil;
    productNameLbl=nil;
    productDesc=nil;
    productImg=nil;
    brandImg=nil;
    self.productNameLbl=nil;
    self.productPriceBtn=nil;
    self.brandImg=nil;
    for(UIView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
    [super viewDidDisappear:YES];
}

@end
