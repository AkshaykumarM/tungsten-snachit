//
//  PaymentOverview.h
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/22/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "AddNewCardForm.h"

@interface PaymentOverview : UIViewController<SWTableViewCellDelegate,PaymentInfoControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;

//- (IBAction)doneBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *productDesc;

@property (weak, nonatomic) IBOutlet UIView *subview;

@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *productPriceBtn;
- (IBAction)addNewCardBtn:(id)sender;

@property (nonatomic,retain)NSIndexPath * checkedIndexPath ;


@property (nonatomic,retain)NSIndexPath * lastchecked ;
@property (nonatomic,assign)int lastcheckeckedcelltag;
@end
