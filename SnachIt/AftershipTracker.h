//
//  AftershipTracker.h
//  SnachIt
//
//  Created by Jayesh Kitukale on 4/24/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AftershipCell.h"
@protocol AftershipTrackerDelegate

@end
@interface AftershipTracker : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *slugIMGV;

@property (weak, nonatomic) IBOutlet UILabel *deliverBy;
@property (weak, nonatomic) IBOutlet UILabel *statusLBL;
@property (weak, nonatomic) IBOutlet NSString *trackingNo;
@property (weak, nonatomic) IBOutlet NSString *slugname;
@property (nonatomic, assign) id<AftershipTrackerDelegate> delegate;
@end
