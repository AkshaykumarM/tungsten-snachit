//
//  ShippingInfoOverview.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/27/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "ShippingInfoOverview.h"
#import "UserProfile.h"
@implementation ShippingInfoOverview
{
    UserProfile *user;
}
@synthesize firstNameTextField=_firstNameTextField;
@synthesize lastNameTextField=_lastNameTextField;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
CGFloat animatedDistance;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the Label text with the selected recipe
    
    
    [self setViewLookAndFeel];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self initialLize];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    user=[UserProfile sharedInstance];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField){
        [textField resignFirstResponder];
    }
    return NO;
}


-(void)initialLize{
    
    if(user.profilePicUrl!=nil){
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:user.profilePicUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            self.profilePic.image = [UIImage imageWithData:data];
        }];
    }
}
-(void)setViewLookAndFeel{
    UIColor *borderColor=[UIColor colorWithRed:0.792 green:0.792 blue:0.792 alpha:0.4];
    self.profilePic.layer.cornerRadius= self.profilePic.frame.size.width/1.96;
    
    
    self.profilePic.clipsToBounds = YES;
    self.profilePic.layer.borderWidth = 3.0f;
    self.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _shippingInfoView=[[[NSBundle mainBundle]loadNibNamed:@"ShippingInfoView" owner:self options:nil] objectAtIndex:0];
    
    _shippingInfoView.frame=CGRectMake(0.0f,_profilePic.frame.origin.y+_profilePic.frame.size.height, _shippingInfoView.frame.size.width, _shippingInfoView.frame.size.height);
    
    
    [_uiView addSubview:_shippingInfoView];
    
    
    CALayer *border1 = [CALayer layer];
    CALayer *border2  = [CALayer layer];
    CALayer *border3 = [CALayer layer];
    CALayer *border4  = [CALayer layer];
    CALayer *border5 = [CALayer layer];
    CALayer *border6  = [CALayer layer];
        
    CGFloat borderWidth = 1;
    border1.borderColor =borderColor.CGColor;
    border1.frame = CGRectMake(0, self.firstNameTextField.frame.size.height - borderWidth, self.firstNameTextField.frame.size.width, self.firstNameTextField.frame.size.height);
    border1.borderWidth = borderWidth;
    [self.firstNameTextField.layer addSublayer:border1];
    self.firstNameTextField.layer.masksToBounds = YES;
    
    
    border2.borderColor =borderColor.CGColor;
    border2.frame = CGRectMake(0, self.lastNameTextField.frame.size.height - borderWidth, self.lastNameTextField.frame.size.width, self.lastNameTextField.frame.size.height);
    border2.borderWidth = borderWidth;
    [self.lastNameTextField.layer addSublayer:border2];
    self.lastNameTextField.layer.masksToBounds = YES;
    
      border3.borderColor =borderColor.CGColor;
    border3.frame = CGRectMake(0, self.addressTextField.frame.size.height - borderWidth, self.addressTextField.frame.size.width, self.addressTextField.frame.size.height);
    border3.borderWidth = borderWidth;
    [self.addressTextField.layer addSublayer:border3];
    self.addressTextField.layer.masksToBounds = YES;
    
    border4.borderColor =borderColor.CGColor;
    border4.frame = CGRectMake(0, self.stateTextField.frame.size.height - borderWidth, self.stateTextField.frame.size.width, self.stateTextField.frame.size.height);
    border4.borderWidth = borderWidth;
    [self.stateTextField.layer addSublayer:border4];
    self.stateTextField.layer.masksToBounds = YES;
    
    border5.borderColor =borderColor.CGColor;
    border5.frame = CGRectMake(0, self.cityTextField.frame.size.height - borderWidth, self.cityTextField.frame.size.width, self.cityTextField.frame.size.height);
    border5.borderWidth = borderWidth;
    [self.cityTextField.layer addSublayer:border5];
    self.cityTextField.layer.masksToBounds = YES;
    
    border6.borderColor =borderColor.CGColor;
    border6.frame = CGRectMake(0, self.postalCodeTextField.frame.size.height - borderWidth, self.postalCodeTextField.frame.size.width, self.postalCodeTextField.frame.size.height);
    border6.borderWidth = borderWidth;
    [self.postalCodeTextField.layer addSublayer:border6];
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

- (IBAction)doneBtn:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
