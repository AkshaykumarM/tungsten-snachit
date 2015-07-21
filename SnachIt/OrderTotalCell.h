//
//  OrderTotalCell.h
//  SnachIt
//
//  Created by Akshakumar Maldhure on 12/31/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTotalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingAndhandlingLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesTaxLabel;
@property (weak, nonatomic) IBOutlet UIButton *shippingandHandling;

@end
