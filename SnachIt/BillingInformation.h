//
//  BillingInformation.h
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillingInformation : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *memberSinceLbl;
- (IBAction)saveBtn:(id)sender;

- (IBAction)addCard:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic,retain)NSIndexPath * checkedIndexPath ;
@end
