//
//  ShippingInfoCell.h
//  SnachIt
//
//  Created by Jayesh Kitukale on 2/10/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShippingInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicImg;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLbl;
@property (weak, nonatomic) IBOutlet UILabel *memberSinceLbl;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end
