//
//  PaymentOverviewCell.h
//  SnachIt
//
//  Created by Akshay Maldhure on 1/23/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentOverviewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cardImage;
@property (weak, nonatomic) IBOutlet UILabel *cardNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *cvvLbl;
@end
