//
//  ScanCard.h
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/26/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanCard : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)closeBtn:(id)sender;

@end
