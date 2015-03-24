//
//  TwitterEmailIdView.h
//  SnachIt
//
//  Created by Akshay Maldhure on 2/6/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterEmailIdView : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailIdTextField;
- (IBAction)logInButton:(id)sender;

@end
