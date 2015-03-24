//
//  BillingInfoCell.h
//  SnachIt
//
//  Created by Akshay Maldhure on 2/10/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillingInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *defBackImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicImg;
@property (weak, nonatomic) IBOutlet UILabel *memberSinceLbl;

@end
