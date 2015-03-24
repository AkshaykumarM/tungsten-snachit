//
//  BillingInformationCell.h
//  SnachIt
//
//  Created by Akshay Maldhure on 2/12/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillingInformationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *CardTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *cvvLbl;
@property (weak, nonatomic) IBOutlet UIImageView *cardImg;

@end
