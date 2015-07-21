//
//  AddNewAddressForm.h
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/19/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator.h"

@protocol AddressInfoControllerDelegate

-(void)editingInfoWasFinished;

@end
@interface AddNewAddressForm : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;

@property (weak, nonatomic) IBOutlet UIWebView *productDesc;

@property (weak, nonatomic) IBOutlet UIView *subview;

@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *productPriceBtn;


- (IBAction)doneBtn:(id)sender;
@property (weak, nonatomic) IBOutlet TextFieldValidator *fullNameTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *streetAddressTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *cityTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *stateTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *zipTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *phoneTextField;
@property (nonatomic) int recordIDToEdit;
@property (nonatomic) int lastCheckedRecord;
@property (nonatomic, strong) id<AddressInfoControllerDelegate> delegate;
@end
