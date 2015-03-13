//
//  AddNewCardForm.h
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/22/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator.h"
@interface AddNewCardForm : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UITextView *productDesc;
- (IBAction)doneBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *productPriceBtn;
@property (weak, nonatomic) IBOutlet TextFieldValidator *cardNumber;
@property (weak, nonatomic) IBOutlet TextFieldValidator *expDateTxtField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *cvvTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *fullNameTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *streetTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *cityTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *stateTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *zipTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *phoneTextField;
@property (weak, nonatomic) IBOutlet UIImageView *cameraBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cardtypeImageView;


@end
