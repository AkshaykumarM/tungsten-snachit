//
//  MyProfileFreindsCell.h
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/15/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileFreindsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *friendPic;

@property (weak, nonatomic) IBOutlet UILabel *friendName;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UILabel *noSnachsYet;




@end
