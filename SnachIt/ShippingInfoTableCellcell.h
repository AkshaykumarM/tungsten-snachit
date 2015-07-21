//
//  ShippingInfoTableCellcell.h
//  SnachIt
//
//  Created by Akshay Maldhure on 2/12/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface ShippingInfoTableCellcell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *streetNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UIImageView *checkmarkImgView;

@end
