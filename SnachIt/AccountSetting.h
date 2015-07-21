//
//  AccountSetting.h
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator.h"

@interface AccountSetting : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>






-(void)updateUserProfile;
-(NSDictionary*)getProfileUpdateValues;
@property (weak, nonatomic) IBOutlet UITableView *tableViewsetting;
- (IBAction)save:(id)sender;
- (IBAction)changePassword:(id)sender;


@end
