//
//  BillingInfoOverview.h
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/27/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillingInfoOverview : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *uiView;

@property (weak, nonatomic) IBOutlet UILabel *fullNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *memberSinceLbl;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIView *billingInfoView;
@property (weak, nonatomic) IBOutlet UIView *staticTableContainer;
@property (weak, nonatomic) IBOutlet UITextField *cardholderNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardnoTextField;
@property (weak, nonatomic) IBOutlet UITextField *expdateTextField;
@property (weak, nonatomic) IBOutlet UITextField *securityCodetextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *postalCodeTextField;

- (IBAction)saveBtn:(id)sender;

@end
