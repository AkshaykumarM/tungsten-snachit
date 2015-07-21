//
//  ShippingOverview.h
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/19/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnachCheckDetails.h"
#import "SWTableViewCell.h"
#import "AddNewAddressForm.h"
@interface ShippingOverview : UIViewController<UINavigationControllerDelegate,SWTableViewCellDelegate,AddressInfoControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;

//@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *productPriceBtn;
- (IBAction)addNewAddressbtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *productDesc;

@property (weak, nonatomic) IBOutlet UITableView *addressTableView;
@property (nonatomic,retain)NSIndexPath * checkedIndexPath ;
@property (weak, nonatomic) IBOutlet UIView *subview;



@property (nonatomic,assign)int lastcheckeckedcelltag;

@end
