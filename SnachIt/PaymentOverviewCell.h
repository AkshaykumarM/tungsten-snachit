//
//  PaymentOverviewCell.h
//  SnachIt
//
//  Created by Akshay Maldhure on 1/23/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface PaymentOverviewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cardImage;
@property (weak, nonatomic) IBOutlet UILabel *cardNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *cvvLbl;
@property (weak, nonatomic) IBOutlet UIImageView *checkmarkImgView;
@end
