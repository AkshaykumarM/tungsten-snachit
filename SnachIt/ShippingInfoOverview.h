//
//  ShippingInfoOverview.h
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/27/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShippingInfoOverview : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
- (IBAction)backBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *defBackImageView;

- (IBAction)saveBtn:(id)sender;

@end
