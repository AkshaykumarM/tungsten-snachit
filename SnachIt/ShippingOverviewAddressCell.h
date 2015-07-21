//
//  ShippingOverviewAddressCell.h
//  SnachIt
//
//  Created by Akshakumar Maldhure on 1/17/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface ShippingOverviewAddressCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *streetNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *cityStateZipLbl;
@property (weak, nonatomic) IBOutlet UIImageView *checkmarkImgView;

@end
