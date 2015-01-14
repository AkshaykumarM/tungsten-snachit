//
//  OrderTotalOverview.h
//  SnachIt
//
//  Created by Jayesh Kitukale on 12/31/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTotalOverview : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UITextView *productDesc;

- (IBAction)doneBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *productPriceBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (nonatomic, strong) NSString *productname,*productimgname,*brandimgname,*productprice,*productdesc;
@end
