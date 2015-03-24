//
//  ScanCard.h
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/26/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardIOPaymentViewControllerDelegate.h"
@interface ScanCard : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)closeBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *scanView;
@end
