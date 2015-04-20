//
//  ShippingInfoOverview.h
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/27/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShippingInfoControllerDelegate

-(void)editingInfoWasFinished;

@end
@interface ShippingInfoOverview : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *defBackImageView;
@property (nonatomic, strong) id<ShippingInfoControllerDelegate> delegate;
- (IBAction)saveBtn:(id)sender;
@property (nonatomic) int recordIDToEdit;

@end
