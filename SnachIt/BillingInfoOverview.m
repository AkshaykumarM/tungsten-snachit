//
//  BillingInfoOverview.m
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/27/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "BillingInfoOverview.h"
#import "UserProfile.h"
#import "BillingInfoScanCell.h"
#import "global.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "RegexValidator.h"
#import "SnachItDB.h"
@interface BillingInfoOverview()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>

;
@property (strong,nonatomic) NSArray *states;
@property (strong,nonatomic) NSArray *statesAbv;

@end
@implementation BillingInfoOverview{
    UserProfile *user;
    NSDate *now ;
    NSDateFormatter *formatter;
    UIPickerView *statePicker,*datePicker;
    CGFloat viewSize;
    NSDateComponents *currentDateComponents;
    NSMutableArray *monthsArray,*yearsArray;


}

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
CGFloat animatedDistance;

- (void)viewDidLoad {
    [super viewDidLoad];
     
    cardNumber=@"";
    cardExp=@"";
    cardCVV=@"";
    now = [NSDate date];
    formatter = [[NSDateFormatter alloc] init];
    [self initializePickers];
    [self setViewLookAndFeel];
    
}

-(void)setViewLookAndFeel{
     self.navigationController.navigationBar.topItem.title = @"billing information";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [btn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    btn.imageEdgeInsets=UIEdgeInsetsMake(5,5,4,5);
    UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = eng_btn;
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    user=[UserProfile sharedInstance];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.tableView reloadData];
    viewSize=self.view.frame.size.width;
    CURRENTDB=SnachItDBFile;
    [self setupAlerts];
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
    
    
    for (NSUInteger i=currentDateComponents.year; i<=currentDateComponents.year+25; i++)
    {
        [yearsArray addObject:[NSString stringWithFormat:@"%lu",(unsigned long)+i]];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField){
        [textField resignFirstResponder];
        
    }
    return NO;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 710;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BillingInfoScanCell *cell = (BillingInfoScanCell *)[tableView dequeueReusableCellWithIdentifier:@"billingInfoScanCell" forIndexPath:indexPath];
    cell.profilePicImg.layer.cornerRadius=RADIOUS;
    cell.profilePicImg.clipsToBounds=YES;
    cell.profilePicImg.layer.borderWidth=BORDERWIDTH;
    cell.profilePicImg.layer.borderColor=[UIColor whiteColor].CGColor;
    if(![user.fullName isKindOfClass:[NSNull class]])
        cell.fullnameLbl.text=[[NSString stringWithFormat:@"%@",user.fullName] uppercaseString];
    
    cell.memberSinceLbl.text=[NSString stringWithFormat:@"Member since %@",[user.joiningDate substringFromIndex:[user.joiningDate length]-4]];
    
    
    [cell.profilePicImg setImageWithURL:user.profilePicUrl placeholderImage:[UIImage imageNamed:@"userIcon.png"]];
    [cell.cardNumberTextField addTarget:self action:@selector(detectCardType) forControlEvents:UIControlEventEditingChanged];
    cell.fullnameLbl.adjustsFontSizeToFitWidth=YES;
    cell.fullnameLbl.minimumScaleFactor=0.5;
    cell.stateTextField.inputView=statePicker;
   
    cell.expDateTextField.inputView=datePicker;
    cell.expDateTextField.inputView.backgroundColor= [UIColor whiteColor];
     
    [global setTextFieldInsets:cell.cardNumberTextField];
    [global setTextFieldInsets:cell.cardHolderNameTextField];
    [global setTextFieldInsets:cell.securityCodeText];
    [global setTextFieldInsets:cell.stateTextField];
    [global setTextFieldInsets:cell.cityTextField];
    [global setTextFieldInsets:cell.addressTextField];
    [global setTextFieldInsets:cell.expDateTextField];
    [global setTextFieldInsets:cell.phoneTextField];
    [global setTextFieldInsets:cell.postalCodeTextField];
    
    
    cell.cardNumberTextField.keyboardType=UIKeyboardTypeNumberPad;
    cell.expDateTextField.keyboardType=UIKeyboardTypeNumberPad;
    cell.securityCodeText.keyboardType=UIKeyboardTypeNumberPad;
    cell.postalCodeTextField.keyboardType=UIKeyboardTypeNumberPad;
    cell.phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    cell.addressTextField.keyboardType=UIKeyboardTypeAlphabet;
    cell.cityTextField.keyboardType=UIKeyboardTypeAlphabet;
    cell.cardHolderNameTextField.keyboardType=UIKeyboardTypeAlphabet;
    [cell.cardNumberTextField setText:cardNumber];
    [cell.expDateTextField setText:cardExp];
    [cell.securityCodeText setText:cardCVV];
    
  
    //setting background img
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if([defaults valueForKey:DEFAULT_BACK_IMG])
        cell.defBackImg.image=[UIImage imageWithData:[defaults valueForKey:DEFAULT_BACK_IMG]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self.tableView superview] endEditing:YES];
}

