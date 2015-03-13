//
//  MyProfile.h
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/12/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfile : UIViewController 

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *memberSinceLbl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tabSelect;
- (IBAction)indexChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *subTabSelect;
- (IBAction)subTabIndexChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *lastLine;
@property (strong, nonatomic) IBOutlet UIView *freindsPopupView;
- (IBAction)closeBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UIButton *productPriceLbl;
@property (weak, nonatomic) IBOutlet UIButton *productNameLbl;
- (IBAction)snoopButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *snoopBtn;

@property (weak, nonatomic) IBOutlet UIImageView *defaultbackImg;
@property (weak, nonatomic) IBOutlet UIButton *friendCount;
- (IBAction)followBrand:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *followStatus;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

-(void)unfollowBrand:(id)sender;
@end
