//
//  AccountSettingCell.h
//  SnachIt
//
//  Created by Akshay Maldhure on 2/10/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator.h"
@interface AccountSettingCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UIImageView *defaultBackImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLbl;
@property (weak, nonatomic) IBOutlet UILabel *memberSinceLbl;
@property (weak, nonatomic) IBOutlet TextFieldValidator *emailTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *nameTextField;
@property (weak, nonatomic) IBOutlet TextFieldValidator *phoneTextField;
@property (weak, nonatomic) IBOutlet UIImageView *appAlertsTopBar;
@property (weak, nonatomic) IBOutlet UIImageView *emailAlertsTopBar;
@property (weak, nonatomic) IBOutlet UIImageView *smsAlertsTopBar;
@property (weak, nonatomic) IBOutlet UIButton *passwordChangeBTN;


@end
