//
//  BillingInfoOverview.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/27/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "BillingInfoOverview.h"

@implementation BillingInfoOverview
@synthesize cardholderNameTextField=_cardholderNameTextField;
@synthesize cardnoTextField=_cardnoTextField;
@synthesize expdateTextField=_expdateTextField;
@synthesize securityCodetextField=_securityCodetextField;
@synthesize addressTextField=_addressTextField;
@synthesize stateTextField=_stateTextField;
@synthesize postalCodeTextField=_postalCodeTextField;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
CGFloat animatedDistance;

- (void)viewDidLoad {
    [super viewDidLoad];
    [_scrollView setScrollEnabled:YES];
    [_scrollView setContentSize:CGSizeMake(320, 568)];
    [self setViewLookAndFeel];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField){
        [textField resignFirstResponder];
    }
    return NO;
}
-(void)setViewLookAndFeel{
    UIColor *borderColor=[UIColor colorWithRed:0.792 green:0.792 blue:0.792 alpha:0.4];
    self.profilePic.layer.cornerRadius= self.profilePic.frame.size.width/1.96;
    
    
    self.profilePic.clipsToBounds = YES;
    self.profilePic.layer.borderWidth = 3.0f;
    self.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    
        _billingInfoView=[[[NSBundle mainBundle]loadNibNamed:@"BillingInfoView" owner:self options:nil] objectAtIndex:0];
    
        _billingInfoView.frame=CGRectMake(0.0f,_staticTableContainer.frame.origin.y+_staticTableContainer.frame.size.height, _billingInfoView.frame.size.width, _billingInfoView.frame.size.height);
  
    
        [_uiView addSubview:_billingInfoView];
    CALayer *border1 = [CALayer layer];
    CALayer *border2  = [CALayer layer];
    CALayer *border3 = [CALayer layer];
    CALayer *border4  = [CALayer layer];
    CALayer *border5 = [CALayer layer];
    CALayer *border6  = [CALayer layer];
    CALayer *border7 = [CALayer layer];
    CALayer *border8  = [CALayer layer];
    
    CGFloat borderWidth = 1;
    border1.borderColor =borderColor.CGColor;
    border1.frame = CGRectMake(0, self.cardholderNameTextField.frame.size.height - borderWidth, self.cardholderNameTextField.frame.size.width, self.cardholderNameTextField.frame.size.height);
    border1.borderWidth = borderWidth;
    [self.cardholderNameTextField.layer addSublayer:border1];
    self.cardholderNameTextField.layer.masksToBounds = YES;
    
    
    border2.borderColor =borderColor.CGColor;
    border2.frame = CGRectMake(0, self.cardnoTextField.frame.size.height - borderWidth, self.cardnoTextField.frame.size.width, self.cardnoTextField.frame.size.height);
    border2.borderWidth = borderWidth;
    [self.cardnoTextField.layer addSublayer:border2];
    self.cardnoTextField.layer.masksToBounds = YES;
    
    border3.borderColor =borderColor.CGColor;
    border3.frame = CGRectMake(0, self.expdateTextField.frame.size.height - borderWidth, self.expdateTextField.frame.size.width, self.expdateTextField.frame.size.height);
    border3.borderWidth = borderWidth;
    [self.expdateTextField.layer addSublayer:border3];
    self.expdateTextField.layer.masksToBounds = YES;
    
    border4.borderColor =borderColor.CGColor;
    border4.frame = CGRectMake(0, self.securityCodetextField.frame.size.height - borderWidth, self.securityCodetextField.frame.size.width, self.securityCodetextField.frame.size.height);
    border4.borderWidth = borderWidth;
    [self.securityCodetextField.layer addSublayer:border4];
    self.securityCodetextField.layer.masksToBounds = YES;
    
    border5.borderColor =borderColor.CGColor;
    border5.frame = CGRectMake(0, self.addressTextField.frame.size.height - borderWidth, self.addressTextField.frame.size.width, self.addressTextField.frame.size.height);
    border5.borderWidth = borderWidth;
    [self.addressTextField.layer addSublayer:border5];
    self.addressTextField.layer.masksToBounds = YES;
    
    border6.borderColor =borderColor.CGColor;
    border6.frame = CGRectMake(0, self.stateTextField.frame.size.height - borderWidth, self.stateTextField.frame.size.width, self.stateTextField.frame.size.height);
    border6.borderWidth = borderWidth;
    [self.stateTextField.layer addSublayer:border6];
    self.stateTextField.layer.masksToBounds = YES;

    border7.borderColor =borderColor.CGColor;
    border7.frame = CGRectMake(0, self.cityTextField.frame.size.height - borderWidth, self.cityTextField.frame.size.width, self.cityTextField.frame.size.height);
    border7.borderWidth = borderWidth;
    [self.cityTextField.layer addSublayer:border7];
    self.cityTextField.layer.masksToBounds = YES;
    
    border8.borderColor =borderColor.CGColor;
    border8.frame = CGRectMake(0, self.postalCodeTextField.frame.size.height - borderWidth, self.postalCodeTextField.frame.size.width, self.postalCodeTextField.frame.size.height);
    border8.borderWidth = borderWidth;
    [self.postalCodeTextField.layer addSublayer:border8];
    self.postalCodeTextField.layer.masksToBounds = YES;

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

- (IBAction)saveBtn:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];

}
@end
