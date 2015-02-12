//
//  BillingInfoOverview.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/27/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "BillingInfoOverview.h"
#import "UserProfile.h"
#import "BillingInfoScanCell.h"
#import "global.h"
@implementation BillingInfoOverview{
    UserProfile *user;
}

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
CGFloat animatedDistance;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    user=[UserProfile sharedInstance];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
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
    return 670;
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
    
    
    if([global isValidUrl:user.profilePicUrl]){
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:user.profilePicUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            cell.profilePicImg.image = [UIImage imageWithData:data];
        }];
    }
      [cell.saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [cell.cardNumberTextField addTarget:self action:@selector(detectCardType) forControlEvents:UIControlEventEditingChanged];
    cell.fullnameLbl.adjustsFontSizeToFitWidth=YES;
    cell.fullnameLbl.minimumScaleFactor=0.5;
  
    return cell;
}

-(void)detectCardType{
    BillingInfoScanCell *tableCell = (BillingInfoScanCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    NSPredicate* visa = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VISA];
     NSPredicate* mastercard = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MASTERCARD];
     NSPredicate* dinnersclub = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", DINNERSCLUB];
     NSPredicate* discover = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", DISCOVER];
     NSPredicate* amex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", AMEX];
    
    if ([visa evaluateWithObject:tableCell.cardNumberTextField.text])
    {
        tableCell.cardTypeImg.image=[UIImage imageNamed:@"visa.png"];
    }
    else if ([mastercard evaluateWithObject:tableCell.cardNumberTextField.text])
    {
        tableCell.cardTypeImg.image=[UIImage imageNamed:@"mastercard.png"];
    }
    else if ([dinnersclub evaluateWithObject:tableCell.cardNumberTextField.text])
    {
        tableCell.cardTypeImg.image=[UIImage imageNamed:@"dinersclub.png"];
    }
    else if ([discover evaluateWithObject:tableCell.cardNumberTextField.text])
    {
        tableCell.cardTypeImg.image=[UIImage imageNamed:@"discover.png"];
    }
    else if ([amex evaluateWithObject:tableCell.cardNumberTextField.text])
    {
        tableCell.cardTypeImg.image=[UIImage imageNamed:@"amex.png"];
    }
    else{
        tableCell.cardTypeImg.image=[UIImage imageNamed:@""];
    }
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

- (void)save {
    [self dismissViewControllerAnimated:true completion:nil];

}
@end
