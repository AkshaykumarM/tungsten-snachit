//
//  BillingInformation.h
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillingInformation : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
- (IBAction)saveBtn:(id)sender;
- (IBAction)backBtn:(id)sender;

@end
