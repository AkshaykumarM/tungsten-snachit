//
//  ScanCard.h
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/26/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardIOPaymentViewControllerDelegate.h"
@interface ScanCard : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)closeBtn:(id)sender;

@end
