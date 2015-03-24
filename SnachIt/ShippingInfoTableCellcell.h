//
//  ShippingInfoTableCellcell.h
//  SnachIt
//
//  Created by Akshay Maldhure on 2/12/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShippingInfoTableCellcell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *streetNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;

@end
