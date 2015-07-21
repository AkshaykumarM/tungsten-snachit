//
//  ShippingOverlay.h
//  SnachIt
//
//  Created by Akshay Maldhure on 1/22/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShippingOverlay : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;

@property (weak, nonatomic) IBOutlet UIWebView *productDesc;

//- (IBAction)doneBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;


@property (weak, nonatomic) IBOutlet UIButton *productPriceBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *subview;

@property (nonatomic,retain)NSIndexPath * checkedIndexPath ;
@property (nonatomic,assign)int lastcheckeckedcelltag;

@end
