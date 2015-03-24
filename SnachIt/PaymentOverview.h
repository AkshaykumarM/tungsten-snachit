//
//  PaymentOverview.h
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/22/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentOverview : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UITextView *productDesc;
- (IBAction)doneBtn:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *productPriceBtn;
- (IBAction)addNewCardBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *paymentTableView;
@property (nonatomic,retain)NSIndexPath * checkedIndexPath ;
@end
