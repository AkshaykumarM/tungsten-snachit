//
//  SnachitStartScreen.h
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/24/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnachitStartScreen : UIViewController

- (IBAction)logInBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logInBtn;
- (IBAction)signUpBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;

@property (weak, nonatomic) IBOutlet UIImageView *background;
@end
