//
//  shippingOverlayCell.h
//  SnachIt
//
//  Created by Akshay Maldhure on 1/22/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface shippingOverlayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *estDeliveryLbl;

@property (weak, nonatomic) IBOutlet UILabel *speedLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@end
