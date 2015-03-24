//
//  ShippingOverview.h
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/19/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnachCheckDetails.h"

@interface ShippingOverview : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UITextView *productDesc;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *productPriceBtn;
- (IBAction)addNewAddressbtn:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *addressTableView;
@property (nonatomic,retain)NSIndexPath * checkedIndexPath ;
@end
