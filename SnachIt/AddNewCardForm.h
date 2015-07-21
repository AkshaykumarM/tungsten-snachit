//
//  AddNewCardForm.h
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/22/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator.h"

@protocol PaymentInfoControllerDelegate

-(void)editingInfoWasFinished;

@end
@interface AddNewCardForm : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UIView *subview;

@property (weak, nonatomic) IBOutlet UIWebView *productDesc;
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
@property (nonatomic) int recordIDToEdit;
@property (nonatomic) int lastCheckedRecord;

@property (nonatomic, strong) id<PaymentInfoControllerDelegate> delegate;

@end
