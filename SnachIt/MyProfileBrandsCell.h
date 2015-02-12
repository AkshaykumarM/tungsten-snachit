//
//  MyProfileBrandsCell.h
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/15/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileBrandsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *brandName;

@property (weak, nonatomic) IBOutlet UIImageView *followStatus;
@property (weak, nonatomic) IBOutlet UIScrollView *productImageConatainer;
@property (weak, nonatomic) IBOutlet UILabel *noSnachYetForbrand;

@end
