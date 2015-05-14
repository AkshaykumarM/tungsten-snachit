//
//  AftershipCell.h
//  SnachIt
//
//  Created by Jayesh Kitukale on 4/24/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AftershipCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tagImgView;
@property (weak, nonatomic) IBOutlet UILabel *checkPointTime;
@property (weak, nonatomic) IBOutlet UILabel *messageLbl;

@property (weak, nonatomic) IBOutlet UILabel *checkPointDate;
@property (weak, nonatomic) IBOutlet UILabel *cityStateZip;

@end
