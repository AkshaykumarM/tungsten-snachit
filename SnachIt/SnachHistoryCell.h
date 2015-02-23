//
//  SnachHistoryCell.h
//  SnachIt
//
//  Created by Jayesh Kitukale on 1/27/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnachHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *dateOrdered;
@property (weak, nonatomic) IBOutlet UILabel *dateDelivered;
@property (weak, nonatomic) IBOutlet UIImageView *statusFlag;
@property (weak, nonatomic) IBOutlet UILabel *deliveryDateLbl;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@end