-(void)detectCardType{
   
    BillingInfoScanCell *tableCell = (BillingInfoScanCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *number=[tableCell.cardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSPredicate* visa = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VISA];
     NSPredicate* mastercard = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MASTERCARD];
     NSPredicate* dinnersclub = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", DINNERSCLUB];
     NSPredicate* discover = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", DISCOVER];
     NSPredicate* amex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", AMEX];
    
    if ([visa evaluateWithObject:number])
    {
        tableCell.cardTypeImg.image=[UIImage imageNamed:@"visa.png"];
    }
    else if ([mastercard evaluateWithObject:number])
    {
        tableCell.cardTypeImg.image=[UIImage imageNamed:@"mastercard.png"];
    }
    else if ([dinnersclub evaluateWithObject:number])
    {
        tableCell.cardTypeImg.image=[UIImage imageNamed:@"dinersclub.png"];
    }
    else if ([discover evaluateWithObject:number])
    {
        tableCell.cardTypeImg.image=[UIImage imageNamed:@"discover.png"];
    }
    else if ([amex evaluateWithObject:number])
    {
        tableCell.cardTypeImg.image=[UIImage imageNamed:@"amex.png"];
    }
    else{
        tableCell.cardTypeImg.image=nil;
    }
}

-(NSString*)processString :(NSString*)yourString
{
    if(yourString == nil){
        return @"";
    }
    int stringLength = (int)[yourString length];
    // the string you want to process
    int len = 4;  // the length
    NSMutableString *str = [NSMutableString string];
    int i = 0;
    for (; i < stringLength; i+=len) {
        @try{
        NSRange range = NSMakeRange(i, len);
        [str appendString:[yourString substringWithRange:range]];
        if(i!=stringLength -4){
            [str appendString:@" "]; //If required stringshould be in format XXXX-XXXX-XXXX-XXX then just replace [str appendString:@"-"]
        }}
        @catch(NSException *e){}
    }
    if (i < [str length]-1) {  // add remain part
        [str appendString:[yourString substringFromIndex:i]];
    }
    // str now is what your want
    
    return str;
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


- (void)backBtn {
    [self.view resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveBtn:(id)sender {
    
    BillingInfoScanCell *cell = (BillingInfoScanCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if([cell.cardNumberTextField validate]&[cell.expDateTextField validate]&[cell.securityCodeText validate]&[cell.cardHolderNameTextField validate] &[cell.addressTextField validate]& [cell.stateTextField validate]&[cell.cityTextField validate]&[cell.stateTextField validate]&[cell.postalCodeTextField validate]&[cell.phoneTextField validate]){
        
         // Execute the query.
        NSDictionary *info=[[SnachItDB database] addPayment:[global getCardType:[cell.cardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]] CardNumber:cell.cardNumberTextField.text CardExpDate:cell.expDateTextField.text CardCVV:cell.securityCodeText.text Name:cell.cardHolderNameTextField.text Street:cell.addressTextField.text City:cell.cityTextField.text State:cell.stateTextField.text Zip:cell.postalCodeTextField.text Phone:cell.phoneTextField.text];
                            
        
    
        
        // If the query was successfully executed then pop the view controller.
        if ([info valueForKey:@"status"]!= 0) {
            
            //this is to track recently added 
            RECENTLY_ADDED_PAYMENT_INFO_TRACKER=[[info valueForKey:@"lastrow"] intValue];
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            [def setObject:[NSString stringWithFormat:@"%d",RECENTLY_ADDED_PAYMENT_INFO_TRACKER] forKey:DEFAULT_BILLING];
            // Pop the view controller.
            [self.view resignFirstResponder];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            RECENTLY_ADDED_PAYMENT_INFO_TRACKER=-1;
            NSLog(@"Could not execute the query.");
        }
    }
    

}


//this function will end editing by dissmissing keyboard if user touches outside the textfields
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


#pragma mark - Credit card Number Field Formatting


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    @try{
    BillingInfoScanCell  *cell = (BillingInfoScanCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (textField == cell.cardNumberTextField) {
        
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
    
    if(textField==cell.securityCodeText){
        if (range.location == 4) {
            return NO;
        }
        return YES;
    }
    if (textField==cell.phoneTextField) {
        if (range.location == 10) {
            return NO;
        }
        return YES;
    }
}@catch(NSException *e){
    
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
        return self.statesAbv[row];
    else
        return 0;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    BillingInfoScanCell *cell = (BillingInfoScanCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if(pickerView.tag==1){
    
    cell.stateTextField.text = self.statesAbv[row];
    
}
    else{
    if ([pickerView selectedRowInComponent:0]+1<=[currentDateComponents month] && [[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]] intValue]==[currentDateComponents year])
    {
        [pickerView selectRow:[currentDateComponents month] inComponent:0 animated:YES];
        
        
    }
    else{
        if([pickerView selectedRowInComponent:0]+1<10){
            cell.expDateTextField.text=[NSString stringWithFormat:@"0%d/%@",[pickerView selectedRowInComponent:0]+1,[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]]];
            [cell.expDateTextField resignFirstResponder];
        }
        else{
            cell.expDateTextField.text=[NSString stringWithFormat:@"%d/%@",[pickerView selectedRowInComponent:0]+1,[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]]];
            [cell.expDateTextField resignFirstResponder];
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
        UILabel *statenamelbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        statenamelbl.text = [self.states objectAtIndex:row];
        
        statenamelbl.backgroundColor = [UIColor clearColor];
        statenamelbl.textAlignment=NSTextAlignmentCenter;
        statenamelbl.font=[UIFont systemFontOfSize:22];

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

/*ends here*/

//setting picker view to select states



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
    BillingInfoScanCell *cell = (BillingInfoScanCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [cell.cardHolderNameTextField addRegx:REGEX_USERNAME withMsg:@"Please enter valid name"];
    [cell.cardNumberTextField addRegx:REGEX_CREDIT_CARD_NO withMsg:@"Please enter valid card no"];
    [cell.phoneTextField addRegx:REGEX_PHONE_DEFAULT withMsg:@"Please enter valid phone no"];
    [cell.postalCodeTextField addRegx:REGEX_ZIP_CODE withMsg:@"Please enter valid zip code"];
    [cell.cityTextField addRegx:REGEX_USERNAME withMsg:@"Please enter valid city"];
    
    cell.cardHolderNameTextField.validateOnResign=YES;
    cell.cardHolderNameTextField.isMandatory=YES;
    cell.cardNumberTextField.isMandatory=YES;
    cell.securityCodeText.isMandatory=YES;
    cell.addressTextField.isMandatory=YES;
    cell.cityTextField.isMandatory=YES;
    cell.stateTextField.isMandatory=YES;
    cell.cityTextField.isMandatory=YES;
    cell.postalCodeTextField.isMandatory=YES;
    cell.phoneTextField.isMandatory=YES;
}


@end
