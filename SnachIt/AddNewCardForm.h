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
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *productPriceBtn;
@property (nonatomic, strong) NSString *productname,*productimgname,*brandimgname,*productprice,*productdesc;

@end
