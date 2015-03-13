//
//  AccountSetting.h
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator.h"

@interface AccountSetting : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>


@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;


-(int)updateUserProfile;
-(NSDictionary*)getProfileUpdateValues;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)save:(id)sender;

@end
