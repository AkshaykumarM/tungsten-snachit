//
//  AddNewCardForm.h
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/22/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewCardForm : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UITextView *productDesc;
- (IBAction)doneBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *productPriceBtn;
@property (weak, nonatomic) IBOutlet UITextField *cardNumber;
@property (weak, nonatomic) IBOutlet UITextField *expDateTxtField;
@property (weak, nonatomic) IBOutlet UITextField *cvvTextField;
@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *streetTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;


@end
