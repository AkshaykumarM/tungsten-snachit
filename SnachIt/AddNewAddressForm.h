//
//  AddNewAddressForm.h
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/19/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewAddressForm : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UITextView *productDesc;


@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *productPriceBtn;


- (IBAction)doneBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *streetAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@end
