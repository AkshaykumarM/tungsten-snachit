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
#import "RegexValidator.h"


NSString *const BACKTOPAYMENT_OVERVIEW_SEAGUE=@"backtoPaymentOverview";

@interface AddNewCardForm()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong) DBManager *dbManager;
@property (strong,nonatomic) NSArray *states;
@property (strong,nonatomic) NSArray *statesAbv;
@end

@implementation AddNewCardForm{
    SnoopedProduct *product;
    UIPickerView *statePicker,*datePicker;
    NSDateComponents *currentDateComponents;
    CGFloat viewSize;
    CGFloat viewCenter;
    NSMutableArray *monthsArray,*yearsArray;
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
    [self initializePickers];

}

-(void)viewDidAppear:(BOOL)animated{
    [self initializeView];
    viewSize=self.view.frame.size.width;
    viewCenter=self.view.center.x-50;
    [self setupAlerts];
}
-(void)viewWillAppear:(BOOL)animated{
   
    
}
-(void)initializePickers{
    statePicker = [[UIPickerView alloc] init];
    statePicker.dataSource = self;
    statePicker.delegate = self;
    statePicker.backgroundColor=[UIColor whiteColor];
    
    currentDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    //Array for picker view
    monthsArray=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",nil];
    yearsArray=[[NSMutableArray alloc]init];
    
    
    for (int i=15; i<30; i++)
    {
        [yearsArray addObject:[NSString stringWithFormat:@"20%d",+i]];
    }
    
    datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    datePicker.delegate = self;
    statePicker.backgroundColor=[UIColor whiteColor];
    
    [datePicker selectRow:[currentDateComponents month]-1 inComponent:0 animated:YES];
    
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"states-info" ofType:@"plist"]];
    
    self.states = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"icons"]];
    self.statesAbv = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"Abb"]];
    statePicker.tag=1;
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
    //[self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    btn.imageEdgeInsets=UIEdgeInsetsMake(5,5,4,5);
    UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = eng_btn;
    
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
    
    //setting keyboardtypes
    self.cardNumber.keyboardType=UIKeyboardTypeNumberPad;
    self.expDateTxtField.keyboardType=UIKeyboardTypeNumberPad;
    self.cvvTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.zipTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.streetTextField.keyboardType=UIKeyboardTypeAlphabet;
    self.cityTextField.keyboardType=UIKeyboardTypeAlphabet;

    
    [self.cardNumber addTarget:self action:@selector(detectCardType) forControlEvents:UIControlEventEditingChanged];

    self.stateTextField.inputView=statePicker;
    self.expDateTxtField.inputView=datePicker;
    self.expDateTxtField.inputView.backgroundColor=[UIColor whiteColor];
    [self.cardNumber setText:cardNumber];
    [self.expDateTxtField setText:cardExp];
    [self.cvvTextField setText:cardCVV];
    //adding action to camera icon
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraIconAction)];
    singleTap.numberOfTapsRequired = 1;
    [self.cameraBtn setUserInteractionEnabled:YES];
    [self.cameraBtn  addGestureRecognizer:singleTap];
    
}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)detectCardType{
    
    NSString *number=[self.cardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSPredicate* visa = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VISA];
    NSPredicate* mastercard = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MASTERCARD];
    NSPredicate* dinnersclub = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", DINNERSCLUB];
    NSPredicate* discover = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", DISCOVER];
    NSPredicate* amex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", AMEX];
    
    if ([visa evaluateWithObject:number])
    {
        self.cardtypeImageView.image=[UIImage imageNamed:@"visa.png"];
    }
    else if ([mastercard evaluateWithObject:number])
    {
        self.cardtypeImageView.image=[UIImage imageNamed:@"mastercard.png"];
    }
    else if ([dinnersclub evaluateWithObject:number])
    {
       self.cardtypeImageView.image=[UIImage imageNamed:@"dinersclub.png"];
    }
    else if ([discover evaluateWithObject:number])
    {
        self.cardtypeImageView.image=[UIImage imageNamed:@"discover.png"];
    }
    else if ([amex evaluateWithObject:number])
    {
        self.cardtypeImageView.image=[UIImage imageNamed:@"amex.png"];
    }
    else{
        self.cardtypeImageView.image=nil;
    }
}
- (IBAction)doneBtn:(id)sender {
    if([self.cardNumber validate]&[self.expDateTxtField validate]&[self.cvvTextField validate]&[self.fullNameTextField validate] &[self.streetTextField validate]& [self.stateTextField validate]&[self.cityTextField validate]&[self.stateTextField validate]&[self.zipTextField validate]&[self.phoneTextField validate]){
        NSString *query = [NSString stringWithFormat:@"insert into payment values(null, '%@', '%@', '%@' ,'%@','%@','%@','%@','%@','%@','%@')",[global getCardType:[self.cardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""] ],self.cardNumber.text,self.expDateTxtField.text,self.cvvTextField.text, self.fullNameTextField.text, self.streetTextField.text, self.cityTextField.text,self.stateTextField.text,self.zipTextField.text,self.phoneTextField.text];
        
        // Execute the query.
        
        [self.dbManager executeQuery:query];
        
        // If the query was successfully executed then pop the view controller.
        if (self.dbManager.affectedRows != 0) {
         
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            RECENTLY_ADDED_PAYMENT_INFO_TRACKER=(int)self.dbManager.lastInsertedRowID;
            // Pop the view controller.
            [self performSegueWithIdentifier:BACKTOPAYMENT_OVERVIEW_SEAGUE sender:self];

        }
        else{
            RECENTLY_ADDED_PAYMENT_INFO_TRACKER=0;
            NSLog(@"Could not execute the query.");
        }
    }
    

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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if(![touch.view isMemberOfClass:[UITextField class]]) {
        [touch.view endEditing:YES];
    }
}


