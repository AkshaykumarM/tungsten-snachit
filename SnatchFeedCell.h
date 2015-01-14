//
//  SnatchFeedCell.h
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/15/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnatchFeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UIButton *brandName;
@property (weak, nonatomic) IBOutlet UIButton *productName;
@property (weak, nonatomic) IBOutlet UIButton *productPrice;
@property (weak, nonatomic) IBOutlet UIButton *followStatus;
@property (weak, nonatomic) IBOutlet UIButton *freindCount;
@property (weak, nonatomic) IBOutlet UIButton *snoop;

@end
