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
-(void)viewDidAppear:(BOOL)animated{
    self.view.frame=CGRectMake(20, 65, self.view.frame.size.width-40, self.view.frame.size.height-80);
    
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
        [SVProgressHUD showWithStatus:@"Processing" maskType:SVProgressHUDMaskTypeBlack];
        dispatch_async(anotherThreadQueue, ^{
            NSString *url=[NSString stringWithFormat:@"%@change-password/?customer_id=%@&old_password=%@&new_password=%@",ec2maschineIP,USERID,self.currentPasswordTXTF.text,self.PasswordTXTF.text];
            NSURL *webURL = [[NSURL alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
            
            if([global isConnected]){
                NSURLRequest *request = [NSURLRequest requestWithURL:webURL];
                NSURLResponse *response = nil;
                
                //getting the data
                jasonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                //json parse
                NSLog(@"\nRequest URL: %@",url);
                
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if (jasonData) {
                    
                    NSDictionary *response= [NSJSONSerialization JSONObjectWithData:jasonData options:NSJSONReadingMutableContainers error: &error];
                      NSLog(@"\nResponse:%@ ",response);
                  
                    if([[response objectForKey:@"success"] isEqual:@"true"])
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"Success"
                                                  message:@"Password changed successfully"
                                                  delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
                        [alertView show];
                    }
                    else{
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"Alert"
                                                  message:[response objectForKey:@"message"]
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
    if(![self.currentPasswordTXTF hasText]&&![self.PasswordTXTF hasText]&&![self.confirmPasswordTXTF hasText])
    { [global showAllertMsg:@"Alert" Message:@"All fields are mandatory"];
        status=0;
    }
    else if(self.PasswordTXTF.text!=self.confirmPasswordTXTF.text)
    {
      [global showAllertMsg:@"Alert" Message:@"Password missmatch"];
        status=0;
    }
    else if([self.currentPasswordTXTF hasText]&&[self.PasswordTXTF hasText]&&[self.confirmPasswordTXTF hasText]&&self.PasswordTXTF.text==self.confirmPasswordTXTF.text){
        status=1;
    }
    else{
        status=0;
    }
    return 0;
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
    if(textField.tag!=4){
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
}

- (void)textFieldDidEndEditing:(UITextField *)textfield{
    if(textfield.tag!=4){
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    }
}
- (IBAction)forgotPassword:(id)sender {
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
    if (buttonIndex == 1 && alertView.tag==1) { // Set buttonIndex == 0 to handel "Ok"/"Yes" button response
       
        __block NSData *jasonData;
        __block NSError *error = nil;
        dispatch_queue_t anotherThreadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        [SVProgressHUD showWithStatus:@"Processing" maskType:SVProgressHUDMaskTypeBlack];
        dispatch_async(anotherThreadQueue, ^{
            NSString *url=[NSString stringWithFormat:@"%@reset-password/?email=%@",ec2maschineIP,emailrecovery.text];
            NSURL *webURL = [[NSURL alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
            
            if([global isConnected]){
                NSURLRequest *request = [NSURLRequest requestWithURL:webURL];
                NSURLResponse *response = nil;
                
                //getting the data
                jasonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                //json parse
                NSLog(@"\nRequest URL: %@",url);
                
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if (jasonData) {
                    
                    NSDictionary *response= [NSJSONSerialization JSONObjectWithData:jasonData options:NSJSONReadingMutableContainers error: &error];
                    NSLog(@"\nResponse:%@ ",response);
                    
                    if([[response objectForKey:@"success"] isEqual:@"true"])
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"Thanks"
                                                  message:@"An email has been sent to this address containing the password reset instructions."
                                                  delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
                        [alertView show];
                    }
                    else{
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"Alert"
                                                  message:[response objectForKey:@"message"]
                                                  delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
                        [alertView show];
                        
                    }
                }
                [SVProgressHUD dismiss];;
                
            });
        });
        animatedDistance=0;
        
    }
    else{
        animatedDistance=0;
        
    }
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