#pragma mark - Credit card Number Field Formatting


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.cardNumber) {
        
        // Only the 16 digits + 3 spaces
        if (range.location == 19) {
            return NO;
        }
        
        // Backspace
        if ([string length] == 0)
            return YES;
        
        if ((range.location == 4) || (range.location == 9) || (range.location == 14))
        {
            
            
            textField.text   = [NSString stringWithFormat:@"%@ ",textField.text];
        }
        
        return YES;
    }
    
    if(textField==self.cvvTextField){
        if (range.location == 4) {
            return NO;
        }
        return YES;
    }
    if (textField==self.phoneTextField) {
        if (range.location == 10) {
            return NO;
        }
        return YES;

    }
    
    return YES;
}

//setting picker view to select states

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView.tag==1)
        return self.states.count;
    else{
    NSInteger rowsInComponent;
    if (component==0)
    {
        rowsInComponent=[monthsArray count];
    }
    else
    {
        rowsInComponent=[yearsArray count];
    }
    return rowsInComponent;
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if(pickerView.tag==1)
        return  1;
    else
        return 2;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(pickerView.tag==1)
    return self.states[row];
    else
        return 0;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(pickerView.tag==1){
    self.stateTextField.text = self.statesAbv[row];
   
    }
    else{
        if ([pickerView selectedRowInComponent:0]+1<=[currentDateComponents month] && [[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]] intValue]==[currentDateComponents year])
        {
            [pickerView selectRow:[currentDateComponents month] inComponent:0 animated:YES];
            
           
        }
        else{
            if([pickerView selectedRowInComponent:0]+1<10){
                self.expDateTxtField.text=[NSString stringWithFormat:@"0%d/%@",[pickerView selectedRowInComponent:0]+1,[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]]];
                [self.expDateTxtField resignFirstResponder];
            }
            else{
                self.expDateTxtField.text=[NSString stringWithFormat:@"%d/%@",[pickerView selectedRowInComponent:0]+1,[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]]];
                [self.expDateTxtField resignFirstResponder];
            }
            
        }
        
        if (component==1)
        {
            
            [pickerView reloadComponent:0];
        }

    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if(pickerView.tag==1){
        UILabel *statenamelbl = [[UILabel alloc] initWithFrame:CGRectMake(viewCenter+20, 0, 180, 32)];
        statenamelbl.text = [self.states objectAtIndex:row];
        
        statenamelbl.backgroundColor = [UIColor clearColor];
        
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize, 32)] ;
        
        [tmpView insertSubview:statenamelbl atIndex:0];
        
        [tmpView setUserInteractionEnabled:NO];
        
        return tmpView;
    }
    else{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
        
        
        label.text = component==0?[monthsArray objectAtIndex:row]:[yearsArray objectAtIndex:row];
        
        if (component==0)
        {
            if (row+1<[currentDateComponents month] && [[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]] intValue]==[currentDateComponents year])
            {
                label.textColor = [UIColor grayColor];
            }
        }
        return label;
        
    }
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat componentWidth ;
    if(pickerView.tag!=1){
   
    
    if (component==0)
    {
        componentWidth = 100;
    }
    else  {
        componentWidth = 100;
    }
    }
    return componentWidth;
    
}
/*ends here*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window) {
        self.view = nil;
    }
    NSLog(@"Recieved memmory warning in addnewcard");
    // Do additional cleanup if necessary
}
- (void)viewDidUnload {
    [super viewDidUnload];
    if (self.isViewLoaded && !self.view.window) {
        self.view = nil;
    }
    // Do additional cleanup if necessary
}

-(void)setupAlerts{
    [self.cardNumber addRegx:REGEX_CREDIT_CARD_NO withMsg:@"Please enter valid card no"];
    [self.expDateTxtField addRegx:REGEX_EXPDATE withMsg:@"Please enter valid cvv"];
    [self.cvvTextField addRegx:REGEX_CVV withMsg:@"Please enter valid cvv"];
    [self.fullNameTextField addRegx:REGEX_USERNAME withMsg:@"Please enter valid name"];
    [self.cityTextField addRegx:REGEX_USERNAME withMsg:@"Please enter valid city"];
    [self.zipTextField addRegx:REGEX_ZIP_CODE withMsg:@"Please enter valid zip code"];
    [self.phoneTextField addRegx:REGEX_PHONE_DEFAULT withMsg:@"Please enter valid phone no"];
    self.cardNumber.isMandatory=YES;
    self.expDateTxtField.isMandatory=YES;
    self.cvvTextField.isMandatory=YES;
    self.fullNameTextField.validateOnResign=YES;
    self.streetTextField.isMandatory=YES;
    self.cityTextField.isMandatory=YES;
    self.stateTextField.isMandatory=YES;
    self.zipTextField.isMandatory=YES;
    self.phoneTextField.isMandatory=YES;
}
@end
