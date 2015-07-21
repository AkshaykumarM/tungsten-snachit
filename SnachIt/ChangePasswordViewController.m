//
//  ChangePasswordViewController.m
//  SnachIt
//
//  Created by Jayesh Kitukale on 5/13/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "global.h"
#import "SVProgressHUD.h"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController
{
     UITextField *emailrecovery;
}
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
CGFloat animatedDistance;
- (void)viewDidLoad {
    [self initialize];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initialize{
    UIColor *color = [UIColor colorWithRed:0.212 green:0.149 blue:0.188 alpha:1];
    [super viewDidAppear:YES];
    self.currentPasswordTXTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"current password" attributes:@{NSForegroundColorAttributeName: color}];
    self.PasswordTXTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"new password" attributes:@{NSForegroundColorAttributeName: color}];
   self.confirmPasswordTXTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"confirm password" attributes:@{NSForegroundColorAttributeName: color}];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveAction:(id)sender {
   
    if([self validate]==1){
        __block NSData *jasonData;
        __block NSError *error = nil;
        dispatch_queue_t anotherThreadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeBlack];
        dispatch_async(anotherThreadQueue, ^{
            NSString *url=[NSString stringWithFormat:@"%@change-password/?customer_id=%@&old_password=%@&new_password=%@",ec2maschineIP,USERID,self.currentPasswordTXTF.text,self.PasswordTXTF.text];
            NSURL *webURL = [[NSURL alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            if([global isConnected]){
                NSURLRequest *request = [NSURLRequest requestWithURL:webURL];
                NSURLResponse *response = nil;
                
                //getting the data
                jasonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                //json parse
               
                
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if (jasonData) {
                    
                    NSDictionary *response= [NSJSONSerialization JSONObjectWithData:jasonData options:NSJSONReadingMutableContainers error: &error];
                    
                  
                    if([[response objectForKey:@"success"] isEqual:@"true"])
                    {
                        [SVProgressHUD dismiss];;
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"Success"
                                                  message:@"Password changed successfully"
                                                  delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
                        [alertView show];
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:self.PasswordTXTF.text forKey:PASSWORD];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    else{
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"Alert"
                                                  message:[response objectForKey:@"error_message"]
                                                  delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
                        [alertView show];
                        
                    }
                }
                [SVProgressHUD dismiss];;
                
            });
        });

        
    }
}

-(int) validate{
    int status=0;
    NSString *confirmPass=self.confirmPasswordTXTF.text;
    
    if(![self.currentPasswordTXTF hasText]||![self.PasswordTXTF hasText]||![self.confirmPasswordTXTF hasText])
    { [global showAllertMsg:@"Alert" Message:@"All fields are mandatory"];
        status=0;
    }
    else if(![confirmPass isEqualToString:self.PasswordTXTF.text])
    {
      [global showAllertMsg:@"Alert" Message:@"Password missmatch"];
        status=0;
    }
    else if([self.currentPasswordTXTF hasText]&&[self.PasswordTXTF hasText]&&[self.confirmPasswordTXTF hasText]&&[confirmPass isEqualToString:self.PasswordTXTF.text]){
        status=1;
    }
    else{
        status=0;
    }
    return status;
}
- (IBAction)closeAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)visibilityAction:(id)sender {
    if ([self.showBTN.titleLabel.text isEqualToString:@"SHOW"]) {
        self.currentPasswordTXTF.secureTextEntry = NO;
        [self.showBTN setTitle:@"HIDE" forState:UIControlStateNormal];
    }
    else {
        self.currentPasswordTXTF.secureTextEntry = YES;
        [self.showBTN setTitle:@"SHOW" forState:UIControlStateNormal];
    }
}


//this function will end editing by dissmissing keyboard if user touches outside the textfields
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if(textField.tag!=4){
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:textField.tag + 1];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
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


- (IBAction)forgotPassword:(id)sender {
   [[self view] endEditing:YES];
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Reset Password"
                              message:@"Please enter the email address associated with the account."
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alertView.tag=1;
    /* Display a numerical keypad for this text field */
    emailrecovery  = [alertView textFieldAtIndex:0];
    [emailrecovery setTag:4];
    emailrecovery.keyboardType = UIKeyboardTypeEmailAddress;
    
    [alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

     if (buttonIndex == 1 && alertView.tag==1) {
    if([global isConnected]){
           [SVProgressHUD showWithStatus:@"Please Wait" maskType:SVProgressHUDMaskTypeBlack];
        @try{
            
            [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@request-to-reset-password/?email=%@&ssoUsing=%@",ec2maschineIP,emailrecovery.text,SSOUSING]]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if (!error) {
                    
                    NSDictionary *responseDic = [self fetchData:data];
                
                    NSLog(@"Dictionary %@",[self fetchData:data]);
                    
                    if (responseDic) {
                        @try{
                            [SVProgressHUD dismiss];
                        }
                        @catch(NSException *e){
                            [SVProgressHUD dismiss];
                        }
                        
                    }
                    [SVProgressHUD dismiss];
                    // As this block of code is run in a background thread, we need to ensure the GUI
                    // update is executed in the main thread
                    [self performSelectorOnMainThread:@selector(doneForgotResponse:) withObject:responseDic waitUntilDone:NO];
                    
                }
                else{
                    NSLog(@"Error: %@", error.description);
                }
                
            }];
        }
        @catch(NSException *e){
            NSLog(@"Exception: %@",e);
        }
    }
     }
     else{
         [self.view endEditing:YES];
     }
}

-(void)doneForgotResponse:(NSDictionary*)response
{
    [SVProgressHUD dismiss];
    if(response!=nil){
    if([[response objectForKey:@"success"] isEqual:@"true"])
    {[SVProgressHUD dismiss];
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Thanks"
                                  message:@"An email has been sent to this address containing the password reset instructions."
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
        
        [alertView show];
        
    }
    else{
        [SVProgressHUD dismiss];
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Alert"
                                  message:[response objectForKey:@"message"]
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
        [alertView show];
        
    }
    }
    [SVProgressHUD dismiss];

}
- (NSDictionary *)fetchData:(NSData *)response
{
    NSError *error = nil;
    NSDictionary* latestBookings = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error: &error];
    
    if (error != nil) {
        NSLog(@"Error: %@", error.description);
        return nil;
    }
    
    
    return latestBookings;
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if(alertView.tag==1){
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",REGEX_EMAIL];
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        if([emailTest evaluateWithObject:inputText] )
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

@end
