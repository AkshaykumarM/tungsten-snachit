//
//  ShippingInformation.h
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShippingInformation : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>



@property (weak, nonatomic) IBOutlet UITableView *tableView1;

- (IBAction)addAddress:(id)sender;


@property (nonatomic,retain)NSIndexPath * checkedIndexPath ;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@end
