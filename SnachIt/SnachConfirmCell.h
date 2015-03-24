//
//  SnachConfirmCell.h
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/18/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SnachConfirmCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *orderAdd;
@property (weak, nonatomic) IBOutlet UIButton *orderSubstract;
@property (weak, nonatomic) IBOutlet UILabel *orderQuantity;
@property (weak, nonatomic) IBOutlet UIButton *expandShipto;
@property (weak, nonatomic) IBOutlet UILabel *shiptoName;
@property (weak, nonatomic) IBOutlet UILabel *paymentCard;
@property (weak, nonatomic) IBOutlet UIButton *expandPayment;
@property (weak, nonatomic) IBOutlet UILabel *orderTotal;
@property (weak, nonatomic) IBOutlet UIButton *expandOrderTotal;

@end
