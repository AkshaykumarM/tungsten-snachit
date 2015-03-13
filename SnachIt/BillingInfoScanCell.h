//
//  BillingInfoScanCell.h
//  SnachIt
//
//  Created by Jayesh Kitukale on 2/10/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator.h"

@interface BillingInfoScanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *defBackImg;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicImg;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLbl;
@property (weak, nonatomic) IBOutlet UILabel *memberSinceLbl;
@property (weak, nonatomic) IBOutlet TextFieldValidator *cardHolderNameTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *cardNumberTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *expDateTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *securityCodeText;
@property (weak, nonatomic) IBOutlet TextFieldValidator *addressTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *cityTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *stateTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *postalCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cardTypeImg;
@property (weak, nonatomic) IBOutlet TextFieldValidator *phoneTextField;

@end
