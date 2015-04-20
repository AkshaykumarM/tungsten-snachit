//
//  OrderTotalOverview.h
//  SnachIt
//
//  Created by Akshakumar Maldhure on 12/31/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTotalOverview : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;

@property (weak, nonatomic) IBOutlet UIWebView *productDesc;
@property (weak, nonatomic) IBOutlet UITableView *tableviewfororder;

//- (IBAction)doneBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *productPriceBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIView *subview;

@end
