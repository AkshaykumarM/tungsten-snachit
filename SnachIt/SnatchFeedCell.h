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

@property (weak, nonatomic) IBOutlet UIButton *productName;
@property (weak, nonatomic) IBOutlet UIButton *productPrice;
@property (retain, nonatomic) IBOutlet UIButton *followStatus;
@property (weak, nonatomic) IBOutlet UIButton *freind;

@property (weak, nonatomic) IBOutlet UIScrollView *productImagesContainer;
@property (weak, nonatomic) IBOutlet UIImageView *snoop;
@property (weak, nonatomic) IBOutlet UIButton *friendCount;

@end
